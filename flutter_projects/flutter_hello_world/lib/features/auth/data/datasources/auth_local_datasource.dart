import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';
import '../models/auth_models.dart';

/// Authentication Local Data Source Interface
/// 
/// Defines the contract for local authentication data operations
abstract class AuthLocalDataSource {
  // Token management
  Future<void> cacheAuthTokens(AuthTokensModel tokens);
  Future<AuthTokensModel?> getCachedAuthTokens();
  Future<void> clearAuthTokens();

  // User data caching
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCachedUser();

  // Session management
  Future<void> cacheUserSession(UserSessionModel session);
  Future<UserSessionModel?> getCachedUserSession();
  Future<void> clearUserSession();

  // Login history caching
  Future<void> cacheLoginHistory(List<LoginHistoryModel> history);
  Future<List<LoginHistoryModel>?> getCachedLoginHistory();
  Future<void> clearLoginHistory();

  // Biometric settings
  Future<void> setBiometricEnabled(bool enabled);
  Future<bool> isBiometricEnabled();
  Future<void> clearBiometricSettings();

  // User preferences
  Future<void> cacheUserPreferences(UserPreferencesModel preferences);
  Future<UserPreferencesModel?> getCachedUserPreferences();
  Future<void> clearUserPreferences();

  // Authentication state
  Future<void> setAuthenticationState(bool isAuthenticated);
  Future<bool> isAuthenticated();
  Future<void> clearAuthenticationState();

  // Device information
  Future<void> setDeviceId(String deviceId);
  Future<String?> getDeviceId();
  Future<void> clearDeviceId();

  // Remember me functionality
  Future<void> setRememberMe(bool remember);
  Future<bool> getRememberMe();
  Future<void> clearRememberMe();

  // Last login information
  Future<void> setLastLoginEmail(String email);
  Future<String?> getLastLoginEmail();
  Future<void> clearLastLoginEmail();

  // Clear all cached data
  Future<void> clearAllData();
}

