import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteService {
  static Interpreter? _interpreter;

  static Future<void> loadModel() async {
    if (_interpreter != null) return;

    try {
      _interpreter = await Interpreter.fromAsset(
        'models/realesrgan_x4.tflite',
        options: InterpreterOptions()
          ..threads = 4
          ..useNnapiForAndroid = true, // Hardware acceleration
      );

      print("✅ Real-ESRGAN-x4plus Model Loaded Successfully!");
      print("Input shape: ${_interpreter!.getInputTensor(0).shape}");
      print("Output shape: ${_interpreter!.getOutputTensor(0).shape}");
    } catch (e) {
      print("❌ Model loading failed: $e");
    }
  }

  static Future<File?> enhanceImage(File imageFile) async {
    if (_interpreter == null) {
      await loadModel();
    }

    try {
      final bytes = await imageFile.readAsBytes();
      img.Image? original = img.decodeImage(bytes);
      if (original == null) return null;

      // Real-ESRGAN usually expects smaller patches for memory efficiency
      const int inputSize = 256;
      final resized =
          img.copyResize(original, width: inputSize, height: inputSize);

      // Input tensor: [1, 256, 256, 3]
      var input = List.generate(
        1,
        (_) => List.generate(
          inputSize,
          (y) => List.generate(inputSize, (x) {
            final pixel = resized.getPixel(x, y);
            return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
          }),
        ),
      );

      // Output tensor
      var output = List.generate(
        1,
        (_) => List.generate(
          inputSize,
          (_) => List.generate(inputSize, (_) => List.filled(3, 0.0)),
        ),
      );

      // Run inference
      _interpreter!.run(input, output);

      // Convert output to image
      img.Image result = img.Image(width: inputSize, height: inputSize);
      for (int y = 0; y < inputSize; y++) {
        for (int x = 0; x < inputSize; x++) {
          final r = (output[0][y][x][0] * 255).clamp(0, 255).toInt();
          final g = (output[0][y][x][1] * 255).clamp(0, 255).toInt();
          final b = (output[0][y][x][2] * 255).clamp(0, 255).toInt();
          result.setPixelRgb(x, y, r, g, b);
        }
      }

      // Save enhanced image
      final tempDir = await getTemporaryDirectory();
      final outputFile = File(
        '${tempDir.path}/enhanced_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      await outputFile.writeAsBytes(Uint8List.fromList(img.encodePng(result)));
      return outputFile;
    } catch (e) {
      print('TFLite Error: $e');
      return null;
    }
  }

  static void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }
}
