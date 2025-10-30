import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';

/// Mock API Service
/// 
/// Simulates real API responses for development and testing
/// Designed to be easily replaceable with real API implementation
class MockApiService {
  static const bool _enableMockApi = true; // Set to false when using real API
  static const int _mockDelayMs = 1000; // Simulate network delay
  
  /// Demo users for testing
  static final List<Map<String, dynamic>> _demoUsers = [
    {
      'id': 'user_001',
      'email': 'demo@gullycric.com',
      'firstName': 'Demo',
      'lastName': 'User',
      'phoneNumber': '+1234567890',
      'profileImageUrl': 'https://api.dicebear.com/7.x/avataaars/svg?seed=demo',
      'isEmailVerified': true,
      'isPhoneVerified': true,
      'role': 'user',
      'status': 'active',
      'cricketProfile': {
        'playerId': 'GC_001',
        'teamId': 'team_001',
        'teamName': 'Demo Warriors',
        'preferredRole': 'batsman',
        'battingStyle': 'rightHanded',
        'bowlingStyle': 'rightArmFast',
        'matchesPlayed': 25,
        'runsScored': 1250,
        'wicketsTaken': 15,
        'battingAverage': 50.0,
        'bowlingAverage': 25.5,
        'strikeRate': 125.0,
        'economyRate': 6.5,
        'centuries': 3,
        'halfCenturies': 8,
        'fiveWickets': 1,
        'achievements': [
          {
            'id': 'ach_001',
            'title': 'First Century',
            'description': 'Scored your first century!',
            'iconUrl': 'https://api.dicebear.com/7.x/icons/svg?seed=century',
            'achievedAt': '2024-01-15T10:30:00Z',
            'type': 'batting',
            'metadata': {'runs': 101, 'match': 'match_001'}
          }
        ],
        'lastMatchDate': '2024-01-20T14:00:00Z'
      },
      'preferences': {
        'enableNotifications': true,
        'enablePushNotifications': true,
        'enableEmailNotifications': true,
        'enableSmsNotifications': false,
        'enableSoundEffects': true,
        'enableHapticFeedback': true,
        'preferredLanguage': 'en',
        'preferredTimeZone': 'UTC',
        'preferredDateFormat': 'dd/MM/yyyy',
        'preferredTimeFormat': '24h',
        'enableDarkMode': false,
        'enableAutoTheme': true,
        'notificationSettings': {
          'matchUpdates': true,
          'tournamentUpdates': true,
          'teamInvitations': true,
          'friendRequests': true,
          'achievements': true,
          'newsUpdates': false,
          'socialUpdates': true,
          'marketingEmails': false
        },
        'privacySettings': {
          'profileVisibility': true,
          'statsVisibility': true,
          'matchHistoryVisibility': true,
          'allowFriendRequests': true,
          'allowTeamInvitations': true,
          'showOnlineStatus': true,
          'allowLocationSharing': false,
          'allowDataAnalytics': true
        }
      },
      'createdAt': '2024-01-01T00:00:00Z',
      'updatedAt': '2024-01-20T15:30:00Z'
    },
    {
      'id': 'user_002',
      'email': 'player@gullycric.com',
      'firstName': 'Cricket',
      'lastName': 'Player',
      'phoneNumber': '+1234567891',
      'profileImageUrl': 'https://api.dicebear.com/7.x/avataaars/svg?seed=player',
      'isEmailVerified': true,
      'isPhoneVerified': false,
      'role': 'premium',
      'status': 'active',
      'cricketProfile': {
        'playerId': 'GC_002',
        'teamId': 'team_002',
        'teamName': 'Street Kings',
        'preferredRole': 'allRounder',
        'battingStyle': 'leftHanded',
        'bowlingStyle': 'leftArmSpin',
        'matchesPlayed': 45,
        'runsScored': 2100,
        'wicketsTaken': 35,
        'battingAverage': 46.7,
        'bowlingAverage': 22.8,
        'strikeRate': 135.5,
        'economyRate': 5.8,
        'centuries': 5,
        'halfCenturies': 12,
        'fiveWickets': 3,
        'achievements': [],
        'lastMatchDate': '2024-01-18T16:00:00Z'
      },
      'preferences': {
        'enableNotifications': true,
        'enablePushNotifications': true,
        'enableEmailNotifications': false,
        'enableSmsNotifications': true,
        'enableSoundEffects': false,
        'enableHapticFeedback': true,
        'preferredLanguage': 'hi',
        'preferredTimeZone': 'Asia/Kolkata',
        'preferredDateFormat': 'dd/MM/yyyy',
        'preferredTimeFormat': '12h',
        'enableDarkMode': true,
        'enableAutoTheme': false,
        'notificationSettings': {
          'matchUpdates': true,
          'tournamentUpdates': true,
          'teamInvitations': true,
          'friendRequests': false,
          'achievements': true,
          'newsUpdates': true,
          'socialUpdates': false,
          'marketingEmails': false
        },
        'privacySettings': {
          'profileVisibility': true,
          'statsVisibility': false,
          'matchHistoryVisibility': true,
          'allowFriendRequests': false,
          'allowTeamInvitations': true,
          'showOnlineStatus': false,
          'allowLocationSharing': true,
          'allowDataAnalytics': false
        }
      },
      'createdAt': '2023-12-15T10:00:00Z',
      'updatedAt': '2024-01-18T17:45:00Z'
    }
  ];
  
