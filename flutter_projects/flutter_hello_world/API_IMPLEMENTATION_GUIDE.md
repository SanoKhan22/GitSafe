# 🚀 GullyCric API Implementation Guide

## 📋 Table of Contents
1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Mock vs Real API](#mock-vs-real-api)
4. [File Structure](#file-structure)
5. [Data Models](#data-models)
6. [API Endpoints](#api-endpoints)
7. [Implementation Steps](#implementation-steps)
8. [Testing](#testing)
9. [Migration Guide](#migration-guide)
10. [Best Practices](#best-practices)
11. [Troubleshooting](#troubleshooting)

---

## 🎯 Overview

This guide explains how to implement and manage APIs in the GullyCric Flutter app. We use a **Clean Architecture** approach with **mock APIs** for development and easy migration to real APIs.

### Key Features
- ✅ **Mock API System** - Development without backend dependency
- ✅ **Clean Architecture** - Separation of concerns
- ✅ **Easy Migration** - One-flag switch to real APIs
- ✅ **Type Safety** - Strong typing with data models
- ✅ **Error Handling** - Comprehensive error management
- ✅ **Testing Ready** - Built for unit and integration tests

---

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Presentation  │    │     Domain      │    │      Data       │
│                 │    │                 │    │                 │
│ ┌─────────────┐ │    │ ┌─────────────┐ │    │ ┌─────────────┐ │
│ │   Widgets   │ │    │ │  Entities   │ │    │ │   Models    │ │
│ │   BLoCs     │ │◄──►│ │  Use Cases  │ │◄──►│ │ Data Sources│ │
│ │   Pages     │ │    │ │ Repositories│ │    │ │ Repositories│ │
│ └─────────────┘ │    │ └─────────────┘ │    │ └─────────────┘ │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                       │
                                              ┌─────────────────┐
                                              │   External      │
                                              │                 │
                                              │ ┌─────────────┐ │
                                              │ │  Mock API   │ │
                                              │ │  Real API   │ │
                                              │ │  Local DB   │ │
                                              │ └─────────────┘ │
                                              └─────────────────┘
```

### Layer Responsibilities

| Layer | Responsibility | Files |
|-------|---------------|-------|
| **Presentation** | UI, State Management | `pages/`, `widgets/`, `blocs/` |
| **Domain** | Business Logic | `entities/`, `usecases/`, `repositories/` |
| **Data** | Data Access | `models/`, `datasources/`, `repositories/` |

---

## 🔄 Mock vs Real API

### Current Setup (Mock API)
```dart
// lib/core/config/api_config.dart
static const bool useMockApi = true; // 🔄 Currently using mock
```

### Benefits of Mock API
- 🚀 **Instant Development** - No backend dependency
- 🧪 **Predictable Testing** - Consistent responses
- 📱 **Offline Work** - No internet required
- 🎯 **Complete Flows** - Full user journeys work

### When to Switch to Real API
- ✅ Backend APIs are ready and tested
- ✅ API documentation is complete
- ✅ Authentication system is implemented
- ✅ Error handling is defined

---

## 📁 File Structure

```
lib/
├── core/
│   ├── config/
│   │   └── api_config.dart              # API configuration
│   ├── constants/
│   │   └── api_endpoints.dart           # All API endpoints
│   ├── network/
│   │   ├── dio_client.dart             # HTTP client setup
│   │   └── api_response.dart           # Response wrapper
│   ├── services/
│   │   └── mock_api_service.dart       # Mock API implementation
│   └── error/
│       ├── exceptions.dart             # Custom exceptions
│       └── failure.dart                # Failure classes
├── features/
│   └── auth/                           # Feature: Authentication
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── auth_remote_datasource.dart    # API interface
│       │   │   ├── auth_mock_datasource.dart      # Mock implementation
│       │   │   └── auth_local_datasource.dart     # Local storage
│       │   ├── models/
│       │   │   ├── user_model.dart               # User data model
│       │   │   └── auth_models.dart              # Auth data models
│       │   └── repositories/
│       │       └── auth_repository_impl.dart     # Repository implementation
│       ├── domain/
│       │   ├── entities/
│       │   │   └── user_entity.dart              # User business entity
│       │   ├── repositories/
│       │   │   └── auth_repository.dart          # Repository interface
│       │   └── usecases/
│       │       ├── login_usecase.dart            # Login business logic
│       │       └── signup_usecase.dart           # Signup business logic
│       └── presentation/
│           ├── pages/
│           ├── widgets/
│           └── blocs/
```

---

## 📊 Data Models

### 1. User Model (`user_model.dart`)

```dart
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    super.phoneNumber,
    super.profileImageUrl,
    super.isEmailVerified,
    super.isPhoneVerified,
    super.role,
    super.status,
    super.cricketProfile,
    super.preferences,
    super.createdAt,
    super.updatedAt,
  });

  // JSON serialization
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    email: json['email'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    phoneNumber: json['phoneNumber'] as String?,
    profileImageUrl: json['profileImageUrl'] as String?,
    isEmailVerified: json['isEmailVerified'] as bool? ?? false,
    isPhoneVerified: json['isPhoneVerified'] as bool? ?? false,
    role: UserRole.values.firstWhere(
      (e) => e.name == json['role'],
      orElse: () => UserRole.user,
    ),
    status: UserStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => UserStatus.active,
    ),
    cricketProfile: json['cricketProfile'] != null
        ? CricketProfileModel.fromJson(json['cricketProfile'])
        : null,
    preferences: json['preferences'] != null
        ? UserPreferencesModel.fromJson(json['preferences'])
        : null,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : null,
    updatedAt: json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'phoneNumber': phoneNumber,
    'profileImageUrl': profileImageUrl,
    'isEmailVerified': isEmailVerified,
    'isPhoneVerified': isPhoneVerified,
    'role': role.name,
    'status': status.name,
    'cricketProfile': cricketProfile?.toJson(),
    'preferences': preferences?.toJson(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}
```

### 2. Auth Response Model (`auth_models.dart`)

```dart
class AuthResponseModel {
  final UserModel user;
  final AuthTokensModel tokens;
  final String message;
  final bool isFirstLogin;

  const AuthResponseModel({
    required this.user,
    required this.tokens,
    required this.message,
    required this.isFirstLogin,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      AuthResponseModel(
        user: UserModel.fromJson(json['user']),
        tokens: AuthTokensModel.fromJson(json['tokens']),
        message: json['message'] as String,
        isFirstLogin: json['isFirstLogin'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'tokens': tokens.toJson(),
        'message': message,
        'isFirstLogin': isFirstLogin,
      };
}

class AuthTokensModel {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final DateTime expiresAt;
  final DateTime issuedAt;
  final String scope;

  const AuthTokensModel({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.expiresAt,
    required this.issuedAt,
    required this.scope,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) =>
      AuthTokensModel(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
        tokenType: json['tokenType'] as String? ?? 'Bearer',
        expiresIn: json['expiresIn'] as int,
        expiresAt: DateTime.parse(json['expiresAt']),
        issuedAt: DateTime.parse(json['issuedAt']),
        scope: json['scope'] as String? ?? 'read write',
      );

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'tokenType': tokenType,
        'expiresIn': expiresIn,
        'expiresAt': expiresAt.toIso8601String(),
        'issuedAt': issuedAt.toIso8601String(),
        'scope': scope,
      };
}
```

---

## 🌐 API Endpoints

### Authentication Endpoints (`api_endpoints.dart`)

```dart
class ApiEndpoints {
  // Base
  static const String baseUrl = '/api/v1';
  
  // Authentication
  static const String loginEmail = '/auth/login/email';
  static const String loginPhone = '/auth/login/phone';
  static const String loginGoogle = '/auth/login/google';
  static const String loginFacebook = '/auth/login/facebook';
  static const String loginApple = '/auth/login/apple';
  static const String loginBiometric = '/auth/login/biometric';
  static const String signUp = '/auth/signup';
  static const String logout = '/auth/logout';
  
  // OTP
  static const String sendOtp = '/auth/otp/send';
  static const String verifyOtp = '/auth/otp/verify';
  
  // Password
  static const String passwordResetRequest = '/auth/password/reset-request';
  static const String passwordReset = '/auth/password/reset';
  static const String passwordChange = '/auth/password/change';
  
  // Token Management
  static const String tokenRefresh = '/auth/token/refresh';
  static const String tokenValidate = '/auth/token/validate';
  
  // Session
  static const String userSession = '/auth/session';
  static const String sessionExtend = '/auth/session/extend';
  static const String loginHistory = '/auth/login-history';
  
  // User
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile/update';
  static const String userCricketProfile = '/user/cricket-profile';
  static const String userPreferences = '/user/preferences';
  
  // Utility
  static const String checkEmailAvailability = '/auth/check/email';
  static const String checkPhoneAvailability = '/auth/check/phone';
  static const String biometricAvailable = '/auth/biometric/available';
}
```

---

## 🛠️ Implementation Steps

### Step 1: Define Data Source Interface

```dart
// auth_remote_datasource.dart
abstract class AuthRemoteDataSource {
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

  Future<OtpResponseModel> sendOtp({
    required String phoneNumber,
  });

  // Add more methods as needed...
}
```

### Step 2: Implement Mock Data Source

```dart
// auth_mock_datasource.dart
class AuthMockDataSource implements AuthRemoteDataSource {
  final MockApiService _mockApiService;
  
  const AuthMockDataSource({required MockApiService mockApiService})
      : _mockApiService = mockApiService;

  @override
  Future<AuthResponseModel> loginWithEmail({
    required String email,
    required String password,
    String? deviceId,
  }) async {
    try {
      final response = await _mockApiService.loginWithEmail(
        email: email,
        password: password,
        deviceId: deviceId,
      );
      return AuthResponseModel.fromJson(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  Exception _handleException(dynamic e) {
    if (e is Exception) return e;
    return ServerException(e.toString());
  }
}
```

### Step 3: Implement Real Data Source

```dart
// auth_api_datasource.dart (Create when ready for real API)
class AuthApiDataSource implements AuthRemoteDataSource {
  final DioClient _dioClient;
  
  const AuthApiDataSource({required DioClient dioClient})
      : _dioClient = dioClient;

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
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.response?.statusCode) {
      case 401:
        return AuthException('Invalid credentials');
      case 404:
        return AuthException('User not found');
      case 500:
        return ServerException('Server error');
      default:
        return NetworkException('Network error');
    }
  }
}
```

### Step 4: Configure Dependency Injection

```dart
// service_locator.dart
void _registerDataSources() {
  // Mock API Service
  sl.registerLazySingleton<MockApiService>(() => MockApiService());
  
  // Choose data source based on configuration
  if (ApiConfig.useMockApi) {
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthMockDataSource(mockApiService: sl()),
    );
  } else {
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthApiDataSource(dioClient: sl()),
    );
  }
}
```

---

## 🧪 Testing

### Unit Tests for Data Sources

```dart
// test/features/auth/data/datasources/auth_mock_datasource_test.dart
void main() {
  late AuthMockDataSource dataSource;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    dataSource = AuthMockDataSource(mockApiService: mockApiService);
  });

  group('loginWithEmail', () {
    test('should return AuthResponseModel when login is successful', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';

      // Act
      final result = await dataSource.loginWithEmail(
        email: email,
        password: password,
      );

      // Assert
      expect(result, isA<AuthResponseModel>());
      expect(result.user.email, equals(email));
    });

    test('should throw AuthException when credentials are invalid', () async {
      // Arrange
      const email = 'invalid@example.com';
      const password = 'wrongpassword';

      // Act & Assert
      expect(
        () => dataSource.loginWithEmail(email: email, password: password),
        throwsA(isA<AuthException>()),
      );
    });
  });
}
```

### Integration Tests

```dart
// integration_test/auth_flow_test.dart
void main() {
  group('Authentication Flow', () {
    testWidgets('should complete login flow with mock API', (tester) async {
      await tester.pumpWidget(MyApp());
      
      // Navigate to login
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();
      
      // Enter credentials
      await tester.enterText(
        find.byKey(const Key('email_field')), 
        'demo@gullycric.com'
      );
      await tester.enterText(
        find.byKey(const Key('password_field')), 
        'password123'
      );
      
      // Submit login
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pumpAndSettle();
      
      // Verify success
      expect(find.text('Welcome'), findsOneWidget);
    });
  });
}
```

---

## 🔄 Migration Guide

### From Mock to Real API

#### 1. Update Configuration
```dart
// lib/core/config/api_config.dart
static const bool useMockApi = false; // 🔄 Switch to real API
```

#### 2. Update Base URLs
```dart
static const String devBaseUrl = 'https://your-api.com/api/v1';
static const String stagingBaseUrl = 'https://staging-api.com/api/v1';
static const String productionBaseUrl = 'https://api.com/api/v1';
```

#### 3. Create Real Data Source
```dart
// Create auth_api_datasource.dart
// Implement AuthRemoteDataSource with real HTTP calls
```

#### 4. Update Dependency Injection
```dart
// Update service_locator.dart to use AuthApiDataSource
sl.registerLazySingleton<AuthRemoteDataSource>(
  () => AuthApiDataSource(dioClient: sl()),
);
```

#### 5. Test Thoroughly
- Run all unit tests
- Run integration tests
- Test error scenarios
- Verify authentication flows

---

## 📋 Best Practices

### 1. Data Models
- ✅ Always extend domain entities
- ✅ Implement `fromJson` and `toJson`
- ✅ Handle null values gracefully
- ✅ Use proper type conversions
- ✅ Add validation where needed

### 2. Error Handling
- ✅ Create specific exception types
- ✅ Map HTTP status codes to exceptions
- ✅ Provide meaningful error messages
- ✅ Log errors for debugging
- ✅ Handle network timeouts

### 3. API Design
- ✅ Use consistent endpoint naming
- ✅ Follow RESTful conventions
- ✅ Version your APIs
- ✅ Document request/response formats
- ✅ Implement proper authentication

### 4. Testing
- ✅ Test both success and failure cases
- ✅ Mock external dependencies
- ✅ Test data model serialization
- ✅ Verify error handling
- ✅ Test edge cases

---

## 🔧 Troubleshooting

### Common Issues

#### 1. Serialization Errors
```dart
// Problem: JSON parsing fails
// Solution: Check data types and null handling
factory UserModel.fromJson(Map<String, dynamic> json) {
  return UserModel(
    id: json['id'] as String? ?? '', // Handle null
    email: json['email'] as String? ?? '',
    // ... other fields
  );
}
```

#### 2. Network Timeouts
```dart
// Problem: Requests timeout
// Solution: Configure proper timeouts
static const Duration connectTimeout = Duration(seconds: 30);
static const Duration receiveTimeout = Duration(seconds: 30);
```

#### 3. Authentication Errors
```dart
// Problem: Token refresh fails
// Solution: Implement proper token management
class TokenInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Refresh token and retry
      _refreshTokenAndRetry(err, handler);
    } else {
      handler.next(err);
    }
  }
}
```

---

## 📈 Future Enhancements

### Planned Features
- [ ] **Caching Layer** - Offline data access
- [ ] **Real-time Updates** - WebSocket integration
- [ ] **File Upload** - Image and document handling
- [ ] **Push Notifications** - FCM integration
- [ ] **Analytics** - User behavior tracking
- [ ] **Performance Monitoring** - API response times

### API Expansion Areas
- [ ] **Match Management** - Create, join, manage matches
- [ ] **Team Management** - Team creation and management
- [ ] **Tournament System** - Tournament brackets and scoring
- [ ] **Social Features** - Friends, chat, sharing
- [ ] **Statistics** - Advanced cricket analytics
- [ ] **Payment Integration** - In-app purchases

---

## 📞 Support

### Team Contacts
- **Backend Team**: backend@gullycric.com
- **Mobile Team**: mobile@gullycric.com
- **DevOps Team**: devops@gullycric.com

### Resources
- [API Documentation](https://docs.gullycric.com/api)
- [Flutter Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Dio HTTP Client](https://pub.dev/packages/dio)
- [JSON Annotation](https://pub.dev/packages/json_annotation)

---

**Last Updated**: December 2024  
**Version**: 1.0.0  
**Maintainer**: GullyCric Development Team