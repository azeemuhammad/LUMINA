import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import '../widgets/glass_card.dart';
import '../services/tflite_service.dart';
import 'results_screen.dart';

class ProcessingScreen extends StatefulWidget {
  final File image;
  const ProcessingScreen({super.key, required this.image});
  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  double progress = 0.0;
  File? enhancedImage;

  @override
  void initState() {
    super.initState();
    _startNeuralProcessing();
  }

  Future<void> _startNeuralProcessing() async {
    for (double i = 0; i <= 0.6; i += 0.1) {
      await Future.delayed(const Duration(milliseconds: 120));
      setState(() => progress = i);
    }

    enhancedImage = await TFLiteService.enhanceImage(widget.image);

    if (enhancedImage == null) {
      // Basic fallback
      final bytes = await widget.image.readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      if (image != null) {
        image = img.sharpen(image, amount: 2.0);
        image = img.adjustColor(image, saturation: 1.3);
        final tempDir = await getTemporaryDirectory();
        enhancedImage = await File('${tempDir.path}/enhanced.jpg')
            .writeAsBytes(img.encodeJpg(image, quality: 90));
      }
    }

    for (double i = 0.6; i <= 1.0; i += 0.1) {
      await Future.delayed(const Duration(milliseconds: 80));
      setState(() => progress = i);
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultsScreen(
            originalImage: widget.image,
            enhancedImage: enhancedImage,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF13121B),
      body: Center(
        child: GlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome,
                  size: 60, color: Color(0xFF4CD7F6)),
              const SizedBox(height: 20),
              const Text("Neural Restoration in Progress",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              const Text("Real-ESRGAN • Offline",
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),
              Image.file(widget.image, height: 260, fit: BoxFit.contain),
              const SizedBox(height: 40),
              SizedBox(
                width: 280,
                child: LinearProgressIndicator(
                    value: progress, color: const Color(0xFF4CD7F6)),
              ),
              Text("${(progress * 100).toInt()}% Complete"),
            ],
          ),
        ),
      ),
    );
  }
}
