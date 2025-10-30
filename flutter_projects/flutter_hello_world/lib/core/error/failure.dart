import 'package:equatable/equatable.dart';

/// GullyCric Failure Classes
/// 
/// Implements the Either pattern for error handling in Clean Architecture.
/// Failures represent errors that can occur in the domain layer and are
/// passed up to the presentation layer for user feedback.

/// Base failure class for all domain errors
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final dynamic details;

  const Failure(
    this.message, [
    this.code,
    this.details,
  ]);

  @override
  List<Object?> get props => [message, code, details];

  @override
  String toString() {
    if (code != null) {
      return 'Failure($code): $message';
    }
    return 'Failure: $message';
  }
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure(
    String message, [
    String? code,
    dynamic details,
  ]) : super(message, code ?? 'NETWORK_FAILURE', details);
}

class ConnectionFailure extends NetworkFailure {
  const ConnectionFailure([
    String message = 'No internet connection available',
  ]) : super(message, 'CONNECTION_FAILURE');
}

class TimeoutFailure extends NetworkFailure {
  const TimeoutFailure([
    String message = 'Request timeout. Please try again.',
  ]) : super(message, 'TIMEOUT_FAILURE');
}

class ServerFailure extends NetworkFailure {
  final int? statusCode;

  const ServerFailure(
    String message, [
    this.statusCode,
    String? code,
  ]) : super(message, code ?? 'SERVER_FAILURE', statusCode);

  @override
  List<Object?> get props => [...super.props, statusCode];
}

/// Authentication and authorization failures
class AuthFailure extends Failure {
  const AuthFailure(
    String message, [
    String? code,
    dynamic details,
  ]) : super(message, code ?? 'AUTH_FAILURE', details);
}

class UnauthorizedFailure extends AuthFailure {
  const UnauthorizedFailure([
    String message = 'Authentication required. Please login.',
  ]) : super(message, 'UNAUTHORIZED_FAILURE');
}

class ForbiddenFailure extends AuthFailure {
  const ForbiddenFailure([
    String message = 'Access denied. Insufficient permissions.',
  ]) : super(message, 'FORBIDDEN_FAILURE');
}

class TokenExpiredFailure extends AuthFailure {
  const TokenExpiredFailure([
    String message = 'Session expired. Please login again.',
  ]) : super(message, 'TOKEN_EXPIRED_FAILURE');
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure([
    String message = 'Invalid email or password.',
  ]) : super(message, 'INVALID_CREDENTIALS_FAILURE');
}

/// Validation failures
class ValidationFailure extends Failure {
  final Map<String, List<String>>? fieldErrors;

  const ValidationFailure(
    String message, [
    this.fieldErrors,
    String? code,
  ]) : super(message, code ?? 'VALIDATION_FAILURE', fieldErrors);

  @override
  List<Object?> get props => [...super.props, fieldErrors];
}

class RequiredFieldFailure extends ValidationFailure {
  final String fieldName;

  const RequiredFieldFailure(
    this.fieldName, [
    String? message,
  ]) : super(
          message ?? '$fieldName is required',
          null,
          'REQUIRED_FIELD_FAILURE',
        );

  @override
  List<Object?> get props => [...super.props, fieldName];
}

class InvalidFormatFailure extends ValidationFailure {
  final String fieldName;
  final String expectedFormat;

  const InvalidFormatFailure(
    this.fieldName,
    this.expectedFormat, [
    String? message,
  ]) : super(
          message ?? '$fieldName must be in $expectedFormat format',
          null,
          'INVALID_FORMAT_FAILURE',
        );

  @override
  List<Object?> get props => [...super.props, fieldName, expectedFormat];
}

/// Data-related failures
class DataFailure extends Failure {
  const DataFailure(
    String message, [
    String? code,
    dynamic details,
  ]) : super(message, code ?? 'DATA_FAILURE', details);
}

class NotFoundFailure extends DataFailure {
  final String resourceType;
  final String? resourceId;

  NotFoundFailure(
    this.resourceType, [
    this.resourceId,
    String? message,
  ]) : super(
          message ?? _buildNotFoundMessage(resourceType, resourceId),
          'NOT_FOUND_FAILURE',
        );

  static String _buildNotFoundMessage(String type, String? id) {
    if (id != null) {
      return '$type with ID $id not found';
    }
    return '$type not found';
  }

  @override
  List<Object?> get props => [...super.props, resourceType, resourceId];
}

class DuplicateFailure extends DataFailure {
  final String resourceType;
  final String? field;

