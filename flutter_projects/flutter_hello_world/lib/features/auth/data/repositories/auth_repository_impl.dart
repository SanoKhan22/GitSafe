import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';
import '../models/auth_models.dart';

/// Authentication Repository Implementation
/// 
/// Implements the auth repository interface using remote and local data sources
/// Handles caching, offline support, and error handling
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
    String? deviceId,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.loginWithEmail(
          email: email,
          password: password,
          deviceId: deviceId,
        );

        // Cache successful login data
        await _cacheAuthData(response);
        await _localDataSource.setLastLoginEmail(email);

        return Right(response.user);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.invalidCredentials(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithPhone({
    required String phoneNumber,
    required String otp,
    String? deviceId,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.loginWithPhone(
          phoneNumber: phoneNumber,
          otp: otp,
          deviceId: deviceId,
        );

        // Cache successful login data
        await _cacheAuthData(response);

        return Right(response.user);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.invalidOtp(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle({
    String? deviceId,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.loginWithGoogle(
          idToken: 'mock_google_token',
          deviceId: deviceId,
        );

        // Cache successful login data
        await _cacheAuthData(response);

        return Right(response.user);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.socialLoginFailed(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithFacebook({
    String? deviceId,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.loginWithFacebook(
          accessToken: 'mock_facebook_token',
          deviceId: deviceId,
        );

        // Cache successful login data
        await _cacheAuthData(response);

        return Right(response.user);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.socialLoginFailed(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithApple({
    String? deviceId,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.loginWithApple(
          idToken: 'mock_apple_token',
          deviceId: deviceId,
        );

        // Cache successful login data
        await _cacheAuthData(response);

        return Right(response.user);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.socialLoginFailed(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithBiometric({
    String? deviceId,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.loginWithBiometric(
          biometricToken: 'mock_biometric_token',
          deviceId: deviceId,
        );

        // Cache successful login data
        await _cacheAuthData(response);

        return Right(response.user);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.biometricFailed(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.signUpWithEmail(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
        );

        // Cache successful signup data
        await _cacheAuthData(response);

        return Right(response.user);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.registrationFailed(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> sendOtp({
    required String phoneNumber,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.sendOtp(phoneNumber: phoneNumber);
        return const Right(null);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.otpSendFailed(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String otpId,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.verifyOtp(
          phoneNumber: phoneNumber,
          otp: otp,
          otpId: otpId,
        );

        // Cache successful verification data
        await _cacheAuthData(response);

        return Right(response.user);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.invalidOtp(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.sendPasswordResetEmail(email: email);
        return const Right(null);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.passwordResetFailed(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPasswordWithToken({
    required String token,
    required String newPassword,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.resetPasswordWithToken(
          token: token,
          newPassword: newPassword,
        );
        return const Right(null);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.passwordResetFailed(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
        return const Right(null);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.passwordChangeFailed(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> sendEmailVerification() async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.sendEmailVerification();
        return const Right(null);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.emailVerificationFailed(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail({
    required String token,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.verifyEmail(token: token);
        
        // Update cached user with verified email status
        final cachedUser = await _localDataSource.getCachedUser();
        if (cachedUser != null) {
          final updatedUser = cachedUser.copyWith(isEmailVerified: true);
          await _localDataSource.cacheUser(updatedUser);
        }
        
        return const Right(null);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.emailVerificationFailed(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> refreshToken({
    required String refreshToken,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final tokens = await _remoteDataSource.refreshToken(refreshToken: refreshToken);
        
        // Cache new tokens
        await _localDataSource.cacheAuthTokens(tokens);
        
        return Right(tokens);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.tokenRefreshFailed(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> validateToken({
    required String token,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final isValid = await _remoteDataSource.validateToken(token: token);
        return Right(isValid);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.tokenValidationFailed(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserSession>> getUserSession() async {
    if (await _networkInfo.isConnected) {
      try {
        final session = await _remoteDataSource.getUserSession();
        
        // Cache session data
        await _localDataSource.cacheUserSession(session);
        
        return Right(session);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.sessionRetrievalFailed(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      // Try to get cached session when offline
      try {
        final cachedSession = await _localDataSource.getCachedUserSession();
        if (cachedSession != null) {
          return Right(cachedSession);
        } else {
          return Left(NetworkFailure('No internet connection and no cached session'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, void>> extendSession() async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.extendSession();
        return const Right(null);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.sessionExtensionFailed(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<LoginHistory>>> getLoginHistory({
    int limit = 10,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final history = await _remoteDataSource.getLoginHistory(limit: limit);
        
        // Cache login history
        await _localDataSource.cacheLoginHistory(history);
        
        return Right(history.cast<LoginHistory>());
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.loginHistoryFailed(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      // Try to get cached history when offline
      try {
        final cachedHistory = await _localDataSource.getCachedLoginHistory();
        if (cachedHistory != null) {
          return Right(cachedHistory.cast<LoginHistory>());
        } else {
          return Left(NetworkFailure('No internet connection and no cached login history'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    if (await _networkInfo.isConnected) {
      try {
        final user = await _remoteDataSource.getCurrentUser();
        
        // Cache user data
        await _localDataSource.cacheUser(user);
        
        return Right(user);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.userRetrievalFailed(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      // Try to get cached user when offline
      try {
        final cachedUser = await _localDataSource.getCachedUser();
        if (cachedUser != null) {
          return Right(cachedUser);
        } else {
          return Left(NetworkFailure('No internet connection and no cached user'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserById({
    required String userId,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final user = await _remoteDataSource.getUserById(userId: userId);
        return Right(user);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.userRetrievalFailed(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final user = await _remoteDataSource.updateProfile(
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
          profileImageUrl: profileImageUrl,
        );
        
        // Cache updated user data
        await _localDataSource.cacheUser(user);
        
        return Right(user);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.profileUpdateFailed(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateCricketProfile({
    required CricketProfile cricketProfile,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final cricketProfileModel = CricketProfileModel.fromEntity(cricketProfile);
        final user = await _remoteDataSource.updateCricketProfile(
          cricketProfile: cricketProfileModel,
        );
        
        // Cache updated user data
        await _localDataSource.cacheUser(user);
        
        return Right(user);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.profileUpdateFailed(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updatePreferences({
    required UserPreferences preferences,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final preferencesModel = UserPreferencesModel.fromEntity(preferences);
        final user = await _remoteDataSource.updatePreferences(
          preferences: preferencesModel,
        );
        
        // Cache updated user data and preferences
        await _localDataSource.cacheUser(user);
        await _localDataSource.cacheUserPreferences(preferencesModel);
        
        return Right(user);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.preferencesUpdateFailed(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> searchUsers({
    required String query,
    int limit = 20,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final users = await _remoteDataSource.searchUsers(
          query: query,
          limit: limit,
        );
        return Right(users.cast<UserEntity>());
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.userSearchFailed(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount({
    required String password,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteAccount(password: password);
        
        // Clear all cached data after account deletion
        await _localDataSource.clearAllData();
        
        return const Right(null);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.accountDeletionFailed(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> isBiometricAvailable() async {
    if (await _networkInfo.isConnected) {
      try {
        final isAvailable = await _remoteDataSource.isBiometricAvailable();
        return Right(isAvailable);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.biometricCheckFailed(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> isBiometricEnabled() async {
    try {
      // Check local storage first for biometric settings
      final isEnabled = await _localDataSource.isBiometricEnabled();
      return Right(isEnabled);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on Exception catch (e) {
      return Left(AuthFailureFactory.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> enableBiometricAuth() async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.enableBiometricAuth();
        
        // Update local biometric settings
        await _localDataSource.setBiometricEnabled(true);
        
        return const Right(null);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.biometricEnableFailed(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> disableBiometricAuth() async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.disableBiometricAuth();
        
        // Update local biometric settings
        await _localDataSource.setBiometricEnabled(false);
        
        return const Right(null);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.biometricDisableFailed(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkEmailAvailability({
    required String email,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final isAvailable = await _remoteDataSource.checkEmailAvailability(email: email);
        return Right(isAvailable);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.emailCheckFailed(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkPhoneAvailability({
    required String phoneNumber,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final isAvailable = await _remoteDataSource.checkPhoneAvailability(phoneNumber: phoneNumber);
        return Right(isAvailable);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.phoneCheckFailed(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  // Convenience methods for backward compatibility
  @override
  Future<Either<Failure, bool>> isEmailAvailable({
    required String email,
  }) async {
    return checkEmailAvailability(email: email);
  }

  @override
  Future<Either<Failure, bool>> isPhoneAvailable({
    required String phoneNumber,
  }) async {
    return checkPhoneAvailability(phoneNumber: phoneNumber);
  }

  @override
  Future<Either<Failure, void>> reportSuspiciousActivity({
    required String description,
    Map<String, dynamic>? metadata,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.reportSuspiciousActivity(
          description: description,
          metadata: metadata,
        );
        return const Right(null);
      } on AuthException catch (e) {
        return Left(AuthFailureFactory.reportFailed(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(AuthFailureFactory.unknown(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      // Check local authentication state first
      final isAuthenticatedLocal = await _localDataSource.isAuthenticated();
      
      if (!isAuthenticatedLocal) {
        return const Right(false);
      }
      
      // Check if tokens are still valid
      final cachedTokens = await _localDataSource.getCachedAuthTokens();
      if (cachedTokens == null || cachedTokens.isExpired) {
        await _localDataSource.setAuthenticationState(false);
        return const Right(false);
      }
      
      return const Right(true);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on Exception catch (e) {
      return Left(AuthFailureFactory.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> getAuthTokens() async {
    try {
      final cachedTokens = await _localDataSource.getCachedAuthTokens();
      if (cachedTokens != null) {
        return Right(cachedTokens);
      } else {
        return Left(AuthFailureFactory.noTokensFound());
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on Exception catch (e) {
      return Left(AuthFailureFactory.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Attempt to logout from server if connected
      if (await _networkInfo.isConnected) {
        try {
          await _remoteDataSource.logout();
        } catch (e) {
          // Continue with local logout even if server logout fails
        }
      }
      
      // Clear all local data
      await _localDataSource.clearAllData();
      
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on Exception catch (e) {
      return Left(AuthFailureFactory.unknown(e.toString()));
    }
  }

  /// Helper method to cache authentication data after successful login/signup
  Future<void> _cacheAuthData(AuthResponseModel response) async {
    await Future.wait([
      _localDataSource.cacheUser(response.user),
      _localDataSource.cacheAuthTokens(response.tokens),
      _localDataSource.setAuthenticationState(true),
    ]);
  }
}