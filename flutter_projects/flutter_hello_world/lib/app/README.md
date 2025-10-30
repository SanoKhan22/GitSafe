# App Layer Documentation

> **AI Maintenance Prompt**: This documentation should be updated whenever files in the `lib/app/` directory are modified. Monitor changes to app configuration, routing setup, navigation components, environment configurations, and global app state management. Update this documentation to reflect new routes, navigation patterns, environment settings, app initialization changes, and global configuration modifications. Keep the routing diagrams, navigation flows, and configuration examples current with the actual implementation.

## Overview

The App layer handles application-level configuration, routing, navigation, and global state management. It serves as the entry point and orchestrates the overall application structure.

## Architecture

```
lib/app/
├── env/                     # Environment configurations
├── navigation/              # Navigation components and guards
├── app.dart                 # Main app widget
├── auth_router.dart         # Authentication-specific routing
├── router.dart              # Main router configuration
└── routes.dart              # Route constants and definitions
```

## Components

### 1. Environment Configuration (`env/`)

#### Config (`env/config.dart`)
Base configuration interface and environment detection.

**Features**:
- Environment detection (dev, staging, production)
- Configuration interface definition
- Environment-specific settings loading

**Usage**:
```dart
abstract class Config {
  String get apiBaseUrl;
  bool get enableLogging;
  bool get enableMockData;
  Duration get apiTimeout;
}

// Get current environment config
final config = Config.instance;
```

#### Development Config (`env/dev_config.dart`)
Development environment configuration.

**Settings**:
- Debug mode enabled
- Verbose logging
- Mock data enabled
- Extended timeouts
- Development API endpoints

```dart
class DevConfig implements Config {
  @override
  String get apiBaseUrl => 'https://dev-api.gullycric.com';
  
  @override
  bool get enableLogging => true;
  
  @override
  bool get enableMockData => true;
  
  @override
  Duration get apiTimeout => Duration(seconds: 30);
}
```

#### Staging Config (`env/staging_config.dart`)
Staging environment configuration.

**Settings**:
- Limited debug features
- Moderate logging
- Real API with test data
- Production-like timeouts
- Staging API endpoints

#### Production Config (`env/production_config.dart`)
Production environment configuration.

**Settings**:
- Debug mode disabled
- Error-only logging
- Real API and data
- Optimized timeouts
- Production API endpoints

### 2. Navigation (`navigation/`)

#### Route Guards (`navigation/route_guards.dart`)
Authentication and authorization guards for routes.

**Guards**:

##### AuthGuard
Protects routes that require authentication.

```dart
class AuthGuard {
  static bool canActivate(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    return authProvider.isAuthenticated;
  }
  
  static Widget redirectTo(BuildContext context) {
    return LoginScreen();
  }
}
```

##### AdminGuard
Protects admin-only routes.

```dart
class AdminGuard {
  static bool canActivate(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    return authProvider.isAuthenticated && 
           authProvider.currentUser?.role == UserRole.admin;
  }
}
```

#### Bottom Navigation (`navigation/bottom_navigation.dart`)
Main app navigation bar component.

**Features**:
- Tab-based navigation
- Badge notifications
- Dynamic tab visibility
- Accessibility support

**Tabs**:
- Home: Dashboard and overview
- Matches: Match listing and management
- Teams: Team management
- Profile: User profile and settings

```dart
class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_cricket),
          label: 'Matches',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Teams',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
```

### 3. Routing Configuration

#### Routes (`routes.dart`)
Route constants and path definitions.

**Route Constants**:
```dart
class AppRoutes {
  // Authentication routes
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  
  // Main app routes
  static const String home = '/';
  static const String matches = '/matches';
  static const String matchDetails = '/matches/:id';
  static const String createMatch = '/matches/create';
  static const String scoreUpdate = '/matches/:id/score';
  
  // Team routes
  static const String teams = '/teams';
  static const String teamDetails = '/teams/:id';
  static const String createTeam = '/teams/create';
  
  // Profile routes
  static const String profile = '/profile';
  static const String settings = '/settings';
  
  // Admin routes
  static const String admin = '/admin';
  static const String adminUsers = '/admin/users';
}
```

