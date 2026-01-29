import 'package:freezed_annotation/freezed_annotation.dart';

part 'memory.freezed.dart';
part 'memory.g.dart';

/// Memory Model (Spaced Repetition)
///
/// Implements SuperMemo SM-2 algorithm for optimal review scheduling
@freezed
class Memory with _$Memory {
  const factory Memory({
    required String id,
    required String userId,
    required String questionId,
    required String questionText,
    required String topic,
    required String subtopic,
    required String leitidee,
    @Default(3) int difficulty,
    @Default(1) int afbLevel,

    // SM-2 Algorithm variables
    @Default(2.5) double easeFactor,
    @Default(0) int interval, // Days until next review
    @Default(0) int repetitions, // Number of successful reviews

    // Review tracking
    required DateTime lastReviewedAt,
    required DateTime nextReviewAt,

    // Statistics
    @Default(0) int reviewCount,
    @Default(0.0) double averageQuality,
    int? lastQuality,

    // Review history
    @Default([]) List<ReviewRecord> reviewHistory,

    // Metadata
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isArchived,
  }) = _Memory;

  factory Memory.fromJson(Map<String, dynamic> json) =>
      _$MemoryFromJson(json);

  /// Create initial memory from question
  factory Memory.initial({
    required String userId,
    required String questionId,
    required String questionText,
    required String topic,
    required String subtopic,
    required String leitidee,
    int? difficulty,
    int? afbLevel,
  }) {
    final now = DateTime.now();
    final nextReview = now.add(const Duration(days: 1)); // First review: 1 day

    return Memory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      questionId: questionId,
      questionText: questionText,
      topic: topic,
      subtopic: subtopic,
      leitidee: leitidee,
      difficulty: difficulty ?? 3,
      afbLevel: afbLevel ?? 1,
      lastReviewedAt: now,
      nextReviewAt: nextReview,
      createdAt: now,
      updatedAt: now,
    );
  }
}

/// Review Record
@freezed
class ReviewRecord with _$ReviewRecord {
  const factory ReviewRecord({
    required DateTime reviewedAt,
    required int quality, // 0-5 (SM-2)
    required double easeFactor,
    required int interval,
    required DateTime nextReviewAt,
    required int repetitions,
  }) = _ReviewRecord;

  factory ReviewRecord.fromJson(Map<String, dynamic> json) =>
      _$ReviewRecordFromJson(json);
}

/// SM-2 Review Result
class SM2Result {
  final double easeFactor;
  final int repetitions;
  final int interval;
  final DateTime nextReviewDate;

  SM2Result({
    required this.easeFactor,
    required this.repetitions,
    required this.interval,
    required this.nextReviewDate,
  });
}

/// SM-2 Algorithm Helper
class SM2Calculator {
  /// Calculate next review parameters based on quality (0-5)
  static SM2Result calculateNextReview({
    required int quality,
    required double easeFactor,
    required int repetitions,
    required int interval,
  }) {
    // Calculate new ease factor
    double newEaseFactor = easeFactor +
        (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));

    // EF cannot be less than 1.3
    if (newEaseFactor < 1.3) {
      newEaseFactor = 1.3;
    }

    int newRepetitions = repetitions;
    int newInterval = interval;

    if (quality < 3) {
      // Incorrect recall - reset repetitions and interval
      newRepetitions = 0;
      newInterval = 1; // Review again tomorrow
    } else {
      // Correct recall - increase repetitions and interval
      newRepetitions = repetitions + 1;

      if (newRepetitions == 1) {
        newInterval = 1; // First review: 1 day
      } else if (newRepetitions == 2) {
        newInterval = 6; // Second review: 6 days
      } else {
        // Subsequent reviews: multiply by ease factor
        newInterval = (interval * newEaseFactor).round();
      }
    }

    final nextReviewDate = DateTime.now().add(Duration(days: newInterval));

    return SM2Result(
      easeFactor: newEaseFactor,
      repetitions: newRepetitions,
      interval: newInterval,
      nextReviewDate: nextReviewDate,
    );
  }

  /// Helper: Convert answer performance to SM-2 quality (0-5)
  static int getQualityFromPerformance({
    required bool isCorrect,
    required int hintsUsed,
    required int timeSpentSeconds,
    required int expectedTimeSeconds,
  }) {
    if (!isCorrect) {
      // Incorrect answer
      if (hintsUsed >= 3) return 0; // Complete blackout
      if (hintsUsed == 2) return 1; // Severe difficulty
      return 2; // Wrong but remembered something
    }

    // Correct answer
    if (hintsUsed == 0 && timeSpentSeconds < expectedTimeSeconds * 0.5) {
      return 5; // Perfect recall, fast
    }
    if (hintsUsed == 0) return 4; // Correct with hesitation
    if (hintsUsed == 1) return 3; // Correct with difficulty
    return 2; // Correct but with much difficulty
  }
}
