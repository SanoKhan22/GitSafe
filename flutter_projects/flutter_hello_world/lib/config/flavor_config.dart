/// GullyCric Flavor Configuration
/// 
/// Manages build flavors and environment-specific configurations
/// Provides a centralized way to handle different build variants
enum Flavor {
  development,
  staging,
  production,
}

class FlavorConfig {
  static Flavor? _currentFlavor;
  static String? _flavorName;
  static Map<String, dynamic>? _variables;

  /// Initialize flavor configuration
  static void initialize({
    required Flavor flavor,
    required String name,
    Map<String, dynamic>? variables,
  }) {
    _currentFlavor = flavor;
    _flavorName = name;
    _variables = variables ?? {};
  }

  /// Get current flavor
  static Flavor get currentFlavor {
    assert(_currentFlavor != null, 'FlavorConfig must be initialized first');
    return _currentFlavor!;
  }

  /// Get flavor name
  static String get flavorName {
    assert(_flavorName != null, 'FlavorConfig must be initialized first');
    return _flavorName!;
  }

  /// Get flavor variables
  static Map<String, dynamic> get variables {
    return _variables ?? {};
  }

  /// Get specific variable by key
  static T? getVariable<T>(String key) {
    return _variables?[key] as T?;
  }

  /// Check if current flavor is development
  static bool get isDevelopment => currentFlavor == Flavor.development;

  /// Check if current flavor is staging
  static bool get isStaging => currentFlavor == Flavor.staging;

  /// Check if current flavor is production
  static bool get isProduction => currentFlavor == Flavor.production;

  /// Check if current flavor is debug (development or staging)
  static bool get isDebug => isDevelopment || isStaging;

  /// Get app name with flavor suffix
  static String getAppName(String baseName) {
    switch (currentFlavor) {
      case Flavor.development:
        return '$baseName (Dev)';
      case Flavor.staging:
        return '$baseName (Staging)';
      case Flavor.production:
        return baseName;
    }
  }

  /// Get app bundle identifier with flavor suffix
  static String getBundleId(String baseBundleId) {
    switch (currentFlavor) {
      case Flavor.development:
        return '$baseBundleId.dev';
      case Flavor.staging:
        return '$baseBundleId.staging';
      case Flavor.production:
        return baseBundleId;
    }
  }

  /// Get database name with flavor suffix
  static String getDatabaseName(String baseName) {
    switch (currentFlavor) {
      case Flavor.development:
        return '${baseName}_dev.db';
      case Flavor.staging:
        return '${baseName}_staging.db';
      case Flavor.production:
        return '$baseName.db';
    }
  }

  /// Get API base URL for current flavor
  static String getApiBaseUrl() {
    switch (currentFlavor) {
      case Flavor.development:
        return getVariable<String>('DEV_API_URL') ?? 'https://dev-api.gullycric.com';
      case Flavor.staging:
        return getVariable<String>('STAGING_API_URL') ?? 'https://staging-api.gullycric.com';
      case Flavor.production:
        return getVariable<String>('PROD_API_URL') ?? 'https://api.gullycric.com';
    }
  }

  /// Get log level for current flavor
  static String getLogLevel() {
    switch (currentFlavor) {
      case Flavor.development:
        return 'DEBUG';
      case Flavor.staging:
        return 'INFO';
      case Flavor.production:
        return 'ERROR';
    }
  }

  /// Get analytics enabled status for current flavor
  static bool getAnalyticsEnabled() {
    switch (currentFlavor) {
      case Flavor.development:
        return false;
      case Flavor.staging:
        return true;
      case Flavor.production:
        return true;
    }
  }

  /// Get crash reporting enabled status for current flavor
  static bool getCrashReportingEnabled() {
    switch (currentFlavor) {
      case Flavor.development:
        return false;
      case Flavor.staging:
        return true;
      case Flavor.production:
        return true;
    }
  }

  /// Get performance monitoring enabled status for current flavor
  static bool getPerformanceMonitoringEnabled() {
    switch (currentFlavor) {
      case Flavor.development:
        return false;
      case Flavor.staging:
        return true;
      case Flavor.production:
        return true;
    }
  }

  /// Get feature flags for current flavor
  static Map<String, bool> getFeatureFlags() {
    final baseFlags = <String, bool>{
      'enableSocialFeatures': true,
      'enablePremiumFeatures': true,
      'enableOfflineMode': true,
      'enablePushNotifications': true,
    };

    switch (currentFlavor) {
      case Flavor.development:
        return {
          ...baseFlags,
          'enableDebugMode': true,
          'enableTestFeatures': true,
          'enableMockData': true,
        };
      case Flavor.staging:
        return {
          ...baseFlags,
          'enableDebugMode': true,
          'enableTestFeatures': true,
          'enableMockData': false,
        };
      case Flavor.production:
        return {
          ...baseFlags,
          'enableDebugMode': false,
          'enableTestFeatures': false,
          'enableMockData': false,
        };
    }
  }

