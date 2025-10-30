import 'dev_config.dart';
import 'production_config.dart';
import 'staging_config.dart';

/// GullyCric Base Configuration
/// 
/// Base configuration class that defines the structure for all environments
/// with parameterized API keys and environment-specific settings
abstract class BaseConfig {
  // App Information
  String get appName;
  String get appVersion;
  String get appBuildNumber;
  
  // Environment
  String get environment;
  bool get isDebug;
  bool get isProduction;
  
  // API Configuration
  String get baseApiUrl;
  String get apiVersion;
  Duration get apiTimeout;
  int get maxRetries;
  
  // External API Keys (parameterized for easy injection)
  String get cricketApiKey;
  String get cricketApiUrl;
  String get weatherApiKey;
  String get weatherApiUrl;
  String get mapsApiKey;
  String get mapsApiUrl;
  String get newsApiKey;
  String get newsApiUrl;
  
  // Firebase Configuration (parameterized)
  String get firebaseProjectId;
  String get firebaseApiKey;
  String get firebaseAppId;
  String get firebaseMessagingSenderId;
  
  // Feature Flags
  bool get enableAnalytics;
  bool get enableCrashReporting;
  bool get enablePerformanceMonitoring;
  bool get enablePushNotifications;
  bool get enableSocialFeatures;
  bool get enablePremiumFeatures;
  bool get enableOfflineMode;
  
  // Cricket-specific Configuration
  int get maxPlayersPerTeam;
  int get maxOversPerInnings;
  Duration get liveUpdateInterval;
  Duration get scoreRefreshInterval;
  int get maxMatchHistory;
  
  // Cache Configuration
  Duration get cacheExpiration;
  Duration get imageCacheExpiration;
  int get maxCacheSize; // in MB
  int get maxImageCacheSize; // in MB
  
  // Network Configuration
  Duration get connectTimeout;
  Duration get receiveTimeout;
  Duration get sendTimeout;
  int get maxConcurrentRequests;
  
  // UI Configuration
  Duration get animationDuration;
  Duration get splashDuration;
  bool get enableHapticFeedback;
  bool get enableSoundEffects;
  
  // Security Configuration
  bool get enableCertificatePinning;
  bool get enableBiometricAuth;
  Duration get sessionTimeout;
  int get maxLoginAttempts;
  
  // Logging Configuration
  String get logLevel;
  bool get enableFileLogging;
  int get maxLogFileSize; // in MB
  int get maxLogFiles;
  
  // Database Configuration
  String get databaseName;
  int get databaseVersion;
  bool get enableDatabaseEncryption;
  
  // Notification Configuration
  bool get enableLocalNotifications;
  bool get enableRemoteNotifications;
  Duration get notificationRetention;
  
  // Social Features Configuration
  int get maxPostLength;
  int get maxImageUploads;
  Duration get feedRefreshInterval;
  
  // Premium Features Configuration
  List<String> get premiumFeatures;
  Duration get trialPeriod;
  
  // Localization Configuration
  List<String> get supportedLanguages;
  String get defaultLanguage;
  
  // Accessibility Configuration
  bool get enableAccessibilityFeatures;
  double get minFontScale;
  double get maxFontScale;
  
  // Performance Configuration
  int get maxImageResolution;
  int get imageCompressionQuality;
  bool get enableImageOptimization;
  
  // Error Handling Configuration
  bool get enableErrorReporting;
  int get maxErrorReports;
  Duration get errorReportingInterval;
}

/// Configuration factory for creating environment-specific configs
class ConfigFactory {
  ConfigFactory._();
  
  /// Create configuration based on environment
  static BaseConfig create({String? environment}) {
    final env = environment ?? 
                const String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
    
    switch (env.toLowerCase()) {
      case 'production':
      case 'prod':
        return ProductionConfig();
      case 'staging':
      case 'stage':
        return StagingConfig();
      case 'development':
      case 'dev':
      default:
        return DevelopmentConfig();
    }
  }
  
