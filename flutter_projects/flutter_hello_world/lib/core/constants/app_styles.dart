import 'package:flutter/material.dart';
import 'app_colors.dart';

/// GullyCric App Style Constants
/// 
/// Defines typography, spacing, dimensions, and other design tokens
/// following Material 3 principles with cricket-themed customizations
class AppStyles {
  AppStyles._(); // Private constructor to prevent instantiation

  // Font Families
  static const String primaryFont = 'Inter'; // Modern, geometric
  static const String secondaryFont = 'Poppins'; // Alternative primary
  static const String scoreFont = 'RobotoMono'; // Monospace for scores

  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // Text Styles - Headlines
  static const TextStyle headline1 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 32,
    fontWeight: bold,
    height: 1.2,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline2 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 28,
    fontWeight: bold,
    height: 1.3,
    letterSpacing: -0.25,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline3 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24,
    fontWeight: semiBold,
    height: 1.3,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline4 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 20,
    fontWeight: semiBold,
    height: 1.4,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline5 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 18,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline6 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: medium,
    height: 1.5,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  // Text Styles - Body
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: regular,
    height: 1.5,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: regular,
    height: 1.4,
    letterSpacing: 0.25,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: regular,
    height: 1.3,
    letterSpacing: 0.4,
    color: AppColors.textSecondary,
  );

  // Text Styles - Labels
  static const TextStyle labelLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0.1,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: medium,
    height: 1.3,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 10,
    fontWeight: medium,
    height: 1.2,
    letterSpacing: 0.5,
    color: AppColors.textSecondary,
  );

  // Cricket-specific Text Styles
  static const TextStyle scoreDisplay = TextStyle(
    fontFamily: scoreFont,
    fontSize: 32,
    fontWeight: bold,
    height: 1.2,
    letterSpacing: 0,
    color: AppColors.primary,
  );

  static const TextStyle scoreMedium = TextStyle(
    fontFamily: scoreFont,
    fontSize: 24,
    fontWeight: semiBold,
    height: 1.3,
    letterSpacing: 0,
    color: AppColors.primary,
  );

  static const TextStyle scoreSmall = TextStyle(
    fontFamily: scoreFont,
    fontSize: 16,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.primary,
  );

  static const TextStyle liveIndicator = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: bold,
    height: 1.2,
    letterSpacing: 1.0,
    color: AppColors.white,
  );

  // Button Text Styles
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: semiBold,
    height: 1.2,
    letterSpacing: 0.5,
    color: AppColors.white,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: medium,
    height: 1.2,
    letterSpacing: 0.25,
    color: AppColors.white,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: medium,
    height: 1.2,
    letterSpacing: 0.25,
    color: AppColors.white,
  );
}

/// Design Dimensions and Spacing
class AppDimensions {
  AppDimensions._(); // Private constructor to prevent instantiation

  // Spacing Scale (8pt grid system)
  static const double spacingXXS = 2.0;
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 40.0;
  static const double spacingXXXL = 48.0;

  // Border Radius
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;
  static const double radiusCircular = 50.0;

  // Component-specific Radius
  static const double cardRadius = radiusL; // 16dp
  static const double buttonRadius = radiusM; // 12dp
  static const double inputRadius = radiusS; // 8dp
  static const double chipRadius = radiusXL; // 20dp

  // Elevation
  static const double elevationNone = 0.0;
  static const double elevationXS = 1.0;
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;
  static const double elevationXL = 12.0;
  static const double elevationXXL = 16.0;

  // Component-specific Elevation
  static const double cardElevation = elevationS; // 2dp
  static const double buttonElevation = elevationXS; // 1dp
  static const double appBarElevation = elevationS; // 2dp
  static const double bottomNavElevation = elevationM; // 4dp

  // Touch Targets (minimum 44px for accessibility)
  static const double minTouchTarget = 44.0;
  static const double buttonHeight = 48.0;
  static const double inputHeight = 56.0;
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 80.0;
  static const double tabHeight = 48.0;

  // Icon Sizes
  static const double iconXS = 16.0;
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 40.0;
  static const double iconXXL = 48.0;

  // Avatar Sizes
  static const double avatarS = 32.0;
  static const double avatarM = 40.0;
  static const double avatarL = 56.0;
  static const double avatarXL = 72.0;

  // Card Dimensions
  static const double cardMinHeight = 120.0;
  static const double cardMaxWidth = 400.0;
  static const double cardPadding = spacingM;

  // Screen Breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;

  // Cricket-specific Dimensions
  static const double scoreCardHeight = 200.0;
  static const double playerCardHeight = 80.0;
  static const double matchCardHeight = 160.0;
  static const double liveIndicatorSize = 8.0;
}

/// Animation Durations and Curves
class AppAnimations {
  AppAnimations._(); // Private constructor to prevent instantiation

  // Duration Constants (200-300ms for smooth feel)
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);
  static const Duration verySlow = Duration(milliseconds: 500);

  // Curve Constants
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve bounceIn = Curves.bounceIn;
  static const Curve bounceOut = Curves.bounceOut;
  static const Curve elasticIn = Curves.elasticIn;
  static const Curve elasticOut = Curves.elasticOut;

  // Cricket-specific Animations
  static const Duration scoreUpdate = Duration(milliseconds: 300);
  static const Duration liveIndicator = Duration(milliseconds: 1000);
  static const Duration cardFlip = Duration(milliseconds: 400);
}

/// Shadow Definitions
class AppShadows {
  AppShadows._(); // Private constructor to prevent instantiation

  // Soft shadows for cards and elevated components
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> appBarShadow = [
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];
}