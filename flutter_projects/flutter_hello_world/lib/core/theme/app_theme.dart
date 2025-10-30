import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import 'text_theme.dart';

/// GullyCric App Theme Configuration
/// 
/// Implements Material 3 design system with cricket-themed customizations
/// Provides both light and dark themes with consistent styling
class AppTheme {
  AppTheme._(); // Private constructor to prevent instantiation

  /// Light theme configuration
  static ThemeData get lightTheme {
    final colorScheme = _lightColorScheme;
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: AppTextTheme.textTheme,
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: AppDimensions.appBarElevation,
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: colorScheme.surfaceTint,
        shadowColor: Colors.black.withOpacity(0.1),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: AppTextTheme.textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: AppDimensions.iconM,
        ),
        actionsIconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: AppDimensions.iconM,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: AppDimensions.bottomNavElevation,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        selectedLabelStyle: AppTextTheme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextTheme.textTheme.labelSmall,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // Navigation Bar Theme (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        elevation: AppDimensions.bottomNavElevation,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        indicatorColor: colorScheme.secondaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextTheme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            );
          }
          return AppTextTheme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
              color: colorScheme.onSecondaryContainer,
              size: AppDimensions.iconM,
            );
          }
          return IconThemeData(
            color: colorScheme.onSurfaceVariant,
            size: AppDimensions.iconM,
          );
        }),
      ),

      // Card Theme
      cardTheme: CardTheme(
        elevation: AppDimensions.cardElevation,
        shadowColor: Colors.black.withOpacity(0.1),
        surfaceTintColor: colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        ),
        margin: const EdgeInsets.all(AppDimensions.spacingS),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: AppDimensions.buttonElevation,
          shadowColor: Colors.black.withOpacity(0.2),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.onSurface.withOpacity(0.12),
          disabledForegroundColor: colorScheme.onSurface.withOpacity(0.38),
          minimumSize: const Size(0, AppDimensions.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingL,
            vertical: AppDimensions.spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          ),
          textStyle: AppStyles.buttonLarge,
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          disabledForegroundColor: colorScheme.onSurface.withOpacity(0.38),
          minimumSize: const Size(0, AppDimensions.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingL,
            vertical: AppDimensions.spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          ),
          side: BorderSide(color: colorScheme.outline),
          textStyle: AppStyles.buttonLarge.copyWith(
            color: colorScheme.primary,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          disabledForegroundColor: colorScheme.onSurface.withOpacity(0.38),
          minimumSize: const Size(0, AppDimensions.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingM,
            vertical: AppDimensions.spacingS,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          ),
          textStyle: AppStyles.buttonMedium.copyWith(
            color: colorScheme.primary,
          ),
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: AppDimensions.elevationM,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingM,
          vertical: AppDimensions.spacingM,
        ),
        hintStyle: AppTextTheme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        labelStyle: AppTextTheme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        errorStyle: AppTextTheme.textTheme.bodySmall?.copyWith(
          color: colorScheme.error,
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.secondaryContainer,
        disabledColor: colorScheme.onSurface.withOpacity(0.12),
        deleteIconColor: colorScheme.onSurfaceVariant,
        labelStyle: AppTextTheme.textTheme.labelLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        secondaryLabelStyle: AppTextTheme.textTheme.labelLarge?.copyWith(
          color: colorScheme.onSecondaryContainer,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingS,
          vertical: AppDimensions.spacingXS,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.chipRadius),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogTheme(
        elevation: AppDimensions.elevationL,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        ),
        titleTextStyle: AppTextTheme.textTheme.headlineSmall?.copyWith(
          color: colorScheme.onSurface,
        ),
        contentTextStyle: AppTextTheme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: AppTextTheme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        actionTextColor: colorScheme.inversePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: AppDimensions.elevationM,
      ),

      // Tab Bar Theme
      tabBarTheme: TabBarTheme(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        labelStyle: AppTextTheme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextTheme.textTheme.titleSmall,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingM,
          vertical: AppDimensions.spacingXS,
        ),
        titleTextStyle: AppTextTheme.textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
        subtitleTextStyle: AppTextTheme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        iconColor: colorScheme.onSurfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        ),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          return colorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.surfaceContainerHighest;
        }),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
        side: BorderSide(color: colorScheme.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
        ),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.outline;
        }),
      ),

      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.surfaceContainerHighest,
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withOpacity(0.12),
        valueIndicatorColor: colorScheme.primary,
        valueIndicatorTextStyle: AppTextTheme.textTheme.labelSmall?.copyWith(
          color: colorScheme.onPrimary,
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
        circularTrackColor: colorScheme.surfaceContainerHighest,
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: AppDimensions.iconM,
      ),

      // Primary Icon Theme
      primaryIconTheme: IconThemeData(
        color: colorScheme.onPrimary,
        size: AppDimensions.iconM,
      ),

      // Scaffold Background Color
      scaffoldBackgroundColor: colorScheme.surface,

      // Canvas Color
      canvasColor: colorScheme.surface,

      // Disabled Color
      disabledColor: colorScheme.onSurface.withOpacity(0.38),

      // Highlight Color
      highlightColor: colorScheme.primary.withOpacity(0.12),

      // Splash Color
      splashColor: colorScheme.primary.withOpacity(0.12),

      // Focus Color
      focusColor: colorScheme.primary.withOpacity(0.12),

      // Hover Color
      hoverColor: colorScheme.primary.withOpacity(0.08),
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    final colorScheme = _darkColorScheme;
    
    return lightTheme.copyWith(
      colorScheme: colorScheme,
      
      // App Bar Theme for dark mode
      appBarTheme: lightTheme.appBarTheme.copyWith(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: AppTextTheme.textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: AppDimensions.iconM,
        ),
        actionsIconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: AppDimensions.iconM,
        ),
      ),

      // Bottom Navigation Bar Theme for dark mode
      bottomNavigationBarTheme: lightTheme.bottomNavigationBarTheme.copyWith(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
      ),

      // Navigation Bar Theme for dark mode
      navigationBarTheme: lightTheme.navigationBarTheme.copyWith(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        indicatorColor: colorScheme.secondaryContainer,
      ),

      // Input Decoration Theme for dark mode
      inputDecorationTheme: lightTheme.inputDecorationTheme.copyWith(
        fillColor: colorScheme.surfaceContainerHighest,
        hintStyle: AppTextTheme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        labelStyle: AppTextTheme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // Scaffold Background Color for dark mode
      scaffoldBackgroundColor: colorScheme.surface,

      // Canvas Color for dark mode
      canvasColor: colorScheme.surface,
    );
  }

  /// Light color scheme based on Material 3 with cricket theme
  static const ColorScheme _lightColorScheme = ColorScheme.light(
    // Primary colors (Royal Blue)
    primary: AppColors.primary,
    onPrimary: AppColors.textOnPrimary,
    primaryContainer: Color(0xFFD1E4FF),
    onPrimaryContainer: Color(0xFF001D36),

    // Secondary colors (Field Green)
    secondary: AppColors.secondary,
    onSecondary: AppColors.textOnSecondary,
    secondaryContainer: Color(0xFFB2F2BB),
    onSecondaryContainer: Color(0xFF002204),

    // Tertiary colors (Sporty Orange)
    tertiary: AppColors.accent,
    onTertiary: AppColors.textOnAccent,
    tertiaryContainer: Color(0xFFFFDCC2),
    onTertiaryContainer: Color(0xFF2A1800),

    // Error colors
    error: AppColors.error,
    onError: Colors.white,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),

    // Surface colors
    surface: AppColors.backgroundLight,
    onSurface: AppColors.textPrimary,
    surfaceContainerHighest: Color(0xFFE6E0E9),
    onSurfaceVariant: AppColors.textSecondary,

    // Outline colors
    outline: Color(0xFF79747E),
    outlineVariant: Color(0xFFCAC4D0),

    // Inverse colors
    inverseSurface: Color(0xFF313033),
    onInverseSurface: Color(0xFFF4EFF4),
    inversePrimary: Color(0xFF9ECAFF),

    // Shadow and surface tint
    shadow: Colors.black,
    surfaceTint: AppColors.primary,
  );

  /// Dark color scheme based on Material 3 with cricket theme
  static const ColorScheme _darkColorScheme = ColorScheme.dark(
    // Primary colors (Royal Blue)
    primary: Color(0xFF9ECAFF),
    onPrimary: Color(0xFF003258),
    primaryContainer: Color(0xFF004A77),
    onPrimaryContainer: Color(0xFFD1E4FF),

    // Secondary colors (Field Green)
    secondary: Color(0xFF57E389),
    onSecondary: Color(0xFF003A16),
    secondaryContainer: Color(0xFF005227),
    onSecondaryContainer: Color(0xFFB2F2BB),

    // Tertiary colors (Sporty Orange)
    tertiary: Color(0xFFFFB77C),
    onTertiary: Color(0xFF452B00),
    tertiaryContainer: Color(0xFF633F00),
    onTertiaryContainer: Color(0xFFFFDCC2),

    // Error colors
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),

    // Surface colors
    surface: AppColors.backgroundDark,
    onSurface: Color(0xFFE6E1E5),
    surfaceContainerHighest: Color(0xFF49454F),
    onSurfaceVariant: Color(0xFFCAC4D0),

    // Outline colors
    outline: Color(0xFF938F99),
    outlineVariant: Color(0xFF49454F),

    // Inverse colors
    inverseSurface: Color(0xFFE6E1E5),
    onInverseSurface: Color(0xFF313033),
    inversePrimary: AppColors.primary,

    // Shadow and surface tint
    shadow: Colors.black,
    surfaceTint: Color(0xFF9ECAFF),
  );

  /// Gets the appropriate theme based on brightness
  static ThemeData getTheme(Brightness brightness) {
    return brightness == Brightness.dark ? darkTheme : lightTheme;
  }

  /// Gets the appropriate color scheme based on brightness
  static ColorScheme getColorScheme(Brightness brightness) {
    return brightness == Brightness.dark ? _darkColorScheme : _lightColorScheme;
  }
}

