import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/user_model.dart';
import '../models/auth_models.dart';

/// Authentication Remote Data Source Interface
/// 
/// Defines the contract for remote authentication operations
abstract class AuthRemoteDataSource {
  // Authentication methods
  Future<AuthResponseModel> loginWithEmail({
    required String email,
    required String password,
    String? deviceId,
  });

  Future<AuthResponseModel> loginWithPhone({
    required String phoneNumber,
    required String otp,
    String? deviceId,
  });

  Future<AuthResponseModel> loginWithGoogle({
    required String idToken,
    String? deviceId,
  });

  Future<AuthResponseModel> loginWithFacebook({
    required String accessToken,
    String? deviceId,
  });

  Future<AuthResponseModel> loginWithApple({
    required String idToken,
    String? authorizationCode,
    String? deviceId,
  });

  Future<AuthResponseModel> loginWithBiometric({
    required String biometricToken,
    String? deviceId,
  });

  // Registration methods
  Future<AuthResponseModel> signUpWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  });

  // OTP methods
  Future<OtpResponseModel> sendOtp({
    required String phoneNumber,
  });

  Future<AuthResponseModel> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String otpId,
  });

  // Password methods
  Future<PasswordResetResponseModel> sendPasswordResetEmail({
    required String email,
  });

  Future<void> resetPasswordWithToken({
    required String token,
    required String newPassword,
  });

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  // Email verification
  Future<EmailVerificationResponseModel> sendEmailVerification();

  Future<void> verifyEmail({
    required String token,
  });

  // Token management
  Future<AuthTokensModel> refreshToken({
    required String refreshToken,
  });

  Future<bool> validateToken({
    required String token,
  });

  // Session management
  Future<UserSessionModel> getUserSession();

  Future<void> extendSession();

  Future<List<LoginHistoryModel>> getLoginHistory({
    int limit = 10,
  });

  // User management
  Future<UserModel> getCurrentUser();

  Future<UserModel> getUserById({
    required String userId,
  });

  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
  });

  Future<UserModel> updateCricketProfile({
    required CricketProfileModel cricketProfile,
  });

  Future<UserModel> updatePreferences({
    required UserPreferencesModel preferences,
  });

  Future<List<UserModel>> searchUsers({
    required String query,
    int limit = 20,
  });

  Future<void> deleteAccount({
    required String password,
  });

  // Biometric methods
  Future<bool> isBiometricAvailable();

  Future<bool> isBiometricEnabled();

  Future<void> enableBiometricAuth();

  Future<void> disableBiometricAuth();

  // Utility methods
  Future<bool> checkEmailAvailability({
    required String email,
  });

  Future<bool> checkPhoneAvailability({
    required String phoneNumber,
  });

  Future<void> reportSuspiciousActivity({
    required String description,
    Map<String, dynamic>? metadata,
  });

  Future<void> logout();
}

