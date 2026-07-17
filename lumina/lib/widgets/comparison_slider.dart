import 'package:flutter/material.dart';

class ComparisonSlider extends StatefulWidget {
  final String beforeImage;
  final String afterImage;

  const ComparisonSlider({
    super.key,
    required this.beforeImage,
    required this.afterImage,
  });

  @override
  State<ComparisonSlider> createState() => _ComparisonSliderState();
}

class _ComparisonSliderState extends State<ComparisonSlider> {
  double _sliderValue = 0.5;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRect(
          child: Align(
            alignment: Alignment.centerRight,
            widthFactor: 1 - _sliderValue,
            child: Image.network(
              widget.afterImage,
              fit: BoxFit.cover,
              height: 400,
            ),
          ),
        ),
        ClipRect(
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: _sliderValue,
            child: Image.network(
              widget.beforeImage,
              fit: BoxFit.cover,
              height: 400,
            ),
          ),
        ),
        Positioned.fill(
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 4,
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withOpacity(0.3),
              thumbColor: Colors.white,
            ),
            child: Slider(
              value: _sliderValue,
              onChanged: (value) => setState(() => _sliderValue = value),
            ),
          ),
        ),
      ],
    );
  }
}
