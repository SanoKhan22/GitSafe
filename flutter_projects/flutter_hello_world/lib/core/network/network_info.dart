import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../utils/logger.dart';

/// GullyCric Network Information Service
/// 
/// Provides network connectivity checking and monitoring
/// with support for different connection types and quality assessment
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Future<ConnectivityResult> get connectionType;
  Future<NetworkQuality> get networkQuality;
  Stream<ConnectivityResult> get onConnectivityChanged;
  Future<bool> hasInternetAccess();
  Future<NetworkSpeed> measureNetworkSpeed();
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;
  
  // Singleton instance
  static NetworkInfoImpl? _instance;
  static NetworkInfoImpl get instance => _instance ??= NetworkInfoImpl._internal();

  NetworkInfoImpl._internal() : _connectivity = Connectivity();

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Future<ConnectivityResult> get connectionType async {
    return await _connectivity.checkConnectivity();
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }

  @override
  Future<bool> hasInternetAccess() async {
    try {
      // Check basic connectivity first
      if (!await isConnected) {
        return false;
      }

      // Try to reach a reliable server
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      
      final hasAccess = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      
      CricketLogger.network(
        'Internet access check: ${hasAccess ? 'Available' : 'Not available'}'
      );
      
      return hasAccess;
    } catch (e) {
      CricketLogger.network('Internet access check failed', error: e);
      return false;
    }
  }

  @override
  Future<NetworkQuality> get networkQuality async {
    try {
      final connectionType = await this.connectionType;
      
      // If no connection, return poor quality
      if (connectionType == ConnectivityResult.none) {
        return NetworkQuality.poor;
      }

      // Check internet access
      if (!await hasInternetAccess()) {
        return NetworkQuality.poor;
      }

      // Measure network speed for quality assessment
      final speed = await measureNetworkSpeed();
      
      // Determine quality based on connection type and speed
      return _determineQualityFromSpeed(connectionType, speed);
    } catch (e) {
      CricketLogger.network('Network quality check failed', error: e);
      return NetworkQuality.poor;
    }
  }

  @override
  Future<NetworkSpeed> measureNetworkSpeed() async {
    try {
      final stopwatch = Stopwatch()..start();
      
      // Download a small test file to measure speed
      final socket = await Socket.connect('google.com', 80)
          .timeout(const Duration(seconds: 10));
      
      socket.write('GET / HTTP/1.1\r\nHost: google.com\r\n\r\n');
      
      var bytesReceived = 0;
      await for (final data in socket) {
        bytesReceived += data.length;
        if (bytesReceived > 1024) break; // Stop after 1KB
      }
      
      stopwatch.stop();
      socket.destroy();
      
      final durationMs = stopwatch.elapsedMilliseconds;
      final speedKbps = (bytesReceived * 8) / (durationMs / 1000) / 1024;
      
      final speed = NetworkSpeed(
        downloadSpeedKbps: speedKbps,
        uploadSpeedKbps: speedKbps * 0.8, // Estimate upload as 80% of download
        latencyMs: durationMs / 2, // Rough estimate
        timestamp: DateTime.now(),
      );

      CricketLogger.network(
        'Network speed measured: ${speed.downloadSpeedKbps.toStringAsFixed(2)} Kbps'
      );
      
      return speed;
    } catch (e) {
      CricketLogger.network('Network speed measurement failed', error: e);
      return NetworkSpeed(
        downloadSpeedKbps: 0,
        uploadSpeedKbps: 0,
        latencyMs: 999,
        timestamp: DateTime.now(),
      );
    }
  }

  /// Determines network quality based on connection type and speed
  NetworkQuality _determineQualityFromSpeed(
    ConnectivityResult connectionType, 
    NetworkSpeed speed
  ) {
    // Base quality on connection type
    var baseQuality = NetworkQuality.good;
    
    switch (connectionType) {
      case ConnectivityResult.wifi:
        baseQuality = NetworkQuality.excellent;
        break;
      case ConnectivityResult.mobile:
        baseQuality = NetworkQuality.good;
        break;
      case ConnectivityResult.ethernet:
        baseQuality = NetworkQuality.excellent;
        break;
      case ConnectivityResult.bluetooth:
        baseQuality = NetworkQuality.fair;
        break;
      case ConnectivityResult.vpn:
        baseQuality = NetworkQuality.good;
        break;
      case ConnectivityResult.other:
        baseQuality = NetworkQuality.fair;
        break;
      case ConnectivityResult.none:
        return NetworkQuality.poor;
    }

    // Adjust based on actual speed
    if (speed.downloadSpeedKbps < 100) {
      return NetworkQuality.poor;
    } else if (speed.downloadSpeedKbps < 500) {
      return NetworkQuality.fair;
    } else if (speed.downloadSpeedKbps < 2000) {
      return NetworkQuality.good;
    } else {
      return NetworkQuality.excellent;
    }
  }

  /// Gets connection type as human-readable string
  static String getConnectionTypeString(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.other:
        return 'Other';
      case ConnectivityResult.none:
        return 'No Connection';
    }
  }

  /// Gets network quality as human-readable string
  static String getNetworkQualityString(NetworkQuality quality) {
    switch (quality) {
      case NetworkQuality.excellent:
        return 'Excellent';
      case NetworkQuality.good:
        return 'Good';
      case NetworkQuality.fair:
        return 'Fair';
      case NetworkQuality.poor:
        return 'Poor';
    }
  }

  /// Checks if connection is suitable for cricket live updates
  Future<bool> isSuitableForLiveUpdates() async {
    final quality = await networkQuality;
    return quality == NetworkQuality.good || quality == NetworkQuality.excellent;
  }

  /// Checks if connection is suitable for video streaming
  Future<bool> isSuitableForVideo() async {
    final quality = await networkQuality;
    final speed = await measureNetworkSpeed();
    return quality == NetworkQuality.excellent && speed.downloadSpeedKbps > 1000;
  }

  /// Checks if connection is metered (mobile data)
  Future<bool> isMeteredConnection() async {
    final connectionType = await this.connectionType;
    return connectionType == ConnectivityResult.mobile;
  }
}

