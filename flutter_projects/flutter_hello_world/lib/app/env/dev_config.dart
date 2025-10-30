import 'config.dart';

/// GullyCric Development Configuration
/// 
/// Configuration for development environment with debug features enabled
/// and parameterized API keys for easy testing and development
class DevelopmentConfig implements BaseConfig {
  @override
  String get appName => 'GullyCric Dev';

  @override
  String get appVersion => '1.0.0-dev';

  @override
  String get appBuildNumber => '1';

  @override
  String get environment => 'development';

  @override
  bool get isDebug => true;

  @override
  bool get isProduction => false;

  // API Configuration - Development endpoints
  @override
  String get baseApiUrl => const String.fromEnvironment(
    'DEV_API_URL',
    defaultValue: 'https://dev-api.gullycric.com',
  );

  @override
  String get apiVersion => 'v1';

  @override
  Duration get apiTimeout => const Duration(seconds: 30);

  @override
  int get maxRetries => 3;

  // External API Keys - Parameterized for development
  @override
  String get cricketApiKey => const String.fromEnvironment(
    'CRICKET_API_KEY',
    defaultValue: 'dev_cricket_api_key_placeholder',
  );

  @override
  String get cricketApiUrl => const String.fromEnvironment(
    'CRICKET_API_URL',
    defaultValue: 'https://api.cricapi.com/v1',
  );

  @override
  String get weatherApiKey => const String.fromEnvironment(
    'WEATHER_API_KEY',
    defaultValue: 'dev_weather_api_key_placeholder',
  );

  @override
  String get weatherApiUrl => const String.fromEnvironment(
    'WEATHER_API_URL',
    defaultValue: 'https://api.openweathermap.org/data/2.5',
  );

  @override
  String get mapsApiKey => const String.fromEnvironment(
    'MAPS_API_KEY',
    defaultValue: 'dev_maps_api_key_placeholder',
  );

  @override
  String get mapsApiUrl => const String.fromEnvironment(
    'MAPS_API_URL',
    defaultValue: 'https://maps.googleapis.com/maps/api',
  );

  @override
  String get newsApiKey => const String.fromEnvironment(
    'NEWS_API_KEY',
    defaultValue: 'dev_news_api_key_placeholder',
  );

  @override
  String get newsApiUrl => const String.fromEnvironment(
    'NEWS_API_URL',
    defaultValue: 'https://newsapi.org/v2',
  );

  // Firebase Configuration - Development
  @override
  String get firebaseProjectId => const String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: 'gullycric-dev',
  );

  @override
  String get firebaseApiKey => const String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: 'dev_firebase_api_key_placeholder',
  );

  @override
  String get firebaseAppId => const String.fromEnvironment(
    'FIREBASE_APP_ID',
    defaultValue: 'dev_firebase_app_id_placeholder',
  );

  @override
  String get firebaseMessagingSenderId => const String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
    defaultValue: 'dev_firebase_sender_id_placeholder',
  );

  // Feature Flags - Development (most features enabled for testing)
  @override
  bool get enableAnalytics => true;

  @override
  bool get enableCrashReporting => true;

  @override
  bool get enablePerformanceMonitoring => true;

  @override
  bool get enablePushNotifications => true;

  @override
  bool get enableSocialFeatures => true;

  @override
  bool get enablePremiumFeatures => true; // Enable for testing

  @override
  bool get enableOfflineMode => true;

  // Cricket-specific Configuration
  @override
  int get maxPlayersPerTeam => 11;

  @override
  int get maxOversPerInnings => 50;

  @override
  Duration get liveUpdateInterval => const Duration(seconds: 10); // Faster for dev

  @override
  Duration get scoreRefreshInterval => const Duration(seconds: 5); // Faster for dev

  @override
  int get maxMatchHistory => 100;

  // Cache Configuration - Development (shorter expiration for testing)
  @override
  Duration get cacheExpiration => const Duration(minutes: 30);

  @override
  Duration get imageCacheExpiration => const Duration(hours: 2);

  @override
  int get maxCacheSize => 50; // MB

  @override
  int get maxImageCacheSize => 100; // MB

  // Network Configuration - Development (shorter timeouts)
  @override
  Duration get connectTimeout => const Duration(seconds: 10);

  @override
  Duration get receiveTimeout => const Duration(seconds: 20);

  @override
  Duration get sendTimeout => const Duration(seconds: 20);

  @override
  int get maxConcurrentRequests => 5;

  // UI Configuration
  @override
  Duration get animationDuration => const Duration(milliseconds: 250);

  @override
  Duration get splashDuration => const Duration(seconds: 1); // Shorter for dev

  @override
  bool get enableHapticFeedback => true;

  @override
  bool get enableSoundEffects => false; // Disabled for dev

  // Security Configuration - Development (relaxed for testing)
  @override
  bool get enableCertificatePinning => false;

  @override
  bool get enableBiometricAuth => false; // Disabled for easier testing

  @override
  Duration get sessionTimeout => const Duration(hours: 8); // Longer for dev

  @override
  int get maxLoginAttempts => 10; // More attempts for dev

  // Logging Configuration - Development (verbose logging)
  @override
  String get logLevel => 'DEBUG';

  @override
  bool get enableFileLogging => true;

  @override
  int get maxLogFileSize => 10; // MB

  @override
  int get maxLogFiles => 5;

  // Database Configuration - Development
  @override
  String get databaseName => 'gullycric_dev.db';

  @override
  int get databaseVersion => 1;

  @override
  bool get enableDatabaseEncryption => false; // Disabled for easier debugging

  // Notification Configuration
  @override
  bool get enableLocalNotifications => true;

  @override
  bool get enableRemoteNotifications => true;

  @override
  Duration get notificationRetention => const Duration(days: 7);

  // Social Features Configuration
  @override
  int get maxPostLength => 500;

  @override
  int get maxImageUploads => 5;

  @override
  Duration get feedRefreshInterval => const Duration(minutes: 5);

  // Premium Features Configuration
  @override
  List<String> get premiumFeatures => [
    'advanced_analytics',
    'unlimited_matches',
    'custom_themes',
    'priority_support',
    'export_data',
  ];

  @override
  Duration get trialPeriod => const Duration(days: 30);

  // Localization Configuration
  @override
  List<String> get supportedLanguages => ['en', 'ur', 'hi', 'bn'];

  @override
  String get defaultLanguage => 'en';

  // Accessibility Configuration
  @override
  bool get enableAccessibilityFeatures => true;

  @override
  double get minFontScale => 0.8;

  @override
  double get maxFontScale => 1.5;

  // Performance Configuration - Development (lower quality for faster testing)
  @override
  int get maxImageResolution => 1920; // pixels

  @override
  int get imageCompressionQuality => 80; // percentage

  @override
  bool get enableImageOptimization => true;

  // Error Handling Configuration - Development (more verbose)
  @override
  bool get enableErrorReporting => true;

  @override
  int get maxErrorReports => 100;

  @override
  Duration get errorReportingInterval => const Duration(minutes: 1);
}