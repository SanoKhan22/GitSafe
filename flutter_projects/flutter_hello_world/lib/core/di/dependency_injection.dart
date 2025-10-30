import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../utils/logger.dart';

/// GullyCric Dependency Injection Setup
/// 
/// Centralized dependency injection using Riverpod providers
/// for network clients, services, and utilities

// Network providers
final dioClientProvider = Provider<DioClient>((ref) {
  Logger.d('Creating DioClient instance', tag: 'DI');
  return DioClient.instance;
});

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  Logger.d('Creating NetworkInfo instance', tag: 'DI');
  return NetworkInfoImpl.instance;
});

// Network monitoring provider
final networkMonitorProvider = Provider<NetworkMonitor>((ref) {
  final networkInfo = ref.watch(networkInfoProvider);
  Logger.d('Creating NetworkMonitor instance', tag: 'DI');
  return NetworkMonitor(networkInfo);
});

// Network status provider (async)
final networkStatusProvider = FutureProvider<NetworkStatus>((ref) async {
  final monitor = ref.watch(networkMonitorProvider);
  Logger.d('Fetching current network status', tag: 'DI');
  return await monitor.getCurrentStatus();
});

// Network connectivity stream provider
final connectivityStreamProvider = StreamProvider<ConnectivityResult>((ref) {
  final networkInfo = ref.watch(networkInfoProvider);
  Logger.d('Setting up connectivity stream', tag: 'DI');
  return networkInfo.onConnectivityChanged;
});

// Network status stream provider
final networkStatusStreamProvider = StreamProvider<NetworkStatus>((ref) {
  final monitor = ref.watch(networkMonitorProvider);
  Logger.d('Setting up network status stream', tag: 'DI');
  
  // Start monitoring when provider is created
  monitor.startMonitoring();
  
  // Clean up when provider is disposed
  ref.onDispose(() {
    Logger.d('Disposing network monitor', tag: 'DI');
    monitor.dispose();
  });
  
  return monitor.onStatusChanged;
});

// Internet connectivity provider
final hasInternetProvider = FutureProvider<bool>((ref) async {
  final networkInfo = ref.watch(networkInfoProvider);
  Logger.d('Checking internet connectivity', tag: 'DI');
  return await networkInfo.hasInternetAccess();
});

// Network quality provider
final networkQualityProvider = FutureProvider<NetworkQuality>((ref) async {
  final networkInfo = ref.watch(networkInfoProvider);
  Logger.d('Checking network quality', tag: 'DI');
  return await networkInfo.networkQuality;
});

// Network speed provider
final networkSpeedProvider = FutureProvider<NetworkSpeed>((ref) async {
  final networkInfo = ref.watch(networkInfoProvider);
  Logger.d('Measuring network speed', tag: 'DI');
  return await networkInfo.measureNetworkSpeed();
});

/// Dependency injection utilities
class DependencyInjection {
  DependencyInjection._();

