import '../app/env/config.dart';
import 'flavor_config.dart';

/// GullyCric Application Configuration
/// 
/// Centralized configuration management that combines flavor-specific
/// settings with environment configurations
class AppConfig {
  static AppConfig? _instance;
  static BaseConfig? _envConfig;

  AppConfig._();

  /// Get singleton instance
  static AppConfig get instance {
    _instance ??= AppConfig._();
    return _instance!;
  }

  /// Initialize app configuration
  static void initialize({
    required Flavor flavor,
    required BaseConfig envConfig,
    Map<String, dynamic>? variables,
  }) {
    // Initialize flavor configuration
    FlavorConfig.initialize(
      flavor: flavor,
      name: _getFlavorName(flavor),
      variables: variables,
    );

    // Set environment configuration
    _envConfig = envConfig;

    // Print configuration summary in debug mode
    if (FlavorConfig.isDebug) {
      FlavorConfig.printConfigSummary();
      _printEnvConfigSummary();
    }
  }

  /// Get environment configuration
  static BaseConfig get envConfig {
    assert(_envConfig != null, 'AppConfig must be initialized first');
    return _envConfig!;
  }

  /// Get flavor name from enum
  static String _getFlavorName(Flavor flavor) {
    switch (flavor) {
      case Flavor.development:
        return 'development';
      case Flavor.staging:
        return 'staging';
      case Flavor.production:
        return 'production';
    }
  }

  /// Print environment configuration summary
  static void _printEnvConfigSummary() {
    print('=== Environment Configuration ===');
    print('App Name: ${envConfig.appName}');
    print('App Version: ${envConfig.appVersion}');
    print('Environment: ${envConfig.environment}');
    print('Base API URL: ${envConfig.baseApiUrl}');
    print('API Version: ${envConfig.apiVersion}');
    print('Enable Analytics: ${envConfig.enableAnalytics}');
    print('Enable Crash Reporting: ${envConfig.enableCrashReporting}');
    print('Enable Push Notifications: ${envConfig.enablePushNotifications}');
    print('================================');
  }

  // App Information
  String get appName => FlavorConfig.getAppName(envConfig.appName);
  String get appVersion => envConfig.appVersion;
  String get appBuildNumber => envConfig.appBuildNumber;
  String get bundleId => FlavorConfig.getBundleId('com.gullycric.app');

  // Environment
  String get environment => envConfig.environment;
  Flavor get flavor => FlavorConfig.currentFlavor;
  bool get isDebug => FlavorConfig.isDebug;
  bool get isProduction => FlavorConfig.isProduction;
  bool get isDevelopment => FlavorConfig.isDevelopment;
  bool get isStaging => FlavorConfig.isStaging;

  // API Configuration
  String get baseApiUrl => FlavorConfig.getApiBaseUrl();
  String get apiVersion => envConfig.apiVersion;
  Duration get apiTimeout => envConfig.apiTimeout;
  int get maxRetries => envConfig.maxRetries;

  // External API Keys
  String get cricketApiKey => envConfig.cricketApiKey;
  String get cricketApiUrl => envConfig.cricketApiUrl;
  String get weatherApiKey => envConfig.weatherApiKey;
  String get weatherApiUrl => envConfig.weatherApiUrl;
  String get mapsApiKey => envConfig.mapsApiKey;
  String get mapsApiUrl => envConfig.mapsApiUrl;
  String get newsApiKey => envConfig.newsApiKey;
  String get newsApiUrl => envConfig.newsApiUrl;

  // Firebase Configuration
  String get firebaseProjectId => envConfig.firebaseProjectId;
  String get firebaseApiKey => envConfig.firebaseApiKey;
  String get firebaseAppId => envConfig.firebaseAppId;
  String get firebaseMessagingSenderId => envConfig.firebaseMessagingSenderId;

  // Feature Flags (combined from env and flavor)
  bool get enableAnalytics => envConfig.enableAnalytics && FlavorConfig.getAnalyticsEnabled();
  bool get enableCrashReporting => envConfig.enableCrashReporting && FlavorConfig.getCrashReportingEnabled();
  bool get enablePerformanceMonitoring => envConfig.enablePerformanceMonitoring && FlavorConfig.getPerformanceMonitoringEnabled();
  bool get enablePushNotifications => envConfig.enablePushNotifications;
  bool get enableSocialFeatures => envConfig.enableSocialFeatures;
  bool get enablePremiumFeatures => envConfig.enablePremiumFeatures;
  bool get enableOfflineMode => envConfig.enableOfflineMode;

