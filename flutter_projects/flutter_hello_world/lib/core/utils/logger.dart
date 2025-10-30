import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/foundation.dart';

/// GullyCric Logging Utility
/// 
/// Provides comprehensive logging functionality with different levels,
/// file output, and cricket-specific logging categories
class Logger {
  static const String _defaultTag = 'GullyCric';
  static const int _maxLogLength = 800; // Max length per log line
  
  // Log levels
  static const int _verbose = 0;
  static const int _debug = 1;
  static const int _info = 2;
  static const int _warning = 3;
  static const int _error = 4;
  static const int _wtf = 5; // What a Terrible Failure
  
  // Current log level (can be changed for different environments)
  static int _currentLogLevel = kDebugMode ? _verbose : _info;
  
  // Log file path (for file logging in release mode)
  static String? _logFilePath;
  
  // Enable/disable file logging
  static bool _fileLoggingEnabled = false;

  Logger._(); // Private constructor

  /// Sets the current log level
  static void setLogLevel(LogLevel level) {
    _currentLogLevel = level.value;
  }

  /// Enables file logging with specified path
  static void enableFileLogging(String filePath) {
    _logFilePath = filePath;
    _fileLoggingEnabled = true;
  }

  /// Disables file logging
  static void disableFileLogging() {
    _fileLoggingEnabled = false;
    _logFilePath = null;
  }

