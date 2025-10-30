import 'user_model.dart';
import '../../domain/entities/user_entity.dart';

/// Authentication Response Model
/// 
/// Represents the response from authentication endpoints
class AuthResponseModel {
  final UserModel user;
  final AuthTokensModel tokens;
  final String message;
  final bool isFirstLogin;

  const AuthResponseModel({
    required this.user,
    required this.tokens,
    required this.message,
    this.isFirstLogin = false,
  });

  /// Create AuthResponseModel from JSON
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      tokens: AuthTokensModel.fromJson(json['tokens'] as Map<String, dynamic>),
      message: json['message'] as String? ?? 'Authentication successful',
      isFirstLogin: json['isFirstLogin'] as bool? ?? false,
    );
  }

  /// Convert AuthResponseModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'tokens': tokens.toJson(),
      'message': message,
      'isFirstLogin': isFirstLogin,
    };
  }

  @override
  String toString() {
    return 'AuthResponseModel(user: ${user.email}, isFirstLogin: $isFirstLogin)';
  }
}

/// Authentication Tokens Model
/// 
/// Represents access and refresh tokens with expiration information
class AuthTokensModel extends AuthTokens {
  const AuthTokensModel({
    required super.accessToken,
    required super.refreshToken,
    required super.tokenType,
    required super.expiresIn,
    required super.expiresAt,
    super.scope,
  });

  /// Create AuthTokensModel from JSON
  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    final expiresIn = json['expiresIn'] as int;
    final issuedAt = json['issuedAt'] != null
        ? DateTime.parse(json['issuedAt'] as String)
        : DateTime.now();
    
    return AuthTokensModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      tokenType: json['tokenType'] as String? ?? 'Bearer',
      expiresIn: expiresIn,
      expiresAt: issuedAt.add(Duration(seconds: expiresIn)),
      scope: json['scope'] as String?,
    );
  }

  /// Convert AuthTokensModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'tokenType': tokenType,
      'expiresIn': expiresIn,
      'expiresAt': expiresAt.toIso8601String(),
      'scope': scope,
    };
  }

  /// Create AuthTokensModel from AuthTokens entity
  factory AuthTokensModel.fromEntity(AuthTokens entity) {
    return AuthTokensModel(
      accessToken: entity.accessToken,
      refreshToken: entity.refreshToken,
      tokenType: entity.tokenType,
      expiresIn: entity.expiresIn,
      expiresAt: entity.expiresAt,
      scope: entity.scope,
    );
  }

  /// Create a copy with updated fields
  AuthTokensModel copyWith({
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    int? expiresIn,
    DateTime? expiresAt,
    String? scope,
  }) {
    return AuthTokensModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
      expiresIn: expiresIn ?? this.expiresIn,
      expiresAt: expiresAt ?? this.expiresAt,
      scope: scope ?? this.scope,
    );
  }

  @override
  String toString() {
    return 'AuthTokensModel(tokenType: $tokenType, expiresAt: $expiresAt, isExpired: $isExpired)';
  }
}

/// User Session Model
/// 
/// Represents current user session information
class UserSessionModel extends UserSession {
  const UserSessionModel({
    required super.sessionId,
    required super.userId,
    required super.deviceId,
    required super.ipAddress,
    required super.userAgent,
    required super.createdAt,
    required super.lastActivityAt,
    required super.expiresAt,
    super.isActive,
    super.location,
  });