  DuplicateFailure(
    this.resourceType, [
    this.field,
    String? message,
  ]) : super(
          message ?? _buildDuplicateMessage(resourceType, field),
          'DUPLICATE_FAILURE',
        );

  static String _buildDuplicateMessage(String type, String? field) {
    if (field != null) {
      return '$type with this $field already exists';
    }
    return '$type already exists';
  }

  @override
  List<Object?> get props => [...super.props, resourceType, field];
}

class ConflictFailure extends DataFailure {
  const ConflictFailure(
    String message, [
    dynamic details,
  ]) : super(message, 'CONFLICT_FAILURE', details);
}

/// Storage and cache failures
class StorageFailure extends Failure {
  const StorageFailure(
    String message, [
    String? code,
    dynamic details,
  ]) : super(message, code ?? 'STORAGE_FAILURE', details);
}

class CacheFailure extends StorageFailure {
  const CacheFailure(
    String message, [
    String? code,
  ]) : super(message, code ?? 'CACHE_FAILURE');
}

class DatabaseFailure extends StorageFailure {
  const DatabaseFailure(
    String message, [
    String? code,
    dynamic details,
  ]) : super(message, code ?? 'DATABASE_FAILURE', details);
}

/// Cricket-specific failures
class MatchFailure extends Failure {
  const MatchFailure(
    String message, [
    String? code,
    dynamic details,
  ]) : super(message, code ?? 'MATCH_FAILURE', details);
}

class InvalidMatchStateFailure extends MatchFailure {
  final String currentState;
  final String requiredState;

  const InvalidMatchStateFailure(
    this.currentState,
    this.requiredState, [
    String? message,
  ]) : super(
          message ?? 'Match is in $currentState state, but $requiredState is required',
          'INVALID_MATCH_STATE_FAILURE',
        );

  @override
  List<Object?> get props => [...super.props, currentState, requiredState];
}

class ScoreUpdateFailure extends MatchFailure {
  const ScoreUpdateFailure(
    String message, [
    dynamic details,
  ]) : super(message, 'SCORE_UPDATE_FAILURE', details);
}

class PlayerFailure extends Failure {
  const PlayerFailure(
    String message, [
    String? code,
    dynamic details,
  ]) : super(message, code ?? 'PLAYER_FAILURE', details);
}

class TeamFailure extends Failure {
  const TeamFailure(
    String message, [
    String? code,
    dynamic details,
  ]) : super(message, code ?? 'TEAM_FAILURE', details);
}

class InsufficientPlayersFailure extends TeamFailure {
  final int currentCount;
  final int requiredCount;

  const InsufficientPlayersFailure(
    this.currentCount,
    this.requiredCount, [
    String? message,
  ]) : super(
          message ?? 'Team has $currentCount players, but $requiredCount are required',
          'INSUFFICIENT_PLAYERS_FAILURE',
        );

  @override
  List<Object?> get props => [...super.props, currentCount, requiredCount];
}

/// Permission and access failures
class PermissionFailure extends Failure {
  final String permission;

  const PermissionFailure(
    this.permission, [
    String? message,
  ]) : super(
          message ?? 'Permission denied: $permission',
          'PERMISSION_FAILURE',
        );

  @override
  List<Object?> get props => [...super.props, permission];
}

class LocationPermissionFailure extends PermissionFailure {
  const LocationPermissionFailure([
    String message = 'Location permission is required for this feature',
  ]) : super('location', message);
}

class CameraPermissionFailure extends PermissionFailure {
  const CameraPermissionFailure([
    String message = 'Camera permission is required for this feature',
  ]) : super('camera', message);
}

class StoragePermissionFailure extends PermissionFailure {
  const StoragePermissionFailure([
    String message = 'Storage permission is required for this feature',
  ]) : super('storage', message);
}

/// Platform-specific failures
class PlatformFailure extends Failure {
  final String platform;

  const PlatformFailure(
    String message,
    this.platform, [
    String? code,
    dynamic details,
  ]) : super(message, code ?? 'PLATFORM_FAILURE', details);

  @override
  List<Object?> get props => [...super.props, platform];
}

/// File and media failures
class FileFailure extends Failure {
  final String? filePath;

  const FileFailure(
    String message, [
    this.filePath,
    String? code,
    dynamic details,
  ]) : super(message, code ?? 'FILE_FAILURE', details);

  @override
  List<Object?> get props => [...super.props, filePath];
}

class FileNotFoundFailure extends FileFailure {
  const FileNotFoundFailure(
    String filePath, [
    String? message,
  ]) : super(
          message ?? 'File not found: $filePath',
          filePath,
          'FILE_NOT_FOUND_FAILURE',
        );
}