  /// Create configuration with custom API keys
  static BaseConfig createWithApiKeys({
    String? environment,
    String? cricketApiKey,
    String? weatherApiKey,
    String? mapsApiKey,
    String? newsApiKey,
    String? firebaseProjectId,
    String? firebaseApiKey,
    String? firebaseAppId,
    String? firebaseMessagingSenderId,
  }) {
    final config = create(environment: environment);
    
    // Return a custom config with injected API keys
    return CustomConfig(
      baseConfig: config,
      customCricketApiKey: cricketApiKey,
      customWeatherApiKey: weatherApiKey,
      customMapsApiKey: mapsApiKey,
      customNewsApiKey: newsApiKey,
      customFirebaseProjectId: firebaseProjectId,
      customFirebaseApiKey: firebaseApiKey,
      customFirebaseAppId: firebaseAppId,
      customFirebaseMessagingSenderId: firebaseMessagingSenderId,
    );
  }
}

/// Custom configuration wrapper for API key injection
class CustomConfig implements BaseConfig {
  final BaseConfig _baseConfig;
  final String? _customCricketApiKey;
  final String? _customWeatherApiKey;
  final String? _customMapsApiKey;
  final String? _customNewsApiKey;
  final String? _customFirebaseProjectId;
  final String? _customFirebaseApiKey;
  final String? _customFirebaseAppId;
  final String? _customFirebaseMessagingSenderId;
  
  CustomConfig({
    required BaseConfig baseConfig,
    String? customCricketApiKey,
    String? customWeatherApiKey,
    String? customMapsApiKey,
    String? customNewsApiKey,
    String? customFirebaseProjectId,
    String? customFirebaseApiKey,
    String? customFirebaseAppId,
    String? customFirebaseMessagingSenderId,
  }) : _baseConfig = baseConfig,
       _customCricketApiKey = customCricketApiKey,
       _customWeatherApiKey = customWeatherApiKey,
       _customMapsApiKey = customMapsApiKey,
       _customNewsApiKey = customNewsApiKey,
       _customFirebaseProjectId = customFirebaseProjectId,
       _customFirebaseApiKey = customFirebaseApiKey,
       _customFirebaseAppId = customFirebaseAppId,
       _customFirebaseMessagingSenderId = customFirebaseMessagingSenderId;
  
  // Override API keys with custom values if provided
  @override
  String get cricketApiKey => _customCricketApiKey ?? _baseConfig.cricketApiKey;
  
  @override
  String get weatherApiKey => _customWeatherApiKey ?? _baseConfig.weatherApiKey;
  
  @override
  String get mapsApiKey => _customMapsApiKey ?? _baseConfig.mapsApiKey;
  
  @override
  String get newsApiKey => _customNewsApiKey ?? _baseConfig.newsApiKey;
  
  @override
  String get firebaseProjectId => _customFirebaseProjectId ?? _baseConfig.firebaseProjectId;
  
  @override
  String get firebaseApiKey => _customFirebaseApiKey ?? _baseConfig.firebaseApiKey;
  
  @override
  String get firebaseAppId => _customFirebaseAppId ?? _baseConfig.firebaseAppId;
  
  @override
  String get firebaseMessagingSenderId => _customFirebaseMessagingSenderId ?? _baseConfig.firebaseMessagingSenderId;
  
  // Delegate all other properties to base config
  @override
  String get appName => _baseConfig.appName;
  
  @override
  String get appVersion => _baseConfig.appVersion;
  
  @override
  String get appBuildNumber => _baseConfig.appBuildNumber;
  
  @override
  String get environment => _baseConfig.environment;
  
  @override
  bool get isDebug => _baseConfig.isDebug;
  
  @override
  bool get isProduction => _baseConfig.isProduction;
  
  @override
  String get baseApiUrl => _baseConfig.baseApiUrl;
  
  @override
  String get apiVersion => _baseConfig.apiVersion;
  
