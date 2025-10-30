import 'dart:convert';
import 'package:flutter/services.dart';

/// GullyCric Secure Configuration Manager
/// 
/// Handles secure storage and retrieval of sensitive configuration data
/// such as API keys, certificates, and other secrets
class SecureConfig {
  static SecureConfig? _instance;
  static Map<String, dynamic>? _secureData;

  SecureConfig._();

  /// Get singleton instance
  static SecureConfig get instance {
    _instance ??= SecureConfig._();
    return _instance!;
  }

  /// Initialize secure configuration
  static Future<void> initialize() async {
    try {
      // Load secure configuration from assets
      await _loadSecureAssets();
    } catch (e) {
      print('Warning: Could not load secure configuration: $e');
      _secureData = {};
    }
  }

  /// Load secure assets from JSON files
  static Future<void> _loadSecureAssets() async {
    try {
      // Try to load secure configuration from assets
      final String secureConfigJson = await rootBundle.loadString('assets/config/secure_config.json');
      _secureData = json.decode(secureConfigJson) as Map<String, dynamic>;
    } catch (e) {
      // If secure config file doesn't exist, create empty configuration
      _secureData = _getDefaultSecureConfig();
    }
  }

  /// Get default secure configuration template
  static Map<String, dynamic> _getDefaultSecureConfig() {
    return {
      'api_keys': {
        'cricket_api': {
          'key': 'your_cricket_api_key_here',
          'secret': 'your_cricket_api_secret_here',
          'enabled': false,
        },
        'weather_api': {
          'key': 'your_weather_api_key_here',
          'enabled': false,
        },
        'maps_api': {
          'key': 'your_maps_api_key_here',
          'enabled': false,
        },
        'news_api': {
          'key': 'your_news_api_key_here',
          'enabled': false,
        },
      },
      'firebase': {
        'project_id': 'your_firebase_project_id',
        'api_key': 'your_firebase_api_key',
        'app_id': 'your_firebase_app_id',
        'messaging_sender_id': 'your_firebase_sender_id',
        'enabled': false,
      },
      'certificates': {
        'ssl_pinning': {
          'enabled': false,
          'certificates': [],
        },
      },
      'encryption': {
        'database_key': 'your_database_encryption_key',
        'storage_key': 'your_storage_encryption_key',
        'enabled': false,
      },
      'oauth': {
        'google': {
          'client_id': 'your_google_client_id',
          'client_secret': 'your_google_client_secret',
          'enabled': false,
        },
        'facebook': {
          'app_id': 'your_facebook_app_id',
          'app_secret': 'your_facebook_app_secret',
          'enabled': false,
        },
      },
      'analytics': {
        'google_analytics': {
          'tracking_id': 'your_ga_tracking_id',
          'enabled': false,
        },
        'firebase_analytics': {
          'enabled': false,
        },
      },
      'push_notifications': {
        'fcm': {
          'server_key': 'your_fcm_server_key',
          'enabled': false,
        },
      },
    };
  }

  /// Get secure value by path (e.g., 'api_keys.cricket_api.key')
  static String? getSecureValue(String path) {
    if (_secureData == null) return null;

    final keys = path.split('.');
    dynamic current = _secureData;

    for (final key in keys) {
      if (current is Map<String, dynamic> && current.containsKey(key)) {
        current = current[key];
      } else {
        return null;
      }
    }

    return current?.toString();
  }

  /// Get secure object by path
  static Map<String, dynamic>? getSecureObject(String path) {
    if (_secureData == null) return null;

    final keys = path.split('.');
    dynamic current = _secureData;

    for (final key in keys) {
      if (current is Map<String, dynamic> && current.containsKey(key)) {
        current = current[key];
      } else {
        return null;
      }
    }

    return current is Map<String, dynamic> ? current : null;
  }

  /// Check if a service is enabled
  static bool isServiceEnabled(String servicePath) {
    final serviceConfig = getSecureObject(servicePath);
    return serviceConfig?['enabled'] == true;
  }

  /// Get API key for a service
  static String? getApiKey(String service) {
    return getSecureValue('api_keys.$service.key');
  }

  /// Get API secret for a service
  static String? getApiSecret(String service) {
    return getSecureValue('api_keys.$service.secret');
  }

  /// Check if API key is configured and valid
  static bool isApiKeyConfigured(String service) {
    final key = getApiKey(service);
    final enabled = isServiceEnabled('api_keys.$service');
    return enabled && key != null && key.isNotEmpty && !key.contains('your_');
  }

  /// Get Firebase configuration
  static Map<String, String?> getFirebaseConfig() {
    return {
      'projectId': getSecureValue('firebase.project_id'),
      'apiKey': getSecureValue('firebase.api_key'),
      'appId': getSecureValue('firebase.app_id'),
      'messagingSenderId': getSecureValue('firebase.messaging_sender_id'),
    };
  }

  /// Check if Firebase is configured
  static bool isFirebaseConfigured() {
    return isServiceEnabled('firebase') && 
           getSecureValue('firebase.project_id')?.isNotEmpty == true &&
           !getSecureValue('firebase.project_id')!.contains('your_');
  }

