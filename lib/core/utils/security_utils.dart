import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

/// Security utilities for the app

class SecurityUtils {
  SecurityUtils._();

  /// Generate a cryptographically secure random string
  static String generateSecureRandomString(int length) {
    final random = Random.secure();
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(length, (_) => chars[random.nextInt(chars.length)]).join();
  }

  /// Hash sensitive data (e.g., for caching keys)
  static String hash(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Simple XOR encryption for non-critical local data
  /// NOTE: This is NOT for sensitive data - use proper encryption for that
  static String obfuscate(String input, String key) {
    final inputBytes = utf8.encode(input);
    final keyBytes = utf8.encode(key);
    final result = <int>[];
    
    for (var i = 0; i < inputBytes.length; i++) {
      result.add(inputBytes[i] ^ keyBytes[i % keyBytes.length]);
    }
    
    return base64Encode(result);
  }

  /// Deobfuscate data
  static String deobfuscate(String input, String key) {
    final inputBytes = base64Decode(input);
    final keyBytes = utf8.encode(key);
    final result = <int>[];
    
    for (var i = 0; i < inputBytes.length; i++) {
      result.add(inputBytes[i] ^ keyBytes[i % keyBytes.length]);
    }
    
    return utf8.decode(result);
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validate password strength
  /// Returns a score from 0-4 and feedback
  static PasswordStrength checkPasswordStrength(String password) {
    int score = 0;
    final feedback = <String>[];

    // Length check
    if (password.length >= 8) {
      score++;
    } else {
      feedback.add('Mindestens 8 Zeichen');
    }

    if (password.length >= 12) {
      score++;
    }

    // Contains uppercase
    if (password.contains(RegExp(r'[A-Z]'))) {
      score++;
    } else {
      feedback.add('Großbuchstaben hinzufügen');
    }

    // Contains lowercase
    if (password.contains(RegExp(r'[a-z]'))) {
      score++;
    } else {
      feedback.add('Kleinbuchstaben hinzufügen');
    }

    // Contains number
    if (password.contains(RegExp(r'[0-9]'))) {
      score++;
    } else {
      feedback.add('Zahlen hinzufügen');
    }

    // Contains special character
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      score++;
    } else {
      feedback.add('Sonderzeichen hinzufügen');
    }

    // Cap score at 4
    score = score.clamp(0, 4);

    return PasswordStrength(
      score: score,
      feedback: feedback.isEmpty ? ['Starkes Passwort!'] : feedback,
    );
  }

  /// Sanitize user input to prevent injection attacks
  static String sanitizeInput(String input, {int maxLength = 1000}) {
    var sanitized = input
        .trim()
        .replaceAll(RegExp(r'[<>]'), '') // Remove HTML tags
        .replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]'), ''); // Remove control chars
    
    if (sanitized.length > maxLength) {
      sanitized = sanitized.substring(0, maxLength);
    }
    
    return sanitized;
  }

  /// Rate limiter for preventing brute force attacks
  static final Map<String, _RateLimitEntry> _rateLimits = {};

  /// Check if an operation is rate limited
  static bool isRateLimited(String key, {int maxAttempts = 5, Duration window = const Duration(minutes: 1)}) {
    final now = DateTime.now();
    final entry = _rateLimits[key];

    if (entry == null) {
      _rateLimits[key] = _RateLimitEntry(attempts: 1, firstAttempt: now);
      return false;
    }

    // Reset if window has passed
    if (now.difference(entry.firstAttempt) > window) {
      _rateLimits[key] = _RateLimitEntry(attempts: 1, firstAttempt: now);
      return false;
    }

    // Check limit
    if (entry.attempts >= maxAttempts) {
      return true;
    }

    // Increment attempts
    entry.attempts++;
    return false;
  }

  /// Clear rate limit for a key
  static void clearRateLimit(String key) {
    _rateLimits.remove(key);
  }

  /// Get remaining attempts for a key
  static int? getRemainingAttempts(String key, {int maxAttempts = 5}) {
    final entry = _rateLimits[key];
    if (entry == null) return maxAttempts;
    return maxAttempts - entry.attempts;
  }
}

/// Password strength result
class PasswordStrength {
  final int score;
  final List<String> feedback;

  const PasswordStrength({required this.score, required this.feedback});

  bool get isWeak => score <= 1;
  bool get isMedium => score == 2;
  bool get isStrong => score >= 3;

  String get label {
    switch (score) {
      case 0:
      case 1:
        return 'Schwach';
      case 2:
        return 'Mittel';
      case 3:
        return 'Stark';
      case 4:
        return 'Sehr Stark';
      default:
        return 'Unbekannt';
    }
  }

  Color get color {
    switch (score) {
      case 0:
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.lightGreen;
      case 4:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class _RateLimitEntry {
  int attempts;
  final DateTime firstAttempt;

  _RateLimitEntry({required this.attempts, required this.firstAttempt});
}

/// Input validation helpers
class InputValidators {
  InputValidators._();

  /// Validate non-empty string
  static String? required(String? value, {String fieldName = 'Feld'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName ist erforderlich';
    }
    return null;
  }

  /// Validate minimum length
  static String? minLength(String? value, int minLength, {String fieldName = 'Feld'}) {
    if (value == null || value.length < minLength) {
      return '$fieldName muss mindestens $minLength Zeichen haben';
    }
    return null;
  }

  /// Validate maximum length
  static String? maxLength(String? value, int maxLength, {String fieldName = 'Feld'}) {
    if (value != null && value.length > maxLength) {
      return '$fieldName darf maximal $maxLength Zeichen haben';
    }
    return null;
  }

  /// Validate numeric range
  static String? range(num? value, num min, num max, {String fieldName = 'Feld'}) {
    if (value == null) return null;
    if (value < min || value > max) {
      return '$fieldName muss zwischen $min und $max liegen';
    }
    return null;
  }

  /// Combine multiple validators
  static String? compose(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) return result;
    }
    return null;
  }
}