#### Router (`router.dart`)
Main router configuration using GoRouter.

**Features**:
- Declarative routing
- Route guards
- Deep linking support
- Navigation state management
- Error handling

```dart
final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  redirect: (context, state) {
    final authProvider = context.read<AuthProvider>();
    
    // Redirect to login if not authenticated
    if (!authProvider.isAuthenticated && 
        !_isPublicRoute(state.location)) {
      return AppRoutes.login;
    }
    
    return null;
  },
  routes: [
    // Authentication routes
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => LoginScreen(),
    ),
    
    // Main app routes with shell
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.matches,
          builder: (context, state) => MatchesScreen(),
        ),
        GoRoute(
          path: AppRoutes.matchDetails,
          builder: (context, state) {
            final matchId = state.params['id']!;
            return MatchDetailsScreen(matchId: matchId);
          },
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => ErrorScreen(
    error: state.error.toString(),
  ),
);
```

#### Auth Router (`auth_router.dart`)
Authentication-specific routing logic.

**Features**:
- Authentication flow management
- Onboarding navigation
- Password reset flows
- Social login redirects

### 4. Main App Widget (`app.dart`)

#### MyApp
Root application widget that configures the entire app.

**Features**:
- Theme configuration
- Localization setup
- Provider initialization
- Router configuration
- Global error handling

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CricketProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'GullyCric',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: appRouter,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en', 'US'),
              Locale('hi', 'IN'),
            ],
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
```

## Navigation Patterns

### 1. Tab Navigation
Main app uses bottom tab navigation for primary sections.

```dart
// Navigate to different tabs
void _onTabTapped(int index) {
  switch (index) {
    case 0:
      context.go(AppRoutes.home);
      break;
    case 1:
      context.go(AppRoutes.matches);
      break;
    case 2:
      context.go(AppRoutes.teams);
      break;
    case 3:
      context.go(AppRoutes.profile);
      break;
  }
}
```

### 2. Stack Navigation
Detailed views use stack navigation for drill-down experiences.

```dart
// Navigate to match details
void _viewMatchDetails(String matchId) {
  context.push('${AppRoutes.matches}/$matchId');
}

// Navigate back
void _goBack() {
  context.pop();
}
```

### 3. Modal Navigation
Forms and dialogs use modal navigation.

```dart
// Show modal bottom sheet
void _showCreateMatchModal() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => CreateMatchSheet(),
  );
}

