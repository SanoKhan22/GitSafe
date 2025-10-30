/// GullyCric Custom Exceptions
/// 
/// Comprehensive exception hierarchy for different error scenarios
/// in the cricket app. Each exception provides specific context
/// for better error handling and user feedback.

/// Base exception class for all app-specific exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException(
    this.message, [
    this.code,
    this.details,
  ]);

  @override
  String toString() {
    if (code != null) {
      return 'AppException($code): $message';
    }
    return 'AppException: $message';
  }
}

/// Generic concrete implementation of AppException
class GenericException extends AppException {
  const GenericException(
    String message, [
    String? code,
    dynamic details,
  ]) : super(message, code ?? 'GENERIC_ERROR', details);
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException(
    String message, [
    String? code,
    dynamic details,
  ]) : super(message, code ?? 'NETWORK_ERROR', details);
}

class ConnectionException extends NetworkException {
  const ConnectionException([
    String message = 'No internet connection available',
  ]) : super(message, 'CONNECTION_ERROR');
}

class TimeoutException extends NetworkException {
  const TimeoutException([
    String message = 'Request timeout. Please try again.',
  ]) : super(message, 'TIMEOUT_ERROR');
}

class ServerException extends NetworkException {
  final int? statusCode;

  const ServerException(
    String message, [
    this.statusCode,
    String? code,
  ]) : super(message, code ?? 'SERVER_ERROR', statusCode);
}

/// Authentication and authorization exceptions
class AuthException extends AppException {
  const AuthException(
    String message, [
    String? code,
    dynamic details,
  ]) : super(message, code ?? 'AUTH_ERROR', details);
}

class UnauthorizedException extends AuthException {
  const UnauthorizedException([
    String message = 'Authentication required. Please login.',
  ]) : super(message, 'UNAUTHORIZED');
}

class ForbiddenException extends AuthException {
  const ForbiddenException([
    String message = 'Access denied. Insufficient permissions.',
  ]) : super(message, 'FORBIDDEN');
}

class TokenExpiredException extends AuthException {
  const TokenExpiredException([
    String message = 'Session expired. Please login again.',
  ]) : super(message, 'TOKEN_EXPIRED');
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException([
    String message = 'Invalid email or password.',
  ]) : super(message, 'INVALID_CREDENTIALS');
}

/// Validation exceptions
class ValidationException extends AppException {
  final Map<String, List<String>>? fieldErrors;

  const ValidationException(
    String message, [
    this.fieldErrors,
    String? code,
  ]) : super(message, code ?? 'VALIDATION_ERROR', fieldErrors);
}

class RequiredFieldException extends ValidationException {
  final String fieldName;

  const RequiredFieldException(
    this.fieldName, [
    String? message,
  ]) : super(
          message ?? '$fieldName is required',
          null,
          'REQUIRED_FIELD',
        );
}

class InvalidFormatException extends ValidationException {
  final String fieldName;
  final String expectedFormat;

  const InvalidFormatException(
    this.fieldName,
    this.expectedFormat, [
    String? message,
  ]) : super(
          message ?? '$fieldName must be in $expectedFormat format',
          null,
          'INVALID_FORMAT',
        );
}

class InvalidLengthException extends ValidationException {
  final String fieldName;
  final int minLength;
  final int? maxLength;

  InvalidLengthException(
    this.fieldName,
    this.minLength, [
    this.maxLength,
    String? message,
  ]) : super(
          message ?? _buildLengthMessage(fieldName, minLength, maxLength),
          null,
          'INVALID_LENGTH',
        );

  static String _buildLengthMessage(String field, int min, int? max) {
    if (max != null) {
      return '$field must be between $min and $max characters';
    }
    return '$field must be at least $min characters';
  }
}

/// Data-related exceptions
class DataException extends AppException {
  const DataException(
    String message, [
    String? code,
    dynamic details,
  ]) : super(message, code ?? 'DATA_ERROR', details);
}

class NotFoundException extends DataException {
  final String resourceType;
  final String? resourceId;

  NotFoundException(
    this.resourceType, [
    this.resourceId,
    String? message,
  ]) : super(
          message ?? _buildNotFoundMessage(resourceType, resourceId),
          'NOT_FOUND',
        );

  static String _buildNotFoundMessage(String type, String? id) {
    if (id != null) {
      return '$type with ID $id not found';
    }
    return '$type not found';
  }
}

class DuplicateException extends DataException {
  final String resourceType;
  final String? field;

  DuplicateException(
    this.resourceType, [
    this.field,
    String? message,
  ]) : super(
          message ?? _buildDuplicateMessage(resourceType, field),
          'DUPLICATE',
        );

  static String _buildDuplicateMessage(String type, String? field) {
    if (field != null) {
      return '$type with this $field already exists';
    }
    return '$type already exists';
  }
}

class ConflictException extends DataException {
  const ConflictException(
    String message, [
    dynamic details,
  ]) : super(message, 'CONFLICT', details);
}

/// Storage and cache exceptions
class StorageException extends AppException {
  const StorageException(
    String message, [
    String? code,
    dynamic details,
  ]) : super(message, code ?? 'STORAGE_ERROR', details);
}

class CacheException extends StorageException {
  const CacheException(
    String message, [
    String? code,
  ]) : super(message, code ?? 'CACHE_ERROR');
}

class DatabaseException extends StorageException {
  const DatabaseException(
    String message, [
    String? code,
    dynamic details,
  ]) : super(message, code ?? 'DATABASE_ERROR', details);
}

/// Cricket-specific exceptions
class MatchException extends AppException {
  const MatchException(
    String message, [
    String? code,
    dynamic details,
  ]) : super(message, code ?? 'MATCH_ERROR', details);
}

