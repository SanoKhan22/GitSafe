import '../../../../core/error/exceptions.dart';
import '../../../../core/services/simple_mock_api.dart';
import '../models/user_model.dart';
import '../models/auth_models.dart';
import 'auth_remote_datasource.dart';

/// Mock Authentication Remote Data Source
/// 
/// Implements AuthRemoteDataSource using mock API service
/// Can be easily replaced with real API implementation
class AuthMockDataSource implements AuthRemoteDataSource {
  final SimpleMockApi _mockApiService;
  
  const AuthMockDataSource({
    required SimpleMockApi mockApiService,
  }) : _mockApiService = mockApiService;

  @override
  Future<AuthResponseModel> loginWithEmail({
    required String email,
    required String password,
    String? deviceId,
  }) async {
    try {
      final response = await _mockApiService.loginWithEmail(
        email: email,
        password: password,
      );
      return AuthResponseModel.fromJson(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<AuthResponseModel> loginWithPhone({
    required String phoneNumber,
    required String otp,
    String? deviceId,
  }) async {
    try {
      final response = await _mockApiService.loginWithPhone(
        phoneNumber: phoneNumber,
        otp: otp,
      );
      return AuthResponseModel.fromJson(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<AuthResponseModel> loginWithGoogle({
    required String idToken,
    String? deviceId,
  }) async {
    try {
      final response = await _mockApiService.loginWithSocial(
        provider: 'google',
      );
      return AuthResponseModel.fromJson(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<AuthResponseModel> loginWithFacebook({
    required String accessToken,
    String? deviceId,
  }) async {
    try {
      final response = await _mockApiService.loginWithSocial(
        provider: 'facebook',
      );
      return AuthResponseModel.fromJson(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<AuthResponseModel> loginWithApple({
    required String idToken,
    String? authorizationCode,
    String? deviceId,
  }) async {
    try {
      final response = await _mockApiService.loginWithSocial(
        provider: 'apple',
      );
      return AuthResponseModel.fromJson(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<AuthResponseModel> loginWithBiometric({
    required String biometricToken,
    String? deviceId,
  }) async {
    try {
      // For mock, use demo user
      final response = await _mockApiService.loginWithEmail(
        email: 'demo@gullycric.com',
        password: 'password123',
      );
      return AuthResponseModel.fromJson(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<AuthResponseModel> signUpWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    try {
      final response = await _mockApiService.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      );
      return AuthResponseModel.fromJson(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<OtpResponseModel> sendOtp({
    required String phoneNumber,
  }) async {
    try {
      final response = await _mockApiService.sendOtp(
        phoneNumber: phoneNumber,
      );
      return OtpResponseModel.fromJson(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<AuthResponseModel> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String otpId,
  }) async {
    try {
      final response = await _mockApiService.loginWithPhone(
        phoneNumber: phoneNumber,
        otp: otp,
      );
      return AuthResponseModel.fromJson(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  // Password methods
  @override
  Future<PasswordResetResponseModel> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      final response = await _mockApiService.sendPasswordResetEmail(email: email);
      return PasswordResetResponseModel.fromJson(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<void> resetPasswordWithToken({
    required String token,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Email verification
  @override
  Future<EmailVerificationResponseModel> sendEmailVerification() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return EmailVerificationResponseModel.fromJson({
      'message': 'Verification email sent',
      'expiresIn': 3600,
    });
  }

  @override
  Future<void> verifyEmail({
    required String token,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Token management
  @override
  Future<AuthTokensModel> refreshToken({
    required String refreshToken,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return AuthTokensModel.fromJson({
      'accessToken': 'mock_new_access_token',
      'refreshToken': 'mock_new_refresh_token',
      'tokenType': 'Bearer',
      'expiresIn': 3600,
    });
  }

  @override
  Future<bool> validateToken({
    required String token,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  // Session management
  @override
  Future<UserSessionModel> getUserSession() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return UserSessionModel.fromJson({
      'sessionId': 'mock_session_id',
      'userId': 'user_001',
      'deviceId': 'mock_device_id',
      'isActive': true,
      'lastActivity': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<void> extendSession() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<List<LoginHistoryModel>> getLoginHistory({
    int limit = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      LoginHistoryModel.fromJson({
        'id': 'login_001',
        'deviceInfo': 'Mock Device',
        'ipAddress': '192.168.1.1',
        'location': 'Mock Location',
        'timestamp': DateTime.now().toIso8601String(),
        'isSuccessful': true,
      }),
    ];
  }

  // User management
  @override
  Future<UserModel> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return UserModel.fromJson({
      'id': 'user_001',
      'email': 'demo@gullycric.com',
      'firstName': 'Demo',
      'lastName': 'User',
      'phoneNumber': '+1234567890',
      'isEmailVerified': true,
      'isPhoneVerified': true,
      'role': 'user',
      'status': 'active',
    });
  }

  @override
  Future<UserModel> getUserById({
    required String userId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return UserModel.fromJson({
      'id': userId,
      'email': 'user@gullycric.com',
      'firstName': 'Mock',
      'lastName': 'User',
      'phoneNumber': '+1234567890',
      'isEmailVerified': true,
      'isPhoneVerified': true,
      'role': 'user',
      'status': 'active',
    });
  }

  @override
  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return UserModel.fromJson({
      'id': 'user_001',
      'email': 'demo@gullycric.com',
      'firstName': firstName ?? 'Demo',
      'lastName': lastName ?? 'User',
      'phoneNumber': phoneNumber ?? '+1234567890',
      'profileImageUrl': profileImageUrl,
      'isEmailVerified': true,
      'isPhoneVerified': true,
      'role': 'user',
      'status': 'active',
    });
  }

  @override
  Future<UserModel> updateCricketProfile({
    required CricketProfileModel cricketProfile,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return UserModel.fromJson({
      'id': 'user_001',
      'email': 'demo@gullycric.com',
      'firstName': 'Demo',
      'lastName': 'User',
      'phoneNumber': '+1234567890',
      'isEmailVerified': true,
      'isPhoneVerified': true,
      'role': 'user',
      'status': 'active',
      'cricketProfile': cricketProfile.toJson(),
    });
  }

  @override
  Future<UserModel> updatePreferences({
    required UserPreferencesModel preferences,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return UserModel.fromJson({
      'id': 'user_001',
      'email': 'demo@gullycric.com',
      'firstName': 'Demo',
      'lastName': 'User',
      'phoneNumber': '+1234567890',
      'isEmailVerified': true,
      'isPhoneVerified': true,
      'role': 'user',
      'status': 'active',
      'preferences': preferences.toJson(),
    });
  }

  @override
  Future<List<UserModel>> searchUsers({
    required String query,
    int limit = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      UserModel.fromJson({
        'id': 'user_002',
        'email': 'search@gullycric.com',
        'firstName': 'Search',
        'lastName': 'Result',
        'phoneNumber': '+1234567891',
        'isEmailVerified': true,
        'isPhoneVerified': true,
        'role': 'user',
        'status': 'active',
      }),
    ];
  }

  @override
  Future<void> deleteAccount({
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Biometric methods
  @override
  Future<bool> isBiometricAvailable() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  @override
  Future<bool> isBiometricEnabled() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return false;
  }

  @override
  Future<void> enableBiometricAuth() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> disableBiometricAuth() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Utility methods
  @override
  Future<bool> checkEmailAvailability({
    required String email,
  }) async {
    try {
      final response = await _mockApiService.checkEmailAvailability(email: email);
      return response['isAvailable'] ?? false;
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<bool> checkPhoneAvailability({
    required String phoneNumber,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return phoneNumber != '+1234567890';
  }

  @override
  Future<void> reportSuspiciousActivity({
    required String description,
    Map<String, dynamic>? metadata,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// Handle exceptions and convert to appropriate types
  Exception _handleException(dynamic e) {
    if (e is Exception) {
      return e;
    }
    return ServerException(e.toString());
  }
}