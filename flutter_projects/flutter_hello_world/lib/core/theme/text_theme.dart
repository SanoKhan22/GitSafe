import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

/// GullyCric Text Theme Configuration
/// 
/// Defines typography hierarchy using Inter/Poppins fonts with
/// cricket-specific text styles and Material 3 compliance
class AppTextTheme {
  AppTextTheme._(); // Private constructor to prevent instantiation

  /// Main text theme for the application
  static const TextTheme textTheme = TextTheme(
    // Display styles (largest text)
    displayLarge: TextStyle(
      fontFamily: AppStyles.primaryFont,
      fontSize: 57,
      fontWeight: FontWeight.w400,
      height: 1.12,
      letterSpacing: -0.25,
      color: AppColors.textPrimary,
    ),
    displayMedium: TextStyle(
      fontFamily: AppStyles.primaryFont,
      fontSize: 45,
      fontWeight: FontWeight.w400,
      height: 1.16,
      letterSpacing: 0,
      color: AppColors.textPrimary,
    ),
    displaySmall: TextStyle(
      fontFamily: AppStyles.primaryFont,
      fontSize: 36,
      fontWeight: FontWeight.w400,
      height: 1.22,
      letterSpacing: 0,
      color: AppColors.textPrimary,
    ),

    // Headline styles
    headlineLarge: TextStyle(
      fontFamily: AppStyles.primaryFont,
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.25,
      letterSpacing: 0,
      color: AppColors.textPrimary,
    ),
    headlineMedium: TextStyle(
      fontFamily: AppStyles.primaryFont,
      fontSize: 28,
      fontWeight: FontWeight.w600,
      height: 1.29,
      letterSpacing: 0,
      color: AppColors.textPrimary,
    ),
    headlineSmall: TextStyle(
      fontFamily: AppStyles.primaryFont,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.33,
      letterSpacing: 0,
      color: AppColors.textPrimary,
    ),

    // Title styles
    titleLarge: TextStyle(
      fontFamily: AppStyles.primaryFont,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.27,
      letterSpacing: 0,
      color: AppColors.textPrimary,
    ),
    titleMedium: TextStyle(
      fontFamily: AppStyles.primaryFont,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.5,
      letterSpacing: 0.15,
      color: AppColors.textPrimary,
    ),
    titleSmall: TextStyle(
      fontFamily: AppStyles.primaryFont,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.43,
      letterSpacing: 0.1,
      color: AppColors.textPrimary,
    ),

    // Body styles
    bodyLarge: TextStyle(
      fontFamily: AppStyles.primaryFont,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
      letterSpacing: 0.5,
      color: AppColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontFamily: AppStyles.primaryFont,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.43,
      letterSpacing: 0.25,
      color: AppColors.textPrimary,
    ),
    bodySmall: TextStyle(
      fontFamily: AppStyles.primaryFont,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.33,
      letterSpacing: 0.4,
      color: AppColors.textSecondary,
    ),

    // Label styles
    labelLarge: TextStyle(
      fontFamily: AppStyles.primaryFont,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.43,
      letterSpacing: 0.1,
      color: AppColors.textPrimary,
    ),
    labelMedium: TextStyle(
      fontFamily: AppStyles.primaryFont,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.33,
      letterSpacing: 0.5,
      color: AppColors.textPrimary,
    ),
    labelSmall: TextStyle(
      fontFamily: AppStyles.primaryFont,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      height: 1.45,
      letterSpacing: 0.5,
      color: AppColors.textSecondary,
    ),
  );

