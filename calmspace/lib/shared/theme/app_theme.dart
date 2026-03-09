import 'package:flutter/material.dart';

class AppTheme {
  // ─── Private constructor ─────────────────────────────────────────
  // Prevents anyone from creating an instance of AppTheme
  // All values are static - accessed directly via AppTheme.background
  AppTheme._();

  // ─── Colors ──────────────────────────────────────────────────────
  static const Color background = Color(0xFF0D0D1A);
  static const Color surface = Color(0xFF1A1A2E);
  static const Color cardBackground = Color(0xFF16213E);
  static const Color primary = Color(0xFF7B8CDE);
  static const Color primaryLight = Color(0xFFB8C0F0);
  static const Color accent = Color(0xFF9B8EC4);
  static const Color textPrimary = Color(0xFFF0F0FF);
  static const Color textSecondary = Color(0xFF9090AA);
  static const Color divider = Color(0xFF2A2A3E);

  // ─── Tag Colors ───────────────────────────────────────────────────
  static const Map<String, Color> tagColors = {
    'Focus': Color(0xFF5B8CFF),
    'Calm': Color(0xFF6BC5A0),
    'Sleep': Color(0xFF9B7FD4),
    'Reset': Color(0xFFFF8C69),
  };

  // ─── Spacing ──────────────────────────────────────────────────────
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;

  // ─── Border Radius ────────────────────────────────────────────────
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;

  // ─── Text Styles ──────────────────────────────────────────────────
  static const TextStyle headingLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    letterSpacing: 0.3,
  );

  // ─── Theme Data ───────────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: accent,
        surface: surface,
        background: background,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: headingSmall,
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: const CardThemeData(
        color: cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(radiusLG),
          ),
        ),
      ),
    );
  }

  // ─── Helper method for tag color ──────────────────────────────────
  static Color getTagColor(String tag) {
    return tagColors[tag] ?? primary;
  }
}