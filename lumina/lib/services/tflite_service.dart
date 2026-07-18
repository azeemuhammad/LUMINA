import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteService {
  static Interpreter? _interpreter;

  /// Load model
  static Future<void> loadModel() async {
    if (_interpreter != null) return;

    _interpreter = await Interpreter.fromAsset(
      'models/realesrgan_x4.tflite',
      options: InterpreterOptions()..threads = 4,
    );

    print("TFLite Model Loaded");
    print(_interpreter!.getInputTensor(0).shape);
    print(_interpreter!.getOutputTensor(0).shape);
  }

  /// Enhance Image
  static Future<File?> enhanceImage(File imageFile) async {
    if (_interpreter == null) {
      await loadModel();
    }

    try {
      // Read image
      final image = img.decodeImage(await imageFile.readAsBytes());

      if (image == null) {
        return null;
      }

      // Resize to model input size
      final resized = img.copyResize(image, width: 256, height: 256);

      // Convert to Float32 input
      var input = List.generate(
        1,
        (_) => List.generate(
          256,
          (y) => List.generate(256, (x) {
            final pixel = resized.getPixel(x, y);

            return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
          }),
        ),
      );

      // Output tensor
      var output = List.generate(
        1,
        (_) => List.generate(
          256,
          (_) => List.generate(256, (_) => List.filled(3, 0.0)),
        ),
      );

      // Run inference
      _interpreter!.run(input, output);

      // Convert output to image
      img.Image result = img.Image(width: 256, height: 256);

      for (int y = 0; y < 256; y++) {
        for (int x = 0; x < 256; x++) {
          int r = (output[0][y][x][0] * 255).clamp(0, 255).toInt();
          int g = (output[0][y][x][1] * 255).clamp(0, 255).toInt();
          int b = (output[0][y][x][2] * 255).clamp(0, 255).toInt();

          result.setPixelRgb(x, y, r, g, b);
        }
      }

      // Save enhanced image
      final dir = await getTemporaryDirectory();

      final outputFile = File(
        '${dir.path}/enhanced_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      await outputFile.writeAsBytes(Uint8List.fromList(img.encodePng(result)));

      return outputFile;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }
}
