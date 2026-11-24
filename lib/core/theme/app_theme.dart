import 'package:flutter/material.dart';

class AppTheme {
  // New palette
  static const blue = Color(0xFF345A93);
  static const darkGreen = Color(0xFF0D4523);
  static const darkTeal = Color(0xFF2A3C39);
  static const lightTeal = Color(0xFF84BDA6);

  static const primary = Color(0xFF345A93);
  static const secondary = Color(0xFF0D4523);
  static const accent = Color(0xFF2A3C39);
  static const surface = Color(0xFF2A3C39);
  static const background = Color(0xFF84BDA6);

  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: secondary,
      surface: surface,
    ),
    scaffoldBackgroundColor: background,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 2,
      backgroundColor: primary,
      foregroundColor: AppTheme.background,
    ),
    cardTheme: CardThemeData(
      elevation: 6,
      shadowColor: primary.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: AppTheme.background,
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
