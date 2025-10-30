# Core Layer Documentation

> **AI Maintenance Prompt**: This documentation should be updated whenever files in the `lib/core/` directory are modified. Monitor changes to configuration files, network setup, dependency injection, error handling, utilities, widgets, and services. Update this documentation to reflect new utilities, configuration changes, DI setup modifications, new error types, widget additions, and service implementations. Keep the architecture diagrams and code examples current with the actual implementation.

## Overview

The Core layer provides shared infrastructure and utilities used across all features in the GullyCric application. This layer follows Clean Architecture principles and contains no business logic - only technical concerns and shared functionality.

## Architecture Principles

- **No Dependencies**: Core layer should not depend on feature layers
- **Shared Utilities**: Provides common functionality for all features
- **Infrastructure**: Handles technical concerns (networking, DI, error handling)
- **Reusability**: Components should be generic and reusable

## Directory Structure

```
lib/core/
├── config/              # Configuration management
├── constants/           # App-wide constants
├── di/                  # Dependency injection setup
├── error/               # Error handling and exceptions
├── network/             # HTTP client and API handling
├── services/            # Shared services (mock APIs, etc.)
├── theme/               # App theming and styling
├── usecases/            # Base usecase interfaces
├── utils/               # Utility functions and extensions
└── widgets/             # Reusable UI components
```

## Components

### 1. Configuration (`config/`)

**Purpose**: Manages API configuration and environment settings.

**Files**:
- `api_config.dart` - API endpoints, timeouts, and mock/real API switching

**Key Features**:
- Environment-specific API URLs
- Mock/Real API toggle
- Timeout configurations
- SSL certificate settings

**Usage**:
```dart
// Check if using mock API
if (ApiConfig.useMockApi) {
  // Use mock data source
}

// Get API configuration
final baseUrl = ApiConfig.getBaseUrl();
final timeout = ApiConfig.connectTimeout;
```

### 2. Constants (`constants/`)

**Purpose**: Centralized storage for app-wide constants.

**Files**:
- `api_endpoints.dart` - All API endpoint URLs
- `app_colors.dart` - Color palette and theme colors
- `app_icons.dart` - Icon constants and asset paths
- `app_strings.dart` - Static text and labels
- `app_styles.dart` - Text styles and UI styling constants

**Key Features**:
- Centralized constant management
- Easy maintenance and updates
- Type-safe constant access
- Environment-specific values

**Usage**:
```dart
// API endpoints
final loginUrl = ApiEndpoints.loginEmail;

// Colors
final primaryColor = AppColors.primary;

// Strings
final welcomeText = AppStrings.welcomeMessage;
```

### 3. Dependency Injection (`di/`)

**Purpose**: Manages dependency registration and resolution.

**Files**:
- `service_locator.dart` - Main DI container setup
- `dependency_injection.dart` - DI configuration and initialization
- `simple_locator.dart` - Simplified DI for testing

**Key Features**:
- Service registration and resolution
- Singleton and factory patterns
- Mock/Real implementation switching
- Lazy loading support

**Usage**:
```dart
// Register dependencies
void configureDependencies() {
  sl.registerLazySingleton<ApiService>(() => ApiService());
}

// Resolve dependencies
final apiService = sl<ApiService>();
```

### 4. Error Handling (`error/`)

**Purpose**: Centralized error handling and exception management.

**Files**:
- `exceptions.dart` - Custom exception classes
- `failure.dart` - Failure classes for error handling

**Key Features**:
- Typed exception hierarchy
- Error mapping and transformation
- User-friendly error messages
- Logging integration

**Exception Types**:
```dart
// Network exceptions
class NetworkException extends Exception
class ServerException extends Exception
class TimeoutException extends Exception

// Authentication exceptions
class AuthException extends Exception
class TokenExpiredException extends Exception

// Validation exceptions
class ValidationException extends Exception
```

**Usage**:
```dart
try {
  final result = await apiCall();
  return Right(result);
} catch (e) {
  return Left(_mapExceptionToFailure(e));
}
```

### 5. Network (`network/`)

**Purpose**: HTTP client setup and API response handling.

**Files**:
- `dio_client.dart` - HTTP client configuration
- `api_response.dart` - API response wrapper
- `network_info.dart` - Network connectivity checking

**Key Features**:
- HTTP client configuration
- Request/Response interceptors
- Error handling and retry logic
- Network connectivity monitoring

**Usage**:
```dart
// Make API call
final response = await dioClient.get('/api/endpoint');

// Check network connectivity
final isConnected = await networkInfo.isConnected;
```

### 6. Services (`services/`)

**Purpose**: Shared services used across features.

**Files**:
- `mock_api_service.dart` - Mock API implementation
- `simple_mock_api.dart` - Simplified mock API

**Key Features**:
- Mock data generation
- API simulation with delays
- Consistent test data
- Development without backend

**Usage**:
```dart
// Get mock data
final mockUser = await mockApiService.getUser('123');
final mockMatches = await mockApiService.getMatches();
```

### 7. Theme (`theme/`)

**Purpose**: App theming and visual styling.

**Files**:
- `app_theme.dart` - Main theme configuration
- `text_theme.dart` - Typography definitions

**Key Features**:
- Material Design 3 support
- Dark/Light theme variants
- Consistent typography
- Color scheme management

**Usage**:
```dart
// Apply theme
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
)

// Use text styles
Text('Title', style: AppTextTheme.headlineLarge)
```

### 8. Use Cases (`usecases/`)

**Purpose**: Base interfaces for business logic use cases.

**Files**:
- `usecase.dart` - Base usecase interface and implementations

**Key Features**:
- Standardized usecase pattern
- Parameter validation
- Error handling integration
- Async operation support

