import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_strings.dart';
import '../core/utils/logger.dart';
import 'auth_router.dart';

/// GullyCric Main Application Widget
/// 
/// Root MaterialApp configuration with themes, routing, and startup logic
/// Integrates Riverpod for state management and dependency injection
class GullyCricApp extends ConsumerWidget {
  const GullyCricApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch theme mode provider (will be implemented later)
    // final themeMode = ref.watch(themeModeProvider);
    
    // For now, use system theme mode
    final themeMode = ThemeMode.system;

    Logger.i('Building GullyCric app with theme mode: $themeMode', tag: 'App');

    return MaterialApp.router(
      // App Information
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,

      // Theme Configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // Routing Configuration
      routerConfig: AuthRouter.createRouter(ref),

      // Localization Configuration (will be implemented later)
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      // supportedLocales: AppLocalizations.supportedLocales,

      // Builder for global configurations
      builder: (context, child) {
        return _AppBuilder(child: child);
      },
    );
  }
}

/// App builder wrapper for global configurations
class _AppBuilder extends StatelessWidget {
  final Widget? child;

  const _AppBuilder({this.child});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      // Ensure text scaling doesn't break the UI
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(
          MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.2),
        ),
      ),
      child: child ?? const SizedBox.shrink(),
    );
  }
}

/// App initialization and startup logic
class AppInitializer {
  AppInitializer._();

  /// Initialize the application
  static Future<void> initialize() async {
    Logger.i('Initializing GullyCric application', tag: 'AppInit');

    try {
      // Initialize core services
      await _initializeCoreServices();

      // Initialize external services
      await _initializeExternalServices();

      // Initialize app-specific services
      await _initializeAppServices();

      Logger.i('GullyCric application initialized successfully', tag: 'AppInit');
    } catch (e, stackTrace) {
      Logger.e(
        'Failed to initialize GullyCric application',
        tag: 'AppInit',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Initialize core services
  static Future<void> _initializeCoreServices() async {
    Logger.d('Initializing core services', tag: 'AppInit');

    // Initialize dependency injection
    // This was already done in main.dart, but we can add more here if needed

    Logger.d('Core services initialized', tag: 'AppInit');
  }

  /// Initialize external services with parameterized API keys
  static Future<void> _initializeExternalServices() async {
    Logger.d('Initializing external services', tag: 'AppInit');

    // TODO: Initialize with actual API keys when available
    // For now, we'll use placeholder keys that can be replaced later
    
    // Cricket API configuration
    const cricketApiKey = String.fromEnvironment(
      'CRICKET_API_KEY',
      defaultValue: 'your_cricket_api_key_here',
    );

    // Weather API configuration
    const weatherApiKey = String.fromEnvironment(
      'WEATHER_API_KEY',
      defaultValue: 'your_weather_api_key_here',
    );

    // Maps API configuration
    const mapsApiKey = String.fromEnvironment(
      'MAPS_API_KEY',
      defaultValue: 'your_maps_api_key_here',
    );

    // News API configuration
    const newsApiKey = String.fromEnvironment(
      'NEWS_API_KEY',
      defaultValue: 'your_news_api_key_here',
    );

    // Configure API keys (these will be injected later)
    _configureApiKeys(
      cricketApiKey: cricketApiKey,
      weatherApiKey: weatherApiKey,
      mapsApiKey: mapsApiKey,
      newsApiKey: newsApiKey,
    );

    Logger.d('External services initialized with parameterized API keys', tag: 'AppInit');
  }

  /// Configure API keys for external services
  static void _configureApiKeys({
    required String cricketApiKey,
    required String weatherApiKey,
    required String mapsApiKey,
    required String newsApiKey,
  }) {
    Logger.d('Configuring API keys for external services', tag: 'AppInit');

    // Import dependency injection here to avoid circular imports
    // We'll configure this when DI is properly set up
    
    // Log which keys are configured (without exposing actual keys)
    Logger.d('Cricket API key: ${cricketApiKey.isNotEmpty ? "configured" : "missing"}', tag: 'AppInit');
    Logger.d('Weather API key: ${weatherApiKey.isNotEmpty ? "configured" : "missing"}', tag: 'AppInit');
    Logger.d('Maps API key: ${mapsApiKey.isNotEmpty ? "configured" : "missing"}', tag: 'AppInit');
    Logger.d('News API key: ${newsApiKey.isNotEmpty ? "configured" : "missing"}', tag: 'AppInit');
  }

  /// Initialize app-specific services
  static Future<void> _initializeAppServices() async {
    Logger.d('Initializing app-specific services', tag: 'AppInit');

    // TODO: Initialize services like:
    // - Local database (Hive/Drift)
    // - Notification service
    // - Analytics service
    // - Crash reporting
    // - Background sync

    Logger.d('App-specific services initialized', tag: 'AppInit');
  }

  /// Configure API keys at runtime (for when you get real keys)
  static void configureRuntimeApiKeys({
    String? cricketApiKey,
    String? weatherApiKey,
    String? mapsApiKey,
    String? newsApiKey,
  }) {
    Logger.i('Configuring runtime API keys', tag: 'AppInit');

    _configureApiKeys(
      cricketApiKey: cricketApiKey ?? 'your_cricket_api_key_here',
      weatherApiKey: weatherApiKey ?? 'your_weather_api_key_here',
      mapsApiKey: mapsApiKey ?? 'your_maps_api_key_here',
      newsApiKey: newsApiKey ?? 'your_news_api_key_here',
    );
  }
}

/// App configuration constants
class AppConfig {
  AppConfig._();

  // App Information
  static const String appName = AppStrings.appName;
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // API Configuration
  static const String apiVersion = 'v1';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;

  // UI Configuration
  static const Duration animationDuration = Duration(milliseconds: 250);
  static const Duration splashDuration = Duration(seconds: 2);
  static const int maxImageCacheSize = 100;

  // Feature Flags
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enablePerformanceMonitoring = true;
  static const bool enableDebugMode = true; // Will be false in production

  // Cricket-specific Configuration
  static const int maxPlayersPerTeam = 11;
  static const int maxOversPerInnings = 50;
  static const Duration liveUpdateInterval = Duration(seconds: 30);
  static const Duration scoreRefreshInterval = Duration(seconds: 10);

  // Cache Configuration
  static const Duration cacheExpiration = Duration(hours: 1);
  static const Duration imageCacheExpiration = Duration(days: 7);
  static const int maxCacheSize = 50; // MB

  // Network Configuration
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Environment Detection
  static bool get isDebug {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  static bool get isRelease => !isDebug;

  static bool get isProduction {
    return const String.fromEnvironment('ENVIRONMENT') == 'production';
  }

  static bool get isDevelopment {
    return const String.fromEnvironment('ENVIRONMENT') == 'development';
  }

  static bool get isStaging {
    return const String.fromEnvironment('ENVIRONMENT') == 'staging';
  }

  // Get current environment
  static String get currentEnvironment {
    if (isProduction) return 'production';
    if (isStaging) return 'staging';
    return 'development';
  }
}

/// Global app state and utilities
class AppGlobals {
  AppGlobals._();

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = 
      GlobalKey<ScaffoldMessengerState>();

  /// Get current context
  static BuildContext? get currentContext => navigatorKey.currentContext;

  /// Show global snackbar
  static void showSnackBar(String message, {Duration? duration}) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }

  /// Show global error snackbar
  static void showErrorSnackBar(String message) {
    final context = currentContext;
    if (context != null) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  /// Show global success snackbar
  static void showSuccessSnackBar(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}