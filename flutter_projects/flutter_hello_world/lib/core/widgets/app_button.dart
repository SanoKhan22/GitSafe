import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../theme/text_theme.dart';

/// GullyCric App Button Widget
/// 
/// Consistent button implementation following Material 3 design
/// with cricket-themed styling and accessibility support
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final Widget? icon;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
  });

  /// Primary button constructor
  const AppButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
  }) : type = AppButtonType.primary;

  /// Secondary button constructor
  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
  }) : type = AppButtonType.secondary;

  /// Outlined button constructor
  const AppButton.outlined({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
  }) : type = AppButtonType.outlined;

  /// Text button constructor
  const AppButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
  }) : type = AppButtonType.text;

  /// Icon button constructor
  const AppButton.icon({
    super.key,
    required this.text,
    required this.icon,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onPressed != null && !isLoading;

    Widget button = _buildButton(context, theme, isEnabled);

    if (isFullWidth) {
      button = SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }

  Widget _buildButton(BuildContext context, ThemeData theme, bool isEnabled) {
    switch (type) {
      case AppButtonType.primary:
        return _buildElevatedButton(context, theme, isEnabled);
      case AppButtonType.secondary:
        return _buildSecondaryButton(context, theme, isEnabled);
      case AppButtonType.outlined:
        return _buildOutlinedButton(context, theme, isEnabled);
      case AppButtonType.text:
        return _buildTextButton(context, theme, isEnabled);
    }
  }

  Widget _buildElevatedButton(BuildContext context, ThemeData theme, bool isEnabled) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? theme.colorScheme.primary,
        foregroundColor: foregroundColor ?? theme.colorScheme.onPrimary,
        elevation: elevation ?? _getElevation(),
        minimumSize: Size(0, _getHeight()),
        padding: padding ?? _getPadding(),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(_getBorderRadius()),
        ),
        textStyle: _getTextStyle(context),
      ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildSecondaryButton(BuildContext context, ThemeData theme, bool isEnabled) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? theme.colorScheme.secondary,
        foregroundColor: foregroundColor ?? theme.colorScheme.onSecondary,
        elevation: elevation ?? _getElevation(),
        minimumSize: Size(0, _getHeight()),
        padding: padding ?? _getPadding(),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(_getBorderRadius()),
        ),
        textStyle: _getTextStyle(context),
      ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildOutlinedButton(BuildContext context, ThemeData theme, bool isEnabled) {
    return OutlinedButton(
      onPressed: isEnabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        foregroundColor: foregroundColor ?? theme.colorScheme.primary,
        minimumSize: Size(0, _getHeight()),
        padding: padding ?? _getPadding(),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(_getBorderRadius()),
        ),
        side: BorderSide(
          color: backgroundColor ?? theme.colorScheme.primary,
          width: 1.5,
        ),
        textStyle: _getTextStyle(context),
      ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildTextButton(BuildContext context, ThemeData theme, bool isEnabled) {
    return TextButton(
      onPressed: isEnabled ? onPressed : null,
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor ?? theme.colorScheme.primary,
        minimumSize: Size(0, _getHeight()),
        padding: padding ?? _getPadding(),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(_getBorderRadius()),
        ),
        textStyle: _getTextStyle(context),
      ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    if (isLoading) {
      return _buildLoadingContent(context);
    }

    if (icon != null) {
      return _buildIconContent(context);
    }

    return Text(text);
  }

  Widget _buildLoadingContent(BuildContext context) {
    final theme = Theme.of(context);
    final indicatorColor = type == AppButtonType.outlined || type == AppButtonType.text
        ? theme.colorScheme.primary
        : theme.colorScheme.onPrimary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: _getIconSize(),
          height: _getIconSize(),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
          ),
        ),
        const SizedBox(width: AppDimensions.spacingS),
        Text(text),
      ],
    );
  }

  Widget _buildIconContent(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: _getIconSize(),
          height: _getIconSize(),
          child: icon,
        ),
        const SizedBox(width: AppDimensions.spacingS),
        Text(text),
      ],
    );
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 36;
      case AppButtonSize.medium:
        return AppDimensions.buttonHeight;
      case AppButtonSize.large:
        return 56;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingM,
          vertical: AppDimensions.spacingS,
        );
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingL,
          vertical: AppDimensions.spacingM,
        );
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingXL,
          vertical: AppDimensions.spacingL,
        );
    }
  }

  double _getBorderRadius() {
    return AppDimensions.buttonRadius;
  }

  double _getElevation() {
    return AppDimensions.buttonElevation;
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return AppDimensions.iconS;
      case AppButtonSize.medium:
        return AppDimensions.iconM;
      case AppButtonSize.large:
        return AppDimensions.iconL;
    }
  }

  TextStyle _getTextStyle(BuildContext context) {
    switch (size) {
      case AppButtonSize.small:
        return AppTextTheme.cricket.buttonSmall;
      case AppButtonSize.medium:
        return AppTextTheme.cricket.buttonMedium;
      case AppButtonSize.large:
        return AppTextTheme.cricket.buttonLarge;
    }
  }
}

