import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// Send Password Reset Email Use Case
/// 
/// Handles sending password reset email to user
class SendPasswordResetEmailUseCase implements UseCase<void, SendPasswordResetEmailParams> {
  final AuthRepository repository;

  const SendPasswordResetEmailUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SendPasswordResetEmailParams params) async {
    // Validate email format
    if (!_isValidEmail(params.email)) {
      return Left(AuthFailureFactory.invalidEmail());
    }

    // Delegate to repository
    return await repository.sendPasswordResetEmail(
      email: params.email.trim().toLowerCase(),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }
}

/// Reset Password with Token Use Case
/// 
/// Handles password reset using a token from email
class ResetPasswordWithTokenUseCase implements UseCase<void, ResetPasswordWithTokenParams> {
  final AuthRepository repository;

  const ResetPasswordWithTokenUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ResetPasswordWithTokenParams params) async {
    // Validate token
    if (params.token.trim().isEmpty) {
      return const Left(ValidationFailure('Reset token is required'));
    }

    // Validate new password
    final passwordValidation = _validatePassword(params.newPassword);
    if (passwordValidation != null) {
      return Left(ValidationFailure(passwordValidation));
    }

    // Delegate to repository
    return await repository.resetPasswordWithToken(
      token: params.token.trim(),
      newPassword: params.newPassword,
    );
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

    return null; // Password is valid
  }
}

/// Change Password Use Case
/// 
/// Handles password change for authenticated users
class ChangePasswordUseCase implements UseCase<void, ChangePasswordParams> {
  final AuthRepository repository;

  const ChangePasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) async {
    // Validate current password
    if (params.currentPassword.isEmpty) {
      return const Left(ValidationFailure('Current password is required'));
    }

    // Validate new password
    final passwordValidation = _validatePassword(params.newPassword);
    if (passwordValidation != null) {
      return Left(ValidationFailure(passwordValidation));
    }

    // Check that new password is different from current
    if (params.currentPassword == params.newPassword) {
      return const Left(ValidationFailure('New password must be different from current password'));
    }

    // Delegate to repository
    return await repository.changePassword(
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
    );
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

/// Validate Password Strength Use Case
/// 
/// Validates password strength without making API calls
class ValidatePasswordStrengthUseCase implements UseCase<PasswordStrength, ValidatePasswordStrengthParams> {
  const ValidatePasswordStrengthUseCase();

  @override
  Future<Either<Failure, PasswordStrength>> call(ValidatePasswordStrengthParams params) async {
    final password = params.password;
    int score = 0;
    final feedback = <String>[];

    // Length check
    if (password.length >= 8) {
      score += 1;
    } else {
      feedback.add('Use at least 8 characters');
    }

    if (password.length >= 12) {
      score += 1;
    } else if (password.length >= 8) {
      feedback.add('Consider using 12+ characters for better security');
    }

    // Character variety checks
    if (RegExp(r'[a-z]').hasMatch(password)) {
      score += 1;
    } else {
      feedback.add('Include lowercase letters');
    }

    if (RegExp(r'[A-Z]').hasMatch(password)) {
      score += 1;
    } else {
      feedback.add('Include uppercase letters');
    }

    if (RegExp(r'\d').hasMatch(password)) {
      score += 1;
    } else {
      feedback.add('Include numbers');
    }

    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      score += 1;
    } else {
      feedback.add('Include special characters');
    }

    // Common password check
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
      score = 0; // Override score for common passwords
      feedback.clear();
      feedback.add('This password is too common. Choose something unique.');
    }

    // Repetitive patterns check
    if (RegExp(r'(.)\1{2,}').hasMatch(password)) {
      score = score > 0 ? score - 1 : 0;
      feedback.add('Avoid repeating characters');
    }

    // Sequential patterns check
    if (RegExp(r'(012|123|234|345|456|567|678|789|890|abc|bcd|cde|def|efg|fgh|ghi|hij|ijk|jkl|klm|lmn|mno|nop|opq|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz)').hasMatch(password.toLowerCase())) {
      score = score > 0 ? score - 1 : 0;
      feedback.add('Avoid sequential patterns');
    }

    // Determine strength level
    PasswordStrengthLevel level;
    if (score <= 2) {
      level = PasswordStrengthLevel.weak;
    } else if (score <= 4) {
      level = PasswordStrengthLevel.medium;
    } else {
      level = PasswordStrengthLevel.strong;
    }

    final strength = PasswordStrength(
      level: level,
      score: score,
      maxScore: 6,
      feedback: feedback,
      isValid: score >= 4, // Require at least medium strength
    );

    return Right(strength);
  }
}

