import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../theme/text_theme.dart';
import 'app_button.dart';

/// GullyCric Error View Widget
/// 
/// Consistent error display following Material 3 design
/// with cricket-themed illustrations and user-friendly messages
class ErrorView extends StatelessWidget {
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;
  final Widget? icon;
  final ErrorViewType type;
  final bool isFullScreen;

  const ErrorView({
    super.key,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
    this.icon,
    this.type = ErrorViewType.generic,
    this.isFullScreen = false,
  });

  /// Network error constructor
  const ErrorView.network({
    super.key,
    this.title = 'Connection Error',
    this.message = 'Please check your internet connection and try again.',
    this.actionText = 'Retry',
    this.onAction,
    this.isFullScreen = false,
  }) : type = ErrorViewType.network,
       icon = null;

  /// Server error constructor
  const ErrorView.server({
    super.key,
    this.title = 'Server Error',
    this.message = 'Something went wrong on our end. Please try again later.',
    this.actionText = 'Retry',
    this.onAction,
    this.isFullScreen = false,
  }) : type = ErrorViewType.server,
       icon = null;

  /// Not found error constructor
  const ErrorView.notFound({
    super.key,
    this.title = 'Not Found',
    this.message = 'The content you\'re looking for could not be found.',
    this.actionText = 'Go Back',
    this.onAction,
    this.isFullScreen = false,
  }) : type = ErrorViewType.notFound,
       icon = null;

  /// Authentication error constructor
  const ErrorView.auth({
    super.key,
    this.title = 'Authentication Required',
    this.message = 'Please log in to continue.',
    this.actionText = 'Login',
    this.onAction,
    this.isFullScreen = false,
  }) : type = ErrorViewType.auth,
       icon = null;

  /// Empty state constructor
  const ErrorView.empty({
    super.key,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
    this.isFullScreen = false,
  }) : type = ErrorViewType.empty,
       icon = null;