  /// Logs verbose message (lowest priority)
  static void v(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(_verbose, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Logs debug message
  static void d(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(_debug, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Logs info message
  static void i(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(_info, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Logs warning message
  static void w(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(_warning, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Logs error message
  static void e(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(_error, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Logs WTF (What a Terrible Failure) message
  static void wtf(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(_wtf, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Main logging method
  static void _log(
    int level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (level < _currentLogLevel) return;

    final logTag = tag ?? _defaultTag;
    final levelString = _getLevelString(level);
    final timestamp = DateTime.now().toIso8601String();
    
    // Format the log message
    String logMessage = '[$timestamp] [$levelString] [$logTag] $message';
    
    // Add error information if provided
    if (error != null) {
      logMessage += '\nError: $error';
    }
    
    // Add stack trace if provided
    if (stackTrace != null) {
      logMessage += '\nStackTrace: $stackTrace';
    }

    // Split long messages
    final lines = _splitMessage(logMessage);
    
    for (final line in lines) {
      // Console logging
      if (kDebugMode) {
        developer.log(
          line,
          name: logTag,
          level: _getDeveloperLogLevel(level),
          error: error,
          stackTrace: stackTrace,
        );
      } else {
        // In release mode, use print for critical logs
        if (level >= _error) {
          print(line);
        }
      }
      
      // File logging
      if (_fileLoggingEnabled && _logFilePath != null) {
        _writeToFile(line);
      }
    }
  }

  /// Splits long messages into multiple lines
  static List<String> _splitMessage(String message) {
    if (message.length <= _maxLogLength) {
      return [message];
    }

    final lines = <String>[];
    int start = 0;
    
    while (start < message.length) {
      int end = start + _maxLogLength;
      if (end > message.length) {
        end = message.length;
      }
      
      lines.add(message.substring(start, end));
      start = end;
    }
    
    return lines;
  }

  /// Gets level string representation
  static String _getLevelString(int level) {
    switch (level) {
      case _verbose: return 'V';
      case _debug: return 'D';
      case _info: return 'I';
      case _warning: return 'W';
      case _error: return 'E';
      case _wtf: return 'WTF';
      default: return 'UNKNOWN';
    }
  }

  /// Gets developer log level for dart:developer
  static int _getDeveloperLogLevel(int level) {
    switch (level) {
      case _verbose: return 500;
      case _debug: return 700;
      case _info: return 800;
      case _warning: return 900;
      case _error: return 1000;
      case _wtf: return 1200;
      default: return 800;
    }
  }

  /// Writes log to file
  static void _writeToFile(String message) {
    try {
      final file = File(_logFilePath!);
      file.writeAsStringSync('$message\n', mode: FileMode.append);
    } catch (e) {
      // Silently fail file logging to avoid infinite loops
      if (kDebugMode) {
        print('Failed to write log to file: $e');
      }
    }
  }

  /// Clears log file
  static Future<void> clearLogFile() async {
    if (_logFilePath != null) {
      try {
        final file = File(_logFilePath!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        Logger.e('Failed to clear log file', error: e);
      }
    }
  }

  /// Gets log file content
  static Future<String?> getLogFileContent() async {
    if (_logFilePath != null) {
      try {
        final file = File(_logFilePath!);
        if (await file.exists()) {
          return await file.readAsString();
        }
      } catch (e) {
        Logger.e('Failed to read log file', error: e);
      }
    }
    return null;
  }
}

/// Log level enumeration
enum LogLevel {
  verbose(0),
  debug(1),
  info(2),
  warning(3),
  error(4),
  wtf(5);

  const LogLevel(this.value);
  final int value;
}

/// Cricket-specific logging utilities
class CricketLogger {
  CricketLogger._();

  // Cricket-specific tags
  static const String _matchTag = 'Match';
  static const String _scoreTag = 'Score';
  static const String _playerTag = 'Player';
  static const String _teamTag = 'Team';
  static const String _authTag = 'Auth';
  static const String _networkTag = 'Network';
  static const String _databaseTag = 'Database';
  static const String _uiTag = 'UI';

  /// Logs match-related events
  static void match(String message, {Object? error, StackTrace? stackTrace}) {
    Logger.i(message, tag: _matchTag, error: error, stackTrace: stackTrace);
  }

  /// Logs score updates
  static void score(String message, {Object? error, StackTrace? stackTrace}) {
    Logger.i(message, tag: _scoreTag, error: error, stackTrace: stackTrace);
  }

  /// Logs player-related events
  static void player(String message, {Object? error, StackTrace? stackTrace}) {
    Logger.i(message, tag: _playerTag, error: error, stackTrace: stackTrace);
  }

  /// Logs team-related events
  static void team(String message, {Object? error, StackTrace? stackTrace}) {
    Logger.i(message, tag: _teamTag, error: error, stackTrace: stackTrace);
  }

  /// Logs authentication events
  static void auth(String message, {Object? error, StackTrace? stackTrace}) {
    Logger.i(message, tag: _authTag, error: error, stackTrace: stackTrace);
  }

  /// Logs network requests and responses
  static void network(String message, {Object? error, StackTrace? stackTrace}) {
    Logger.d(message, tag: _networkTag, error: error, stackTrace: stackTrace);
  }

  /// Logs database operations
  static void database(String message, {Object? error, StackTrace? stackTrace}) {
    Logger.d(message, tag: _databaseTag, error: error, stackTrace: stackTrace);
  }

  /// Logs UI events and interactions
  static void ui(String message, {Object? error, StackTrace? stackTrace}) {
    Logger.d(message, tag: _uiTag, error: error, stackTrace: stackTrace);
  }

  /// Logs match start event
  static void matchStarted(String matchId, String title) {
    match('Match started: $title (ID: $matchId)');
  }

  /// Logs match end event
  static void matchEnded(String matchId, String title, String result) {
    match('Match ended: $title (ID: $matchId) - Result: $result');
  }

  /// Logs score update event
  static void scoreUpdated(String matchId, String newScore) {
    score('Score updated for match $matchId: $newScore');
  }

  /// Logs player action
  static void playerAction(String playerId, String playerName, String action) {
    player('Player action: $playerName ($playerId) - $action');
  }

  /// Logs team formation
  static void teamFormed(String teamId, String teamName, int playerCount) {
    team('Team formed: $teamName ($teamId) with $playerCount players');
  }

  /// Logs user login
  static void userLogin(String userId, String email) {
    auth('User logged in: $email (ID: $userId)');
  }

  /// Logs user logout
  static void userLogout(String userId) {
    auth('User logged out: ID $userId');
  }

  /// Logs API request
  static void apiRequest(String method, String endpoint) {
    network('API Request: $method $endpoint');
  }

  /// Logs API response
  static void apiResponse(String method, String endpoint, int statusCode, {int? duration}) {
    final durationText = duration != null ? ' (${duration}ms)' : '';
    network('API Response: $method $endpoint - $statusCode$durationText');
  }

  /// Logs API error
  static void apiError(String method, String endpoint, Object error) {
    Logger.e('API Error: $method $endpoint', tag: _networkTag, error: error);
  }

  /// Logs database query
  static void dbQuery(String query, {int? duration}) {
    final durationText = duration != null ? ' (${duration}ms)' : '';
    database('DB Query: $query$durationText');
  }

  /// Logs database error
  static void dbError(String operation, Object error) {
    Logger.e('DB Error: $operation', tag: _databaseTag, error: error);
  }

  /// Logs screen navigation
  static void screenNavigation(String from, String to) {
    ui('Navigation: $from -> $to');
  }

  /// Logs user interaction
  static void userInteraction(String action, {Map<String, dynamic>? data}) {
    final dataText = data != null ? ' - Data: $data' : '';
    ui('User interaction: $action$dataText');
  }
}

/// Performance logging utilities
class PerformanceLogger {
  PerformanceLogger._();

  static const String _performanceTag = 'Performance';
  static final Map<String, Stopwatch> _stopwatches = {};

  /// Starts timing an operation
  static void startTiming(String operationName) {
    final stopwatch = Stopwatch()..start();
    _stopwatches[operationName] = stopwatch;
    Logger.d('Started timing: $operationName', tag: _performanceTag);
  }

  /// Ends timing an operation and logs the duration
  static void endTiming(String operationName) {
    final stopwatch = _stopwatches.remove(operationName);
    if (stopwatch != null) {
      stopwatch.stop();
      final duration = stopwatch.elapsedMilliseconds;
      Logger.i('Operation completed: $operationName (${duration}ms)', tag: _performanceTag);
    } else {
      Logger.w('No timing started for operation: $operationName', tag: _performanceTag);
    }
  }

  /// Times a function execution
  static T timeFunction<T>(String operationName, T Function() function) {
    startTiming(operationName);
    try {
      final result = function();
      endTiming(operationName);
      return result;
    } catch (e) {
      endTiming(operationName);
      Logger.e('Error in timed operation: $operationName', tag: _performanceTag, error: e);
      rethrow;
    }
  }

  /// Times an async function execution
  static Future<T> timeAsyncFunction<T>(String operationName, Future<T> Function() function) async {
    startTiming(operationName);
    try {
      final result = await function();
      endTiming(operationName);
      return result;
    } catch (e) {
      endTiming(operationName);
      Logger.e('Error in timed async operation: $operationName', tag: _performanceTag, error: e);
      rethrow;
    }
  }

  /// Logs memory usage (if available)
  static void logMemoryUsage(String context) {
    // This is a placeholder - actual memory monitoring would require platform-specific code
    Logger.d('Memory usage check: $context', tag: _performanceTag);
  }

  /// Logs frame rate information
  static void logFrameRate(double fps) {
    Logger.d('Frame rate: ${fps.toStringAsFixed(1)} FPS', tag: _performanceTag);
  }
}

/// Debug logging utilities for development
class DebugLogger {
  DebugLogger._();

  static const String _debugTag = 'Debug';

  /// Logs widget build
  static void widgetBuild(String widgetName) {
    if (kDebugMode) {
      Logger.v('Widget built: $widgetName', tag: _debugTag);
    }
  }

  /// Logs state change
  static void stateChange(String stateName, dynamic oldValue, dynamic newValue) {
    if (kDebugMode) {
      Logger.d('State change: $stateName ($oldValue -> $newValue)', tag: _debugTag);
    }
  }

  /// Logs provider update
  static void providerUpdate(String providerName, dynamic value) {
    if (kDebugMode) {
      Logger.d('Provider update: $providerName = $value', tag: _debugTag);
    }
  }

  /// Logs lifecycle event
  static void lifecycle(String event, String context) {
    if (kDebugMode) {
      Logger.d('Lifecycle: $event in $context', tag: _debugTag);
    }
  }

  /// Logs method entry
  static void methodEntry(String className, String methodName, [Map<String, dynamic>? params]) {
    if (kDebugMode) {
      final paramsText = params != null ? ' with params: $params' : '';
      Logger.v('Method entry: $className.$methodName$paramsText', tag: _debugTag);
    }
  }

  /// Logs method exit
  static void methodExit(String className, String methodName, [dynamic result]) {
    if (kDebugMode) {
      final resultText = result != null ? ' returning: $result' : '';
      Logger.v('Method exit: $className.$methodName$resultText', tag: _debugTag);
    }
  }
}