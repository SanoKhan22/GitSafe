import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/user_entity.dart';

/// GullyCric Authentication Repository Interface
/// 
/// Defines the contract for authentication operations
/// Following Clean Architecture principles - domain layer defines the interface
abstract class AuthRepository {
  // Authentication methods
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
    String? deviceId,
  });

  Future<Either<Failure, UserEntity>> signInWithPhone({
    required String phoneNumber,
    required String otp,
    String? deviceId,
  });

  Future<Either<Failure, UserEntity>> signInWithGoogle({
    String? deviceId,
  });

  Future<Either<Failure, UserEntity>> signInWithFacebook({
    String? deviceId,
  });

  Future<Either<Failure, UserEntity>> signInWithApple({
    String? deviceId,
  });

  Future<Either<Failure, UserEntity>> signInWithBiometric({
    String? deviceId,
  });

  // Registration methods
  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  });

  // OTP methods
  Future<Either<Failure, void>> sendOtp({
    required String phoneNumber,
  });

  Future<Either<Failure, UserEntity>> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String otpId,
  });

  // Password methods
  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  });

  Future<Either<Failure, void>> resetPasswordWithToken({
    required String token,
    required String newPassword,
  });

  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  // Email verification
  Future<Either<Failure, void>> sendEmailVerification();

  Future<Either<Failure, void>> verifyEmail({
    required String token,
  });

  // Token management
  Future<Either<Failure, AuthTokens>> refreshToken({
    required String refreshToken,
  });

  Future<Either<Failure, bool>> validateToken({
    required String token,
  });

  // Session management
  Future<Either<Failure, UserSession>> getUserSession();

  Future<Either<Failure, void>> extendSession();

  Future<Either<Failure, List<LoginHistory>>> getLoginHistory({
    int limit = 10,
  });

  // User management
  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<Either<Failure, UserEntity>> getUserById({
    required String userId,
  });

  Future<Either<Failure, UserEntity>> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
  });

  Future<Either<Failure, UserEntity>> updateCricketProfile({
    required CricketProfile cricketProfile,
  });

  Future<Either<Failure, UserEntity>> updatePreferences({
    required UserPreferences preferences,
  });

  Future<Either<Failure, List<UserEntity>>> searchUsers({
    required String query,
    int limit = 20,
  });

  Future<Either<Failure, void>> deleteAccount({
    required String password,
  });

  // Biometric methods
  Future<Either<Failure, bool>> isBiometricAvailable();

  Future<Either<Failure, bool>> isBiometricEnabled();

  Future<Either<Failure, void>> enableBiometricAuth();

  Future<Either<Failure, void>> disableBiometricAuth();

  // Utility methods
  Future<Either<Failure, bool>> checkEmailAvailability({
    required String email,
  });

  Future<Either<Failure, bool>> checkPhoneAvailability({
    required String phoneNumber,
  });

  Future<Either<Failure, void>> reportSuspiciousActivity({
    required String description,
    Map<String, dynamic>? metadata,
  });

  // Authentication state
  Future<Either<Failure, bool>> isAuthenticated();

  Future<Either<Failure, AuthTokens>> getAuthTokens();

  Future<Either<Failure, void>> logout();

  // Additional convenience methods for backward compatibility
  Future<Either<Failure, bool>> isEmailAvailable({
    required String email,
  });

  Future<Either<Failure, bool>> isPhoneAvailable({
    required String phoneNumber,
  });
}