/// Authentication Remote Data Source Implementation
/// 
/// Implements remote authentication operations using HTTP API
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  const AuthRemoteDataSourceImpl({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  @override
  Future<AuthResponseModel> loginWithEmail({
    required String email,
    required String password,
    String? deviceId,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.loginEmail,
        data: {
          'email': email,
          'password': password,
          'deviceId': deviceId,
        },
      );

      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to login with email: $e');
    }
  }

  @override
  Future<AuthResponseModel> loginWithPhone({
    required String phoneNumber,
    required String otp,
    String? deviceId,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.loginPhone,
        data: {
          'phoneNumber': phoneNumber,
          'otp': otp,
          'deviceId': deviceId,
        },
      );

      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to login with phone: $e');
    }
  }

  @override
  Future<AuthResponseModel> loginWithGoogle({
    required String idToken,
    String? deviceId,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.loginGoogle,
        data: {
          'idToken': idToken,
          'deviceId': deviceId,
        },
      );

      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to login with Google: $e');
    }
  }

  @override
  Future<AuthResponseModel> loginWithFacebook({
    required String accessToken,
    String? deviceId,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.loginFacebook,
        data: {
          'accessToken': accessToken,
          'deviceId': deviceId,
        },
      );

      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to login with Facebook: $e');
    }
  }

  @override
  Future<AuthResponseModel> loginWithApple({
    required String idToken,
    String? authorizationCode,
    String? deviceId,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.loginApple,
        data: {
          'idToken': idToken,
          'authorizationCode': authorizationCode,
          'deviceId': deviceId,
        },
      );

      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to login with Apple: $e');
    }
  }

  @override
  Future<AuthResponseModel> loginWithBiometric({
    required String biometricToken,
    String? deviceId,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.loginBiometric,
        data: {
          'biometricToken': biometricToken,
          'deviceId': deviceId,
        },
      );

      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to login with biometric: $e');
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
      final response = await _dioClient.post(
        ApiEndpoints.signUp,
        data: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'phoneNumber': phoneNumber,
        },
      );

      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to sign up: $e');
    }
  }

  @override
  Future<OtpResponseModel> sendOtp({
    required String phoneNumber,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.sendOtp,
        data: {
          'phoneNumber': phoneNumber,
        },
      );

      return OtpResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to send OTP: $e');
    }
  }

  @override
  Future<AuthResponseModel> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String otpId,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.verifyOtp,
        data: {
          'phoneNumber': phoneNumber,
          'otp': otp,
          'otpId': otpId,
        },
      );

      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to verify OTP: $e');
    }
  }

  @override
  Future<PasswordResetResponseModel> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.passwordResetRequest,
        data: {
          'email': email,
        },
      );

      return PasswordResetResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to send password reset email: $e');
    }
  }

  @override
  Future<void> resetPasswordWithToken({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _dioClient.post(
        ApiEndpoints.passwordReset,
        data: {
          'token': token,
          'newPassword': newPassword,
        },
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to reset password: $e');
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _dioClient.put(
        ApiEndpoints.passwordChange,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to change password: $e');
    }
  }

  @override
  Future<EmailVerificationResponseModel> sendEmailVerification() async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.emailVerificationSend,
      );

      return EmailVerificationResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to send email verification: $e');
    }
  }

  @override
  Future<void> verifyEmail({
    required String token,
  }) async {
    try {
      await _dioClient.post(
        ApiEndpoints.emailVerificationVerify,
        data: {
          'token': token,
        },
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to verify email: $e');
    }
  }

  @override
  Future<AuthTokensModel> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.tokenRefresh,
        data: {
          'refreshToken': refreshToken,
        },
      );

      return AuthTokensModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to refresh token: $e');
    }
  }

  @override
  Future<bool> validateToken({
    required String token,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.tokenValidate,
        data: {
          'token': token,
        },
      );

      return response.data['isValid'] as bool? ?? false;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to validate token: $e');
    }
  }

  @override
  Future<UserSessionModel> getUserSession() async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.userSession,
      );

      return UserSessionModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to get user session: $e');
    }
  }

  @override
  Future<void> extendSession() async {
    try {
      await _dioClient.post(
        ApiEndpoints.sessionExtend,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to extend session: $e');
    }
  }

  @override
  Future<List<LoginHistoryModel>> getLoginHistory({
    int limit = 10,
  }) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.loginHistory,
        queryParameters: {
          'limit': limit,
        },
      );

      final List<dynamic> data = response.data['history'] as List<dynamic>;
      return data.map((json) => LoginHistoryModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to get login history: $e');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.userProfile,
      );

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to get current user: $e');
    }
  }

  @override
  Future<UserModel> getUserById({
    required String userId,
  }) async {
    try {
      final response = await _dioClient.get(
        '${ApiEndpoints.users}/$userId',
      );

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to get user by ID: $e');
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (firstName != null) data['firstName'] = firstName;
      if (lastName != null) data['lastName'] = lastName;
      if (phoneNumber != null) data['phoneNumber'] = phoneNumber;
      if (profileImageUrl != null) data['profileImageUrl'] = profileImageUrl;

      final response = await _dioClient.put(
        ApiEndpoints.userProfile,
        data: data,
      );

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to update profile: $e');
    }
  }

  @override
  Future<UserModel> updateCricketProfile({
    required CricketProfileModel cricketProfile,
  }) async {
    try {
      final response = await _dioClient.put(
        ApiEndpoints.userCricketProfile,
        data: cricketProfile.toJson(),
      );

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to update cricket profile: $e');
    }
  }

  @override
  Future<UserModel> updatePreferences({
    required UserPreferencesModel preferences,
  }) async {
    try {
      final response = await _dioClient.put(
        ApiEndpoints.userPreferences,
        data: preferences.toJson(),
      );

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to update preferences: $e');
    }
  }

  @override
  Future<List<UserModel>> searchUsers({
    required String query,
    int limit = 20,
  }) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.userSearch,
        queryParameters: {
          'query': query,
          'limit': limit,
        },
      );

      final List<dynamic> data = response.data['users'] as List<dynamic>;
      return data.map((json) => UserModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to search users: $e');
    }
  }

  @override
  Future<void> deleteAccount({
    required String password,
  }) async {
    try {
      await _dioClient.delete(
        ApiEndpoints.userAccount,
        data: {
          'password': password,
        },
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to delete account: $e');
    }
  }

  @override
  Future<bool> isBiometricAvailable() async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.biometricAvailable,
      );

      return response.data['isAvailable'] as bool? ?? false;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to check biometric availability: $e');
    }
  }

  @override
  Future<bool> isBiometricEnabled() async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.biometricStatus,
      );

      return response.data['isEnabled'] as bool? ?? false;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to check biometric status: $e');
    }
  }

  @override
  Future<void> enableBiometricAuth() async {
    try {
      await _dioClient.post(
        ApiEndpoints.biometricEnable,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to enable biometric auth: $e');
    }
  }

  @override
  Future<void> disableBiometricAuth() async {
    try {
      await _dioClient.post(
        ApiEndpoints.biometricDisable,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to disable biometric auth: $e');
    }
  }

  @override
  Future<bool> checkEmailAvailability({
    required String email,
  }) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.checkEmailAvailability,
        queryParameters: {
          'email': email,
        },
      );

      return response.data['isAvailable'] as bool? ?? false;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to check email availability: $e');
    }
  }

  @override
  Future<bool> checkPhoneAvailability({
    required String phoneNumber,
  }) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.checkPhoneAvailability,
        queryParameters: {
          'phoneNumber': phoneNumber,
        },
      );

      return response.data['isAvailable'] as bool? ?? false;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to check phone availability: $e');
    }
  }

  @override
  Future<void> reportSuspiciousActivity({
    required String description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _dioClient.post(
        ApiEndpoints.reportSuspiciousActivity,
        data: {
          'description': description,
          'metadata': metadata,
        },
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to report suspicious activity: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dioClient.post(
        ApiEndpoints.logout,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to logout: $e');
    }
  }

  /// Handle Dio exceptions and convert them to appropriate custom exceptions
  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout. Please check your internet connection.');
      
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        
        if (statusCode == 401) {
          return AuthException('Authentication failed. Please login again.');
        } else if (statusCode == 403) {
          return AuthException('Access denied. You do not have permission to perform this action.');
        } else if (statusCode == 404) {
          return ServerException('Resource not found.');
        } else if (statusCode == 422) {
          String message = 'Validation failed.';
          if (data is Map<String, dynamic> && data.containsKey('message')) {
            message = data['message'] as String;
          }
          return ValidationException(message);
        } else if (statusCode != null && statusCode >= 500) {
          return ServerException('Server error. Please try again later.');
        } else {
          String message = 'An error occurred.';
          if (data is Map<String, dynamic> && data.containsKey('message')) {
            message = data['message'] as String;
          }
          return ServerException(message);
        }
      
      case DioExceptionType.cancel:
        return NetworkException('Request was cancelled.');
      
      case DioExceptionType.connectionError:
        return NetworkException('No internet connection. Please check your network settings.');
      
      case DioExceptionType.badCertificate:
        return NetworkException('SSL certificate error. Please check your connection security.');
      
      case DioExceptionType.unknown:
      default:
        return ServerException('An unexpected error occurred: ${e.message}');
    }
  }
}