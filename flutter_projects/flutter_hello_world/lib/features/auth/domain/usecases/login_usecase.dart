import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Login with Email Use Case
/// 
/// Handles user authentication with email and password
/// Validates input and delegates to repository
class LoginWithEmailUseCase implements UseCase<UserEntity, LoginWithEmailParams> {
  final AuthRepository repository;

  const LoginWithEmailUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginWithEmailParams params) async {
    // Validate email format
    if (!_isValidEmail(params.email)) {
      return Left(AuthFailureFactory.invalidEmail());
    }

    // Validate password
    if (params.password.isEmpty) {
      return const Left(ValidationFailure('Password cannot be empty'));
    }

    if (params.password.length < 6) {
      return const Left(ValidationFailure('Password must be at least 6 characters'));
    }

    // Delegate to repository
    return await repository.signInWithEmail(
      email: params.email.trim().toLowerCase(),
      password: params.password,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }
}

/// Login with Phone Use Case
class LoginWithPhoneUseCase implements UseCase<UserEntity, LoginWithPhoneParams> {
  final AuthRepository repository;

  const LoginWithPhoneUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginWithPhoneParams params) async {
    // Validate phone number format
    if (!_isValidPhoneNumber(params.phoneNumber)) {
      return Left(AuthFailureFactory.invalidPhoneNumber());
    }

    // Validate OTP
    if (params.otp.isEmpty || params.otp.length != 6) {
      return const Left(ValidationFailure('OTP must be 6 digits'));
    }

    // Delegate to repository
    return await repository.signInWithPhone(
      phoneNumber: params.phoneNumber,
      otp: params.otp,
    );
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phoneNumber);
  }
}

/// Login with Google Use Case
class LoginWithGoogleUseCase implements UseCase<UserEntity, NoParams> {
  final AuthRepository repository;

  const LoginWithGoogleUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await repository.signInWithGoogle();
  }
}

/// Login with Facebook Use Case
class LoginWithFacebookUseCase implements UseCase<UserEntity, NoParams> {
  final AuthRepository repository;

  const LoginWithFacebookUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await repository.signInWithFacebook();
  }
}

/// Login with Apple Use Case
class LoginWithAppleUseCase implements UseCase<UserEntity, NoParams> {
  final AuthRepository repository;

  const LoginWithAppleUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await repository.signInWithApple();
  }
}

/// Login with Biometric Use Case
class LoginWithBiometricUseCase implements UseCase<UserEntity, NoParams> {
  final AuthRepository repository;

  const LoginWithBiometricUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    // Check if biometric is available
    final isAvailableResult = await repository.isBiometricAvailable();
    if (isAvailableResult.isLeft()) {
      return Left(isAvailableResult.fold((l) => l, (r) => AuthFailureFactory.unknown()));
    }

    final isAvailable = isAvailableResult.fold((l) => false, (r) => r);
    if (!isAvailable) {
      return Left(AuthFailureFactory.biometricNotAvailable());
    }

    // Check if biometric is enabled
    final isEnabledResult = await repository.isBiometricEnabled();
    if (isEnabledResult.isLeft()) {
      return Left(isEnabledResult.fold((l) => l, (r) => AuthFailureFactory.unknown()));
    }

    final isEnabled = isEnabledResult.fold((l) => false, (r) => r);
    if (!isEnabled) {
      return Left(AuthFailureFactory.biometricNotEnabled());
    }

    // Proceed with biometric authentication
    return await repository.signInWithBiometric();
  }
}

/// Send OTP Use Case
class SendOtpUseCase implements UseCase<String, SendOtpParams> {
  final AuthRepository repository;

  const SendOtpUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(SendOtpParams params) async {
    // Validate phone number format
    if (!_isValidPhoneNumber(params.phoneNumber)) {
      return Left(AuthFailureFactory.invalidPhoneNumber());
    }

    // Delegate to repository
    return await repository.sendOtpToPhone(
      phoneNumber: params.phoneNumber,
    );
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phoneNumber);
  }
}

/// Verify OTP Use Case
class VerifyOtpUseCase implements UseCase<bool, VerifyOtpParams> {
  final AuthRepository repository;

  const VerifyOtpUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(VerifyOtpParams params) async {
    // Validate phone number format
    if (!_isValidPhoneNumber(params.phoneNumber)) {
      return Left(AuthFailureFactory.invalidPhoneNumber());
    }

    // Validate OTP
    if (params.otp.isEmpty || params.otp.length != 6) {
      return const Left(ValidationFailure('OTP must be 6 digits'));
    }

    // Delegate to repository
    return await repository.verifyPhoneOtp(
      phoneNumber: params.phoneNumber,
      otp: params.otp,
    );
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phoneNumber);
  }
}

