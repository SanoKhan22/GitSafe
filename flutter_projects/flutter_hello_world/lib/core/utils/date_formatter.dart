import 'package:intl/intl.dart';

/// GullyCric Date Formatting Utilities
/// 
/// Provides consistent date and time formatting throughout the app
/// with cricket-specific formats and localization support
class DateFormatter {
  DateFormatter._(); // Private constructor to prevent instantiation

  // Standard date formats
  static const String _standardDateFormat = 'dd/MM/yyyy';
  static const String _standardTimeFormat = 'HH:mm';
  static const String _standardDateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String _isoDateFormat = 'yyyy-MM-dd';
  static const String _isoDateTimeFormat = 'yyyy-MM-ddTHH:mm:ss';

  // Cricket-specific formats
  static const String _matchDateFormat = 'EEE, dd MMM yyyy';
  static const String _matchTimeFormat = 'h:mm a';
  static const String _matchDateTimeFormat = 'EEE, dd MMM yyyy • h:mm a';
  static const String _scoreDateFormat = 'dd MMM';
  static const String _liveTimeFormat = 'mm:ss';

  // Relative time formats
  static const String _relativeShortFormat = 'MMM dd';
  static const String _relativeYearFormat = 'MMM dd, yyyy';

  // Formatters
  static final DateFormat _standardDate = DateFormat(_standardDateFormat);
  static final DateFormat _standardTime = DateFormat(_standardTimeFormat);
  static final DateFormat _standardDateTime = DateFormat(_standardDateTimeFormat);
  static final DateFormat _isoDate = DateFormat(_isoDateFormat);
  static final DateFormat _isoDateTime = DateFormat(_isoDateTimeFormat);
  
  static final DateFormat _matchDate = DateFormat(_matchDateFormat);
  static final DateFormat _matchTime = DateFormat(_matchTimeFormat);
  static final DateFormat _matchDateTime = DateFormat(_matchDateTimeFormat);
  static final DateFormat _scoreDate = DateFormat(_scoreDateFormat);
  static final DateFormat _liveTime = DateFormat(_liveTimeFormat);
  
  static final DateFormat _relativeShort = DateFormat(_relativeShortFormat);
  static final DateFormat _relativeYear = DateFormat(_relativeYearFormat);

  /// Formats date in standard format (dd/MM/yyyy)
  static String formatStandardDate(DateTime date) {
    return _standardDate.format(date);
  }

  /// Formats time in standard format (HH:mm)
  static String formatStandardTime(DateTime date) {
    return _standardTime.format(date);
  }

  /// Formats date and time in standard format (dd/MM/yyyy HH:mm)
  static String formatStandardDateTime(DateTime date) {
    return _standardDateTime.format(date);
  }

  /// Formats date in ISO format (yyyy-MM-dd)
  static String formatIsoDate(DateTime date) {
    return _isoDate.format(date);
  }

  /// Formats date and time in ISO format (yyyy-MM-ddTHH:mm:ss)
  static String formatIsoDateTime(DateTime date) {
    return _isoDateTime.format(date);
  }

  /// Formats date for match display (Wed, 15 Mar 2024)
  static String formatMatchDate(DateTime date) {
    return _matchDate.format(date);
  }

  /// Formats time for match display (2:30 PM)
  static String formatMatchTime(DateTime date) {
    return _matchTime.format(date);
  }

  /// Formats date and time for match display (Wed, 15 Mar 2024 • 2:30 PM)
  static String formatMatchDateTime(DateTime date) {
    return _matchDateTime.format(date);
  }

  /// Formats date for score display (15 Mar)
  static String formatScoreDate(DateTime date) {
    return _scoreDate.format(date);
  }

  /// Formats time for live match display (45:30)
  static String formatLiveTime(DateTime date) {
    return _liveTime.format(date);
  }