  /// Get timeout configurations for current flavor
  static Map<String, Duration> getTimeoutConfig() {
    switch (currentFlavor) {
      case Flavor.development:
        return {
          'connectTimeout': const Duration(seconds: 30),
          'receiveTimeout': const Duration(seconds: 60),
          'sendTimeout': const Duration(seconds: 60),
        };
      case Flavor.staging:
        return {
          'connectTimeout': const Duration(seconds: 20),
          'receiveTimeout': const Duration(seconds: 45),
          'sendTimeout': const Duration(seconds: 45),
        };
      case Flavor.production:
        return {
          'connectTimeout': const Duration(seconds: 15),
          'receiveTimeout': const Duration(seconds: 30),
          'sendTimeout': const Duration(seconds: 30),
        };
    }
  }

  /// Get cache configurations for current flavor
  static Map<String, dynamic> getCacheConfig() {
    switch (currentFlavor) {
      case Flavor.development:
        return {
          'maxCacheSize': 50, // MB
          'maxImageCacheSize': 100, // MB
          'cacheExpiration': const Duration(hours: 6),
          'imageCacheExpiration': const Duration(days: 1),
        };
      case Flavor.staging:
        return {
          'maxCacheSize': 75, // MB
          'maxImageCacheSize': 150, // MB
          'cacheExpiration': const Duration(hours: 12),
          'imageCacheExpiration': const Duration(days: 3),
        };
      case Flavor.production:
        return {
          'maxCacheSize': 100, // MB
          'maxImageCacheSize': 200, // MB
          'cacheExpiration': const Duration(hours: 24),
          'imageCacheExpiration': const Duration(days: 7),
        };
    }
  }

  /// Get security configurations for current flavor
  static Map<String, dynamic> getSecurityConfig() {
    switch (currentFlavor) {
      case Flavor.development:
        return {
          'enableCertificatePinning': false,
          'enableBiometricAuth': true,
          'sessionTimeout': const Duration(hours: 24),
          'maxLoginAttempts': 10,
          'enableDatabaseEncryption': false,
        };
      case Flavor.staging:
        return {
          'enableCertificatePinning': false,
          'enableBiometricAuth': true,
          'sessionTimeout': const Duration(hours: 12),
          'maxLoginAttempts': 10,
          'enableDatabaseEncryption': false,
        };
      case Flavor.production:
        return {
          'enableCertificatePinning': true,
          'enableBiometricAuth': true,
          'sessionTimeout': const Duration(hours: 24),
          'maxLoginAttempts': 5,
          'enableDatabaseEncryption': true,
        };
    }
  }

  /// Get notification configurations for current flavor
  static Map<String, dynamic> getNotificationConfig() {
    return {
      'enableLocalNotifications': true,
      'enableRemoteNotifications': !isDevelopment,
      'notificationRetention': isDevelopment 
          ? const Duration(days: 7) 
          : const Duration(days: 30),
    };
  }

  /// Get localization configurations
  static Map<String, dynamic> getLocalizationConfig() {
    return {
      'supportedLanguages': ['en', 'hi', 'ur', 'bn'],
      'defaultLanguage': 'en',
      'enableRTL': true,
    };
  }

  /// Get cricket-specific configurations
  static Map<String, dynamic> getCricketConfig() {
    return {
      'maxPlayersPerTeam': 11,
      'maxOversPerInnings': 50,
      'liveUpdateInterval': isDevelopment 
          ? const Duration(seconds: 5) 
          : const Duration(seconds: 30),
      'scoreRefreshInterval': isDevelopment 
          ? const Duration(seconds: 3) 
          : const Duration(seconds: 15),
      'maxMatchHistory': isDevelopment ? 20 : 100,
    };
  }

  /// Get all configuration as a map for debugging
  static Map<String, dynamic> getAllConfig() {
    return {
      'flavor': flavorName,
      'environment': currentFlavor.toString(),
      'isDebug': isDebug,
      'isProduction': isProduction,
      'variables': variables,
      'apiBaseUrl': getApiBaseUrl(),
      'logLevel': getLogLevel(),
      'featureFlags': getFeatureFlags(),
      'timeoutConfig': getTimeoutConfig(),
      'cacheConfig': getCacheConfig(),
      'securityConfig': getSecurityConfig(),
      'notificationConfig': getNotificationConfig(),
      'localizationConfig': getLocalizationConfig(),
      'cricketConfig': getCricketConfig(),
    };
  }

  /// Print configuration summary for debugging
  static void printConfigSummary() {
    print('=== GullyCric Flavor Configuration ===');
    print('Flavor: $flavorName');
    print('Environment: ${currentFlavor.toString()}');
    print('Is Debug: $isDebug');
    print('Is Production: $isProduction');
    print('API Base URL: ${getApiBaseUrl()}');
    print('Log Level: ${getLogLevel()}');
    print('Analytics Enabled: ${getAnalyticsEnabled()}');
    print('Crash Reporting Enabled: ${getCrashReportingEnabled()}');
    print('=====================================');
  }
}