class FileSizeFailure extends FileFailure {
  final int currentSize;
  final int maxSize;

  const FileSizeFailure(
    this.currentSize,
    this.maxSize, [
    String? filePath,
    String? message,
  ]) : super(
          message ?? 'File size ${currentSize}B exceeds maximum ${maxSize}B',
          filePath,
          'FILE_SIZE_FAILURE',
        );

  @override
  List<Object?> get props => [...super.props, currentSize, maxSize];
}

class UnsupportedFileTypeFailure extends FileFailure {
  final String fileType;
  final List<String> supportedTypes;

  UnsupportedFileTypeFailure(
    this.fileType,
    this.supportedTypes, [
    String? filePath,
    String? message,
  ]) : super(
          message ?? 'File type $fileType not supported. Supported: ${supportedTypes.join(", ")}',
          filePath,
          'UNSUPPORTED_FILE_TYPE_FAILURE',
        );

  @override
  List<Object?> get props => [...super.props, fileType, supportedTypes];
}

/// Utility functions for failure handling
class FailureUtils {
  FailureUtils._();

  /// Checks if a failure is network-related
  static bool isNetworkFailure(Failure failure) {
    return failure is NetworkFailure ||
        failure is ConnectionFailure ||
        failure is TimeoutFailure ||
        failure is ServerFailure;
  }

  /// Checks if a failure is authentication-related
  static bool isAuthFailure(Failure failure) {
    return failure is AuthFailure ||
        failure is UnauthorizedFailure ||
        failure is ForbiddenFailure ||
        failure is TokenExpiredFailure ||
        failure is InvalidCredentialsFailure;
  }

  /// Checks if a failure is validation-related
  static bool isValidationFailure(Failure failure) {
    return failure is ValidationFailure ||
        failure is RequiredFieldFailure ||
        failure is InvalidFormatFailure;
  }

  /// Gets user-friendly error message from failure
  static String getUserFriendlyMessage(Failure failure) {
    // Return the failure message directly as it's already user-friendly
    return failure.message;
  }

  /// Gets appropriate retry action based on failure type
  static bool canRetry(Failure failure) {
    // Network failures can usually be retried
    if (isNetworkFailure(failure)) {
      return true;
    }

    // Auth failures might need re-authentication
    if (failure is TokenExpiredFailure) {
      return true;
    }

    // Validation failures should not be retried without fixing input
    if (isValidationFailure(failure)) {
      return false;
    }

    // Server errors might be temporary
    if (failure is ServerFailure) {
      return failure.statusCode != null && failure.statusCode! >= 500;
    }

    // Default to not retryable
    return false;
  }

  /// Gets appropriate action text for failure
  static String getActionText(Failure failure) {
    if (canRetry(failure)) {
      return 'Retry';
    }

    if (failure is TokenExpiredFailure) {
      return 'Login Again';
    }

    if (isValidationFailure(failure)) {
      return 'Fix Input';
    }

    return 'OK';
  }
}

/// Extended AuthFailure with factory methods for common auth scenarios
extension AuthFailureFactory on AuthFailure {
  // Login failures
  static AuthFailure invalidCredentials([String? message]) =>
      AuthFailure(message ?? 'Invalid email or password', 'INVALID_CREDENTIALS');
  
  static AuthFailure invalidEmail([String? message]) =>
      AuthFailure(message ?? 'Invalid email format', 'INVALID_EMAIL');
  
  static AuthFailure invalidPhoneNumber([String? message]) =>
      AuthFailure(message ?? 'Invalid phone number format', 'INVALID_PHONE');
  
  static AuthFailure invalidOtp([String? message]) =>
      AuthFailure(message ?? 'Invalid or expired OTP', 'INVALID_OTP');
  
  // Social login failures
  static AuthFailure socialLoginFailed([String? message]) =>
      AuthFailure(message ?? 'Social login failed', 'SOCIAL_LOGIN_FAILED');
  
  // Registration failures
  static AuthFailure registrationFailed([String? message]) =>
      AuthFailure(message ?? 'Registration failed', 'REGISTRATION_FAILED');
  
  static AuthFailure emailAlreadyExists([String? message]) =>
      AuthFailure(message ?? 'Email already exists', 'EMAIL_EXISTS');
  
  static AuthFailure phoneAlreadyExists([String? message]) =>
      AuthFailure(message ?? 'Phone number already exists', 'PHONE_EXISTS');
  
  // OTP failures
  static AuthFailure otpSendFailed([String? message]) =>
      AuthFailure(message ?? 'Failed to send OTP', 'OTP_SEND_FAILED');
  