/// Authentication Local Data Source Implementation
/// 
/// Implements local authentication data operations using secure storage
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;

  // Storage keys
  static const String _keyAuthTokens = 'auth_tokens';
  static const String _keyUser = 'cached_user';
  static const String _keyUserSession = 'user_session';
  static const String _keyLoginHistory = 'login_history';
  static const String _keyBiometricEnabled = 'biometric_enabled';
  static const String _keyUserPreferences = 'user_preferences';
  static const String _keyAuthenticationState = 'authentication_state';
  static const String _keyDeviceId = 'device_id';
  static const String _keyRememberMe = 'remember_me';
  static const String _keyLastLoginEmail = 'last_login_email';

  const AuthLocalDataSourceImpl({
    required FlutterSecureStorage secureStorage,
  }) : _secureStorage = secureStorage;

  @override
  Future<void> cacheAuthTokens(AuthTokensModel tokens) async {
    try {
      final tokensJson = jsonEncode(tokens.toJson());
      await _secureStorage.write(key: _keyAuthTokens, value: tokensJson);
    } catch (e) {
      throw CacheException('Failed to cache auth tokens: $e');
    }
  }

  @override
  Future<AuthTokensModel?> getCachedAuthTokens() async {
    try {
      final tokensJson = await _secureStorage.read(key: _keyAuthTokens);
      if (tokensJson == null) return null;

      final tokensMap = jsonDecode(tokensJson) as Map<String, dynamic>;
      return AuthTokensModel.fromJson(tokensMap);
    } catch (e) {
      throw CacheException('Failed to get cached auth tokens: $e');
    }
  }

  @override
  Future<void> clearAuthTokens() async {
    try {
      await _secureStorage.delete(key: _keyAuthTokens);
    } catch (e) {
      throw CacheException('Failed to clear auth tokens: $e');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await _secureStorage.write(key: _keyUser, value: userJson);
    } catch (e) {
      throw CacheException('Failed to cache user: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = await _secureStorage.read(key: _keyUser);
      if (userJson == null) return null;

      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      throw CacheException('Failed to get cached user: $e');
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      await _secureStorage.delete(key: _keyUser);
    } catch (e) {
      throw CacheException('Failed to clear cached user: $e');
    }
  }

  @override
  Future<void> cacheUserSession(UserSessionModel session) async {
    try {
      final sessionJson = jsonEncode(session.toJson());
      await _secureStorage.write(key: _keyUserSession, value: sessionJson);
    } catch (e) {
      throw CacheException('Failed to cache user session: $e');
    }
  }

  @override
  Future<UserSessionModel?> getCachedUserSession() async {
    try {
      final sessionJson = await _secureStorage.read(key: _keyUserSession);
      if (sessionJson == null) return null;

      final sessionMap = jsonDecode(sessionJson) as Map<String, dynamic>;
      return UserSessionModel.fromJson(sessionMap);
    } catch (e) {
      throw CacheException('Failed to get cached user session: $e');
    }
  }

  @override
  Future<void> clearUserSession() async {
    try {
      await _secureStorage.delete(key: _keyUserSession);
    } catch (e) {
      throw CacheException('Failed to clear user session: $e');
    }
  }

  @override
  Future<void> cacheLoginHistory(List<LoginHistoryModel> history) async {
    try {
      final historyJson = jsonEncode(history.map((h) => h.toJson()).toList());
      await _secureStorage.write(key: _keyLoginHistory, value: historyJson);
    } catch (e) {
      throw CacheException('Failed to cache login history: $e');
    }
  }

  @override
  Future<List<LoginHistoryModel>?> getCachedLoginHistory() async {
    try {
      final historyJson = await _secureStorage.read(key: _keyLoginHistory);
      if (historyJson == null) return null;

      final historyList = jsonDecode(historyJson) as List<dynamic>;
      return historyList
          .map((json) => LoginHistoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('Failed to get cached login history: $e');
    }
  }

  @override
  Future<void> clearLoginHistory() async {
    try {
      await _secureStorage.delete(key: _keyLoginHistory);
    } catch (e) {
      throw CacheException('Failed to clear login history: $e');
    }
  }

  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    try {
      await _secureStorage.write(key: _keyBiometricEnabled, value: enabled.toString());
    } catch (e) {
      throw CacheException('Failed to set biometric enabled: $e');
    }
  }

  @override
  Future<bool> isBiometricEnabled() async {
    try {
      final enabledString = await _secureStorage.read(key: _keyBiometricEnabled);
      return enabledString == 'true';
    } catch (e) {
      throw CacheException('Failed to check if biometric is enabled: $e');
    }
  }

  @override
  Future<void> clearBiometricSettings() async {
    try {
      await _secureStorage.delete(key: _keyBiometricEnabled);
    } catch (e) {
      throw CacheException('Failed to clear biometric settings: $e');
    }
  }

  @override
  Future<void> cacheUserPreferences(UserPreferencesModel preferences) async {
    try {
      final preferencesJson = jsonEncode(preferences.toJson());
      await _secureStorage.write(key: _keyUserPreferences, value: preferencesJson);
    } catch (e) {
      throw CacheException('Failed to cache user preferences: $e');
    }
  }

  @override
  Future<UserPreferencesModel?> getCachedUserPreferences() async {
    try {
      final preferencesJson = await _secureStorage.read(key: _keyUserPreferences);
      if (preferencesJson == null) return null;

      final preferencesMap = jsonDecode(preferencesJson) as Map<String, dynamic>;
      return UserPreferencesModel.fromJson(preferencesMap);
    } catch (e) {
      throw CacheException('Failed to get cached user preferences: $e');
    }
  }

  @override
  Future<void> clearUserPreferences() async {
    try {
      await _secureStorage.delete(key: _keyUserPreferences);
    } catch (e) {
      throw CacheException('Failed to clear user preferences: $e');
    }
  }

  @override
  Future<void> setAuthenticationState(bool isAuthenticated) async {
    try {
      await _secureStorage.write(key: _keyAuthenticationState, value: isAuthenticated.toString());
    } catch (e) {
      throw CacheException('Failed to set authentication state: $e');
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final authStateString = await _secureStorage.read(key: _keyAuthenticationState);
      return authStateString == 'true';
    } catch (e) {
      throw CacheException('Failed to check authentication state: $e');
    }
  }

  @override
  Future<void> clearAuthenticationState() async {
    try {
      await _secureStorage.delete(key: _keyAuthenticationState);
    } catch (e) {
      throw CacheException('Failed to clear authentication state: $e');
    }
  }

  @override
  Future<void> setDeviceId(String deviceId) async {
    try {
      await _secureStorage.write(key: _keyDeviceId, value: deviceId);
    } catch (e) {
      throw CacheException('Failed to set device ID: $e');
    }
  }

  @override
  Future<String?> getDeviceId() async {
    try {
      return await _secureStorage.read(key: _keyDeviceId);
    } catch (e) {
      throw CacheException('Failed to get device ID: $e');
    }
  }

  @override
  Future<void> clearDeviceId() async {
    try {
      await _secureStorage.delete(key: _keyDeviceId);
    } catch (e) {
      throw CacheException('Failed to clear device ID: $e');
    }
  }

  @override
  Future<void> setRememberMe(bool remember) async {
    try {
      await _secureStorage.write(key: _keyRememberMe, value: remember.toString());
    } catch (e) {
      throw CacheException('Failed to set remember me: $e');
    }
  }

  @override
  Future<bool> getRememberMe() async {
    try {
      final rememberString = await _secureStorage.read(key: _keyRememberMe);
      return rememberString == 'true';
    } catch (e) {
      throw CacheException('Failed to get remember me: $e');
    }
  }

  @override
  Future<void> clearRememberMe() async {
    try {
      await _secureStorage.delete(key: _keyRememberMe);
    } catch (e) {
      throw CacheException('Failed to clear remember me: $e');
    }
  }

  @override
  Future<void> setLastLoginEmail(String email) async {
    try {
      await _secureStorage.write(key: _keyLastLoginEmail, value: email);
    } catch (e) {
      throw CacheException('Failed to set last login email: $e');
    }
  }

  @override
  Future<String?> getLastLoginEmail() async {
    try {
      return await _secureStorage.read(key: _keyLastLoginEmail);
    } catch (e) {
      throw CacheException('Failed to get last login email: $e');
    }
  }

  @override
  Future<void> clearLastLoginEmail() async {
    try {
      await _secureStorage.delete(key: _keyLastLoginEmail);
    } catch (e) {
      throw CacheException('Failed to clear last login email: $e');
    }
  }

  @override
  Future<void> clearAllData() async {
    try {
      await Future.wait([
        clearAuthTokens(),
        clearCachedUser(),
        clearUserSession(),
        clearLoginHistory(),
        clearBiometricSettings(),
        clearUserPreferences(),
        clearAuthenticationState(),
        clearDeviceId(),
        clearRememberMe(),
        clearLastLoginEmail(),
      ]);
    } catch (e) {
      throw CacheException('Failed to clear all data: $e');
    }
  }

  /// Helper method to check if cached data is still valid
  Future<bool> isCacheValid(String key, Duration maxAge) async {
    try {
      final timestampKey = '${key}_timestamp';
      final timestampString = await _secureStorage.read(key: timestampKey);
      
      if (timestampString == null) return false;
      
      final timestamp = DateTime.parse(timestampString);
      final now = DateTime.now();
      
      return now.difference(timestamp) < maxAge;
    } catch (e) {
      return false;
    }
  }

  /// Helper method to set cache timestamp
  Future<void> setCacheTimestamp(String key) async {
    try {
      final timestampKey = '${key}_timestamp';
      await _secureStorage.write(key: timestampKey, value: DateTime.now().toIso8601String());
    } catch (e) {
      // Ignore timestamp errors
    }
  }

  /// Helper method to clear cache timestamp
  Future<void> clearCacheTimestamp(String key) async {
    try {
      final timestampKey = '${key}_timestamp';
      await _secureStorage.delete(key: timestampKey);
    } catch (e) {
      // Ignore timestamp errors
    }
  }

  /// Get all stored keys (for debugging)
  Future<Map<String, String>> getAllStoredData() async {
    try {
      return await _secureStorage.readAll();
    } catch (e) {
      throw CacheException('Failed to get all stored data: $e');
    }
  }

  /// Check storage health
  Future<bool> isStorageHealthy() async {
    try {
      const testKey = 'health_check';
      const testValue = 'test';
      
      // Write test data
      await _secureStorage.write(key: testKey, value: testValue);
      
      // Read test data
      final readValue = await _secureStorage.read(key: testKey);
      
      // Clean up test data
      await _secureStorage.delete(key: testKey);
      
      return readValue == testValue;
    } catch (e) {
      return false;
    }
  }

  /// Get storage statistics
  Future<Map<String, dynamic>> getStorageStats() async {
    try {
      final allData = await getAllStoredData();
      final totalKeys = allData.length;
      final totalSize = allData.values.fold<int>(0, (sum, value) => sum + value.length);
      
      return {
        'totalKeys': totalKeys,
        'totalSize': totalSize,
        'keys': allData.keys.toList(),
        'isHealthy': await isStorageHealthy(),
      };
    } catch (e) {
      return {
        'totalKeys': 0,
        'totalSize': 0,
        'keys': <String>[],
        'isHealthy': false,
        'error': e.toString(),
      };
    }
  }
}