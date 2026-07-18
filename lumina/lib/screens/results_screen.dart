import 'package:flutter/material.dart';
import 'dart:io';
import 'package:confetti/confetti.dart';
import '../widgets/comparison_slider.dart';

class ResultsScreen extends StatefulWidget {
  final File originalImage;
  final File? enhancedImage;

  const ResultsScreen({
    super.key,
    required this.originalImage,
    this.enhancedImage,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 4),
    );
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Restoration Complete")),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  "Neural Restoration Successful",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "4x Upscaled • Enhanced Details",
                  style: TextStyle(color: Colors.greenAccent),
                ),
                const SizedBox(height: 30),
                if (widget.enhancedImage != null)
                  SizedBox(
                    height: 450,
                    child: ComparisonSlider(
                      beforeImage: widget.originalImage.path,
                      afterImage: widget.enhancedImage!.path,
                    ),
                  ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download),
                      label: const Text("Download"),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share),
                      label: const Text("Share"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(confettiController: _confettiController),
          ),
        ],
      ),
    );
  }
}
