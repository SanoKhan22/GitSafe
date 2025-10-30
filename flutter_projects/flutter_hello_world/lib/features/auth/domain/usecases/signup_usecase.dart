import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Sign Up with Email Use Case
/// 
/// Handles user registration with email and password
/// Validates input and delegates to repository
class SignUpWithEmailUseCase implements UseCase<UserEntity, SignUpWithEmailParams> {
  final AuthRepository repository;

  const SignUpWithEmailUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignUpWithEmailParams params) async {
    // Validate email format
    if (!_isValidEmail(params.email)) {
      return Left(AuthFailureFactory.invalidEmail());
    }

    // Validate password strength
    final passwordValidation = _validatePassword(params.password);
    if (passwordValidation != null) {
      return Left(ValidationFailure(passwordValidation));
    }

    // Validate names
    if (params.firstName.trim().isEmpty) {
      return const Left(ValidationFailure('First name is required'));
    }

    if (params.lastName.trim().isEmpty) {
      return const Left(ValidationFailure('Last name is required'));
    }

    if (params.firstName.trim().length < 2) {
      return const Left(ValidationFailure('First name must be at least 2 characters'));
    }

    if (params.lastName.trim().length < 2) {
      return const Left(ValidationFailure('Last name must be at least 2 characters'));
    }

    // Validate phone number if provided
    if (params.phoneNumber != null && !_isValidPhoneNumber(params.phoneNumber!)) {
      return Left(AuthFailureFactory.invalidPhoneNumber());
    }

    // Check if email is available
    final emailAvailableResult = await repository.isEmailAvailable(email: params.email);
    if (emailAvailableResult.isLeft()) {
      return Left(emailAvailableResult.fold((l) => l, (r) => AuthFailureFactory.unknown()));
    }

    final isEmailAvailable = emailAvailableResult.fold((l) => false, (r) => r);
    if (!isEmailAvailable) {
      return Left(AuthFailureFactory.emailAlreadyExists());
    }

    // Check if phone number is available (if provided)
    if (params.phoneNumber != null) {
      final phoneAvailableResult = await repository.isPhoneAvailable(phoneNumber: params.phoneNumber!);
      if (phoneAvailableResult.isLeft()) {
        return Left(phoneAvailableResult.fold((l) => l, (r) => AuthFailureFactory.unknown()));
      }

      final isPhoneAvailable = phoneAvailableResult.fold((l) => false, (r) => r);
      if (!isPhoneAvailable) {
        return Left(AuthFailureFactory.phoneAlreadyExists());
      }
    }

    // Delegate to repository
    return await repository.signUpWithEmail(
      email: params.email.trim().toLowerCase(),
      password: params.password,
      firstName: params.firstName.trim(),
      lastName: params.lastName.trim(),
      phoneNumber: params.phoneNumber?.trim(),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phoneNumber);
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (password.length > 128) {
      return 'Password must be less than 128 characters';
    }

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for at least one digit
    if (!RegExp(r'\d').hasMatch(password)) {
      return 'Password must contain at least one number';
    }

    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'Password must contain at least one special character';
    }

    // Check for common weak passwords
    final commonPasswords = [
      'password',
      '12345678',
      'qwerty123',
      'abc123456',
      'password123',
      '123456789',
      'qwertyuiop',
    ];

    if (commonPasswords.contains(password.toLowerCase())) {
      return 'Password is too common. Please choose a stronger password';
    }

    return null; // Password is valid
  }
}

/// Send Email Verification Use Case
class SendEmailVerificationUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  const SendEmailVerificationUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.sendEmailVerification();
  }
}

/// Verify Email Use Case
class VerifyEmailUseCase implements UseCase<void, VerifyEmailParams> {
  final AuthRepository repository;

  const VerifyEmailUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(VerifyEmailParams params) async {
    // Validate token
    if (params.token.trim().isEmpty) {
      return const Left(ValidationFailure('Verification token is required'));
    }

    // Delegate to repository
    return await repository.verifyEmail(token: params.token.trim());
  }
}

/// Check Email Availability Use Case
class CheckEmailAvailabilityUseCase implements UseCase<bool, CheckEmailAvailabilityParams> {
  final AuthRepository repository;

  const CheckEmailAvailabilityUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(CheckEmailAvailabilityParams params) async {
    // Validate email format
    if (!_isValidEmail(params.email)) {
      return Left(AuthFailureFactory.invalidEmail());
    }

    // Delegate to repository
    return await repository.isEmailAvailable(email: params.email.trim().toLowerCase());
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }
}

/// Check Phone Availability Use Case
class CheckPhoneAvailabilityUseCase implements UseCase<bool, CheckPhoneAvailabilityParams> {
  final AuthRepository repository;

  const CheckPhoneAvailabilityUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(CheckPhoneAvailabilityParams params) async {
    // Validate phone number format
    if (!_isValidPhoneNumber(params.phoneNumber)) {
      return Left(AuthFailureFactory.invalidPhoneNumber());
    }

    // Delegate to repository
    return await repository.isPhoneAvailable(phoneNumber: params.phoneNumber.trim());
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phoneNumber);
  }
}

/// Parameters for sign up with email
class SignUpWithEmailParams {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? phoneNumber;

  const SignUpWithEmailParams({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
  });

  @override
  String toString() {
    return 'SignUpWithEmailParams(email: $email, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber)';
  }
}

/// Parameters for email verification
class VerifyEmailParams {
  final String token;

  const VerifyEmailParams({
    required this.token,
  });

  @override
  String toString() => 'VerifyEmailParams(token: ${token.substring(0, 8)}...)';
}

/// Parameters for checking email availability
class CheckEmailAvailabilityParams {
  final String email;

  const CheckEmailAvailabilityParams({
    required this.email,
  });

  @override
  String toString() => 'CheckEmailAvailabilityParams(email: $email)';
}

/// Parameters for checking phone availability
class CheckPhoneAvailabilityParams {
  final String phoneNumber;

  const CheckPhoneAvailabilityParams({
    required this.phoneNumber,
  });

  @override
  String toString() => 'CheckPhoneAvailabilityParams(phoneNumber: $phoneNumber)';
}

/// Main Sign Up Use Case - Aggregates all signup methods
class SignUpUseCase {
  final SignUpWithEmailUseCase _signUpWithEmailUseCase;
  final CheckEmailAvailabilityUseCase _checkEmailAvailabilityUseCase;
  final CheckPhoneAvailabilityUseCase _checkPhoneAvailabilityUseCase;

  const SignUpUseCase({
    required SignUpWithEmailUseCase signUpWithEmailUseCase,
    required CheckEmailAvailabilityUseCase checkEmailAvailabilityUseCase,
    required CheckPhoneAvailabilityUseCase checkPhoneAvailabilityUseCase,
  }) : _signUpWithEmailUseCase = signUpWithEmailUseCase,
       _checkEmailAvailabilityUseCase = checkEmailAvailabilityUseCase,
       _checkPhoneAvailabilityUseCase = checkPhoneAvailabilityUseCase;

  Future<Either<Failure, UserEntity>> signUpWithEmail(SignUpWithEmailParams params) {
    return _signUpWithEmailUseCase.call(params);
  }

  Future<Either<Failure, bool>> checkEmailAvailability(CheckEmailAvailabilityParams params) {
    return _checkEmailAvailabilityUseCase.call(params);
  }

  Future<Either<Failure, bool>> checkPhoneAvailability(CheckPhoneAvailabilityParams params) {
    return _checkPhoneAvailabilityUseCase.call(params);
  }
}