/// Cricket-specific theme extensions
extension CricketThemeExtension on ThemeData {
  /// Gets cricket-specific colors
  CricketColors get cricketColors => CricketColors(colorScheme);
  
  /// Gets cricket-specific text styles
  CricketTextStyles get cricketTextStyles => CricketTextStyles(textTheme);
}

/// Cricket-specific color definitions
class CricketColors {
  final ColorScheme _colorScheme;
  
  const CricketColors(this._colorScheme);

  // Cricket ball and equipment colors
  Color get cricketBall => AppColors.cricketBall;
  Color get cricketPitch => AppColors.cricketPitch;
  Color get cricketStumps => AppColors.cricketStumps;
  Color get cricketBoundary => AppColors.cricketBoundary;

  // Match status colors
  Color get liveMatch => AppColors.error;
  Color get upcomingMatch => AppColors.warning;
  Color get completedMatch => AppColors.success;

  // Score colors
  Color get runsColor => _colorScheme.primary;
  Color get wicketsColor => _colorScheme.error;
  Color get oversColor => _colorScheme.secondary;
  Color get extrasColor => _colorScheme.tertiary;

  // Team colors (can be customized per team)
  Color get teamAColor => _colorScheme.primary;
  Color get teamBColor => _colorScheme.secondary;

