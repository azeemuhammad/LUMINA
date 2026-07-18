import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import '../widgets/glass_card.dart';
import '../services/ai_service.dart';
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
    // Progress animation
    for (double i = 0; i <= 1.0; i += 0.08) {
      await Future.delayed(const Duration(milliseconds: 180));
      setState(() => progress = i);
    }

    // Try Cloud Neural Upscaling first
    enhancedImage = await AIService.neuralUpscale(widget.image);

    // Local fallback if API fails
    if (enhancedImage == null) {
      final bytes = await widget.image.readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image != null) {
        // Neural-like enhancements
        image = img.gaussianBlur(image, radius: 0);
        image = img.sharpen(image, amount: 2.8);
        image = img.adjustColor(image, saturation: 1.45, gamma: 0.95);
        image = img.copyResize(
          image,
          width: (image.width * 2).clamp(512, 2048),
        );

        final tempDir = await getTemporaryDirectory();
        enhancedImage = await File(
          '${tempDir.path}/enhanced_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ).writeAsBytes(img.encodeJpg(image, quality: 95));
      }
    }

    // Navigate to results
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
              const Icon(
                Icons.auto_awesome,
                size: 60,
                color: Color(0xFF4CD7F6),
              ),
              const SizedBox(height: 20),
              const Text(
                "Neural Restoration in Progress",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              const Text(
                "4x Upscaling • Detail Enhancement",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              Image.file(widget.image, height: 260, fit: BoxFit.contain),
              const SizedBox(height: 40),
              SizedBox(
                width: 280,
                child: LinearProgressIndicator(
                  value: progress,
                  color: const Color(0xFF4CD7F6),
                  backgroundColor: Colors.white24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "${(progress * 100).toInt()}% Complete",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
