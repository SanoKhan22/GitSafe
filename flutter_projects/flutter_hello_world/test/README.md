# Testing Documentation

> **AI Maintenance Prompt**: This documentation should be updated whenever test files are added, modified, or removed from the `test/` directory. Monitor changes to unit tests, widget tests, integration tests, test helpers, mock implementations, and testing utilities. Update this documentation to reflect new testing strategies, test coverage improvements, mock updates, testing tool changes, and test structure modifications. Keep the testing guidelines, examples, and best practices current with the actual test implementations.

## Overview

The testing suite for GullyCric follows a comprehensive testing strategy covering unit tests, widget tests, integration tests, and end-to-end tests. The testing structure mirrors the main application architecture for easy navigation and maintenance.

## Testing Architecture

```
test/
├── auth_test.dart                    # Authentication integration tests
├── features/                         # Feature-specific tests
│   ├── auth/                        # Authentication feature tests
│   │   ├── data/                    # Data layer tests
│   │   ├── domain/                  # Domain layer tests
│   │   └── presentation/            # Presentation layer tests
│   └── cricket/                     # Cricket feature tests
│       ├── data/                    # Data layer tests
│       ├── domain/                  # Domain layer tests
│       ├── presentation/            # Presentation layer tests
│       ├── helpers/                 # Test helpers and utilities
│       └── integration/             # Integration tests
├── core/                            # Core layer tests
│   ├── network/                     # Network layer tests
│   ├── utils/                       # Utility tests
│   └── widgets/                     # Core widget tests
└── integration_test/                # End-to-end tests
```

## Testing Strategy

### 1. Unit Tests
Test individual functions, methods, and classes in isolation.

**Coverage Areas**:
- Use cases and business logic
- Repository implementations
- Data models and serialization
- Utility functions
- Validation logic

**Example Structure**:
```dart
// test/features/auth/domain/usecases/login_usecase_test.dart
void main() {
  group('LoginUseCase', () {
    late LoginUseCase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = LoginUseCase(repository: mockRepository);
    });

    group('loginWithEmail', () {
      test('should return AuthResponse when login is successful', () async {
        // Arrange
        final params = LoginWithEmailParams(
          email: 'test@example.com',
          password: 'password123',
        );
        final expectedResponse = AuthResponse(
          user: mockUser,
          tokens: mockTokens,
        );
        
        when(mockRepository.loginWithEmail(params))
            .thenAnswer((_) async => Right(expectedResponse));

        // Act
        final result = await useCase.loginWithEmail(params);

        // Assert
        expect(result, Right(expectedResponse));
        verify(mockRepository.loginWithEmail(params));
      });

      test('should return AuthFailure when credentials are invalid', () async {
        // Arrange
        final params = LoginWithEmailParams(
          email: 'invalid@example.com',
          password: 'wrongpassword',
        );
        
        when(mockRepository.loginWithEmail(params))
            .thenAnswer((_) async => Left(AuthFailure('Invalid credentials')));

        // Act
        final result = await useCase.loginWithEmail(params);

        // Assert
        expect(result, Left(AuthFailure('Invalid credentials')));
      });
    });
  });
}
```

### 2. Widget Tests
Test individual widgets and their interactions.

**Coverage Areas**:
- Widget rendering
- User interactions
- State changes
- Widget composition
- Accessibility

**Example Structure**:
```dart
// test/features/auth/presentation/screens/login_screen_test.dart
void main() {
  group('LoginScreen', () {
    testWidgets('should display login form', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(),
        ),
      );

      expect(find.byType(AuthFormField), findsNWidgets(2)); // Email and password
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('should show error when login fails', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => MockAuthProvider(),
          child: MaterialApp(home: LoginScreen()),
        ),
      );

      // Enter invalid credentials
      await tester.enterText(
        find.byKey(Key('email_field')), 
        'invalid@example.com'
      );
      await tester.enterText(
        find.byKey(Key('password_field')), 
        'wrongpassword'
      );

      // Tap login button
      await tester.tap(find.byKey(Key('login_button')));
      await tester.pumpAndSettle();

      // Verify error is shown
      expect(find.text('Invalid credentials'), findsOneWidget);
    });
  });
}
```

### 3. Integration Tests
Test feature workflows and component interactions.

**Coverage Areas**:
- Complete user flows
- Feature integration
- API integration
- Navigation flows
- State management integration

