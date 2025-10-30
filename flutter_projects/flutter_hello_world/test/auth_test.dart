import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_hello_world/core/services/simple_mock_api.dart';

void main() {
  group('Simple Mock API Tests', () {
    late SimpleMockApi mockApi;

    setUp(() {
      mockApi = SimpleMockApi();
    });

    test('should login with valid credentials', () async {
      // Test our simple mock API
      final result = await mockApi.loginWithEmail(
        email: 'demo@gullycric.com',
        password: 'password123',
      );

      expect(result, isNotNull);
      expect(result['user'], isNotNull);
      expect(result['tokens'], isNotNull);
      expect(result['user']['email'], equals('demo@gullycric.com'));
      expect(result['message'], equals('Login successful'));
    });

    test('should reject invalid credentials', () async {
      expect(
        () => mockApi.loginWithEmail(
          email: 'wrong@example.com',
          password: 'wrongpassword',
        ),
        throwsException,
      );
    });

    test('should send OTP successfully', () async {
      final result = await mockApi.sendOtp(
        phoneNumber: '+1234567890',
      );

      expect(result, isNotNull);
      expect(result['otpId'], isNotNull);
      expect(result['message'], equals('OTP sent successfully'));
      expect(result['expiresIn'], equals(300));
    });

    test('should verify OTP successfully', () async {
      final result = await mockApi.verifyOtp(
        phoneNumber: '+1234567890',
        otp: '123456',
      );

      expect(result, isNotNull);
      expect(result['user'], isNotNull);
      expect(result['tokens'], isNotNull);
      expect(result['message'], equals('OTP verified successfully'));
    });

    test('should reject invalid OTP', () async {
      expect(
        () => mockApi.verifyOtp(
          phoneNumber: '+1234567890',
          otp: '000000',
        ),
        throwsException,
      );
    });

    test('should check email availability', () async {
      // New email should be available
      final result1 = await mockApi.checkEmailAvailability(
        email: 'new@example.com',
      );
      expect(result1['isAvailable'], isTrue);

      // Demo email should not be available
      final result2 = await mockApi.checkEmailAvailability(
        email: 'demo@gullycric.com',
      );
      expect(result2['isAvailable'], isFalse);
    });

    test('should handle social login', () async {
      final result = await mockApi.socialLogin(
        provider: 'google',
        token: 'mock_google_token',
      );

      expect(result, isNotNull);
      expect(result['user'], isNotNull);
      expect(result['tokens'], isNotNull);
      expect(result['user']['email'], equals('social.google@gullycric.com'));
      expect(result['message'], equals('Social login successful'));
    });

    test('should handle signup', () async {
      final result = await mockApi.signUp(
        email: 'newuser@example.com',
        password: 'password123',
        firstName: 'New',
        lastName: 'User',
        phoneNumber: '+1234567891',
      );

      expect(result, isNotNull);
      expect(result['user'], isNotNull);
      expect(result['tokens'], isNotNull);
      expect(result['user']['email'], equals('newuser@example.com'));
      expect(result['user']['firstName'], equals('New'));
      expect(result['user']['lastName'], equals('User'));
      expect(result['isFirstLogin'], isTrue);
    });
  });
}