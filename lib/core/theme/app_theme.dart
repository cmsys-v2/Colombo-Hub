import 'package:flutter/material.dart';

class AppTheme {
  // Brand Color Palette
  static const Color primaryTeal = Color(0xFF0F766E);
  static const Color primaryTealDark = Color(0xFF115E59);
  static const Color accentAmber = Color(0xFFD97706);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceWhite = Colors.white;

  // Extended ColomboHub Accent Palette
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

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundLight,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryTeal,
      primary: primaryTeal,
      secondary: accentAmber,
      surface: surfaceWhite,
    ),
    fontFamily: 'Inter',
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceWhite,
      elevation: 0,
      scrolledUnderElevation: 1,
      titleTextStyle: TextStyle(color: Color(0xFF0F172A), fontSize: 18, fontWeight: FontWeight.bold),
    ),
    cardTheme: CardThemeData(
      elevation: 0.5,
      color: surfaceWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
    ),
  );
}