// Show full screen modal
void _showFullScreenModal() {
  Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => CreateMatchScreen(),
    ),
  );
}
```

## Route Guards Implementation

### Authentication Guard
```dart
class AuthGuard {
  static String? redirect(BuildContext context, GoRouterState state) {
    final authProvider = context.read<AuthProvider>();
    
    if (!authProvider.isAuthenticated) {
      // Save intended destination
      final intended = state.location;
      return '${AppRoutes.login}?redirect=$intended';
    }
    
    return null;
  }
}
```

### Role-based Guards
```dart
class RoleGuard {
  static String? requireRole(
    BuildContext context, 
    GoRouterState state, 
    UserRole requiredRole,
  ) {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;
    
    if (user == null || !user.hasRole(requiredRole)) {
      return AppRoutes.unauthorized;
    }
    
    return null;
  }
}
```

## Deep Linking

### URL Structure
```
gullycric://
├── /                        # Home
├── /matches                 # Match list
├── /matches/123             # Match details
├── /matches/123/score       # Live scoring
├── /teams/456               # Team details
├── /profile                 # User profile
└── /admin                   # Admin panel
```

### Deep Link Handling
```dart
// Handle incoming deep links
void _handleDeepLink(String link) {
  final uri = Uri.parse(link);
  
  switch (uri.pathSegments.first) {
    case 'matches':
      if (uri.pathSegments.length > 1) {
        final matchId = uri.pathSegments[1];
        context.push('${AppRoutes.matches}/$matchId');
      } else {
        context.go(AppRoutes.matches);
      }
      break;
    case 'teams':
      // Handle team deep links
      break;
    default:
      context.go(AppRoutes.home);
  }
}
```

## State Management Integration

### Global State Providers
```dart
// App-level providers
MultiProvider(
  providers: [
    // Authentication state
    ChangeNotifierProvider(
      create: (_) => AuthProvider()..checkAuthStatus(),
    ),
    
    // App configuration
    Provider(
      create: (_) => AppConfig.instance,
    ),
    
    // Theme management
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
    ),
    
    // Connectivity
    StreamProvider(
      create: (_) => ConnectivityService().connectionStream,
      initialData: ConnectivityResult.none,
    ),
  ],
  child: MyApp(),
)
```

### Route-specific State
```dart
// Provide state for specific route trees
ShellRoute(
  builder: (context, state, child) {
    return ChangeNotifierProvider(
      create: (_) => CricketProvider(),
      child: CricketShell(child: child),
    );
  },
  routes: [
    // Cricket-related routes
  ],
)
```

## Error Handling

### Global Error Handling
```dart
class AppErrorHandler {
  static void handleError(Object error, StackTrace stackTrace) {
    // Log error
    Logger.error('App error', error: error, stackTrace: stackTrace);
    
    // Report to crash analytics
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
    
    // Show user-friendly message
    if (error is NetworkException) {
      _showNetworkError();
    } else if (error is AuthException) {
      _showAuthError();
    } else {
      _showGenericError();
    }
  }
}
```

### Route Error Handling
```dart
// Custom error page for routing errors
class RouteErrorScreen extends StatelessWidget {
  final String error;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64),
            SizedBox(height: 16),
            Text('The page you requested could not be found.'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Performance Considerations

### Route Optimization
- Lazy loading of screens
- Route-based code splitting
- Preloading critical routes
- Efficient state management

### Navigation Performance
```dart
// Efficient navigation with minimal rebuilds
class OptimizedNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        // Only rebuild when auth state changes
        if (!auth.isAuthenticated) {
          return LoginScreen();
        }
        
        return child!; // Reuse child widget
      },
      child: MainAppShell(), // This won't rebuild
    );
  }
}
```

## Testing Strategy

### Router Testing
```dart
void main() {
  group('App Router', () {
    testWidgets('should navigate to login when not authenticated', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProviderOverride(MockAuthProvider(isAuthenticated: false)),
          ],
          child: MaterialApp.router(routerConfig: appRouter),
        ),
      );
      
      expect(find.byType(LoginScreen), findsOneWidget);
    });
    
    testWidgets('should navigate to home when authenticated', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProviderOverride(MockAuthProvider(isAuthenticated: true)),
          ],
          child: MaterialApp.router(routerConfig: appRouter),
        ),
      );
      
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
```

### Navigation Testing
```dart
void main() {
  group('Navigation', () {
    testWidgets('should navigate between tabs', (tester) async {
      await tester.pumpWidget(MyApp());
      
      // Tap matches tab
      await tester.tap(find.text('Matches'));
      await tester.pumpAndSettle();
      
      expect(find.byType(MatchesScreen), findsOneWidget);
    });
  });
}
```

## Security Considerations

### Route Security
- Authentication guards on protected routes
- Role-based access control
- Secure parameter passing
- Input validation on route parameters

### Deep Link Security
```dart
class DeepLinkValidator {
  static bool isValidLink(String link) {
    final uri = Uri.tryParse(link);
    if (uri == null) return false;
    
    // Validate scheme
    if (uri.scheme != 'gullycric' && uri.scheme != 'https') {
      return false;
    }
    
    // Validate host for HTTPS links
    if (uri.scheme == 'https' && uri.host != 'gullycric.com') {
      return false;
    }
    
    return true;
  }
}
```

## Future Enhancements

### Planned Features
- [ ] Advanced route animations
- [ ] Route-based analytics
- [ ] A/B testing integration
- [ ] Progressive web app support
- [ ] Multi-window support (desktop)
- [ ] Voice navigation
- [ ] Gesture-based navigation

### Technical Improvements
- [ ] Route preloading strategies
- [ ] Advanced state persistence
- [ ] Route-based code splitting
- [ ] Navigation performance monitoring
- [ ] Accessibility improvements

---

**Last Updated**: December 2024  
**Maintainer**: GullyCric Development Team  
**Next Review**: When app configuration or routing is modified