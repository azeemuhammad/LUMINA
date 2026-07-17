import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'results_screen.dart';
import '../widgets/glass_card.dart';

class ProcessingScreen extends StatefulWidget {
  final File image;

  const ProcessingScreen({super.key, required this.image});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen>
    with TickerProviderStateMixin {
  double progress = 0.0;
  File? enhancedImage;

  @override
  void initState() {
    super.initState();
    _startAIProcessing();
  }

  Future<void> _startAIProcessing() async {
    // Simulate progress
    for (double i = 0; i <= 1.0; i += 0.1) {
      await Future.delayed(const Duration(milliseconds: 400));
      setState(() => progress = i);
    }

    // Real Image Processing
    final bytes = await widget.image.readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    if (image != null) {
      // AI-like enhancements
      image = img.gaussianBlur(image, radius: 1); // Noise reduction
      image = img.sharpen(image, amount: 2.0); // Sharpening
      image = img.adjustColor(image, saturation: 1.3); // Color boost
      image = img.copyResize(
        image,
        width: image.width * 2,
      ); // Upscale simulation

      final enhancedBytes = img.encodeJpg(image, quality: 95);
      final tempDir = await getTemporaryDirectory();
      enhancedImage = await File(
        '${tempDir.path}/enhanced.jpg',
      ).writeAsBytes(enhancedBytes);
    }

    setState(() {});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Neural Restoration in Progress",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 30),
              Image.file(widget.image, height: 280),
              const SizedBox(height: 30),
              LinearProgressIndicator(
                value: progress,
                color: const Color(0xFF4CD7F6),
              ),
              Text("${(progress * 100).toInt()}% • AI Processing"),
            ],
          ),
        ),
      ),
    );
  }
}
