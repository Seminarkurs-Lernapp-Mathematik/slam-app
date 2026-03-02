import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Structured logging system for the app
/// 
/// Usage:
/// ```dart
/// Logger.info('User logged in', tag: 'Auth', data: {'userId': id});
/// Logger.error('Failed to load data', error: e, stackTrace: st);
/// ```

enum LogLevel {
  verbose,
  debug,
  info,
  warning,
  error,
  fatal,
}

class Logger {
  static LogLevel _minLevel = kDebugMode ? LogLevel.verbose : LogLevel.warning;
  static bool _enableConsole = true;
  static final List<LogEntry> _recentLogs = [];
  static const int _maxRecentLogs = 100;

  /// Configure logger
  static void configure({
    LogLevel? minLevel,
    bool? enableConsole,
  }) {
    _minLevel = minLevel ?? _minLevel;
    _enableConsole = enableConsole ?? _enableConsole;
  }

  // ============================================================================
  // LOG METHODS
  // ============================================================================

  static void verbose(String message, {String? tag, Map<String, dynamic>? data}) {
    _log(LogLevel.verbose, message, tag: tag, data: data);
  }

  static void debug(String message, {String? tag, Map<String, dynamic>? data}) {
    _log(LogLevel.debug, message, tag: tag, data: data);
  }

  static void info(String message, {String? tag, Map<String, dynamic>? data}) {
    _log(LogLevel.info, message, tag: tag, data: data);
  }

  static void warning(String message, {String? tag, Map<String, dynamic>? data, Object? error}) {
    _log(LogLevel.warning, message, tag: tag, data: data, error: error);
  }

  static void error(
    String message, {
    String? tag,
    Map<String, dynamic>? data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.error, message, tag: tag, data: data, error: error, stackTrace: stackTrace);
  }

  static void fatal(
    String message, {
    String? tag,
    Map<String, dynamic>? data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.fatal, message, tag: tag, data: data, error: error, stackTrace: stackTrace);
  }

  // ============================================================================
  // INTERNAL
  // ============================================================================

  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    Map<String, dynamic>? data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (level.index < _minLevel.index) return;

    final entry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: message,
      tag: tag ?? 'App',
      data: data,
      error: error?.toString(),
      stackTrace: stackTrace?.toString(),
    );

    // Store recent logs
    _recentLogs.add(entry);
    if (_recentLogs.length > _maxRecentLogs) {
      _recentLogs.removeAt(0);
    }

    // Console output
    if (_enableConsole) {
      _printToConsole(entry);
    }

    // Development logging
    if (kDebugMode) {
      developer.log(
        message,
        name: entry.tag,
        error: error,
        stackTrace: stackTrace,
        time: entry.timestamp,
      );
    }
  }

  static void _printToConsole(LogEntry entry) {
    final emoji = _getEmoji(entry.level);
    final time = entry.timestamp.toIso8601String().split('T')[1].split('.')[0];
    final prefix = '[$time] $emoji [${entry.tag}] ${entry.level.name.toUpperCase()}';
    
    // ignore: avoid_print
    print('$prefix: ${entry.message}');
    
    if (entry.data != null && entry.data!.isNotEmpty) {
      // ignore: avoid_print
      print('  Data: ${entry.data}');
    }
    
    if (entry.error != null) {
      // ignore: avoid_print
      print('  Error: ${entry.error}');
    }
    
    if (entry.stackTrace != null && entry.level.index >= LogLevel.error.index) {
      // ignore: avoid_print
      print('  StackTrace:\n${entry.stackTrace}');
    }
  }

  static String _getEmoji(LogLevel level) {
    return switch (level) {
      LogLevel.verbose => '📝',
      LogLevel.debug => '🐛',
      LogLevel.info => 'ℹ️',
      LogLevel.warning => '⚠️',
      LogLevel.error => '❌',
      LogLevel.fatal => '💥',
    };
  }

  // ============================================================================
  // QUERY METHODS
  // ============================================================================

  static List<LogEntry> getRecentLogs({LogLevel? minLevel, String? tag}) {
    return _recentLogs.where((log) {
      if (minLevel != null && log.level.index < minLevel.index) return false;
      if (tag != null && log.tag != tag) return false;
      return true;
    }).toList();
  }

  static void clearRecentLogs() {
    _recentLogs.clear();
  }

  static void dumpToConsole() {
    // ignore: avoid_print
    print('\n========== LOG DUMP ==========');
    for (final log in _recentLogs) {
      _printToConsole(log);
    }
    // ignore: avoid_print
    print('========== END DUMP ==========\n');
  }
}

/// Log entry model
class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String message;
  final String tag;
  final Map<String, dynamic>? data;
  final String? error;
  final String? stackTrace;

  LogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
    required this.tag,
    this.data,
    this.error,
    this.stackTrace,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'level': level.name,
    'message': message,
    'tag': tag,
    'data': data,
    'error': error,
    'stackTrace': stackTrace,
  };
}

// ============================================================================
// EXTENSIONS FOR EASY LOGGING
// ============================================================================

extension LoggerExtension on Object {
  void logVerbose(String message, {Map<String, dynamic>? data}) {
    Logger.verbose(message, tag: runtimeType.toString(), data: data);
  }

  void logDebug(String message, {Map<String, dynamic>? data}) {
    Logger.debug(message, tag: runtimeType.toString(), data: data);
  }

  void logInfo(String message, {Map<String, dynamic>? data}) {
    Logger.info(message, tag: runtimeType.toString(), data: data);
  }

  void logWarning(String message, {Map<String, dynamic>? data, Object? error}) {
    Logger.warning(message, tag: runtimeType.toString(), data: data, error: error);
  }

  void logError(
    String message, {
    Map<String, dynamic>? data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    Logger.error(
      message,
      tag: runtimeType.toString(),
      data: data,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
