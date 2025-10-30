import 'package:flutter/material.dart';

/// GullyCric App Color Palette
/// 
/// Defines the consistent color scheme for the cricket app:
/// - Primary: Royal Blue #1E88E5 (energetic, trustworthy)
/// - Secondary: Field Green #00C853 (cricket field, nature)
/// - Accent: Sporty Orange #FF6D00 (action, highlights)
/// - Backgrounds: Off White (light) / Charcoal (dark)
/// - Text: Dark Slate for readability
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Colors - Royal Blue theme
  static const Color primary = Color(0xFF1E88E5);
  static const Color primaryLight = Color(0xFF6AB7FF);
  static const Color primaryDark = Color(0xFF005CB2);

  // Secondary Colors - Field Green theme
  static const Color secondary = Color(0xFF00C853);
  static const Color secondaryLight = Color(0xFF5EFC82);
  static const Color secondaryDark = Color(0xFF009624);

  // Accent Colors - Sporty Orange theme
  static const Color accent = Color(0xFFFF6D00);
  static const Color accentLight = Color(0xFFFF9E40);
  static const Color accentDark = Color(0xFFC43E00);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF9FAFB); // Off White
  static const Color backgroundDark = Color(0xFF121212);  // Charcoal
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Text Colors
  static const Color textPrimary = Color(0xFF263238);     // Dark Slate
  static const Color textSecondary = Color(0xFF546E7A);   // Medium Slate
  static const Color textTertiary = Color(0xFF90A4AE);    // Light Slate
  static const Color textOnPrimary = Colors.white;
  static const Color textOnSecondary = Colors.white;
  static const Color textOnAccent = Colors.white;
  static const Color textOnBackground = Color(0xFF263238);
  static const Color textOnSurface = Color(0xFF263238);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Cricket-specific Colors
  static const Color cricketBall = Color(0xFFD32F2F);     // Red cricket ball
  static const Color cricketPitch = Color(0xFF8D6E63);    // Brown pitch
  static const Color cricketStumps = Color(0xFFFFEB3B);   // Yellow stumps
  static const Color cricketBoundary = Color(0xFF4CAF50); // Green boundary

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Gradient Colors for dynamic effects
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Stadium night theme gradient for dark mode
  static const LinearGradient stadiumNightGradient = LinearGradient(
    colors: [backgroundDark, Color(0xFF1A1A1A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Convenience getters for theme-aware colors
  static Color get background => backgroundLight;
  static Color get surface => surfaceLight;
  static Color get border => grey300;
}