  // Flavor-specific feature flags
  bool get enableDebugMode => FlavorConfig.getFeatureFlags()['enableDebugMode'] ?? false;
  bool get enableTestFeatures => FlavorConfig.getFeatureFlags()['enableTestFeatures'] ?? false;
  bool get enableMockData => FlavorConfig.getFeatureFlags()['enableMockData'] ?? false;

  // Cricket-specific Configuration
  int get maxPlayersPerTeam => FlavorConfig.getCricketConfig()['maxPlayersPerTeam'] ?? envConfig.maxPlayersPerTeam;
  int get maxOversPerInnings => FlavorConfig.getCricketConfig()['maxOversPerInnings'] ?? envConfig.maxOversPerInnings;
  Duration get liveUpdateInterval => FlavorConfig.getCricketConfig()['liveUpdateInterval'] ?? envConfig.liveUpdateInterval;
  Duration get scoreRefreshInterval => FlavorConfig.getCricketConfig()['scoreRefreshInterval'] ?? envConfig.scoreRefreshInterval;
  int get maxMatchHistory => FlavorConfig.getCricketConfig()['maxMatchHistory'] ?? envConfig.maxMatchHistory;

  // Cache Configuration
  Duration get cacheExpiration => FlavorConfig.getCacheConfig()['cacheExpiration'] ?? envConfig.cacheExpiration;
  Duration get imageCacheExpiration => FlavorConfig.getCacheConfig()['imageCacheExpiration'] ?? envConfig.imageCacheExpiration;
  int get maxCacheSize => FlavorConfig.getCacheConfig()['maxCacheSize'] ?? envConfig.maxCacheSize;
  int get maxImageCacheSize => FlavorConfig.getCacheConfig()['maxImageCacheSize'] ?? envConfig.maxImageCacheSize;

  // Network Configuration
  Duration get connectTimeout => FlavorConfig.getTimeoutConfig()['connectTimeout'] ?? envConfig.connectTimeout;
  Duration get receiveTimeout => FlavorConfig.getTimeoutConfig()['receiveTimeout'] ?? envConfig.receiveTimeout;
  Duration get sendTimeout => FlavorConfig.getTimeoutConfig()['sendTimeout'] ?? envConfig.sendTimeout;
  int get maxConcurrentRequests => envConfig.maxConcurrentRequests;

  // UI Configuration
  Duration get animationDuration => envConfig.animationDuration;
  Duration get splashDuration => envConfig.splashDuration;
  bool get enableHapticFeedback => envConfig.enableHapticFeedback;
  bool get enableSoundEffects => envConfig.enableSoundEffects;

  // Security Configuration
  bool get enableCertificatePinning => FlavorConfig.getSecurityConfig()['enableCertificatePinning'] ?? envConfig.enableCertificatePinning;
  bool get enableBiometricAuth => FlavorConfig.getSecurityConfig()['enableBiometricAuth'] ?? envConfig.enableBiometricAuth;
  Duration get sessionTimeout => FlavorConfig.getSecurityConfig()['sessionTimeout'] ?? envConfig.sessionTimeout;
  int get maxLoginAttempts => FlavorConfig.getSecurityConfig()['maxLoginAttempts'] ?? envConfig.maxLoginAttempts;

  // Logging Configuration
  String get logLevel => FlavorConfig.getLogLevel();
  bool get enableFileLogging => envConfig.enableFileLogging;
  int get maxLogFileSize => envConfig.maxLogFileSize;
  int get maxLogFiles => envConfig.maxLogFiles;

  // Database Configuration
  String get databaseName => FlavorConfig.getDatabaseName('gullycric');
  int get databaseVersion => envConfig.databaseVersion;
  bool get enableDatabaseEncryption => FlavorConfig.getSecurityConfig()['enableDatabaseEncryption'] ?? envConfig.enableDatabaseEncryption;

  // Notification Configuration
  bool get enableLocalNotifications => FlavorConfig.getNotificationConfig()['enableLocalNotifications'] ?? envConfig.enableLocalNotifications;
  bool get enableRemoteNotifications => FlavorConfig.getNotificationConfig()['enableRemoteNotifications'] ?? envConfig.enableRemoteNotifications;
  Duration get notificationRetention => FlavorConfig.getNotificationConfig()['notificationRetention'] ?? envConfig.notificationRetention;

  // Social Features Configuration
  int get maxPostLength => envConfig.maxPostLength;
  int get maxImageUploads => envConfig.maxImageUploads;
  Duration get feedRefreshInterval => envConfig.feedRefreshInterval;