/// Parameters for sending password reset email
class SendPasswordResetEmailParams {
  final String email;

  const SendPasswordResetEmailParams({
    required this.email,
  });

  @override
  String toString() => 'SendPasswordResetEmailParams(email: $email)';
}

/// Parameters for resetting password with token
class ResetPasswordWithTokenParams {
  final String token;
  final String newPassword;

  const ResetPasswordWithTokenParams({
    required this.token,
    required this.newPassword,
  });

  @override
  String toString() => 'ResetPasswordWithTokenParams(token: ${token.substring(0, 8)}...)';
}

/// Parameters for changing password
class ChangePasswordParams {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  String toString() => 'ChangePasswordParams()';
}

/// Parameters for validating password strength
class ValidatePasswordStrengthParams {
  final String password;

  const ValidatePasswordStrengthParams({
    required this.password,
  });

  @override
  String toString() => 'ValidatePasswordStrengthParams()';
}

/// Password strength result
class PasswordStrength {
  final PasswordStrengthLevel level;
  final int score;
  final int maxScore;
  final List<String> feedback;
  final bool isValid;

  const PasswordStrength({
    required this.level,
    required this.score,
    required this.maxScore,
    required this.feedback,
    required this.isValid,
  });

  /// Get strength percentage (0-100)
  double get percentage => (score / maxScore) * 100;

  /// Get strength description
  String get description {
    switch (level) {
      case PasswordStrengthLevel.weak:
        return 'Weak';
      case PasswordStrengthLevel.medium:
        return 'Medium';
      case PasswordStrengthLevel.strong:
        return 'Strong';
    }
  }

  @override
  String toString() {
    return 'PasswordStrength(level: $level, score: $score/$maxScore, isValid: $isValid)';
  }
}

/// Password strength levels
enum PasswordStrengthLevel {
  weak,
  medium,
  strong,
}

/// Main Password Use Case - Aggregates all password methods
class PasswordUseCase {
  final SendPasswordResetEmailUseCase _sendPasswordResetEmailUseCase;
  final ResetPasswordWithTokenUseCase _resetPasswordWithTokenUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final ValidatePasswordStrengthUseCase _validatePasswordStrengthUseCase;

  const PasswordUseCase({
    required SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase,
    required ResetPasswordWithTokenUseCase resetPasswordWithTokenUseCase,
    required ChangePasswordUseCase changePasswordUseCase,
    required ValidatePasswordStrengthUseCase validatePasswordStrengthUseCase,
  }) : _sendPasswordResetEmailUseCase = sendPasswordResetEmailUseCase,
       _resetPasswordWithTokenUseCase = resetPasswordWithTokenUseCase,
       _changePasswordUseCase = changePasswordUseCase,
       _validatePasswordStrengthUseCase = validatePasswordStrengthUseCase;

  Future<Either<Failure, void>> sendPasswordResetEmail(SendPasswordResetEmailParams params) {
    return _sendPasswordResetEmailUseCase.call(params);
  }

  Future<Either<Failure, void>> resetPasswordWithToken(ResetPasswordWithTokenParams params) {
    return _resetPasswordWithTokenUseCase.call(params);
  }

  Future<Either<Failure, void>> changePassword(ChangePasswordParams params) {
    return _changePasswordUseCase.call(params);
  }

  Future<Either<Failure, PasswordStrength>> validatePasswordStrength(ValidatePasswordStrengthParams params) {
    return _validatePasswordStrengthUseCase.call(params);
  }
}