  /// Dark theme text theme with adjusted colors
  static TextTheme get darkTextTheme {
    return textTheme.copyWith(
      displayLarge: textTheme.displayLarge?.copyWith(
        color: AppColors.white,
      ),
      displayMedium: textTheme.displayMedium?.copyWith(
        color: AppColors.white,
      ),
      displaySmall: textTheme.displaySmall?.copyWith(
        color: AppColors.white,
      ),
      headlineLarge: textTheme.headlineLarge?.copyWith(
        color: AppColors.white,
      ),
      headlineMedium: textTheme.headlineMedium?.copyWith(
        color: AppColors.white,
      ),
      headlineSmall: textTheme.headlineSmall?.copyWith(
        color: AppColors.white,
      ),
      titleLarge: textTheme.titleLarge?.copyWith(
        color: AppColors.white,
      ),
      titleMedium: textTheme.titleMedium?.copyWith(
        color: AppColors.white,
      ),
      titleSmall: textTheme.titleSmall?.copyWith(
        color: AppColors.white,
      ),
      bodyLarge: textTheme.bodyLarge?.copyWith(
        color: AppColors.white,
      ),
      bodyMedium: textTheme.bodyMedium?.copyWith(
        color: AppColors.white,
      ),
      bodySmall: textTheme.bodySmall?.copyWith(
        color: AppColors.grey300,
      ),
      labelLarge: textTheme.labelLarge?.copyWith(
        color: AppColors.white,
      ),
      labelMedium: textTheme.labelMedium?.copyWith(
        color: AppColors.white,
      ),
      labelSmall: textTheme.labelSmall?.copyWith(
        color: AppColors.grey300,
      ),
    );
  }

  /// Cricket-specific text styles
  static const CricketTextTheme cricket = CricketTextTheme();
}

/// Cricket-specific text theme
class CricketTextTheme {
  const CricketTextTheme();

  // Score display styles with monospace font
  TextStyle get scoreDisplayLarge => const TextStyle(
    fontFamily: AppStyles.scoreFont,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0,
    color: AppColors.primary,
  );

  TextStyle get scoreDisplayMedium => const TextStyle(
    fontFamily: AppStyles.scoreFont,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0,
    color: AppColors.primary,
  );

  TextStyle get scoreDisplaySmall => const TextStyle(
    fontFamily: AppStyles.scoreFont,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0,
    color: AppColors.primary,
  );

  TextStyle get scoreText => const TextStyle(
    fontFamily: AppStyles.scoreFont,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.44,
    letterSpacing: 0,
    color: AppColors.primary,
  );

  TextStyle get scoreSmall => const TextStyle(
    fontFamily: AppStyles.scoreFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0,
    color: AppColors.primary,
  );

