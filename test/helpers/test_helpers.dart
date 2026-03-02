import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Test helper utilities for SLAM App tests

/// Initialize Hive for testing
Future<void> setupTestHive() async {
  Hive.init('test/hive_temp');
  await Hive.openBox<String>('api_keys');
  await Hive.openBox<Map>('offline_cache');
  await Hive.openBox<Map>('sync_queue');
}

/// Clean up test Hive
Future<void> tearDownTestHive() async {
  await Hive.deleteFromDisk();
}

/// Create a testable widget with ProviderScope
Widget createTestableWidget({
  required Widget child,
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      home: child,
    ),
  );
}

/// Pump and settle with a timeout
Future<void> pumpAndSettleWithTimeout(
  WidgetTester tester, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  await tester.pumpAndSettle(const Duration(milliseconds: 100), EnginePhase.sendSemanticsUpdate, timeout);
}

/// Mock data generators for testing
class MockData {
  MockData._();

  /// Generate a mock user data map
  static Map<String, dynamic> userData({
    String uid = 'test-uid',
    String email = 'test@example.com',
    String displayName = 'Test User',
  }) {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  /// Generate mock user stats
  static Map<String, dynamic> userStats({
    int level = 1,
    int xp = 0,
    int streak = 0,
    int coins = 100,
  }) {
    return {
      'level': level,
      'xp': xp,
      'totalXp': xp,
      'streak': streak,
      'coins': coins,
      'streakFreezes': 0,
      'lastSessionDate': null,
      'weeklyProgress': {},
    };
  }

  /// Generate mock user settings
  static Map<String, dynamic> userSettings({
    String theme = 'sunsetOrange',
    String aiProvider = 'claude',
    String aiModel = 'claude-sonnet-4-5',
    String gradeLevel = '11',
    String courseType = 'Leistungskurs',
  }) {
    return {
      'theme': theme,
      'aiProvider': aiProvider,
      'aiModel': aiModel,
      'gradeLevel': gradeLevel,
      'courseType': courseType,
      'enableSound': true,
      'enableAnimations': true,
      'offlineMode': false,
      'autoSync': true,
    };
  }

  /// Generate mock topic data
  static Map<String, dynamic> topicData({
    String leitidee = 'Algebra',
    String thema = 'Gleichungen',
    String unterthema = 'Lineare Gleichungen',
  }) {
    return {
      'leitidee': leitidee,
      'thema': thema,
      'unterthema': unterthema,
    };
  }

  /// Generate mock lernplan
  static Map<String, dynamic> lernplan({
    String id = 'lernplan-1',
    String userId = 'test-uid',
    List<Map<String, dynamic>>? topics,
  }) {
    return {
      'id': id,
      'userId': userId,
      'topics': topics ?? [topicData()],
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
}

// NOTE: Result pattern matchers removed - Result/Success/Failure types not available in test scope.
// Re-add these once the result pattern types are properly exported/imported.

// class IsSuccess<T> extends CustomMatcher { ... }
// class IsFailure<E> extends CustomMatcher { ... }
// Matcher emitsResult<T, E>({ T? success, E? failure }) { ... }

/// Async test helpers
Future<void> waitFor(Duration duration) => Future.delayed(duration);