  /// Create UserSessionModel from JSON
  factory UserSessionModel.fromJson(Map<String, dynamic> json) {
    return UserSessionModel(
      sessionId: json['sessionId'] as String,
      userId: json['userId'] as String,
      deviceId: json['deviceId'] as String,
      ipAddress: json['ipAddress'] as String,
      userAgent: json['userAgent'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastActivityAt: DateTime.parse(json['lastActivityAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      location: json['location'] as String?,
    );
  }

  /// Convert UserSessionModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'userId': userId,
      'deviceId': deviceId,
      'ipAddress': ipAddress,
      'userAgent': userAgent,
      'createdAt': createdAt.toIso8601String(),
      'lastActivityAt': lastActivityAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'isActive': isActive,
      'location': location,
    };
  }

  /// Create UserSessionModel from UserSession entity
  factory UserSessionModel.fromEntity(UserSession entity) {
    return UserSessionModel(
      sessionId: entity.sessionId,
      userId: entity.userId,
      deviceId: entity.deviceId,
      ipAddress: entity.ipAddress,
      userAgent: entity.userAgent,
      createdAt: entity.createdAt,
      lastActivityAt: entity.lastActivityAt,
      expiresAt: entity.expiresAt,
      isActive: entity.isActive,
      location: entity.location,
    );
  }

  @override
  String toString() {
    return 'UserSessionModel(sessionId: $sessionId, userId: $userId, isActive: $isActive)';
  }
}

/// Login History Model
/// 
/// Represents a login history entry
class LoginHistoryModel {
  final String id;
  final String userId;
  final DateTime loginAt;
  final String ipAddress;
  final String userAgent;
  final String deviceType;
  final String loginMethod;
  final String? location;
  final bool? isSuccessful;
  final String? failureReason;

  const LoginHistoryModel({
    required this.id,
    required this.userId,
    required this.loginAt,
    required this.ipAddress,
    required this.userAgent,
    required this.deviceType,
    required this.loginMethod,
    this.location,
    this.isSuccessful,
    this.failureReason,
  });

  /// Create LoginHistoryModel from JSON
  factory LoginHistoryModel.fromJson(Map<String, dynamic> json) {
    return LoginHistoryModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      loginAt: DateTime.parse(json['loginAt'] as String),
      ipAddress: json['ipAddress'] as String,
      userAgent: json['userAgent'] as String,
      deviceType: json['deviceType'] as String,
      loginMethod: json['loginMethod'] as String,
      location: json['location'] as String?,
      isSuccessful: json['isSuccessful'] as bool? ?? true,
      failureReason: json['failureReason'] as String?,
    );
  }

  /// Convert LoginHistoryModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'loginAt': loginAt.toIso8601String(),
      'ipAddress': ipAddress,
      'userAgent': userAgent,
      'deviceType': deviceType,
      'loginMethod': loginMethod,
      'location': location,
      'isSuccessful': isSuccessful,
      'failureReason': failureReason,
    };
  }



  @override
  String toString() {
    return 'LoginHistoryModel(id: $id, method: $loginMethod, successful: $isSuccessful)';
  }
}

/// OTP Response Model
/// 
/// Represents the response from OTP generation endpoints
class OtpResponseModel {
  final String otpId;
  final String message;
  final int expiresIn;
  final DateTime expiresAt;
  final int attemptsRemaining;

  const OtpResponseModel({
    required this.otpId,
    required this.message,
    required this.expiresIn,
    required this.expiresAt,
    this.attemptsRemaining = 3,
  });

  /// Create OtpResponseModel from JSON
  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    final expiresIn = json['expiresIn'] as int;
    final issuedAt = json['issuedAt'] != null
        ? DateTime.parse(json['issuedAt'] as String)
        : DateTime.now();

    return OtpResponseModel(
      otpId: json['otpId'] as String,
      message: json['message'] as String? ?? 'OTP sent successfully',
      expiresIn: expiresIn,
      expiresAt: issuedAt.add(Duration(seconds: expiresIn)),
      attemptsRemaining: json['attemptsRemaining'] as int? ?? 3,
    );
  }

  /// Convert OtpResponseModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'otpId': otpId,
      'message': message,
      'expiresIn': expiresIn,
      'expiresAt': expiresAt.toIso8601String(),
      'attemptsRemaining': attemptsRemaining,
    };
  }

  /// Check if OTP is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Get remaining time until expiry
  Duration get timeUntilExpiry {
    final now = DateTime.now();
    if (now.isAfter(expiresAt)) {
      return Duration.zero;
    }
    return expiresAt.difference(now);
  }

  @override
  String toString() {
    return 'OtpResponseModel(otpId: $otpId, expiresAt: $expiresAt, attemptsRemaining: $attemptsRemaining)';
  }
}

