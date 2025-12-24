import 'package:intl/intl.dart';

/// Date and time formatting utilities
class DateFormatter {
  // Private constructor
  DateFormatter._();

  /// Format date to "MMM dd, yyyy" (e.g., "Dec 24, 2025")
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Format time to "hh:mm a" (e.g., "05:30 PM")
  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  /// Format date and time to "MMM dd, yyyy • hh:mm a" (e.g., "Dec 24, 2025 • 05:30 PM")
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
  }

  /// Format date to "EEEE, MMM dd" (e.g., "Monday, Dec 24")
  static String formatDayDate(DateTime date) {
    return DateFormat('EEEE, MMM dd').format(date);
  }

  /// Format relative time (e.g., "Today", "Tomorrow", "In 3 days")
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    
    final difference = targetDate.difference(today).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference == -1) {
      return 'Yesterday';
    } else if (difference > 1 && difference <= 7) {
      return 'In $difference days';
    } else if (difference < -1 && difference >= -7) {
      return '${-difference} days ago';
    } else if (difference < 0) {
      return 'Overdue';
    } else {
      return formatDate(date);
    }
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is in the past
  static bool isPast(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  /// Check if date is overdue (past and not completed)
  static bool isOverdue(DateTime dueDate, bool isCompleted) {
    return !isCompleted && isPast(dueDate);
  }

  /// Format timestamp to "MMM dd, yyyy"
  static String formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return formatDate(date);
  }

  /// Get time of day from DateTime
  static String getTimeOfDay(DateTime date) {
    final hour = date.hour;
    if (hour < 12) {
      return 'Morning';
    } else if (hour < 17) {
      return 'Afternoon';
    } else {
      return 'Evening';
    }
  }
}