/// Network quality enumeration
enum NetworkQuality {
  excellent,
  good,
  fair,
  poor,
}

/// Network speed measurement
class NetworkSpeed {
  final double downloadSpeedKbps;
  final double uploadSpeedKbps;
  final double latencyMs;
  final DateTime timestamp;

  const NetworkSpeed({
    required this.downloadSpeedKbps,
    required this.uploadSpeedKbps,
    required this.latencyMs,
    required this.timestamp,
  });

  /// Gets download speed in Mbps
  double get downloadSpeedMbps => downloadSpeedKbps / 1024;

  /// Gets upload speed in Mbps
  double get uploadSpeedMbps => uploadSpeedKbps / 1024;

  /// Checks if speed is suitable for live cricket updates
  bool get isSuitableForLiveUpdates => downloadSpeedKbps > 100;

  /// Checks if speed is suitable for video streaming
  bool get isSuitableForVideo => downloadSpeedKbps > 1000;

  /// Gets speed category
  SpeedCategory get category {
    if (downloadSpeedKbps < 100) return SpeedCategory.slow;
    if (downloadSpeedKbps < 500) return SpeedCategory.moderate;
    if (downloadSpeedKbps < 2000) return SpeedCategory.fast;
    return SpeedCategory.veryFast;
  }

  @override
  String toString() {
    return 'NetworkSpeed(download: ${downloadSpeedKbps.toStringAsFixed(2)} Kbps, '
           'upload: ${uploadSpeedKbps.toStringAsFixed(2)} Kbps, '
           'latency: ${latencyMs.toStringAsFixed(2)} ms)';
  }
}

/// Speed category enumeration
enum SpeedCategory {
  slow,
  moderate,
  fast,
  veryFast,
}

/// Network monitoring service
class NetworkMonitor {
  final NetworkInfo _networkInfo;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  final StreamController<NetworkStatus> _statusController = 
      StreamController<NetworkStatus>.broadcast();

  NetworkMonitor(this._networkInfo);

  /// Stream of network status changes
  Stream<NetworkStatus> get onStatusChanged => _statusController.stream;

  /// Start monitoring network changes
  void startMonitoring() {
    _connectivitySubscription = _networkInfo.onConnectivityChanged.listen(
      (result) async {
        final status = await _createNetworkStatus(result);
        _statusController.add(status);
        
        CricketLogger.network(
          'Network status changed: ${NetworkInfoImpl.getConnectionTypeString(result)}'
        );
      },
    );
  }

  /// Stop monitoring network changes
  void stopMonitoring() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  /// Get current network status
  Future<NetworkStatus> getCurrentStatus() async {
    final connectionType = await _networkInfo.connectionType;
    return await _createNetworkStatus(connectionType);
  }

  /// Create network status from connectivity result
  Future<NetworkStatus> _createNetworkStatus(ConnectivityResult result) async {
    final isConnected = result != ConnectivityResult.none;
    final hasInternet = isConnected ? await _networkInfo.hasInternetAccess() : false;
    final quality = isConnected ? await _networkInfo.networkQuality : NetworkQuality.poor;
    final speed = isConnected ? await _networkInfo.measureNetworkSpeed() : null;

    return NetworkStatus(
      connectionType: result,
      isConnected: isConnected,
      hasInternetAccess: hasInternet,
      quality: quality,
      speed: speed,
      timestamp: DateTime.now(),
    );
  }

  /// Dispose resources
  void dispose() {
    stopMonitoring();
    _statusController.close();
  }
}

/// Network status information
class NetworkStatus {
  final ConnectivityResult connectionType;
  final bool isConnected;
  final bool hasInternetAccess;
  final NetworkQuality quality;
  final NetworkSpeed? speed;
  final DateTime timestamp;

  const NetworkStatus({
    required this.connectionType,
    required this.isConnected,
    required this.hasInternetAccess,
    required this.quality,
    this.speed,
    required this.timestamp,
  });

  /// Gets connection type as string
  String get connectionTypeString => 
      NetworkInfoImpl.getConnectionTypeString(connectionType);

  /// Gets quality as string
  String get qualityString => 
      NetworkInfoImpl.getNetworkQualityString(quality);

  /// Checks if suitable for cricket live updates
  bool get isSuitableForLiveUpdates => 
      hasInternetAccess && 
      (quality == NetworkQuality.good || quality == NetworkQuality.excellent);

  /// Checks if suitable for video streaming
  bool get isSuitableForVideo => 
      hasInternetAccess && 
      quality == NetworkQuality.excellent && 
      (speed?.isSuitableForVideo ?? false);

  /// Checks if connection is metered
  bool get isMetered => connectionType == ConnectivityResult.mobile;

  @override
  String toString() {
    return 'NetworkStatus(type: $connectionTypeString, '
           'connected: $isConnected, internet: $hasInternetAccess, '
           'quality: $qualityString)';
  }
}