  @override
  Duration get apiTimeout => _baseConfig.apiTimeout;
  
  @override
  int get maxRetries => _baseConfig.maxRetries;
  
  @override
  String get cricketApiUrl => _baseConfig.cricketApiUrl;
  
  @override
  String get weatherApiUrl => _baseConfig.weatherApiUrl;
  
  @override
  String get mapsApiUrl => _baseConfig.mapsApiUrl;
  
  @override
  String get newsApiUrl => _baseConfig.newsApiUrl;
  
  @override
  bool get enableAnalytics => _baseConfig.enableAnalytics;
  
  @override
  bool get enableCrashReporting => _baseConfig.enableCrashReporting;
  
  @override
  bool get enablePerformanceMonitoring => _baseConfig.enablePerformanceMonitoring;
  
  @override
  bool get enablePushNotifications => _baseConfig.enablePushNotifications;
  
  @override
  bool get enableSocialFeatures => _baseConfig.enableSocialFeatures;
  
  @override
  bool get enablePremiumFeatures => _baseConfig.enablePremiumFeatures;
  
  @override
  bool get enableOfflineMode => _baseConfig.enableOfflineMode;
  
  @override
  int get maxPlayersPerTeam => _baseConfig.maxPlayersPerTeam;
  
  @override
  int get maxOversPerInnings => _baseConfig.maxOversPerInnings;
  
  @override
  Duration get liveUpdateInterval => _baseConfig.liveUpdateInterval;
  
  @override
  Duration get scoreRefreshInterval => _baseConfig.scoreRefreshInterval;
  
  @override
  int get maxMatchHistory => _baseConfig.maxMatchHistory;
  
  @override
  Duration get cacheExpiration => _baseConfig.cacheExpiration;
  
  @override
  Duration get imageCacheExpiration => _baseConfig.imageCacheExpiration;
  
  @override
  int get maxCacheSize => _baseConfig.maxCacheSize;
  
  @override
  int get maxImageCacheSize => _baseConfig.maxImageCacheSize;
  
  @override
  Duration get connectTimeout => _baseConfig.connectTimeout;
  
  @override
  Duration get receiveTimeout => _baseConfig.receiveTimeout;
  
  @override
  Duration get sendTimeout => _baseConfig.sendTimeout;
  
  @override
  int get maxConcurrentRequests => _baseConfig.maxConcurrentRequests;
  
  @override
  Duration get animationDuration => _baseConfig.animationDuration;
  
  @override
  Duration get splashDuration => _baseConfig.splashDuration;
  
  @override
  bool get enableHapticFeedback => _baseConfig.enableHapticFeedback;
  
  @override
  bool get enableSoundEffects => _baseConfig.enableSoundEffects;
  
  @override
  bool get enableCertificatePinning => _baseConfig.enableCertificatePinning;
  
  @override
  bool get enableBiometricAuth => _baseConfig.enableBiometricAuth;
  
  @override
  Duration get sessionTimeout => _baseConfig.sessionTimeout;
  
  @override
  int get maxLoginAttempts => _baseConfig.maxLoginAttempts;
  
  @override
  String get logLevel => _baseConfig.logLevel;
  
  @override
  bool get enableFileLogging => _baseConfig.enableFileLogging;
  
  @override
  int get maxLogFileSize => _baseConfig.maxLogFileSize;
  
  @override
  int get maxLogFiles => _baseConfig.maxLogFiles;
  
  @override
  String get databaseName => _baseConfig.databaseName;
  
  @override
  int get databaseVersion => _baseConfig.databaseVersion;
  
  @override
  bool get enableDatabaseEncryption => _baseConfig.enableDatabaseEncryption;
  
  @override
  bool get enableLocalNotifications => _baseConfig.enableLocalNotifications;
  
  @override
  bool get enableRemoteNotifications => _baseConfig.enableRemoteNotifications;
  
  @override
  Duration get notificationRetention => _baseConfig.notificationRetention;
  
  @override
  int get maxPostLength => _baseConfig.maxPostLength;
  
