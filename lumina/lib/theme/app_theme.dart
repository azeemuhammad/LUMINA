import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData dark = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: const Color(0xFF13121B),
    primaryColor: const Color(0xFFC3C0FF),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFC3C0FF),
      brightness: Brightness.dark,
      secondary: const Color(0xFF4CD7F6),
    ),
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.geist(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      headlineMedium: GoogleFonts.geist(
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.geist(fontSize: 24, fontWeight: FontWeight.w600),
    ),
  );
}
