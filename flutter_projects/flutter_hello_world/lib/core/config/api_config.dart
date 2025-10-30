/// API Configuration
/// 
/// Manages API endpoints and data source selection
/// Allows easy switching between mock and real APIs
class ApiConfig {
  // Environment flags
  static const bool useMockApi = true; // 🔄 Set to false when real API is ready
  static const bool enableApiLogging = true;
  static const bool enableNetworkDelay = true;
  
  // Base URLs
  static const String mockBaseUrl = 'https://mock.gullycric.com/api/v1';
  static const String devBaseUrl = 'https://dev-api.gullycric.com/api/v1';
  static const String stagingBaseUrl = 'https://staging-api.gullycric.com/api/v1';
  static const String productionBaseUrl = 'https://api.gullycric.com/api/v1';
  
  // Current base URL based on environment
  static String get baseUrl {
    if (useMockApi) return mockBaseUrl;
    // You can add environment detection here
    // For now, return dev URL
    return devBaseUrl;
  }
  
  // API timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // Mock API settings
  static const Duration mockNetworkDelay = Duration(milliseconds: 1000);
  static const double mockErrorRate = 0.05; // 5% error rate for testing
  
  // Real API settings
  static const String apiVersion = 'v1';
  static const String userAgent = 'GullyCric Mobile App';
  
  // Feature flags
  static const bool enableBiometricAuth = true;
  static const bool enableSocialLogin = true;
  static const bool enablePhoneAuth = true;
  static const bool enableOfflineMode = true;
  
  // Cache settings
  static const Duration cacheExpiry = Duration(hours: 1);
  static const Duration tokenRefreshThreshold = Duration(minutes: 5);
  
  /// Check if we're using mock API
  static bool get isMockMode => useMockApi;
  
  /// Check if we're in development mode
  static bool get isDevelopmentMode {
    // You can add proper environment detection here
    return true;
  }
  
  /// Get API configuration summary
  static Map<String, dynamic> get configSummary => {
    'useMockApi': useMockApi,
    'baseUrl': baseUrl,
    'enableApiLogging': enableApiLogging,
    'enableNetworkDelay': enableNetworkDelay,
    'enableBiometricAuth': enableBiometricAuth,
    'enableSocialLogin': enableSocialLogin,
    'enablePhoneAuth': enablePhoneAuth,
    'enableOfflineMode': enableOfflineMode,
  };
}