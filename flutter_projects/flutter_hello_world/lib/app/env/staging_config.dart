import 'config.dart';

/// Staging environment configuration
class StagingConfig implements BaseConfig {
  @override
  String get appName => 'GullyCric (Staging)';
  
  @override
  String get appVersion => '1.0.0-staging';
  
  @override
  String get appBuildNumber => '1';
  
  @override
  String get environment => 'staging';
  
  @override
  bool get isDebug => false;
  
  @override
  bool get isProduction => false;
  
  @override
  String get baseApiUrl => 'https://staging-api.gullycric.com';
  
  @override
  String get apiVersion => 'v1';
  
  @override
  Duration get apiTimeout => const Duration(seconds: 45);
  
  @override
  int get maxRetries => 3;
  
  // External API Keys (to be injected)
  @override
  String get cricketApiKey => 'your_cricket_api_key_here';
  
  @override
  String get cricketApiUrl => 'https://api.cricapi.com/v1';
  
  @override
  String get weatherApiKey => 'your_weather_api_key_here';
  
  @override
  String get weatherApiUrl => 'https://api.openweathermap.org/data/2.5';
  
  @override
  String get mapsApiKey => 'your_maps_api_key_here';
  
  @override
  String get mapsApiUrl => 'https://maps.googleapis.com/maps/api';
  
  @override
  String get newsApiKey => 'your_news_api_key_here';
  
  @override
  String get newsApiUrl => 'https://newsapi.org/v2';
  
  // Firebase Configuration (to be injected)
  @override
  String get firebaseProjectId => 'your_firebase_project_id_staging';
  
  @override
  String get firebaseApiKey => 'your_firebase_api_key_staging';
  
  @override
  String get firebaseAppId => 'your_firebase_app_id_staging';
  
  @override
  String get firebaseMessagingSenderId => 'your_firebase_sender_id_staging';
  
  // Feature Flags - Staging settings (more permissive for testing)
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
  bool get enablePremiumFeatures => true;
  
  @override
  bool get enableOfflineMode => true;
  
  // Cricket-specific Configuration
  @override
  int get maxPlayersPerTeam => 11;
  
  @override
  int get maxOversPerInnings => 50;
  
  @override
  Duration get liveUpdateInterval => const Duration(seconds: 15); // Faster for testing
  
  @override
  Duration get scoreRefreshInterval => const Duration(seconds: 10); // Faster for testing
  
  @override
  int get maxMatchHistory => 50;
  
  // Cache Configuration
  @override
  Duration get cacheExpiration => const Duration(hours: 12);
  
  @override
  Duration get imageCacheExpiration => const Duration(days: 3);
  
  @override
  int get maxCacheSize => 50; // MB
  
  @override
  int get maxImageCacheSize => 100; // MB
  
  // Network Configuration
  @override
  Duration get connectTimeout => const Duration(seconds: 20);
  
  @override
  Duration get receiveTimeout => const Duration(seconds: 45);
  
  @override
  Duration get sendTimeout => const Duration(seconds: 45);
  
  @override
  int get maxConcurrentRequests => 8;
  
  // UI Configuration
  @override
  Duration get animationDuration => const Duration(milliseconds: 300);
  
  @override
  Duration get splashDuration => const Duration(seconds: 1);
  
  @override
  bool get enableHapticFeedback => true;
  
  @override
  bool get enableSoundEffects => true;
  
  // Security Configuration
  @override
  bool get enableCertificatePinning => false; // Disabled for staging
  
  @override
  bool get enableBiometricAuth => true;
  
  @override
  Duration get sessionTimeout => const Duration(hours: 12);
  
  @override
  int get maxLoginAttempts => 10; // More lenient for testing
  
  // Logging Configuration
  @override
  String get logLevel => 'INFO';
  
  @override
  bool get enableFileLogging => true;
  
  @override
  int get maxLogFileSize => 20; // MB
  
  @override
  int get maxLogFiles => 10;
  
  // Database Configuration
  @override
  String get databaseName => 'gullycric_staging.db';
  
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
  Duration get notificationRetention => const Duration(days: 14);
  
  // Social Features Configuration
  @override
  int get maxPostLength => 500; // More lenient for testing
  
  @override
  int get maxImageUploads => 6;
  
  @override
  Duration get feedRefreshInterval => const Duration(minutes: 2);
  
  // Premium Features Configuration
  @override
  List<String> get premiumFeatures => [
    'advanced_stats',
    'live_commentary',
    'video_highlights',
    'custom_notifications',
    'ad_free_experience',
    'beta_features', // Extra for staging
  ];
  
  @override
  Duration get trialPeriod => const Duration(days: 14); // Longer for testing
  
  // Localization Configuration
  @override
  List<String> get supportedLanguages => ['en', 'hi', 'ta', 'te', 'bn'];
  
  @override
  String get defaultLanguage => 'en';
  
  // Accessibility Configuration
  @override
  bool get enableAccessibilityFeatures => true;
  
  @override
  double get minFontScale => 0.8;
  
  @override
  double get maxFontScale => 2.5;
  
  // Performance Configuration
  @override
  int get maxImageResolution => 1920;
  
  @override
  int get imageCompressionQuality => 80;
  
  @override
  bool get enableImageOptimization => true;
  
  // Error Handling Configuration
  @override
  bool get enableErrorReporting => true;
  
  @override
  int get maxErrorReports => 200;
  
  @override
  Duration get errorReportingInterval => const Duration(minutes: 2);
}