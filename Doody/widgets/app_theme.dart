// ============================================================
//  theme/app_theme.dart — Design System
//  Centralised colour palette, text styles, and Material theme.
// ============================================================

import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ── Colour Palette ───────────────────────────────────────
  static const Color background    = Color(0xFF0D0F1A);
  static const Color surface       = Color(0xFF161928);
  static const Color card          = Color(0xFF1E2235);
  static const Color primary       = Color(0xFF6EE7B7); // mint green
  static const Color secondary     = Color(0xFF818CF8); // lavender
  static const Color accent        = Color(0xFFFBBF24); // amber
  static const Color danger        = Color(0xFFF87171); // soft red
  static const Color textPrimary   = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color divider       = Color(0xFF2A2F45);

  // ── Gradient Presets ─────────────────────────────────────
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D0F1A), Color(0xFF111827), Color(0xFF0A0E1A)],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6EE7B7), Color(0xFF3B82F6)],
  );

  static const LinearGradient happyGradient = LinearGradient(
    colors: [Color(0xFF6EE7B7), Color(0xFFFBBF24)],
  );

  static const LinearGradient sadGradient = LinearGradient(
    colors: [Color(0xFF818CF8), Color(0xFF6366F1)],
  );

  // ── Text Styles ──────────────────────────────────────────
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    color: textPrimary,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  // ── Material ThemeData ───────────────────────────────────
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      background: background,
      surface: surface,
      primary: primary,
      secondary: secondary,
      error: danger,
    ),
    cardTheme: CardTheme(
      color: card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: primary,
      unselectedItemColor: textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    fontFamily: 'Roboto',
  );
}
