import 'package:flutter/material.dart';

class AppTheme {
  // Color palette from project specification
  static const primary = Color(0xFF1A2D42);
  static const secondary = Color(0xFF2E4156);
  static const accent = Color(0xFFAA8787);
  static const surface = Color(0xFFC0C8CA);
  static const background = Color(0xFFD4D8DD);

  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: accent,
      surface: surface,
    ),
    scaffoldBackgroundColor: background,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 2,
      backgroundColor: primary,
      foregroundColor: Colors.white,
    ),
    cardTheme: CardThemeData(
      elevation: 6,
      shadowColor: primary.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    ),
  );
}