  /// Mock login history
  static final List<Map<String, dynamic>> _loginHistory = [
    {
      'id': 'login_001',
      'userId': 'user_001',
      'loginAt': '2024-01-20T09:30:00Z',
      'ipAddress': '192.168.1.100',
      'userAgent': 'GullyCric-Flutter/1.0.0 (Android 14)',
      'deviceType': 'Mobile',
      'loginMethod': 'email',
      'location': 'Mumbai, India',
      'isSuccessful': true,
      'failureReason': null
    },
    {
      'id': 'login_002',
      'userId': 'user_001',
      'loginAt': '2024-01-19T14:15:00Z',
      'ipAddress': '192.168.1.100',
      'userAgent': 'GullyCric-Flutter/1.0.0 (Android 14)',
      'deviceType': 'Mobile',
      'loginMethod': 'biometric',
      'location': 'Mumbai, India',
      'isSuccessful': true,
      'failureReason': null
    }
  ];
  
  /// Check if mock API should be used
  static bool get shouldUseMockApi => _enableMockApi;
  
  /// Simulate network delay
  static Future<void> _simulateDelay() async {
    await Future.delayed(Duration(milliseconds: _mockDelayMs));
  }
  
  /// Generate mock tokens
  static Map<String, dynamic> _generateTokens() {
    final now = DateTime.now();
    final expiresAt = now.add(const Duration(hours: 1));
    
    return {
      'accessToken': 'mock_access_token_${_generateRandomString(32)}',
      'refreshToken': 'mock_refresh_token_${_generateRandomString(32)}',
      'tokenType': 'Bearer',
      'expiresIn': 3600,
      'expiresAt': expiresAt.toIso8601String(),
      'issuedAt': now.toIso8601String(),
      'scope': 'read write'
    };
  }
  