  @override
  Widget build(BuildContext context) {
    Widget content = _buildContent(context);

    if (isFullScreen) {
      content = Scaffold(
        body: Center(child: content),
      );
    }

    return content;
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Error icon/illustration
          _buildErrorIcon(context),
          
          const SizedBox(height: AppDimensions.spacingXL),
          
          // Error title
          Text(
            title,
            style: AppTextTheme.cricket.matchTitle.copyWith(
              color: _getErrorColor(context),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppDimensions.spacingM),
          
          // Error message
          Text(
            message,
            style: AppTextTheme.cricket.cardSubtitle,
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          
          // Action button
          if (actionText != null && onAction != null) ...[
            const SizedBox(height: AppDimensions.spacingXL),
            AppButton.primary(
              text: actionText!,
              onPressed: onAction,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorIcon(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = _getErrorColor(context);

    if (icon != null) {
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: errorColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: icon,
      );
    }

    IconData iconData;
    switch (type) {
      case ErrorViewType.network:
        iconData = Icons.wifi_off_outlined;
        break;
      case ErrorViewType.server:
        iconData = Icons.error_outline;
        break;
      case ErrorViewType.notFound:
        iconData = Icons.search_off_outlined;
        break;
      case ErrorViewType.auth:
        iconData = Icons.lock_outline;
        break;
      case ErrorViewType.empty:
        iconData = Icons.inbox_outlined;
        break;
      case ErrorViewType.generic:
      default:
        iconData = Icons.warning_outlined;
        break;
    }

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: errorColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        size: 40,
        color: errorColor,
      ),
    );
  }

  Color _getErrorColor(BuildContext context) {
    final theme = Theme.of(context);
    
    switch (type) {
      case ErrorViewType.network:
        return AppColors.warning;
      case ErrorViewType.server:
        return theme.colorScheme.error;
      case ErrorViewType.notFound:
        return theme.colorScheme.onSurfaceVariant;
      case ErrorViewType.auth:
        return theme.colorScheme.primary;
      case ErrorViewType.empty:
        return theme.colorScheme.onSurfaceVariant;
      case ErrorViewType.generic:
      default:
        return theme.colorScheme.error;
    }
  }
}

/// Cricket-specific error views
class CricketErrorView extends StatelessWidget {
  final CricketErrorType errorType;
  final String? customMessage;
  final VoidCallback? onRetry;

  const CricketErrorView({
    super.key,
    required this.errorType,
    this.customMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final errorInfo = _getErrorInfo();
    
    return ErrorView(
      title: errorInfo.title,
      message: customMessage ?? errorInfo.message,
      actionText: errorInfo.actionText,
      onAction: onRetry,
      icon: Icon(
        errorInfo.icon,
        size: 40,
        color: _getErrorColor(context),
      ),
    );
  }

  _CricketErrorInfo _getErrorInfo() {
    switch (errorType) {
      case CricketErrorType.noMatches:
        return _CricketErrorInfo(
          title: 'No Matches Found',
          message: 'There are no cricket matches available at the moment.',
          actionText: 'Refresh',
          icon: Icons.sports_cricket,
        );
      case CricketErrorType.matchNotFound:
        return _CricketErrorInfo(
          title: 'Match Not Found',
          message: 'The match you\'re looking for could not be found.',
          actionText: 'Go Back',
          icon: Icons.search_off,
        );
      case CricketErrorType.scoreUpdateFailed:
        return _CricketErrorInfo(
          title: 'Score Update Failed',
          message: 'Unable to update the match score. Please try again.',
          actionText: 'Retry',
          icon: Icons.update,
        );
      case CricketErrorType.playerNotFound:
        return _CricketErrorInfo(
          title: 'Player Not Found',
          message: 'The player you\'re looking for could not be found.',
          actionText: 'Go Back',
          icon: Icons.person_search,
        );
      case CricketErrorType.teamNotFound:
        return _CricketErrorInfo(
          title: 'Team Not Found',
          message: 'The team you\'re looking for could not be found.',
          actionText: 'Go Back',
          icon: Icons.groups,
        );
      case CricketErrorType.liveDataUnavailable:
        return _CricketErrorInfo(
          title: 'Live Data Unavailable',
          message: 'Live match data is currently unavailable. Please check back later.',
          actionText: 'Refresh',
          icon: Icons.tv_off,
        );
    }
  }

  Color _getErrorColor(BuildContext context) {
    final theme = Theme.of(context);
    
    switch (errorType) {
      case CricketErrorType.noMatches:
      case CricketErrorType.matchNotFound:
      case CricketErrorType.playerNotFound:
      case CricketErrorType.teamNotFound:
        return theme.colorScheme.onSurfaceVariant;
      case CricketErrorType.scoreUpdateFailed:
      case CricketErrorType.liveDataUnavailable:
        return AppColors.warning;
    }
  }
}

/// Inline error widget for forms and inputs
class InlineError extends StatelessWidget {
  final String message;
  final EdgeInsetsGeometry? padding;

  const InlineError({
    super.key,
    required this.message,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: padding ?? const EdgeInsets.only(
        top: AppDimensions.spacingS,
        left: AppDimensions.spacingM,
        right: AppDimensions.spacingM,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline,
            size: AppDimensions.iconS,
            color: theme.colorScheme.error,
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Expanded(
            child: Text(
              message,
              style: AppTextTheme.cricket.inputError,
            ),
          ),
        ],
      ),
    );
  }
}

/// Error banner widget
class ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;
  final VoidCallback? onAction;
  final String? actionText;
  final bool isDismissible;

  const ErrorBanner({
    super.key,
    required this.message,
    this.onDismiss,
    this.onAction,
    this.actionText,
    this.isDismissible = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.onErrorContainer,
            size: AppDimensions.iconM,
          ),
          const SizedBox(width: AppDimensions.spacingM),
          Expanded(
            child: Text(
              message,
              style: AppTextTheme.cricket.cardSubtitle.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
          if (actionText != null && onAction != null) ...[
            const SizedBox(width: AppDimensions.spacingM),
            TextButton(
              onPressed: onAction,
              child: Text(
                actionText!,
                style: TextStyle(
                  color: theme.colorScheme.onErrorContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          if (isDismissible && onDismiss != null) ...[
            const SizedBox(width: AppDimensions.spacingS),
            IconButton(
              onPressed: onDismiss,
              icon: Icon(
                Icons.close,
                color: theme.colorScheme.onErrorContainer,
                size: AppDimensions.iconS,
              ),
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Error enumerations
enum ErrorViewType {
  generic,
  network,
  server,
  notFound,
  auth,
  empty,
}

enum CricketErrorType {
  noMatches,
  matchNotFound,
  scoreUpdateFailed,
  playerNotFound,
  teamNotFound,
  liveDataUnavailable,
}

/// Helper class for cricket error information
class _CricketErrorInfo {
  final String title;
  final String message;
  final String actionText;
  final IconData icon;

  const _CricketErrorInfo({
    required this.title,
    required this.message,
    required this.actionText,
    required this.icon,
  });
}