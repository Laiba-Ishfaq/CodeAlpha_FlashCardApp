import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF4A55A2);
  static const Color secondary = Color(0xFF7895CB);
  static const Color accent = Color(0xFFF5A623);
  static const Color background = Color(0xFFF6F8FC);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF4CAF50);
  static const Color danger = Color(0xFFEF5350);
  static const Color title = Color(0xFF1F2937);
  static const Color subtitle = Color(0xFF6B7280);
  static const Color textDark = title;
  static const Color textMuted = subtitle;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        surface: cardBackground,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 72,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: title,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        titleLarge: TextStyle(
          color: title,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(
          color: subtitle,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
      cardTheme: const CardThemeData(
        color: cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: primary,
        selectionColor: Color(0xFFBAC8FF),
      ),
    );
  }
}