  /// Generate random string
  static String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length)))
    );
  }
  
  /// Generate mock session
  static Map<String, dynamic> _generateSession(String userId) {
    final now = DateTime.now();
    return {
      'sessionId': 'session_${_generateRandomString(16)}',
      'userId': userId,
      'deviceId': 'device_${_generateRandomString(12)}',
      'ipAddress': '192.168.1.100',
      'userAgent': 'GullyCric-Flutter/1.0.0 (Android 14)',
      'createdAt': now.subtract(const Duration(hours: 2)).toIso8601String(),
      'lastActivityAt': now.toIso8601String(),
      'expiresAt': now.add(const Duration(hours: 24)).toIso8601String(),
      'isActive': true,
      'location': 'Mumbai, India'
    };
  }
  
  /// Mock API Response Interceptor
  static Future<Response<T>> mockResponse<T>(
    RequestOptions requestOptions,
    Future<Response<T>> Function() realApiCall,
  ) async {
    if (!shouldUseMockApi) {
      return await realApiCall();
    }
    
    await _simulateDelay();
    
    final path = requestOptions.path;
    final method = requestOptions.method.toUpperCase();
    final data = requestOptions.data;
    
    // Mock Authentication Endpoints
    if (path.contains('/auth/login/email') && method == 'POST') {
      return _mockLoginEmail(data);
    }
    
    if (path.contains('/auth/login/phone') && method == 'POST') {
      return _mockLoginPhone(data);
    }
    
    if (path.contains('/auth/login/google') && method == 'POST') {
      return _mockSocialLogin('google');
    }
    
    if (path.contains('/auth/login/facebook') && method == 'POST') {
      return _mockSocialLogin('facebook');
    }
    
    if (path.contains('/auth/login/apple') && method == 'POST') {
      return _mockSocialLogin('apple');
    }
    
    if (path.contains('/auth/signup') && method == 'POST') {
      return _mockSignUp(data);
    }
    
    if (path.contains('/auth/otp/send') && method == 'POST') {
      return _mockSendOtp(data);
    }
    
    if (path.contains('/auth/otp/verify') && method == 'POST') {
      return _mockVerifyOtp(data);
    }
    
    if (path.contains('/auth/password/reset-request') && method == 'POST') {
      return _mockPasswordResetRequest(data);
    }
    
    if (path.contains('/auth/token/refresh') && method == 'POST') {
      return _mockTokenRefresh(data);
    }
    
    if (path.contains('/auth/session') && method == 'GET') {
      return _mockGetSession();
    }
    
    if (path.contains('/auth/login-history') && method == 'GET') {
      return _mockGetLoginHistory();
    }
    
    if (path.contains('/user/profile') && method == 'GET') {
      return _mockGetCurrentUser();
    }
    
    if (path.contains('/auth/check/email') && method == 'GET') {
      return _mockCheckEmailAvailability(requestOptions.queryParameters);
    }
    
    if (path.contains('/auth/biometric/available') && method == 'GET') {
      return _mockBiometricAvailable();
    }
    
    // Default mock response for unhandled endpoints
    return _mockGenericSuccess();
  }
  
  /// Mock login with email
  static Response<T> _mockLoginEmail<T>(dynamic data) {
    final email = data['email'] as String?;
    final password = data['password'] as String?;
    
    // Find user by email
    final user = _demoUsers.firstWhere(
      (u) => u['email'] == email,
      orElse: () => {},
    );
    
    if (user.isEmpty) {
      return _mockErrorResponse(401, 'Invalid email or password');
    }
    
    // Simple password check (in real API, this would be hashed)
    if (password != 'password123' && password != 'demo123') {
      return _mockErrorResponse(401, 'Invalid email or password');
    }
    
    final tokens = _generateTokens();
    final response = {
      'user': user,
      'tokens': tokens,
      'message': 'Login successful',
      'isFirstLogin': false
    };
    
    return Response<T>(
      data: response as T,
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );
  }
  
  /// Mock login with phone
  static Response<T> _mockLoginPhone<T>(dynamic data) {
    final phoneNumber = data['phoneNumber'] as String?;
    final otp = data['otp'] as String?;
    
    // Find user by phone
    final user = _demoUsers.firstWhere(
      (u) => u['phoneNumber'] == phoneNumber,
      orElse: () => {},
    );
    
    if (user.isEmpty) {
      return _mockErrorResponse(401, 'Invalid phone number');
    }
    
    // Simple OTP check
    if (otp != '123456') {
      return _mockErrorResponse(401, 'Invalid or expired OTP');
    }
    
    final tokens = _generateTokens();
    final response = {
      'user': user,
      'tokens': tokens,
      'message': 'Login successful',
      'isFirstLogin': false
    };
    
    return Response<T>(
      data: response as T,
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );
  }
  
  /// Mock social login
  static Response<T> _mockSocialLogin<T>(String provider) {
    final user = _demoUsers.first; // Use first demo user
    final tokens = _generateTokens();
    
    final response = {
      'user': user,
      'tokens': tokens,
      'message': 'Social login successful',
      'isFirstLogin': false
    };
    
    return Response<T>(
      data: response as T,
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );
  }
  
  /// Mock sign up
  static Response<T> _mockSignUp<T>(dynamic data) {
    final email = data['email'] as String?;
    
    // Check if email already exists
    final existingUser = _demoUsers.any((u) => u['email'] == email);
    if (existingUser) {
      return _mockErrorResponse(409, 'Email already exists');
    }
    
    // Create new user
    final newUser = Map<String, dynamic>.from(_demoUsers.first);
    newUser['id'] = 'user_${_generateRandomString(8)}';
    newUser['email'] = email;
    newUser['firstName'] = data['firstName'];
    newUser['lastName'] = data['lastName'];
    newUser['phoneNumber'] = data['phoneNumber'];
    newUser['isEmailVerified'] = false;
    newUser['createdAt'] = DateTime.now().toIso8601String();
    newUser['updatedAt'] = DateTime.now().toIso8601String();
    
    final tokens = _generateTokens();
    final response = {
      'user': newUser,
      'tokens': tokens,
      'message': 'Registration successful',
      'isFirstLogin': true
    };
    
    return Response<T>(
      data: response as T,
      statusCode: 201,
      requestOptions: RequestOptions(path: ''),
    );
  }
  
  /// Mock send OTP
  static Response<T> _mockSendOtp<T>(dynamic data) {
    final response = {
      'otpId': 'otp_${_generateRandomString(16)}',
      'message': 'OTP sent successfully',
      'expiresIn': 300,
      'expiresAt': DateTime.now().add(const Duration(minutes: 5)).toIso8601String(),
      'attemptsRemaining': 3
    };
    
    return Response<T>(
      data: response as T,
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );
  }
  
  /// Mock verify OTP
  static Response<T> _mockVerifyOtp<T>(dynamic data) {
    final otp = data['otp'] as String?;
    
    if (otp != '123456') {
      return _mockErrorResponse(401, 'Invalid or expired OTP');
    }
    
    final user = _demoUsers.first;
    final tokens = _generateTokens();
    
    final response = {
      'user': user,
      'tokens': tokens,
      'message': 'OTP verification successful',
      'isFirstLogin': false
    };
    
    return Response<T>(
      data: response as T,
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );
  }
  
  /// Mock password reset request
  static Response<T> _mockPasswordResetRequest<T>(dynamic data) {
    final response = {
      'resetToken': 'reset_${_generateRandomString(32)}',
      'message': 'Password reset email sent',
      'expiresIn': 3600,
      'expiresAt': DateTime.now().add(const Duration(hours: 1)).toIso8601String()
    };
    
    return Response<T>(
      data: response as T,
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );
  }
  
  /// Mock token refresh
  static Response<T> _mockTokenRefresh<T>(dynamic data) {
    final tokens = _generateTokens();
    
    return Response<T>(
      data: tokens as T,
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );
  }
  
  /// Mock get session
  static Response<T> _mockGetSession<T>() {
    final session = _generateSession('user_001');
    
    return Response<T>(
      data: session as T,
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );
  }
  
  /// Mock get login history
  static Response<T> _mockGetLoginHistory<T>() {
    final response = {
      'history': _loginHistory
    };
    
    return Response<T>(
      data: response as T,
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );
  }
  
  /// Mock get current user
  static Response<T> _mockGetCurrentUser<T>() {
    final user = _demoUsers.first;
    
    return Response<T>(
      data: user as T,
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );
  }
  
  /// Mock check email availability
  static Response<T> _mockCheckEmailAvailability<T>(Map<String, dynamic>? params) {
    final email = params?['email'] as String?;
    final isAvailable = !_demoUsers.any((u) => u['email'] == email);
    
    final response = {
      'isAvailable': isAvailable
    };
    
    return Response<T>(
      data: response as T,
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );
  }
  
  /// Mock biometric available
  static Response<T> _mockBiometricAvailable<T>() {
    final response = {
      'isAvailable': true
    };
    
    return Response<T>(
      data: response as T,
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );
  }
  
  /// Mock generic success response
  static Response<T> _mockGenericSuccess<T>() {
    final response = {
      'success': true,
      'message': 'Operation completed successfully'
    };
    
    return Response<T>(
      data: response as T,
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );
  }
  
  /// Mock error response
  static Response<T> _mockErrorResponse<T>(int statusCode, String message) {
    final response = {
      'error': 'API_ERROR',
      'message': message,
      'statusCode': statusCode,
      'timestamp': DateTime.now().toIso8601String()
    };
    
    return Response<T>(
      data: response as T,
      statusCode: statusCode,
      requestOptions: RequestOptions(path: ''),
    );
  }
}

/// Mock API Interceptor for Dio
class MockApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add mock API headers
    options.headers['X-Mock-API'] = 'true';
    options.headers['X-Mock-Version'] = '1.0.0';
    super.onRequest(options, handler);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Add mock response headers
    response.headers.add('X-Mock-Response', 'true');
    super.onResponse(response, handler);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle mock API errors
    if (MockApiService.shouldUseMockApi) {
      // Convert real network errors to mock errors for consistency
      final mockResponse = MockApiService._mockErrorResponse(
        err.response?.statusCode ?? 500,
        err.message ?? 'Unknown error occurred'
      );
      
      final response = Response(
        data: mockResponse.data,
        statusCode: mockResponse.statusCode,
        requestOptions: err.requestOptions,
      );
      
      handler.resolve(response);
      return;
    }
    
    super.onError(err, handler);
  }
}