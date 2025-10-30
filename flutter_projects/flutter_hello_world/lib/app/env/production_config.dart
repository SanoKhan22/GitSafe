import 'config.dart';

/// Production environment configuration
class ProductionConfig implements BaseConfig {
  @override
  String get appName => 'GullyCric';
  
  @override
  String get appVersion => '1.0.0';
  
  @override
  String get appBuildNumber => '1';
  
  @override
  String get environment => 'production';
  
  @override
  bool get isDebug => false;
  
  @override
  bool get isProduction => true;
  
  @override
  String get baseApiUrl => 'https://api.gullycric.com';
  
  @override
  String get apiVersion => 'v1';
  
  @override
  Duration get apiTimeout => const Duration(seconds: 30);
  
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
  String get firebaseProjectId => 'your_firebase_project_id';
  
  @override
  String get firebaseApiKey => 'your_firebase_api_key';
  
  @override
  String get firebaseAppId => 'your_firebase_app_id';
  
  @override
  String get firebaseMessagingSenderId => 'your_firebase_sender_id';
  
  // Feature Flags - Production settings
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
  Duration get liveUpdateInterval => const Duration(seconds: 30);
  
  @override
  Duration get scoreRefreshInterval => const Duration(seconds: 15);
  
  @override
  int get maxMatchHistory => 100;
  
  // Cache Configuration
  @override
  Duration get cacheExpiration => const Duration(hours: 24);
  
  @override
  Duration get imageCacheExpiration => const Duration(days: 7);
  
  @override
  int get maxCacheSize => 100; // MB
  
  @override
  int get maxImageCacheSize => 200; // MB
  
  // Network Configuration
  @override
  Duration get connectTimeout => const Duration(seconds: 15);
  
  @override
  Duration get receiveTimeout => const Duration(seconds: 30);
  
  @override
  Duration get sendTimeout => const Duration(seconds: 30);
  
  @override
  int get maxConcurrentRequests => 10;
  
  // UI Configuration
  @override
  Duration get animationDuration => const Duration(milliseconds: 300);
  
  @override
  Duration get splashDuration => const Duration(seconds: 2);
  
  @override
  bool get enableHapticFeedback => true;
  
  @override
  bool get enableSoundEffects => true;
  
  // Security Configuration
  @override
  bool get enableCertificatePinning => true;
  
  @override
  bool get enableBiometricAuth => true;
  
  @override
  Duration get sessionTimeout => const Duration(hours: 24);
  
  @override
  int get maxLoginAttempts => 5;
  
  // Logging Configuration
  @override
  String get logLevel => 'ERROR';
  
  @override
  bool get enableFileLogging => false;
  
  @override
  int get maxLogFileSize => 10; // MB
  
  @override
  int get maxLogFiles => 5;
  
  // Database Configuration
  @override
  String get databaseName => 'gullycric_prod.db';
  
  @override
  int get databaseVersion => 1;
  
  @override
  bool get enableDatabaseEncryption => true;
  
  // Notification Configuration
  @override
  bool get enableLocalNotifications => true;
  
  @override
  bool get enableRemoteNotifications => true;
  
  @override
  Duration get notificationRetention => const Duration(days: 30);
  
  // Social Features Configuration
  @override
  int get maxPostLength => 280;
  
  @override
  int get maxImageUploads => 4;
  
  @override
  Duration get feedRefreshInterval => const Duration(minutes: 5);
  
  // Premium Features Configuration
  @override
  List<String> get premiumFeatures => [
    'advanced_stats',
    'live_commentary',
    'video_highlights',
    'custom_notifications',
    'ad_free_experience',
  ];
  
  @override
  Duration get trialPeriod => const Duration(days: 7);
  
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
  double get maxFontScale => 2.0;
  
  // Performance Configuration
  @override
  int get maxImageResolution => 1920;
  
  @override
  int get imageCompressionQuality => 85;
  
  @override
  bool get enableImageOptimization => true;
  
  // Error Handling Configuration
  @override
  bool get enableErrorReporting => true;
  
  @override
  int get maxErrorReports => 100;
  
  @override
  Duration get errorReportingInterval => const Duration(minutes: 5);
}