**Usage**:
```dart
// Define usecase
class LoginUseCase extends UseCase<AuthResponse, LoginParams> {
  @override
  Future<Either<Failure, AuthResponse>> call(LoginParams params) async {
    // Implementation
  }
}

// Use usecase
final result = await loginUseCase(LoginParams(email: email, password: password));
```

### 9. Utils (`utils/`)

**Purpose**: Utility functions and extensions.

**Files**:
- `date_formatter.dart` - Date formatting utilities
- `extensions.dart` - Dart/Flutter extensions
- `logger.dart` - Logging utilities
- `validators.dart` - Input validation functions

**Key Features**:
- Common utility functions
- Type extensions
- Validation helpers
- Logging infrastructure

**Usage**:
```dart
// Date formatting
final formattedDate = DateFormatter.formatMatchDate(DateTime.now());

// Validation
final isValid = Validators.isValidEmail(email);

// Extensions
final capitalizedText = 'hello'.capitalize();

// Logging
Logger.info('User logged in successfully');
```

### 10. Widgets (`widgets/`)

**Purpose**: Reusable UI components.

**Files**:
- `app_button.dart` - Standardized button component
- `app_card.dart` - Card component with consistent styling
- `app_loader.dart` - Loading indicators
- `error_view.dart` - Error display component

**Key Features**:
- Consistent UI components
- Customizable properties
- Accessibility support
- Theme integration

**Usage**:
```dart
// Use core widgets
AppButton(
  text: 'Login',
  onPressed: () => login(),
  isLoading: isLoading,
)

AppCard(
  child: Text('Content'),
  elevation: 2,
)

ErrorView(
  message: 'Something went wrong',
  onRetry: () => retry(),
)
```

## Best Practices

### 1. No Business Logic
- Core layer should contain no business rules
- Keep components generic and reusable
- Avoid feature-specific implementations

### 2. Dependency Direction
- Core layer should not depend on feature layers
- Features can depend on core utilities
- Use dependency inversion for external services

### 3. Configuration Management
- Centralize all configuration in core layer
- Use environment-specific settings
- Keep sensitive data secure

### 4. Error Handling
- Define comprehensive exception hierarchy
- Provide meaningful error messages
- Log errors appropriately for debugging

### 5. Testing
- Write unit tests for all utilities
- Mock external dependencies
- Test error scenarios thoroughly

## Integration with Features

### Authentication Feature
```dart
// Uses core components
class AuthRepositoryImpl {
  final AuthRemoteDataSource remoteDataSource; // Uses network layer
  final AuthLocalDataSource localDataSource;   // Uses storage utilities
  final NetworkInfo networkInfo;               // Uses network utilities
  
  // Implementation uses core error handling
  @override
  Future<Either<Failure, User>> login(LoginParams params) async {
    try {
      if (await networkInfo.isConnected) {
        final result = await remoteDataSource.login(params);
        return Right(result);
      } else {
        return Left(NetworkFailure('No internet connection'));
      }
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }
}
```

### Cricket Feature
```dart
// Uses core widgets and utilities
class MatchCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppCard( // Core widget
      child: Column(
        children: [
          Text(
            DateFormatter.formatMatchDate(match.date), // Core utility
            style: AppTextTheme.bodyMedium, // Core theme
          ),
          AppButton( // Core widget
            text: AppStrings.joinMatch, // Core constants
            onPressed: onJoin,
          ),
        ],
      ),
    );
  }
}
```

## Maintenance Guidelines

### Adding New Utilities
1. Determine the appropriate subdirectory
2. Create utility with comprehensive documentation
3. Add unit tests
4. Update this README
5. Add usage examples

### Modifying Existing Components
1. Ensure backward compatibility
2. Update all dependent code
3. Update tests
4. Update documentation
5. Consider deprecation warnings

### Configuration Changes
1. Update all environment configurations
2. Test in all build flavors
3. Update documentation
4. Notify team of changes

## Testing Strategy

### Unit Tests
- Test all utility functions
- Test error handling scenarios
- Test configuration loading
- Mock external dependencies

### Integration Tests
- Test DI container setup
- Test network layer integration
- Test theme application
- Test widget rendering

### Example Test Structure
```dart
// test/core/utils/validators_test.dart
void main() {
  group('Validators', () {
    group('isValidEmail', () {
      test('should return true for valid email', () {
        expect(Validators.isValidEmail('test@example.com'), true);
      });
      
      test('should return false for invalid email', () {
        expect(Validators.isValidEmail('invalid-email'), false);
      });
    });
  });
}
```

## Performance Considerations

### Lazy Loading
- Use lazy singletons in DI container
- Load resources only when needed
- Cache expensive computations

### Memory Management
- Dispose of resources properly
- Use weak references where appropriate
- Monitor memory usage in utilities

### Network Optimization
- Implement request caching
- Use connection pooling
- Handle network timeouts gracefully

## Security Considerations

### API Security
- Use HTTPS for all requests
- Implement certificate pinning
- Validate SSL certificates

### Data Protection
- Encrypt sensitive data
- Use secure storage for tokens
- Implement proper key management

### Error Handling
- Don't expose sensitive information in errors
- Log security events appropriately
- Implement rate limiting

## Future Enhancements

### Planned Additions
- [ ] Caching layer for offline support
- [ ] Real-time communication (WebSocket)
- [ ] Push notification handling
- [ ] Analytics integration
- [ ] Performance monitoring
- [ ] Crash reporting

### Architecture Improvements
- [ ] Modular DI system
- [ ] Plugin architecture
- [ ] Configuration hot-reloading
- [ ] Advanced error recovery
- [ ] Metrics collection

---

**Last Updated**: December 2024  
**Maintainer**: GullyCric Development Team  
**Next Review**: When core components are modified