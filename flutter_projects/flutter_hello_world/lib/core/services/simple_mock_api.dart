import 'dart:async';
import 'dart:math';

/// Simple Mock API Service for GullyCric
/// 
/// Provides basic mock responses for authentication testing
class SimpleMockApi {
  static const int _delayMs = 1000;
  final Random _random = Random();

  /// Mock user data
  static final Map<String, dynamic> _demoUser = {
    'id': 'user_001',
    'email': 'demo@gullycric.com',
    'firstName': 'Demo',
    'lastName': 'User',
    'phoneNumber': '+1234567890',
    'isEmailVerified': true,
    'isPhoneVerified': true,
    'role': 'user',
    'status': 'active',
  };

  /// Simulate network delay
  Future<void> _delay() async {
    await Future.delayed(Duration(milliseconds: _delayMs));
  }

  /// Mock login with email
  Future<Map<String, dynamic>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    await _delay();

    if (email == 'demo@gullycric.com' && password == 'password123') {
      return {
        'user': _demoUser,
        'tokens': {
          'accessToken': 'mock_access_token_${_random.nextInt(1000)}',
          'refreshToken': 'mock_refresh_token_${_random.nextInt(1000)}',
          'tokenType': 'Bearer',
          'expiresIn': 3600,
          'expiresAt': DateTime.now().add(Duration(hours: 1)).toIso8601String(),
        },
        'message': 'Login successful',
        'isFirstLogin': false,
      };
    } else {
      throw Exception('Invalid credentials');
    }
  }

  /// Mock send OTP
  Future<Map<String, dynamic>> sendOtp({
    required String phoneNumber,
  }) async {
    await _delay();

    return {
      'otpId': 'otp_${_random.nextInt(1000)}',
      'message': 'OTP sent successfully',
      'expiresIn': 300,
      'expiresAt': DateTime.now().add(Duration(minutes: 5)).toIso8601String(),
    };
  }

  /// Mock verify OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    await _delay();

    if (otp == '123456') {
      return {
        'user': _demoUser,
        'tokens': {
          'accessToken': 'mock_access_token_${_random.nextInt(1000)}',
          'refreshToken': 'mock_refresh_token_${_random.nextInt(1000)}',
          'tokenType': 'Bearer',
          'expiresIn': 3600,
          'expiresAt': DateTime.now().add(Duration(hours: 1)).toIso8601String(),
        },
        'message': 'OTP verified successfully',
        'isFirstLogin': false,
      };
    } else {
      throw Exception('Invalid OTP');
    }
  }

  /// Mock signup
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    await _delay();

    final newUser = Map<String, dynamic>.from(_demoUser);
    newUser['email'] = email;
    newUser['firstName'] = firstName;
    newUser['lastName'] = lastName;
    newUser['phoneNumber'] = phoneNumber;
    newUser['id'] = 'user_${_random.nextInt(1000)}';

    return {
      'user': newUser,
      'tokens': {
        'accessToken': 'mock_access_token_${_random.nextInt(1000)}',
        'refreshToken': 'mock_refresh_token_${_random.nextInt(1000)}',
        'tokenType': 'Bearer',
        'expiresIn': 3600,
        'expiresAt': DateTime.now().add(Duration(hours: 1)).toIso8601String(),
      },
      'message': 'Account created successfully',
      'isFirstLogin': true,
    };
  }

  /// Mock check email availability
  Future<Map<String, dynamic>> checkEmailAvailability({
    required String email,
  }) async {
    await _delay();

    final isAvailable = email != 'demo@gullycric.com';
    return {
      'isAvailable': isAvailable,
      'email': email,
      'message': isAvailable ? 'Email is available' : 'Email is already taken',
    };
  }

  /// Mock social login
  Future<Map<String, dynamic>> socialLogin({
    required String provider,
    required String token,
  }) async {
    await _delay();

    final user = Map<String, dynamic>.from(_demoUser);
    user['email'] = 'social.${provider}@gullycric.com';
    user['firstName'] = 'Social';
    user['lastName'] = provider.toUpperCase();

    return {
      'user': user,
      'tokens': {
        'accessToken': 'mock_access_token_${_random.nextInt(1000)}',
        'refreshToken': 'mock_refresh_token_${_random.nextInt(1000)}',
        'tokenType': 'Bearer',
        'expiresIn': 3600,
        'expiresAt': DateTime.now().add(Duration(hours: 1)).toIso8601String(),
      },
      'message': 'Social login successful',
      'isFirstLogin': false,
    };
  }

  /// Mock password reset
  Future<Map<String, dynamic>> sendPasswordResetEmail({
    required String email,
  }) async {
    await _delay();

    return {
      'resetToken': 'reset_token_${_random.nextInt(1000)}',
      'message': 'Password reset email sent',
      'expiresIn': 3600,
      'expiresAt': DateTime.now().add(Duration(hours: 1)).toIso8601String(),
    };
  }

  /// Mock login with phone
  Future<Map<String, dynamic>> loginWithPhone({
    required String phoneNumber,
    required String otp,
  }) async {
    await _delay();

    if (otp == '123456') {
      return {
        'user': _demoUser,
        'tokens': {
          'accessToken': 'mock_access_token_${_random.nextInt(1000)}',
          'refreshToken': 'mock_refresh_token_${_random.nextInt(1000)}',
          'tokenType': 'Bearer',
          'expiresIn': 3600,
          'expiresAt': DateTime.now().add(Duration(hours: 1)).toIso8601String(),
        },
        'message': 'Login successful',
        'isFirstLogin': false,
      };
    } else {
      throw Exception('Invalid OTP');
    }
  }

  /// Mock social login
  Future<Map<String, dynamic>> loginWithSocial({
    required String provider,
  }) async {
    await _delay();

    return {
      'user': _demoUser,
      'tokens': {
        'accessToken': 'mock_access_token_${_random.nextInt(1000)}',
        'refreshToken': 'mock_refresh_token_${_random.nextInt(1000)}',
        'tokenType': 'Bearer',
        'expiresIn': 3600,
        'expiresAt': DateTime.now().add(Duration(hours: 1)).toIso8601String(),
      },
      'message': 'Social login successful',
      'isFirstLogin': false,
    };
  }


}