**Example Structure**:
```dart
// test/features/cricket/integration/match_workflow_test.dart
void main() {
  group('Match Workflow Integration', () {
    testWidgets('should complete match creation flow', (tester) async {
      await tester.pumpWidget(MyApp());

      // Navigate to create match
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Fill match details
      await tester.enterText(
        find.byKey(Key('match_title_field')), 
        'Test Match'
      );
      await tester.tap(find.text('T20'));
      await tester.pumpAndSettle();

      // Select teams
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Team A'));
      await tester.tap(find.text('Team B'));

      // Create match
      await tester.tap(find.text('Create Match'));
      await tester.pumpAndSettle();

      // Verify match was created
      expect(find.text('Test Match'), findsOneWidget);
      expect(find.text('Scheduled'), findsOneWidget);
    });
  });
}
```

### 4. End-to-End Tests
Test complete application workflows from user perspective.

**Coverage Areas**:
- Full user journeys
- Cross-platform testing
- Performance testing
- Real device testing

## Test Helpers and Utilities

### Test Helpers (`test/features/cricket/helpers/test_helpers.dart`)

**Purpose**: Provide reusable test data and helper functions.

**Current Issues**: The test helpers file has compilation errors that need to be fixed:

```dart
// Current issues in test_helpers.dart:
// 1. Missing required parameters in entity constructors
// 2. Enum value mismatches
// 3. Outdated entity structures

// Example of what needs to be fixed:
PlayerEntity createTestPlayer({String? id, String? name}) {
  return PlayerEntity(
    id: id ?? 'player_001',
    firstName: name ?? 'Test',
    lastName: 'Player',
    // Missing required parameters:
    battingStyle: BattingStyle.rightHanded,
    bowlingStyle: BowlingStyle.rightArmMedium,
    preferredRole: PlayerRole.batsman,
    careerStats: PlayerStats.empty(),
    seasonStats: PlayerStats.empty(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}
```

### Mock Implementations

**Mock Classes**: Generated using `mockito` package.

**Current Issues**: Mock classes are outdated and need regeneration:

```bash
# Regenerate mocks
flutter packages pub run build_runner build --delete-conflicting-outputs
```

**Mock Examples**:
```dart
// Mock repository
class MockCricketRepository extends Mock implements CricketRepository {}

// Mock data source
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

// Mock providers
class MockAuthProvider extends Mock implements AuthProvider {}
```

## Testing Tools and Packages

### Core Testing Packages
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.2
  build_runner: ^2.4.7
  integration_test:
    sdk: flutter
  patrol: ^2.6.0  # For advanced integration testing
