import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/password_usecase.dart';
import '../../../../core/di/simple_locator.dart';
import '../../../../core/usecases/usecase.dart';

/// Authentication State
class AuthState {
  final UserEntity? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    UserEntity? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

/// Authentication Provider
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final SignUpUseCase _signUpUseCase;
  final PasswordUseCase _passwordUseCase;

  AuthNotifier({
    required LoginUseCase loginUseCase,
    required SignUpUseCase signUpUseCase,
    required PasswordUseCase passwordUseCase,
  })  : _loginUseCase = loginUseCase,
        _signUpUseCase = signUpUseCase,
        _passwordUseCase = passwordUseCase,
        super(const AuthState());

  /// Login with email and password
  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _loginUseCase.loginWithEmail(
      LoginWithEmailParams(
        email: email,
        password: password,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (user) => state = state.copyWith(
        isLoading: false,
        user: user,
        isAuthenticated: true,
        error: null,
      ),
    );
  }

  /// Login with phone and OTP
  Future<void> loginWithPhone({
    required String phoneNumber,
    required String otp,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _loginUseCase.loginWithPhone(
      LoginWithPhoneParams(
        phoneNumber: phoneNumber,
        otp: otp,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (user) => state = state.copyWith(
        isLoading: false,
        user: user,
        isAuthenticated: true,
        error: null,
      ),
    );
  }

  /// Login with Google
  Future<void> loginWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _loginUseCase.loginWithGoogle(
      const NoParams(),
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (user) => state = state.copyWith(
        isLoading: false,
        user: user,
        isAuthenticated: true,
        error: null,
      ),
    );
  }

  /// Login with biometric
  Future<void> loginWithBiometric() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _loginUseCase.loginWithBiometric(
      const NoParams(),
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (user) => state = state.copyWith(
        isLoading: false,
        user: user,
        isAuthenticated: true,
        error: null,
      ),
    );
  }

  /// Sign up with email
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _signUpUseCase.signUpWithEmail(
      SignUpWithEmailParams(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (user) => state = state.copyWith(
        isLoading: false,
        user: user,
        isAuthenticated: true,
        error: null,
      ),
    );
  }

  /// Send OTP
  Future<void> sendOtp({required String phoneNumber}) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _loginUseCase.sendOtp(
      SendOtpParams(phoneNumber: phoneNumber),
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (otpResponse) => state = state.copyWith(
        isLoading: false,
        error: null,
      ),
    );
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail({required String email}) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _passwordUseCase.sendPasswordResetEmail(
      SendPasswordResetEmailParams(email: email),
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (resetResponse) => state = state.copyWith(
        isLoading: false,
        error: null,
      ),
    );
  }

  /// Logout
  Future<void> logout() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _loginUseCase.logout(const NoParams());

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (_) => state = const AuthState(),
    );
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    loginUseCase: sl<LoginUseCase>(),
    signUpUseCase: sl<SignUpUseCase>(),
    passwordUseCase: sl<PasswordUseCase>(),
  );
});

/// Auth State Providers
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

final currentUserProvider = Provider<UserEntity?>((ref) {
  return ref.watch(authProvider).user;
});

final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).error;
});