class InvalidMatchStateException extends MatchException {
  final String currentState;
  final String requiredState;

  const InvalidMatchStateException(
    this.currentState,
    this.requiredState, [
    String? message,
  ]) : super(
          message ?? 'Match is in $currentState state, but $requiredState is required',
          'INVALID_MATCH_STATE',
        );
}

class ScoreUpdateException extends MatchException {
  const ScoreUpdateException(
    String message, [
    dynamic details,
  ]) : super(message, 'SCORE_UPDATE_ERROR', details);
}

class PlayerException extends AppException {
  const PlayerException(
    String message, [
    String? code,
    dynamic details,
  ]) : super(message, code ?? 'PLAYER_ERROR', details);
}

class TeamException extends AppException {
  const TeamException(
    String message, [
    String? code,
    dynamic details,
  ]) : super(message, code ?? 'TEAM_ERROR', details);
}

class InsufficientPlayersException extends TeamException {
  final int currentCount;
  final int requiredCount;

  const InsufficientPlayersException(
    this.currentCount,
    this.requiredCount, [
    String? message,
  ]) : super(
          message ?? 'Team has $currentCount players, but $requiredCount are required',
          'INSUFFICIENT_PLAYERS',
        );
}

/// Permission and access exceptions
class PermissionException extends AppException {
  final String permission;

  const PermissionException(
    this.permission, [
    String? message,
  ]) : super(
          message ?? 'Permission denied: $permission',
          'PERMISSION_DENIED',
        );
}

class LocationPermissionException extends PermissionException {
  const LocationPermissionException([
    String message = 'Location permission is required for this feature',
  ]) : super('location', message);
}

class CameraPermissionException extends PermissionException {
  const CameraPermissionException([
    String message = 'Camera permission is required for this feature',
  ]) : super('camera', message);
}

class StoragePermissionException extends PermissionException {
  const StoragePermissionException([
    String message = 'Storage permission is required for this feature',
  ]) : super('storage', message);
}

/// Platform-specific exceptions
class PlatformException extends AppException {
  final String platform;

  const PlatformException(
    String message,
    this.platform, [
    String? code,
    dynamic details,
  ]) : super(message, code ?? 'PLATFORM_ERROR', details);
}

/// File and media exceptions
class FileException extends AppException {
  final String? filePath;

  const FileException(
    String message, [
    this.filePath,
    String? code,
    dynamic details,
  ]) : super(message, code ?? 'FILE_ERROR', details);
}

class FileNotFoundExceptionCustom extends FileException {
  const FileNotFoundExceptionCustom(
    String filePath, [
    String? message,
  ]) : super(
          message ?? 'File not found: $filePath',
          filePath,
          'FILE_NOT_FOUND',
        );
}

class FileSizeException extends FileException {
  final int currentSize;
  final int maxSize;

  const FileSizeException(
    this.currentSize,
    this.maxSize, [
    String? filePath,
    String? message,
  ]) : super(
          message ?? 'File size ${currentSize}B exceeds maximum ${maxSize}B',
          filePath,
          'FILE_SIZE_EXCEEDED',
        );
}

class UnsupportedFileTypeException extends FileException {
  final String fileType;
  final List<String> supportedTypes;

  UnsupportedFileTypeException(
    this.fileType,
    this.supportedTypes, [
    String? filePath,
    String? message,
  ]) : super(
          message ?? 'File type $fileType not supported. Supported: ${supportedTypes.join(", ")}',
          filePath,
          'UNSUPPORTED_FILE_TYPE',
        );
}

/// Utility functions for exception handling
class ExceptionUtils {
  ExceptionUtils._();

  /// Converts a generic exception to an AppException
  static AppException fromException(Exception exception) {
    if (exception is AppException) {
      return exception;
    }

    // Handle common Flutter/Dart exceptions
    if (exception is FormatException) {
      return ValidationException(
        'Invalid data format: ${exception.message}',
        null,
        'FORMAT_ERROR',
      );
    }

    if (exception is ArgumentError) {
      return ValidationException(
        'Invalid argument: ${exception.toString()}',
        null,
        'ARGUMENT_ERROR',
      );
    }

    if (exception is StateError) {
      return DataException(
        'Invalid state: ${exception.toString()}',
        'STATE_ERROR',
      );
    }

    // Default to generic app exception
    return GenericException(
      exception.toString(),
      'UNKNOWN_ERROR',
      exception,
    );
  }

  /// Checks if an exception is network-related
  static bool isNetworkException(Exception exception) {
    return exception is NetworkException ||
        exception is ConnectionException ||
        exception is TimeoutException ||
        exception is ServerException;
  }

  /// Checks if an exception is authentication-related
  static bool isAuthException(Exception exception) {
    return exception is AuthException ||
        exception is UnauthorizedException ||
        exception is ForbiddenException ||
        exception is TokenExpiredException ||
        exception is InvalidCredentialsException;
  }

  /// Checks if an exception is validation-related
  static bool isValidationException(Exception exception) {
    return exception is ValidationException ||
        exception is RequiredFieldException ||
        exception is InvalidFormatException ||
        exception is InvalidLengthException;
  }

  /// Gets user-friendly error message from exception
  static String getUserFriendlyMessage(Exception exception) {
    if (exception is AppException) {
      return exception.message;
    }

    // Fallback messages for common exceptions
    if (isNetworkException(exception)) {
      return 'Network error. Please check your connection and try again.';
    }

    if (isAuthException(exception)) {
      return 'Authentication error. Please login and try again.';
    }

    if (isValidationException(exception)) {
      return 'Please check your input and try again.';
    }

    return 'Something went wrong. Please try again.';
  }
}