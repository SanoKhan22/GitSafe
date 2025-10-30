import 'dart:math' show pow;
import 'package:flutter/material.dart';

/// GullyCric Dart and Flutter Extensions
/// 
/// Provides useful extensions for common operations throughout the app
/// with cricket-specific utilities and enhanced functionality

// String Extensions
extension StringExtensions on String {
  /// Capitalizes the first letter of the string
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Capitalizes the first letter of each word
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.isEmpty ? word : word.capitalize)
        .join(' ');
  }

  /// Removes extra whitespace and trims
  String get clean {
    return trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Checks if string is a valid email
  bool get isValidEmail {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(this);
  }

  /// Checks if string is a valid phone number
  bool get isValidPhoneNumber {
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  }

  /// Checks if string contains only letters
  bool get isAlpha {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(this);
  }

  /// Checks if string contains only numbers
  bool get isNumeric {
    return RegExp(r'^[0-9]+$').hasMatch(this);
  }

  /// Checks if string contains only alphanumeric characters
  bool get isAlphaNumeric {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);
  }

  /// Converts string to snake_case
  String get toSnakeCase {
    return replaceAllMapped(RegExp(r'[A-Z]'), (match) => '_${match.group(0)!.toLowerCase()}')
        .replaceAll(RegExp(r'^_'), '');
  }

  /// Converts string to camelCase
  String get toCamelCase {
    final words = split(RegExp(r'[\s_-]+'));
    if (words.isEmpty) return this;
    
    return words.first.toLowerCase() + 
           words.skip(1).map((word) => word.capitalize).join();
  }

  /// Converts string to PascalCase
  String get toPascalCase {
    return split(RegExp(r'[\s_-]+'))
        .map((word) => word.capitalize)
        .join();
  }

  /// Truncates string to specified length with ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Masks string for privacy (e.g., email, phone)
  String mask({int visibleStart = 2, int visibleEnd = 2, String maskChar = '*'}) {
    if (length <= visibleStart + visibleEnd) return this;
    
    final start = substring(0, visibleStart);
    final end = substring(length - visibleEnd);
    final maskLength = length - visibleStart - visibleEnd;
    
    return '$start${maskChar * maskLength}$end';
  }

  /// Removes all non-numeric characters
  String get numbersOnly {
    return replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// Removes all non-alphabetic characters
  String get lettersOnly {
    return replaceAll(RegExp(r'[^a-zA-Z]'), '');
  }

  /// Formats as currency (simple implementation)
  String toCurrency({String symbol = '\$', int decimals = 2}) {
    final number = double.tryParse(this) ?? 0.0;
    return '$symbol${number.toStringAsFixed(decimals)}';
  }

  /// Cricket-specific: Formats as over (e.g., "15.3")
  String get asOver {
    final balls = int.tryParse(this) ?? 0;
    final overs = balls ~/ 6;
    final remainingBalls = balls % 6;
    return remainingBalls == 0 ? '$overs' : '$overs.$remainingBalls';
  }

  /// Cricket-specific: Formats as run rate
  String get asRunRate {
    final rate = double.tryParse(this) ?? 0.0;
    return rate.toStringAsFixed(2);
  }
}

// Nullable String Extensions
extension NullableStringExtensions on String? {
  /// Checks if string is null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Checks if string is null, empty, or only whitespace
  bool get isNullOrWhitespace => this == null || this!.trim().isEmpty;

  /// Returns the string or a default value if null/empty
  String orDefault(String defaultValue) {
    return isNullOrEmpty ? defaultValue : this!;
  }

  /// Returns the string or null if empty
  String? get orNull => isNullOrEmpty ? null : this;
}

// Integer Extensions
extension IntExtensions on int {
  /// Formats number with thousand separators
  String get withCommas {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );
  }

  /// Converts to ordinal string (1st, 2nd, 3rd, etc.)
  String get ordinal {
    if (this >= 11 && this <= 13) return '${this}th';
    
    switch (this % 10) {
      case 1: return '${this}st';
      case 2: return '${this}nd';
      case 3: return '${this}rd';
      default: return '${this}th';
    }
  }

  /// Checks if number is even
  bool get isEven => this % 2 == 0;

  /// Checks if number is odd
  bool get isOdd => this % 2 != 0;

  /// Cricket-specific: Converts balls to overs
  String get asOvers {
    final overs = this ~/ 6;
    final balls = this % 6;
    return balls == 0 ? '$overs' : '$overs.$balls';
  }

  /// Cricket-specific: Formats as score (runs/wickets)
  String scoreWith(int wickets) => '$this/$wickets';
}

// Double Extensions
extension DoubleExtensions on double {
  /// Rounds to specified decimal places
  double roundToDecimal(int places) {
    final mod = pow(10.0, places);
    return ((this * mod).round().toDouble() / mod);
  }

  /// Formats as percentage
  String toPercentage({int decimals = 1}) {
    return '${(this * 100).toStringAsFixed(decimals)}%';
  }