  // Performance indicator colors
  Color get excellentPerformance => const Color(0xFF4CAF50);
  Color get goodPerformance => const Color(0xFF8BC34A);
  Color get averagePerformance => const Color(0xFFFF9800);
  Color get poorPerformance => const Color(0xFFF44336);
}

/// Cricket-specific text styles
class CricketTextStyles {
  final TextTheme _textTheme;
  
  const CricketTextStyles(this._textTheme);

  // Score display styles
  TextStyle get scoreDisplay => AppStyles.scoreDisplay;
  TextStyle get scoreMedium => AppStyles.scoreMedium;
  TextStyle get scoreSmall => AppStyles.scoreSmall;

  // Live indicator style
  TextStyle get liveIndicator => AppStyles.liveIndicator;

  // Match status styles
  TextStyle get matchTitle => _textTheme.titleLarge ?? AppStyles.headline4;
  TextStyle get matchSubtitle => _textTheme.titleMedium ?? AppStyles.headline5;
  TextStyle get matchDetails => _textTheme.bodyMedium ?? AppStyles.bodyMedium;

  // Player and team styles
  TextStyle get playerName => _textTheme.titleMedium ?? AppStyles.headline5;
  TextStyle get teamName => _textTheme.titleLarge ?? AppStyles.headline4;
  TextStyle get playerStats => _textTheme.bodySmall ?? AppStyles.bodySmall;

  // Commentary and news styles
  TextStyle get commentary => _textTheme.bodyMedium ?? AppStyles.bodyMedium;
  TextStyle get newsTitle => _textTheme.titleMedium ?? AppStyles.headline5;
  TextStyle get newsContent => _textTheme.bodyMedium ?? AppStyles.bodyMedium;
}