/// Get Current User Use Case
class GetCurrentUserUseCase implements UseCase<UserEntity?, NoParams> {
  final AuthRepository repository;

  const GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}

/// Check Authentication Status Use Case
class CheckAuthStatusUseCase implements UseCase<bool, NoParams> {
  final AuthRepository repository;

  const CheckAuthStatusUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.isAuthenticated();
  }
}

/// Logout Use Case
class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  const LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.signOut();
  }
}

/// Refresh Token Use Case
class RefreshTokenUseCase implements UseCase<String, NoParams> {
  final AuthRepository repository;

  const RefreshTokenUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.refreshToken();
  }
}

/// Parameters for login with email
class LoginWithEmailParams {
  final String email;
  final String password;

  const LoginWithEmailParams({
    required this.email,
    required this.password,
  });

  @override
  String toString() => 'LoginWithEmailParams(email: $email)';
}

/// Parameters for login with phone
class LoginWithPhoneParams {
  final String phoneNumber;
  final String otp;

  const LoginWithPhoneParams({
    required this.phoneNumber,
    required this.otp,
  });

  @override
  String toString() => 'LoginWithPhoneParams(phoneNumber: $phoneNumber)';
}

/// Parameters for sending OTP
class SendOtpParams {
  final String phoneNumber;

  const SendOtpParams({
    required this.phoneNumber,
  });

  @override
  String toString() => 'SendOtpParams(phoneNumber: $phoneNumber)';
}

/// Parameters for verifying OTP
class VerifyOtpParams {
  final String phoneNumber;
  final String otp;

  const VerifyOtpParams({
    required this.phoneNumber,
    required this.otp,
  });

  @override
  String toString() => 'VerifyOtpParams(phoneNumber: $phoneNumber)';
}

/// Main Login Use Case - Aggregates all login methods
class LoginUseCase {
  final LoginWithEmailUseCase _loginWithEmailUseCase;
  final LoginWithPhoneUseCase _loginWithPhoneUseCase;
  final LoginWithGoogleUseCase _loginWithGoogleUseCase;
  final LoginWithFacebookUseCase _loginWithFacebookUseCase;
  final LoginWithAppleUseCase _loginWithAppleUseCase;
  final LoginWithBiometricUseCase _loginWithBiometricUseCase;
  final LogoutUseCase _logoutUseCase;

  const LoginUseCase({
    required LoginWithEmailUseCase loginWithEmailUseCase,
    required LoginWithPhoneUseCase loginWithPhoneUseCase,
    required LoginWithGoogleUseCase loginWithGoogleUseCase,
    required LoginWithFacebookUseCase loginWithFacebookUseCase,
    required LoginWithAppleUseCase loginWithAppleUseCase,
    required LoginWithBiometricUseCase loginWithBiometricUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _loginWithEmailUseCase = loginWithEmailUseCase,
       _loginWithPhoneUseCase = loginWithPhoneUseCase,
       _loginWithGoogleUseCase = loginWithGoogleUseCase,
       _loginWithFacebookUseCase = loginWithFacebookUseCase,
       _loginWithAppleUseCase = loginWithAppleUseCase,
       _loginWithBiometricUseCase = loginWithBiometricUseCase,
       _logoutUseCase = logoutUseCase;

  Future<Either<Failure, UserEntity>> loginWithEmail(LoginWithEmailParams params) {
    return _loginWithEmailUseCase.call(params);
  }

  Future<Either<Failure, UserEntity>> loginWithPhone(LoginWithPhoneParams params) {
    return _loginWithPhoneUseCase.call(params);
  }

  Future<Either<Failure, UserEntity>> loginWithGoogle(NoParams params) {
    return _loginWithGoogleUseCase.call(params);
  }

  Future<Either<Failure, UserEntity>> loginWithFacebook(NoParams params) {
    return _loginWithFacebookUseCase.call(params);
  }

  Future<Either<Failure, UserEntity>> loginWithApple(NoParams params) {
    return _loginWithAppleUseCase.call(params);
  }

  Future<Either<Failure, UserEntity>> loginWithBiometric(NoParams params) {
    return _loginWithBiometricUseCase.call(params);
  }

  Future<Either<Failure, void>> logout(NoParams params) {
    return _logoutUseCase.call(params);
  }
}