  // Password failures
  static AuthFailure passwordResetFailed([String? message]) =>
      AuthFailure(message ?? 'Password reset failed', 'PASSWORD_RESET_FAILED');
  
  static AuthFailure passwordChangeFailed([String? message]) =>
      AuthFailure(message ?? 'Password change failed', 'PASSWORD_CHANGE_FAILED');
  
  // Email verification failures
  static AuthFailure emailVerificationFailed([String? message]) =>
      AuthFailure(message ?? 'Email verification failed', 'EMAIL_VERIFICATION_FAILED');
  
  // Token failures
  static AuthFailure tokenRefreshFailed([String? message]) =>
      AuthFailure(message ?? 'Token refresh failed', 'TOKEN_REFRESH_FAILED');
  
  static AuthFailure tokenValidationFailed([String? message]) =>
      AuthFailure(message ?? 'Token validation failed', 'TOKEN_VALIDATION_FAILED');
  
  static AuthFailure noTokensFound([String? message]) =>
      AuthFailure(message ?? 'No authentication tokens found', 'NO_TOKENS_FOUND');
  
  // Session failures
  static AuthFailure sessionExpired([String? message]) =>
      AuthFailure(message ?? 'Session has expired', 'SESSION_EXPIRED');
  
  static AuthFailure sessionRetrievalFailed([String? message]) =>
      AuthFailure(message ?? 'Failed to retrieve session', 'SESSION_RETRIEVAL_FAILED');
  
  static AuthFailure sessionExtensionFailed([String? message]) =>
      AuthFailure(message ?? 'Failed to extend session', 'SESSION_EXTENSION_FAILED');
  
  static AuthFailure loginHistoryFailed([String? message]) =>
      AuthFailure(message ?? 'Failed to retrieve login history', 'LOGIN_HISTORY_FAILED');
  
  // User management failures
  static AuthFailure userRetrievalFailed([String? message]) =>
      AuthFailure(message ?? 'Failed to retrieve user data', 'USER_RETRIEVAL_FAILED');
  
  static AuthFailure profileUpdateFailed([String? message]) =>
      AuthFailure(message ?? 'Failed to update profile', 'PROFILE_UPDATE_FAILED');
  
  static AuthFailure preferencesUpdateFailed([String? message]) =>
      AuthFailure(message ?? 'Failed to update preferences', 'PREFERENCES_UPDATE_FAILED');
  
  static AuthFailure userSearchFailed([String? message]) =>
      AuthFailure(message ?? 'User search failed', 'USER_SEARCH_FAILED');
  
  static AuthFailure accountDeletionFailed([String? message]) =>
      AuthFailure(message ?? 'Account deletion failed', 'ACCOUNT_DELETION_FAILED');
  
  // Biometric failures
  static AuthFailure biometricNotAvailable([String? message]) =>
      AuthFailure(message ?? 'Biometric authentication not available', 'BIOMETRIC_NOT_AVAILABLE');
  
  static AuthFailure biometricNotEnabled([String? message]) =>
      AuthFailure(message ?? 'Biometric authentication not enabled', 'BIOMETRIC_NOT_ENABLED');
  
  static AuthFailure biometricFailed([String? message]) =>
      AuthFailure(message ?? 'Biometric authentication failed', 'BIOMETRIC_FAILED');
  
  static AuthFailure biometricCheckFailed([String? message]) =>
      AuthFailure(message ?? 'Biometric availability check failed', 'BIOMETRIC_CHECK_FAILED');
  
  static AuthFailure biometricEnableFailed([String? message]) =>
      AuthFailure(message ?? 'Failed to enable biometric authentication', 'BIOMETRIC_ENABLE_FAILED');
  
  static AuthFailure biometricDisableFailed([String? message]) =>
      AuthFailure(message ?? 'Failed to disable biometric authentication', 'BIOMETRIC_DISABLE_FAILED');
  
  // Availability check failures
  static AuthFailure emailCheckFailed([String? message]) =>
      AuthFailure(message ?? 'Email availability check failed', 'EMAIL_CHECK_FAILED');
  
  static AuthFailure phoneCheckFailed([String? message]) =>
      AuthFailure(message ?? 'Phone availability check failed', 'PHONE_CHECK_FAILED');
  
  // Security failures
  static AuthFailure reportFailed([String? message]) =>
      AuthFailure(message ?? 'Failed to report suspicious activity', 'REPORT_FAILED');
  
  // Generic failures
  static AuthFailure unknown([String? message]) =>
      AuthFailure(message ?? 'An unknown error occurred', 'UNKNOWN_ERROR');
}