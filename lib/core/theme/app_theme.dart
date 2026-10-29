import 'package:flutter/material.dart';

class AppTheme {
  // Signature ColomboHub Palette
  static const Color primaryTeal = Color(0xFF0D9488);
  static const Color darkTeal = Color(0xFF0F766E);
  static const Color lightTeal = Color(0xFFF0FDFA);
  static const Color tealBorder = Color(0xFF99F6E4);

  static const Color emeraldGreen = Color(0xFF059669);
  static const Color emeraldLight = Color(0xFFECFDF5);
  static const Color emeraldBorder = Color(0xFFA7F3D0);

  static const Color slateDark = Color(0xFF0F172A);
  static const Color slateCard = Color(0xFF1E293B);
  static const Color slateMuted = Color(0xFF64748B);
  static const Color slateLightBg = Color(0xFFF8FAFC);
  static const Color slateBorder = Color(0xFFE2E8F0);

  static const Color amberAccent = Color(0xFFD97706);
  static const Color amberLight = Color(0xFFFFFBEB);
  static const Color amberBorder = Color(0xFFFDE68A);

  static const Color purpleAccent = Color(0xFF7C3AED);
  static const Color purpleLight = Color(0xFFF5F3FF);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryTeal,
        primary: primaryTeal,
        secondary: emeraldGreen,
        surface: slateLightBg,
        onSurface: slateDark,
      ),
      scaffoldBackgroundColor: slateLightBg,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: slateDark,
        elevation: 0.5,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: slateBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryTeal,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: slateDark,
          side: const BorderSide(color: slateBorder),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: slateBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: slateBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryTeal, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }
}