  /// Initialize all dependencies
  static Future<void> initialize() async {
    Logger.i('Initializing dependency injection', tag: 'DI');
    
    try {
      // Initialize network components
      final dioClient = DioClient.instance;
      final networkInfo = NetworkInfoImpl.instance;
      
      // Test network connectivity
      final isConnected = await networkInfo.isConnected;
      Logger.i('Network connectivity: ${isConnected ? 'Connected' : 'Disconnected'}', tag: 'DI');
      
      // Log initialization success
      Logger.i('Dependency injection initialized successfully', tag: 'DI');
    } catch (e, stackTrace) {
      Logger.e('Failed to initialize dependency injection', tag: 'DI', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Clean up all dependencies
  static Future<void> dispose() async {
    Logger.i('Disposing dependency injection', tag: 'DI');
    
    try {
      // Cancel all network requests
      DioClient.instance.cancelRequests();
      
      Logger.i('Dependency injection disposed successfully', tag: 'DI');
    } catch (e, stackTrace) {
      Logger.e('Error during dependency injection disposal', tag: 'DI', error: e, stackTrace: stackTrace);
    }
  }

  /// Set API keys for external services
  static void setApiKeys({
    String? cricketApiKey,
    String? weatherApiKey,
    String? mapsApiKey,
  }) {
    Logger.i('Setting API keys for external services', tag: 'DI');
    
    final dioClient = DioClient.instance;
    
    if (cricketApiKey != null) {
      dioClient.setCricketApiKey(cricketApiKey);
      Logger.d('Cricket API key set', tag: 'DI');
    }
    
    if (weatherApiKey != null) {
      dioClient.setWeatherApiKey(weatherApiKey);
      Logger.d('Weather API key set', tag: 'DI');
    }
    
    if (mapsApiKey != null) {
      dioClient.setMapsApiKey(mapsApiKey);
      Logger.d('Maps API key set', tag: 'DI');
    }
  }

  /// Set authentication token
  static void setAuthToken(String token) {
    Logger.i('Setting authentication token', tag: 'DI');
    DioClient.instance.setAuthToken(token);
  }

  /// Remove authentication token
  static void removeAuthToken() {
    Logger.i('Removing authentication token', tag: 'DI');
    DioClient.instance.removeAuthToken();
  }
}

/// Provider overrides for testing
class TestProviderOverrides {
  TestProviderOverrides._();

  /// Get provider overrides for testing
  static List<Override> getOverrides({
    DioClient? mockDioClient,
    NetworkInfo? mockNetworkInfo,
  }) {
    final overrides = <Override>[];

    if (mockDioClient != null) {
      overrides.add(dioClientProvider.overrideWithValue(mockDioClient));
    }

    if (mockNetworkInfo != null) {
      overrides.add(networkInfoProvider.overrideWithValue(mockNetworkInfo));
    }

    return overrides;
  }
}

/// Extension for WidgetRef to access common dependencies
extension DependencyExtensions on WidgetRef {
  /// Gets DioClient instance
  DioClient get dioClient => read(dioClientProvider);

  /// Gets NetworkInfo instance
  NetworkInfo get networkInfo => read(networkInfoProvider);

  /// Gets NetworkMonitor instance
  NetworkMonitor get networkMonitor => read(networkMonitorProvider);

  /// Watches network status
  AsyncValue<NetworkStatus> get networkStatus => watch(networkStatusProvider);

  /// Watches connectivity stream
  AsyncValue<ConnectivityResult> get connectivity => watch(connectivityStreamProvider);

  /// Watches network status stream
  AsyncValue<NetworkStatus> get networkStatusStream => watch(networkStatusStreamProvider);

  /// Watches internet connectivity
  AsyncValue<bool> get hasInternet => watch(hasInternetProvider);

  /// Watches network quality
  AsyncValue<NetworkQuality> get networkQuality => watch(networkQualityProvider);

  /// Watches network speed
  AsyncValue<NetworkSpeed> get networkSpeed => watch(networkSpeedProvider);
}

/// Extension for Ref to access common dependencies
extension RefDependencyExtensions on Ref {
  /// Gets DioClient instance
  DioClient get dioClient => read(dioClientProvider);

  /// Gets NetworkInfo instance
  NetworkInfo get networkInfo => read(networkInfoProvider);

  /// Gets NetworkMonitor instance
  NetworkMonitor get networkMonitor => read(networkMonitorProvider);

  /// Watches network status
  AsyncValue<NetworkStatus> get networkStatus => watch(networkStatusProvider);

  /// Watches connectivity stream
  AsyncValue<ConnectivityResult> get connectivity => watch(connectivityStreamProvider);

  /// Watches network status stream
  AsyncValue<NetworkStatus> get networkStatusStream => watch(networkStatusStreamProvider);

  /// Watches internet connectivity
  AsyncValue<bool> get hasInternet => watch(hasInternetProvider);

  /// Watches network quality
  AsyncValue<NetworkQuality> get networkQuality => watch(networkQualityProvider);

  /// Watches network speed
  AsyncValue<NetworkSpeed> get networkSpeed => watch(networkSpeedProvider);
}

