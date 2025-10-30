# 🚀 GullyCric API Quick Reference

## 🔄 Switch Between Mock and Real API

```dart
// lib/core/config/api_config.dart
static const bool useMockApi = true;  // Mock API
static const bool useMockApi = false; // Real API
```

## 📁 Key Files to Know

| File | Purpose | When to Edit |
|------|---------|--------------|
| `api_config.dart` | API configuration | Switch APIs, update URLs |
| `api_endpoints.dart` | All endpoint URLs | Add new endpoints |
| `mock_api_service.dart` | Mock API responses | Add mock data |
| `*_model.dart` | Data models | API response changes |
| `*_datasource.dart` | API calls | New API methods |

## 🛠️ Adding New API Endpoint

### 1. Add Endpoint URL
```dart
// lib/core/constants/api_endpoints.dart
static const String newEndpoint = '/api/v1/new-feature';
```

### 2. Create Data Model
```dart
// lib/features/feature/data/models/feature_model.dart
class FeatureModel {
  final String id;
  final String name;
  
  factory FeatureModel.fromJson(Map<String, dynamic> json) => FeatureModel(
    id: json['id'] as String,
    name: json['name'] as String,
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}
```

### 3. Add Mock Response
```dart
// lib/core/services/mock_api_service.dart
Future<Map<String, dynamic>> getNewFeature() async {
  await _simulateNetworkDelay();
  return {
    'id': 'feature_001',
    'name': 'New Feature',
  };
}
```

### 4. Add to Data Source
```dart
// lib/features/feature/data/datasources/feature_remote_datasource.dart
abstract class FeatureRemoteDataSource {
  Future<FeatureModel> getNewFeature();
}

class FeatureMockDataSource implements FeatureRemoteDataSource {
  @override
  Future<FeatureModel> getNewFeature() async {
    final response = await _mockApiService.getNewFeature();
    return FeatureModel.fromJson(response);
  }
}
```

## 🧪 Testing Your API

### Mock API Test Users
```dart
// Available test accounts
Email: demo@gullycric.com
Password: password123

Email: captain@gullycric.com  
Password: captain123

Phone: +1234567890
OTP: 123456 (always works in mock)
```

### Test API Calls
```dart
// Test login
final authDataSource = sl<AuthRemoteDataSource>();
final result = await authDataSource.loginWithEmail(
  email: 'demo@gullycric.com',
  password: 'password123',
);
print('Login successful: ${result.user.firstName}');
```

## 🔧 Common Patterns

### Error Handling
```dart
try {
  final result = await dataSource.someMethod();
  return Right(result);
} catch (e) {
  return Left(_handleException(e));
}

Exception _handleException(dynamic e) {
  if (e.toString().contains('Invalid credentials')) {
    return AuthFailure.invalidCredentials();
  }
  return ServerFailure(e.toString());
}
```

### JSON Serialization
```dart
// Always handle nulls
factory Model.fromJson(Map<String, dynamic> json) => Model(
  id: json['id'] as String? ?? '',
  name: json['name'] as String? ?? 'Unknown',
  count: json['count'] as int? ?? 0,
  isActive: json['isActive'] as bool? ?? false,
  createdAt: json['createdAt'] != null 
    ? DateTime.parse(json['createdAt']) 
    : null,
);
```

### Repository Pattern
```dart
class FeatureRepositoryImpl implements FeatureRepository {
  final FeatureRemoteDataSource remoteDataSource;
  final FeatureLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, Feature>> getFeature() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getFeature();
        await localDataSource.cacheFeature(result);
        return Right(result);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final result = await localDataSource.getCachedFeature();
        return Right(result);
      } catch (e) {
        return Left(CacheFailure('No cached data'));
      }
    }
  }
}
```

## 🚨 Troubleshooting

### Issue: JSON Parsing Error
```dart
// Problem: type 'Null' is not a subtype of type 'String'
// Solution: Add null checks
factory Model.fromJson(Map<String, dynamic> json) => Model(
  name: json['name'] as String? ?? 'Default', // ✅ Safe
  // name: json['name'] as String,            // ❌ Unsafe
);
```

### Issue: Network Timeout
```dart
// Problem: Request takes too long
// Solution: Increase timeout in api_config.dart
static const Duration connectTimeout = Duration(seconds: 60); // Increase
```

### Issue: Mock API Not Working
```dart
// Check: Is mock API enabled?
print('Using mock API: ${ApiConfig.useMockApi}'); // Should be true

// Check: Is mock service registered?
final mockService = sl<MockApiService>(); // Should not throw
```

## 📋 Checklist for New Features

- [ ] Add endpoint to `api_endpoints.dart`
- [ ] Create data model with `fromJson`/`toJson`
- [ ] Add mock response to `mock_api_service.dart`
- [ ] Implement in mock data source
- [ ] Add to repository
- [ ] Create use case
- [ ] Write unit tests
- [ ] Test with mock data
- [ ] Document API contract

## 🔗 Quick Links

- [Full API Guide](./API_IMPLEMENTATION_GUIDE.md)
- [Project README](./README.md)
- [Architecture Spec](./.kiro/specs/gullycric-architecture/)

---

**Need Help?** Check the full API Implementation Guide or ask the team!