```

### Testing Utilities
- **Mockito**: Mock generation and verification
- **Build Runner**: Code generation for mocks
- **Integration Test**: Flutter's integration testing framework
- **Patrol**: Advanced integration testing with native interactions

## Current Testing Issues

### 1. Compilation Errors
The test suite currently has 1000+ compilation errors that need to be addressed:

**Main Issues**:
- Outdated entity constructors missing required parameters
- Mock classes with incorrect method signatures
- Enum value mismatches
- Import conflicts

**Priority Fixes**:
1. Update test helper entities with all required parameters
2. Regenerate mock classes
3. Fix enum references
4. Resolve import conflicts

### 2. Test Data Issues
Test helper functions need updates to match current entity structures:

```dart
// Fix required for test helpers
TeamEntity createTestTeam({String? id, String? name}) {
  return TeamEntity(
    id: id ?? 'team_001',
    name: name ?? 'Test Team',
    shortName: 'TT',
    // Add all required parameters:
    captainId: 'player_001',
    playerIds: ['player_001', 'player_002'],
    type: TeamType.friends,
    settings: TeamSettings.defaults(),
    stats: TeamStats.empty(),
    createdBy: 'user_001',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}
```

## Testing Best Practices

### 1. Test Structure
- **Arrange**: Set up test data and mocks
- **Act**: Execute the code under test
- **Assert**: Verify the expected outcome

### 2. Naming Conventions
```dart
// Good test names
test('should return success when valid credentials are provided')
test('should throw AuthException when user is not found')
test('should update UI when match score changes')

// Bad test names
test('login test')
test('test match creation')
test('check user')
```

### 3. Mock Usage
```dart
// Good mock setup
when(mockRepository.getMatches(any))
    .thenAnswer((_) async => Right([match1, match2]));

// Verify interactions
verify(mockRepository.getMatches(any)).called(1);
verifyNoMoreInteractions(mockRepository);
```

### 4. Widget Testing
```dart
// Good widget test setup
await tester.pumpWidget(
  MaterialApp(
    home: ChangeNotifierProvider(
      create: (_) => mockProvider,
      child: ScreenUnderTest(),
    ),
  ),
);

// Wait for animations and async operations
await tester.pumpAndSettle();
```

### 5. Test Data Management
```dart
// Use test helpers for consistent data
final testUser = TestHelpers.createTestUser();
final testMatch = TestHelpers.createTestMatch();

// Use builders for flexible test data
final customMatch = TestHelpers.matchBuilder()
    .withTitle('Custom Match')
    .withStatus(MatchStatus.live)
    .build();
```

## Test Coverage

### Current Coverage Goals
- **Unit Tests**: 80%+ coverage for business logic
- **Widget Tests**: 70%+ coverage for UI components
- **Integration Tests**: Cover all major user flows

### Coverage Reporting
```bash
# Generate coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# View coverage report
open coverage/html/index.html
```

## Continuous Integration

### GitHub Actions Testing
```yaml
name: Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test --coverage
      - run: flutter test integration_test/
```

### Test Automation
- Run tests on every commit
- Generate coverage reports
- Block merges if tests fail
- Run integration tests on staging

## Performance Testing

### Widget Performance
```dart
testWidgets('should render large list efficiently', (tester) async {
  final stopwatch = Stopwatch()..start();
  
  await tester.pumpWidget(
    MaterialApp(
      home: MatchListScreen(matches: generateLargeMatchList()),
    ),
  );
  
  await tester.pumpAndSettle();
  stopwatch.stop();
  
  expect(stopwatch.elapsedMilliseconds, lessThan(1000));
});
```

### Memory Testing
```dart
test('should not leak memory during match updates', () async {
  final initialMemory = ProcessInfo.currentRss;
  
  // Perform memory-intensive operations
  for (int i = 0; i < 1000; i++) {
    await matchProvider.updateScore(mockScoreUpdate);
  }
  
  // Force garbage collection
  await Future.delayed(Duration(milliseconds: 100));
  
  final finalMemory = ProcessInfo.currentRss;
  final memoryIncrease = finalMemory - initialMemory;
  
  expect(memoryIncrease, lessThan(50 * 1024 * 1024)); // Less than 50MB
});
```

## Debugging Tests

### Test Debugging Tips
```dart
// Add debug prints
test('debug test', () {
  print('Test data: $testData');
  debugPrint('Widget tree: ${tester.binding.renderViewElement}');
});

// Use debugger
test('debug with breakpoint', () {
  debugger(); // Set breakpoint here
  // Test code
});

// Pump with duration for debugging
await tester.pump(Duration(seconds: 5)); // Keep UI visible
```

### Common Test Issues
1. **Async operations not completing**: Use `pumpAndSettle()`
2. **Widget not found**: Check widget keys and text
3. **State not updating**: Verify provider setup
4. **Mock not working**: Check mock setup and verification

## Test Maintenance

### Regular Maintenance Tasks
- [ ] Update test data when entities change
- [ ] Regenerate mocks when interfaces change
- [ ] Review and update test coverage
- [ ] Clean up obsolete tests
- [ ] Update test documentation

### Refactoring Tests
```dart
// Before: Repetitive test setup
test('test 1', () {
  final repository = MockRepository();
  final useCase = UseCase(repository);
  // Test code
});

test('test 2', () {
  final repository = MockRepository();
  final useCase = UseCase(repository);
  // Test code
});

// After: Shared setup
group('UseCase Tests', () {
  late MockRepository repository;
  late UseCase useCase;
  
  setUp(() {
    repository = MockRepository();
    useCase = UseCase(repository);
  });
  
  test('test 1', () {
    // Test code
  });
  
  test('test 2', () {
    // Test code
  });
});
```

## Future Testing Enhancements

### Planned Improvements
- [ ] Visual regression testing
- [ ] Accessibility testing automation
- [ ] Performance benchmarking
- [ ] Cross-platform testing
- [ ] API contract testing
- [ ] Load testing for real-time features

### Advanced Testing Tools
- [ ] Maestro for UI testing
- [ ] Detox for end-to-end testing
- [ ] Appium for cross-platform testing
- [ ] Artillery for load testing

---

**Last Updated**: December 2024  
**Maintainer**: GullyCric Development Team  
**Next Review**: When test structure or strategy changes  
**Priority**: Fix compilation errors in test suite