  /// Cricket-specific: Formats as run rate
  String get asRunRate => toStringAsFixed(2);

  /// Cricket-specific: Formats as strike rate
  String get asStrikeRate => toStringAsFixed(2);

  /// Cricket-specific: Formats as economy rate
  String get asEconomyRate => toStringAsFixed(2);

  /// Cricket-specific: Formats as average
  String get asAverage => toStringAsFixed(2);
}

// DateTime Extensions
extension DateTimeExtensions on DateTime {
  /// Checks if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Checks if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  /// Checks if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  /// Gets start of day
  DateTime get startOfDay => DateTime(year, month, day);

  /// Gets end of day
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Gets start of week (Monday)
  DateTime get startOfWeek {
    return startOfDay.subtract(Duration(days: weekday - 1));
  }

  /// Gets end of week (Sunday)
  DateTime get endOfWeek {
    return startOfWeek.add(const Duration(days: 6)).endOfDay;
  }

  /// Formats as time ago string
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Formats as relative date string
  String get relativeDate {
    if (isToday) return 'Today';
    if (isYesterday) return 'Yesterday';
    if (isTomorrow) return 'Tomorrow';
    
    final now = DateTime.now();
    final difference = now.difference(this).inDays;
    
    if (difference > 0 && difference < 7) {
      return '$difference day${difference == 1 ? '' : 's'} ago';
    } else if (difference < 0 && difference > -7) {
      return 'In ${difference.abs()} day${difference.abs() == 1 ? '' : 's'}';
    }
    
    return toString().split(' ')[0]; // Return date part
  }
}

// List Extensions
extension ListExtensions<T> on List<T> {
  /// Gets element at index or null if out of bounds
  T? elementAtOrNull(int index) {
    return index >= 0 && index < length ? this[index] : null;
  }

  /// Checks if list is null or empty
  bool get isNullOrEmpty => isEmpty;

  /// Gets random element from list
  T? get random {
    if (isEmpty) return null;
    return this[(DateTime.now().millisecondsSinceEpoch % length)];
  }

  /// Splits list into chunks of specified size
  List<List<T>> chunk(int size) {
    final chunks = <List<T>>[];
    for (int i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }

  /// Groups elements by a key function
  Map<K, List<T>> groupBy<K>(K Function(T) keyFunction) {
    final map = <K, List<T>>{};
    for (final element in this) {
      final key = keyFunction(element);
      map.putIfAbsent(key, () => <T>[]).add(element);
    }
    return map;
  }
}

// Map Extensions
extension MapExtensions<K, V> on Map<K, V> {
  /// Gets value by key or returns default
  V getOrDefault(K key, V defaultValue) {
    return containsKey(key) ? this[key]! : defaultValue;
  }

  /// Gets value by key or null
  V? getOrNull(K key) {
    return containsKey(key) ? this[key] : null;
  }
}

// BuildContext Extensions
extension BuildContextExtensions on BuildContext {
  /// Gets screen size
  Size get screenSize => MediaQuery.of(this).size;

  /// Gets screen width
  double get screenWidth => screenSize.width;

  /// Gets screen height
  double get screenHeight => screenSize.height;

  /// Checks if device is in portrait mode
  bool get isPortrait => screenHeight > screenWidth;

  /// Checks if device is in landscape mode
  bool get isLandscape => screenWidth > screenHeight;

  /// Gets theme data
  ThemeData get theme => Theme.of(this);

  /// Gets text theme
  TextTheme get textTheme => theme.textTheme;

  /// Gets color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Checks if dark mode is enabled
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Shows snackbar with message
  void showSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }

  /// Shows error snackbar
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.error,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Shows success snackbar
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Dismisses keyboard
  void dismissKeyboard() {
    FocusScope.of(this).unfocus();
  }

  /// Navigates to route
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }

  /// Replaces current route
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(String routeName, {Object? arguments, TO? result}) {
    return Navigator.of(this).pushReplacementNamed<T, TO>(routeName, arguments: arguments, result: result);
  }

  /// Pops current route
  void pop<T>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }

  /// Checks if can pop
  bool get canPop => Navigator.of(this).canPop();
}

// Color Extensions
extension ColorExtensions on Color {
  /// Converts color to hex string
  String get toHex {
    return '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  /// Creates a lighter version of the color
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// Creates a darker version of the color
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// Gets contrasting color (black or white)
  Color get contrastColor {
    final luminance = computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

// Duration Extensions
extension DurationExtensions on Duration {
  /// Formats duration as human readable string
  String get humanReadable {
    if (inDays > 0) {
      return '${inDays}d ${inHours.remainder(24)}h';
    } else if (inHours > 0) {
      return '${inHours}h ${inMinutes.remainder(60)}m';
    } else if (inMinutes > 0) {
      return '${inMinutes}m ${inSeconds.remainder(60)}s';
    } else {
      return '${inSeconds}s';
    }
  }

  /// Formats as MM:SS
  String get asMinutesSeconds {
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Formats as HH:MM:SS
  String get asHoursMinutesSeconds {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