/// Password Reset Response Model
/// 
/// Represents the response from password reset endpoints
class PasswordResetResponseModel {
  final String resetToken;
  final String message;
  final int expiresIn;
  final DateTime expiresAt;

  const PasswordResetResponseModel({
    required this.resetToken,
    required this.message,
    required this.expiresIn,
    required this.expiresAt,
  });

  /// Create PasswordResetResponseModel from JSON
  factory PasswordResetResponseModel.fromJson(Map<String, dynamic> json) {
    final expiresIn = json['expiresIn'] as int;
    final issuedAt = json['issuedAt'] != null
        ? DateTime.parse(json['issuedAt'] as String)
        : DateTime.now();

    return PasswordResetResponseModel(
      resetToken: json['resetToken'] as String,
      message: json['message'] as String? ?? 'Password reset email sent',
      expiresIn: expiresIn,
      expiresAt: issuedAt.add(Duration(seconds: expiresIn)),
    );
  }

  /// Convert PasswordResetResponseModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'resetToken': resetToken,
      'message': message,
      'expiresIn': expiresIn,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  /// Check if reset token is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Get remaining time until expiry
  Duration get timeUntilExpiry {
    final now = DateTime.now();
    if (now.isAfter(expiresAt)) {
      return Duration.zero;
    }
    return expiresAt.difference(now);
  }

  @override
  String toString() {
    return 'PasswordResetResponseModel(resetToken: ${resetToken.substring(0, 8)}..., expiresAt: $expiresAt)';
  }
}

/// Email Verification Response Model
/// 
/// Represents the response from email verification endpoints
class EmailVerificationResponseModel {
  final String verificationToken;
  final String message;
  final int expiresIn;
  final DateTime expiresAt;

  const EmailVerificationResponseModel({
    required this.verificationToken,
    required this.message,
    required this.expiresIn,
    required this.expiresAt,
  });

  /// Create EmailVerificationResponseModel from JSON
  factory EmailVerificationResponseModel.fromJson(Map<String, dynamic> json) {
    final expiresIn = json['expiresIn'] as int;
    final issuedAt = json['issuedAt'] != null
        ? DateTime.parse(json['issuedAt'] as String)
        : DateTime.now();

    return EmailVerificationResponseModel(
      verificationToken: json['verificationToken'] as String,
      message: json['message'] as String? ?? 'Verification email sent',
      expiresIn: expiresIn,
      expiresAt: issuedAt.add(Duration(seconds: expiresIn)),
    );
  }

  /// Convert EmailVerificationResponseModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'verificationToken': verificationToken,
      'message': message,
      'expiresIn': expiresIn,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  /// Check if verification token is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Get remaining time until expiry
  Duration get timeUntilExpiry {
    final now = DateTime.now();
    if (now.isAfter(expiresAt)) {
      return Duration.zero;
    }
    return expiresAt.difference(now);
  }

  @override
  String toString() {
    return 'EmailVerificationResponseModel(token: ${verificationToken.substring(0, 8)}..., expiresAt: $expiresAt)';
  }
}

/// API Error Response Model
/// 
/// Represents error responses from the API
class ApiErrorResponseModel {
  final String error;
  final String message;
  final int statusCode;
  final List<String>? details;
  final String? field;
  final DateTime timestamp;

  const ApiErrorResponseModel({
    required this.error,
    required this.message,
    required this.statusCode,
    this.details,
    this.field,
    required this.timestamp,
  });

  /// Create ApiErrorResponseModel from JSON
  factory ApiErrorResponseModel.fromJson(Map<String, dynamic> json) {
    return ApiErrorResponseModel(
      error: json['error'] as String,
      message: json['message'] as String,
      statusCode: json['statusCode'] as int,
      details: (json['details'] as List<dynamic>?)?.cast<String>(),
      field: json['field'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  /// Convert ApiErrorResponseModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      'statusCode': statusCode,
      'details': details,
      'field': field,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ApiErrorResponseModel(error: $error, statusCode: $statusCode, message: $message)';
  }
}