  // Live match indicator
  TextStyle get liveIndicator => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.33,
    letterSpacing: 1.0,
    color: AppColors.white,
  );

  // Match status styles
  TextStyle get matchTitle => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  TextStyle get matchSubtitle => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.15,
    color: AppColors.textSecondary,
  );

  TextStyle get matchDetails => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0.25,
    color: AppColors.textSecondary,
  );

  TextStyle get matchTime => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.4,
    color: AppColors.textTertiary,
  );

  // Team and player styles
  TextStyle get teamName => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.44,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  TextStyle get teamNameSmall => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.43,
    letterSpacing: 0.1,
    color: AppColors.textPrimary,
  );

  TextStyle get playerName => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  TextStyle get playerNameSmall => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.1,
    color: AppColors.textPrimary,
  );

  TextStyle get playerRole => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.4,
    color: AppColors.textSecondary,
  );

  TextStyle get playerStats => const TextStyle(
    fontFamily: AppStyles.scoreFont,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.4,
    color: AppColors.textSecondary,
  );

  // Over and ball information
  TextStyle get overInfo => const TextStyle(
    fontFamily: AppStyles.scoreFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.secondary,
  );

  TextStyle get ballInfo => const TextStyle(
    fontFamily: AppStyles.scoreFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0,
    color: AppColors.secondary,
  );

  // Run rate and statistics
  TextStyle get runRate => const TextStyle(
    fontFamily: AppStyles.scoreFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0,
    color: AppColors.accent,
  );

  TextStyle get statistics => const TextStyle(
    fontFamily: AppStyles.scoreFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0,
    color: AppColors.textSecondary,
  );

  // Commentary and news
  TextStyle get commentary => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.25,
    color: AppColors.textPrimary,
  );

  TextStyle get commentaryTime => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.4,
    color: AppColors.textTertiary,
  );

  TextStyle get newsTitle => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  TextStyle get newsContent => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.25,
    color: AppColors.textPrimary,
  );

  TextStyle get newsMetadata => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.4,
    color: AppColors.textSecondary,
  );

  // Button text styles
  TextStyle get buttonLarge => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.5,
    color: AppColors.white,
  );

  TextStyle get buttonMedium => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.29,
    letterSpacing: 0.25,
    color: AppColors.white,
  );

  TextStyle get buttonSmall => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0.25,
    color: AppColors.white,
  );

  // Form and input styles
  TextStyle get inputLabel => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.1,
    color: AppColors.textSecondary,
  );

  TextStyle get inputText => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  TextStyle get inputHint => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.5,
    color: AppColors.textTertiary,
  );

  TextStyle get inputError => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.4,
    color: AppColors.error,
  );

  // Card and list styles
  TextStyle get cardTitle => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  TextStyle get cardSubtitle => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0.25,
    color: AppColors.textSecondary,
  );

  TextStyle get listTitle => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  TextStyle get listSubtitle => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0.25,
    color: AppColors.textSecondary,
  );

  // Tab and navigation styles
  TextStyle get tabLabel => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.43,
    letterSpacing: 0.1,
    color: AppColors.primary,
  );

  TextStyle get tabLabelInactive => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.1,
    color: AppColors.textSecondary,
  );

  TextStyle get navigationLabel => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0.5,
    color: AppColors.primary,
  );

  TextStyle get navigationLabelInactive => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.5,
    color: AppColors.textSecondary,
  );

  // Status and badge styles
  TextStyle get statusActive => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0.5,
    color: AppColors.success,
  );

  TextStyle get statusInactive => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0.5,
    color: AppColors.textTertiary,
  );

  TextStyle get badge => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0.5,
    color: AppColors.white,
  );

  // Tooltip and helper text
  TextStyle get tooltip => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.4,
    color: AppColors.white,
  );

  TextStyle get helperText => const TextStyle(
    fontFamily: AppStyles.primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.4,
    color: AppColors.textTertiary,
  );
}

/// Text theme utilities
class TextThemeUtils {
  TextThemeUtils._();

  /// Gets text style with custom color
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Gets text style with custom weight
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  /// Gets text style with custom size
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }

  /// Gets text style with opacity
  static TextStyle withOpacity(TextStyle style, double opacity) {
    return style.copyWith(color: style.color?.withOpacity(opacity));
  }

  /// Gets responsive text style based on screen size
  static TextStyle responsive(
    BuildContext context,
    TextStyle baseStyle, {
    double? mobileScale,
    double? tabletScale,
    double? desktopScale,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    double scale = 1.0;

    if (screenWidth < AppDimensions.mobileBreakpoint) {
      scale = mobileScale ?? 0.9;
    } else if (screenWidth < AppDimensions.tabletBreakpoint) {
      scale = tabletScale ?? 1.0;
    } else {
      scale = desktopScale ?? 1.1;
    }

    return baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? 14) * scale,
    );
  }

  /// Gets text style for different cricket contexts
  static TextStyle forCricketContext(
    CricketTextContext context, {
    Color? color,
    FontWeight? weight,
  }) {
    TextStyle baseStyle;

    switch (context) {
      case CricketTextContext.score:
        baseStyle = AppTextTheme.cricket.scoreText;
        break;
      case CricketTextContext.team:
        baseStyle = AppTextTheme.cricket.teamName;
        break;
      case CricketTextContext.player:
        baseStyle = AppTextTheme.cricket.playerName;
        break;
      case CricketTextContext.match:
        baseStyle = AppTextTheme.cricket.matchTitle;
        break;
      case CricketTextContext.commentary:
        baseStyle = AppTextTheme.cricket.commentary;
        break;
      case CricketTextContext.news:
        baseStyle = AppTextTheme.cricket.newsTitle;
        break;
    }

    return baseStyle.copyWith(
      color: color,
      fontWeight: weight,
    );
  }
}

/// Cricket text context enumeration
enum CricketTextContext {
  score,
  team,
  player,
  match,
  commentary,
  news,
}