  /// Get OAuth configuration for a provider
  static Map<String, String?> getOAuthConfig(String provider) {
    return {
      'clientId': getSecureValue('oauth.$provider.client_id'),
      'clientSecret': getSecureValue('oauth.$provider.client_secret'),
      'appId': getSecureValue('oauth.$provider.app_id'),
      'appSecret': getSecureValue('oauth.$provider.app_secret'),
    };
  }

  /// Check if OAuth provider is configured
  static bool isOAuthConfigured(String provider) {
    return isServiceEnabled('oauth.$provider');
  }

  /// Get encryption keys
  static Map<String, String?> getEncryptionKeys() {
    return {
      'databaseKey': getSecureValue('encryption.database_key'),
      'storageKey': getSecureValue('encryption.storage_key'),
    };
  }

  /// Check if encryption is enabled
  static bool isEncryptionEnabled() {
    return isServiceEnabled('encryption');
  }

  /// Get SSL certificates for pinning
  static List<String> getSSLCertificates() {
    final certs = getSecureObject('certificates.ssl_pinning')?['certificates'];
    if (certs is List) {
      return certs.cast<String>();
    }
    return [];
  }

  /// Check if SSL pinning is enabled
  static bool isSSLPinningEnabled() {
    return isServiceEnabled('certificates.ssl_pinning') && 
           getSSLCertificates().isNotEmpty;
  }

  /// Get analytics configuration
  static Map<String, dynamic> getAnalyticsConfig() {
    return {
      'googleAnalytics': {
        'trackingId': getSecureValue('analytics.google_analytics.tracking_id'),
        'enabled': isServiceEnabled('analytics.google_analytics'),
      },
      'firebaseAnalytics': {
        'enabled': isServiceEnabled('analytics.firebase_analytics'),
      },
    };
  }

  /// Get push notification configuration
  static Map<String, String?> getPushNotificationConfig() {
    return {
      'fcmServerKey': getSecureValue('push_notifications.fcm.server_key'),
    };
  }

  /// Check if push notifications are configured
  static bool isPushNotificationConfigured() {
    return isServiceEnabled('push_notifications.fcm');
  }

  /// Get all configured API keys (for debugging - masks sensitive data)
  static Map<String, dynamic> getConfiguredServices() {
    final configured = <String, dynamic>{};

    // API Keys
    final apiServices = ['cricket_api', 'weather_api', 'maps_api', 'news_api'];
    for (final service in apiServices) {
      configured[service] = {
        'configured': isApiKeyConfigured(service),
        'enabled': isServiceEnabled('api_keys.$service'),
      };
    }

    // Firebase
    configured['firebase'] = {
      'configured': isFirebaseConfigured(),
      'enabled': isServiceEnabled('firebase'),
    };

    // OAuth
    final oauthProviders = ['google', 'facebook'];
    for (final provider in oauthProviders) {
      configured['oauth_$provider'] = {
        'configured': isOAuthConfigured(provider),
        'enabled': isServiceEnabled('oauth.$provider'),
      };
    }

    // Other services
    configured['encryption'] = {
      'enabled': isEncryptionEnabled(),
    };

    configured['ssl_pinning'] = {
      'enabled': isSSLPinningEnabled(),
      'certificates_count': getSSLCertificates().length,
    };

    configured['push_notifications'] = {
      'configured': isPushNotificationConfigured(),
      'enabled': isServiceEnabled('push_notifications.fcm'),
    };

    return configured;
  }

  /// Print configuration status (for debugging)
  static void printConfigurationStatus() {
    print('=== Secure Configuration Status ===');
    final configured = getConfiguredServices();
    configured.forEach((service, config) {
      print('$service: $config');
    });
    print('==================================');
  }

  /// Validate all configurations
  static List<String> validateConfiguration() {
    final errors = <String>[];

    // Check if secure data is loaded
    if (_secureData == null || _secureData!.isEmpty) {
      errors.add('Secure configuration not loaded');
      return errors;
    }

    // Validate API keys
    final apiServices = ['cricket_api', 'weather_api', 'maps_api', 'news_api'];
    for (final service in apiServices) {
      if (isServiceEnabled('api_keys.$service') && !isApiKeyConfigured(service)) {
        errors.add('$service is enabled but not properly configured');
      }
    }

    // Validate Firebase
    if (isServiceEnabled('firebase') && !isFirebaseConfigured()) {
      errors.add('Firebase is enabled but not properly configured');
    }

    // Validate OAuth
    final oauthProviders = ['google', 'facebook'];
    for (final provider in oauthProviders) {
      if (isServiceEnabled('oauth.$provider') && !isOAuthConfigured(provider)) {
        errors.add('OAuth $provider is enabled but not properly configured');
      }
    }

    // Validate SSL pinning
    if (isServiceEnabled('certificates.ssl_pinning') && !isSSLPinningEnabled()) {
      errors.add('SSL pinning is enabled but no certificates provided');
    }

    return errors;
  }

  /// Create secure configuration template file content
  static String createSecureConfigTemplate() {
    final template = _getDefaultSecureConfig();
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(template);
  }
}