/// Cricket-specific button variants
class CricketButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final CricketButtonVariant variant;
  final AppButtonSize size;
  final Widget? icon;
  final bool isLoading;
  final bool isFullWidth;

  const CricketButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = CricketButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  /// Live match button
  const CricketButton.live({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  }) : variant = CricketButtonVariant.live;

  /// Score update button
  const CricketButton.score({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  }) : variant = CricketButtonVariant.score;

  /// Team selection button
  const CricketButton.team({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  }) : variant = CricketButtonVariant.team;

  @override
  Widget build(BuildContext context) {
    final colors = _getVariantColors(context);
    
    return AppButton(
      text: text,
      onPressed: onPressed,
      type: AppButtonType.primary,
      size: size,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      backgroundColor: colors.backgroundColor,
      foregroundColor: colors.foregroundColor,
    );
  }

  _VariantColors _getVariantColors(BuildContext context) {
    final theme = Theme.of(context);
    
    switch (variant) {
      case CricketButtonVariant.primary:
        return _VariantColors(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        );
      case CricketButtonVariant.live:
        return _VariantColors(
          backgroundColor: AppColors.error,
          foregroundColor: AppColors.white,
        );
      case CricketButtonVariant.score:
        return _VariantColors(
          backgroundColor: AppColors.secondary,
          foregroundColor: AppColors.white,
        );
      case CricketButtonVariant.team:
        return _VariantColors(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.white,
        );
    }
  }
}

/// Floating Action Button for cricket actions
class CricketFAB extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final String? tooltip;
  final bool isExtended;
  final String? label;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CricketFAB({
    super.key,
    this.onPressed,
    required this.icon,
    this.tooltip,
    this.isExtended = false,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
  });

  /// Extended FAB constructor
  const CricketFAB.extended({
    super.key,
    this.onPressed,
    required this.icon,
    required this.label,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
  }) : isExtended = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isExtended && label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        icon: icon,
        label: Text(label!),
        tooltip: tooltip,
        backgroundColor: backgroundColor ?? theme.colorScheme.primary,
        foregroundColor: foregroundColor ?? theme.colorScheme.onPrimary,
        elevation: AppDimensions.elevationM,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor ?? theme.colorScheme.primary,
      foregroundColor: foregroundColor ?? theme.colorScheme.onPrimary,
      elevation: AppDimensions.elevationM,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: icon,
    );
  }
}

/// Button enumerations
enum AppButtonType {
  primary,
  secondary,
  outlined,
  text,
}

enum AppButtonSize {
  small,
  medium,
  large,
}

enum CricketButtonVariant {
  primary,
  live,
  score,
  team,
}

/// Helper class for variant colors
class _VariantColors {
  final Color backgroundColor;
  final Color foregroundColor;

  const _VariantColors({
    required this.backgroundColor,
    required this.foregroundColor,
  });
}