  /// Formats duration in cricket-friendly format (2h 30m)
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      if (minutes > 0) {
        return '${hours}h ${minutes}m';
      }
      return '${hours}h';
    } else if (minutes > 0) {
      if (seconds > 0) {
        return '${minutes}m ${seconds}s';
      }
      return '${minutes}m';
    } else {
      return '${seconds}s';
    }
  }

  /// Formats match duration specifically (3h 45m)
  static String formatMatchDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
    } else {
      return '${minutes}m';
    }
  }

  /// Formats relative time (e.g., "2 hours ago", "Yesterday", "Last week")
  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      // Today
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        } else if (difference.inMinutes == 1) {
          return '1 minute ago';
        } else {
          return '${difference.inMinutes} minutes ago';
        }
      } else if (difference.inHours == 1) {
        return '1 hour ago';
      } else {
        return '${difference.inHours} hours ago';
      }
    } else if (difference.inDays == 1) {
      // Yesterday
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      // This week
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      // This month
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
    } else if (difference.inDays < 365) {
      // This year
      return _relativeShort.format(date);
    } else {
      // Previous years
      return _relativeYear.format(date);
    }
  }

  /// Formats time until a future date (e.g., "in 2 hours", "Tomorrow")
  static String formatTimeUntil(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.isNegative) {
      return formatRelativeTime(date);
    }

    if (difference.inDays == 0) {
      // Today
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Now';
        } else if (difference.inMinutes == 1) {
          return 'In 1 minute';
        } else {
          return 'In ${difference.inMinutes} minutes';
        }
      } else if (difference.inHours == 1) {
        return 'In 1 hour';
      } else {
        return 'In ${difference.inHours} hours';
      }
    } else if (difference.inDays == 1) {
      // Tomorrow
      return 'Tomorrow';
    } else if (difference.inDays < 7) {
      // This week
      return 'In ${difference.inDays} days';
    } else {
      // Future date
      return formatMatchDate(date);
    }
  }

  /// Formats match status time (Live, Upcoming, Completed)
  static String formatMatchStatus(DateTime? startTime, DateTime? endTime) {
    final now = DateTime.now();

    if (startTime == null) {
      return 'TBD';
    }

    if (endTime != null && now.isAfter(endTime)) {
      return 'Completed';
    }

    if (now.isAfter(startTime)) {
      if (endTime == null || now.isBefore(endTime)) {
        return 'Live';
      }
    }

    return formatTimeUntil(startTime);
  }

  /// Formats age from birth date
  static String formatAge(DateTime birthDate) {
    final now = DateTime.now();
    final age = now.year - birthDate.year;
    
    if (now.month < birthDate.month || 
        (now.month == birthDate.month && now.day < birthDate.day)) {
      return '${age - 1} years';
    }
    
    return '$age years';
  }

  /// Formats cricket over (e.g., "15.3" for 15 overs and 3 balls)
  static String formatOver(int balls) {
    final overs = balls ~/ 6;
    final remainingBalls = balls % 6;
    
    if (remainingBalls == 0) {
      return '$overs';
    }
    
    return '$overs.$remainingBalls';
  }

  /// Formats cricket run rate (e.g., "7.25")
  static String formatRunRate(double runRate) {
    return runRate.toStringAsFixed(2);
  }

  /// Formats cricket strike rate (e.g., "125.50")
  static String formatStrikeRate(double strikeRate) {
    return strikeRate.toStringAsFixed(2);
  }

  /// Formats cricket economy rate (e.g., "6.75")
  static String formatEconomyRate(double economyRate) {
    return economyRate.toStringAsFixed(2);
  }

  /// Formats cricket average (e.g., "45.67")
  static String formatAverage(double average) {
    return average.toStringAsFixed(2);
  }

  /// Parses date from string in standard format
  static DateTime? parseStandardDate(String dateString) {
    try {
      return _standardDate.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Parses date and time from string in standard format
  static DateTime? parseStandardDateTime(String dateTimeString) {
    try {
      return _standardDateTime.parse(dateTimeString);
    } catch (e) {
      return null;
    }
  }

  /// Parses date from ISO string
  static DateTime? parseIsoDate(String dateString) {
    try {
      return _isoDate.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Parses date and time from ISO string
  static DateTime? parseIsoDateTime(String dateTimeString) {
    try {
      return DateTime.parse(dateTimeString);
    } catch (e) {
      return null;
    }
  }

  /// Checks if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  /// Checks if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && 
           date.month == yesterday.month && 
           date.day == yesterday.day;
  }

  /// Checks if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && 
           date.month == tomorrow.month && 
           date.day == tomorrow.day;
  }

  /// Checks if date is in current week
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
           date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Gets start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Gets end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Gets start of week (Monday)
  static DateTime startOfWeek(DateTime date) {
    final startOfDay = DateFormatter.startOfDay(date);
    return startOfDay.subtract(Duration(days: date.weekday - 1));
  }

  /// Gets end of week (Sunday)
  static DateTime endOfWeek(DateTime date) {
    final startOfWeek = DateFormatter.startOfWeek(date);
    return endOfDay(startOfWeek.add(const Duration(days: 6)));
  }
}