import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF4A55A2);
  static const Color accent = Color(0xFFF5A623);
  static const Color background = Color(0xFFF7F8FC);
  static const Color cardBackground = Color(0xFF5E6DDD);
  static const Color textDark = Color(0xFF2E2E2E);
  static const Color textMuted = Color(0xFF8A8A8A);
  static const Color danger = Color(0xFFE57373);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: accent,
        surface: cardBackground,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: textDark,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        titleLarge: TextStyle(
          color: textDark,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: const CardThemeData(
        color: cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: primary,
        selectionColor: Color(0xFFBAC8FF),
      ),
    );
  }
}