  // Premium Features Configuration
  List<String> get premiumFeatures => envConfig.premiumFeatures;
  Duration get trialPeriod => envConfig.trialPeriod;

  // Localization Configuration
  List<String> get supportedLanguages => FlavorConfig.getLocalizationConfig()['supportedLanguages'] ?? envConfig.supportedLanguages;
  String get defaultLanguage => FlavorConfig.getLocalizationConfig()['defaultLanguage'] ?? envConfig.defaultLanguage;

  // Accessibility Configuration
  bool get enableAccessibilityFeatures => envConfig.enableAccessibilityFeatures;
  double get minFontScale => envConfig.minFontScale;
  double get maxFontScale => envConfig.maxFontScale;

  // Performance Configuration
  int get maxImageResolution => envConfig.maxImageResolution;
  int get imageCompressionQuality => envConfig.imageCompressionQuality;
  bool get enableImageOptimization => envConfig.enableImageOptimization;

  // Error Handling Configuration
  bool get enableErrorReporting => envConfig.enableErrorReporting;
  int get maxErrorReports => envConfig.maxErrorReports;
  Duration get errorReportingInterval => envConfig.errorReportingInterval;

  // Utility Methods

  /// Check if a feature is enabled
  bool isFeatureEnabled(String featureName) {
    final featureFlags = FlavorConfig.getFeatureFlags();
    return featureFlags[featureName] ?? false;
  }

  /// Get a custom variable from flavor configuration
  T? getCustomVariable<T>(String key) {
    return FlavorConfig.getVariable<T>(key);
  }

  /// Get API endpoint with base URL
  String getApiEndpoint(String endpoint) {
    return '$baseApiUrl/$apiVersion/$endpoint';
  }

  /// Get full API URL
  String getFullApiUrl(String path) {
    return '$baseApiUrl$path';
  }

  /// Check if API key is configured
  bool isApiKeyConfigured(String apiType) {
    switch (apiType.toLowerCase()) {
      case 'cricket':
        return cricketApiKey.isNotEmpty && !cricketApiKey.contains('your_');
      case 'weather':
        return weatherApiKey.isNotEmpty && !weatherApiKey.contains('your_');
      case 'maps':
        return mapsApiKey.isNotEmpty && !mapsApiKey.contains('your_');
      case 'news':
        return newsApiKey.isNotEmpty && !newsApiKey.contains('your_');
      case 'firebase':
        return firebaseProjectId.isNotEmpty && !firebaseProjectId.contains('your_');
      default:
        return false;
    }
  }

  /// Get configuration summary for debugging
  Map<String, dynamic> getConfigSummary() {
    return {
      'app': {
        'name': appName,
        'version': appVersion,
        'buildNumber': appBuildNumber,
        'bundleId': bundleId,
      },
      'environment': {
        'name': environment,
        'flavor': flavor.toString(),
        'isDebug': isDebug,
        'isProduction': isProduction,
      },
      'api': {
        'baseUrl': baseApiUrl,
        'version': apiVersion,
        'timeout': apiTimeout.inSeconds,
        'maxRetries': maxRetries,
      },
      'features': {
        'analytics': enableAnalytics,
        'crashReporting': enableCrashReporting,
        'pushNotifications': enablePushNotifications,
        'socialFeatures': enableSocialFeatures,
        'premiumFeatures': enablePremiumFeatures,
        'offlineMode': enableOfflineMode,
        'debugMode': enableDebugMode,
        'testFeatures': enableTestFeatures,
        'mockData': enableMockData,
      },
      'security': {
        'certificatePinning': enableCertificatePinning,
        'biometricAuth': enableBiometricAuth,
        'databaseEncryption': enableDatabaseEncryption,
      },
      'cricket': {
        'maxPlayersPerTeam': maxPlayersPerTeam,
        'maxOversPerInnings': maxOversPerInnings,
        'liveUpdateInterval': liveUpdateInterval.inSeconds,
        'scoreRefreshInterval': scoreRefreshInterval.inSeconds,
      },
    };
  }

  /// Print full configuration summary
  void printFullConfigSummary() {
    if (!isDebug) return;

    print('=== GullyCric Full Configuration ===');
    final summary = getConfigSummary();
    summary.forEach((category, config) {
      print('$category:');
      if (config is Map) {
        config.forEach((key, value) {
          print('  $key: $value');
        });
      } else {
        print('  $config');
      }
      print('');
    });
    print('===================================');
  }
}