  @override
  int get maxImageUploads => _baseConfig.maxImageUploads;
  
  @override
  Duration get feedRefreshInterval => _baseConfig.feedRefreshInterval;
  
  @override
  List<String> get premiumFeatures => _baseConfig.premiumFeatures;
  
  @override
  Duration get trialPeriod => _baseConfig.trialPeriod;
  
  @override
  List<String> get supportedLanguages => _baseConfig.supportedLanguages;
  
  @override
  String get defaultLanguage => _baseConfig.defaultLanguage;
  
  @override
  bool get enableAccessibilityFeatures => _baseConfig.enableAccessibilityFeatures;
  
  @override
  double get minFontScale => _baseConfig.minFontScale;
  
  @override
  double get maxFontScale => _baseConfig.maxFontScale;
  
  @override
  int get maxImageResolution => _baseConfig.maxImageResolution;
  
  @override
  int get imageCompressionQuality => _baseConfig.imageCompressionQuality;
  
  @override
  bool get enableImageOptimization => _baseConfig.enableImageOptimization;
  
  @override
  bool get enableErrorReporting => _baseConfig.enableErrorReporting;
  
  @override
  int get maxErrorReports => _baseConfig.maxErrorReports;
  
  @override
  Duration get errorReportingInterval => _baseConfig.errorReportingInterval;
}

/// Configuration utilities
class ConfigUtils {
  ConfigUtils._();
  
  /// Validate API key format
  static bool isValidApiKey(String? apiKey) {
    if (apiKey == null || apiKey.isEmpty) return false;
    if (apiKey.contains('your_') && apiKey.contains('_key_here')) return false;
    return apiKey.length >= 10; // Minimum reasonable API key length
  }
  
  /// Get masked API key for logging
  static String maskApiKey(String apiKey) {
    if (apiKey.length <= 8) return '***';
    return '${apiKey.substring(0, 4)}***${apiKey.substring(apiKey.length - 4)}';
  }
  
  /// Validate configuration
  static List<String> validateConfig(BaseConfig config) {
    final errors = <String>[];
    
    // Validate required fields
    if (config.appName.isEmpty) errors.add('App name is required');
    if (config.baseApiUrl.isEmpty) errors.add('Base API URL is required');
    
    // Validate API keys if features are enabled
    if (config.enableAnalytics && !isValidApiKey(config.cricketApiKey)) {
      errors.add('Cricket API key is invalid or missing');
    }
    
    // Validate numeric ranges
    if (config.maxPlayersPerTeam < 1 || config.maxPlayersPerTeam > 20) {
      errors.add('Max players per team must be between 1 and 20');
    }
    
    if (config.maxOversPerInnings < 1 || config.maxOversPerInnings > 100) {
      errors.add('Max overs per innings must be between 1 and 100');
    }
    
    return errors;
  }
  
  /// Get configuration summary for debugging
  static Map<String, dynamic> getConfigSummary(BaseConfig config) {
    return {
      'environment': config.environment,
      'appVersion': config.appVersion,
      'isDebug': config.isDebug,
      'baseApiUrl': config.baseApiUrl,
      'cricketApiKey': isValidApiKey(config.cricketApiKey) ? 'configured' : 'missing',
      'weatherApiKey': isValidApiKey(config.weatherApiKey) ? 'configured' : 'missing',
      'mapsApiKey': isValidApiKey(config.mapsApiKey) ? 'configured' : 'missing',
      'newsApiKey': isValidApiKey(config.newsApiKey) ? 'configured' : 'missing',
      'enabledFeatures': [
        if (config.enableAnalytics) 'analytics',
        if (config.enableCrashReporting) 'crash_reporting',
        if (config.enablePushNotifications) 'push_notifications',
        if (config.enableSocialFeatures) 'social_features',
        if (config.enablePremiumFeatures) 'premium_features',
        if (config.enableOfflineMode) 'offline_mode',
      ],
    };
  }
}