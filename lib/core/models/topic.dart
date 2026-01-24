import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic.freezed.dart';
part 'topic.g.dart';

/// Topic Model
///
/// Represents a single topic in the learning plan
@freezed
class Topic with _$Topic {
  const Topic._();

  const factory Topic({
    required String id,
    required String topicKey, // e.g., "Analysis|Ableitungen|Potenzregel"
    required String title,
    required String mainTopic,
    String? subtopic,
    String? description,
    @Default(0) int progress, // 0-100
    @Default(0) int completed,
    @Default(0) int total,
    @Default(false) bool needsMoreQuestions,
    String? lastSessionId,
    @Default(0) int avgAccuracy, // 0-100
    String? level,
  }) = _Topic;

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

  /// Create topic from Firestore topicProgress
  factory Topic.fromFirestore(String id, Map<String, dynamic> data) {
    final topicKey = data['topicKey'] as String;
    final parts = topicKey.split('|');
    final mainTopic = parts[0];
    final subtopic = parts.length > 1 ? parts[1] : null;
    final subsubtopic = parts.length > 2 ? parts[2] : null;

    final completed = data['questionsCompleted'] as int? ?? 0;
    final total = data['totalQuestions'] as int? ?? 0;
    final progress =
        total > 0 ? ((completed / total) * 100).round() : 0;
    final avgAccuracy = data['avgAccuracy'] as int? ?? 0;

    return Topic(
      id: id,
      topicKey: topicKey,
      title: subtopic ?? mainTopic,
      mainTopic: mainTopic,
      subtopic: subtopic,
      description: subsubtopic ?? subtopic,
      progress: progress,
      completed: completed,
      total: total,
      needsMoreQuestions: data['needsMoreQuestions'] as bool? ?? false,
      lastSessionId: data['lastSessionId'] as String?,
      avgAccuracy: avgAccuracy,
      level: '$avgAccuracy%',
    );
  }
}

/// Topic Progress Model (Firestore)
///
/// Firestore: users/{userId}/topicProgress/{topicKey}
@freezed
class TopicProgress with _$TopicProgress {
  const TopicProgress._();

  const factory TopicProgress({
    required String topicKey,
    @Default(0) int questionsCompleted,
    @Default(0) int totalQuestions,
    String? lastSessionId,
    DateTime? lastAccessed,
    @Default(false) bool needsMoreQuestions,
    @Default(0) int avgAccuracy, // 0-100
    DateTime? createdAt,
  }) = _TopicProgress;

  factory TopicProgress.fromJson(Map<String, dynamic> json) =>
      _$TopicProgressFromJson(json);

  /// Initial topic progress
  factory TopicProgress.initial(String topicKey) {
    return TopicProgress(
      topicKey: topicKey,
      questionsCompleted: 0,
      totalQuestions: 0,
      needsMoreQuestions: true,
      avgAccuracy: 0,
      createdAt: DateTime.now(),
    );
  }
}

/// Learning Session Model
///
/// Firestore: users/{userId}/learningSessions/{sessionId}
@freezed
class LearningSession with _$LearningSession {
  const LearningSession._();

  const factory LearningSession({
    required String sessionId,
    required dynamic learningPlanItemId, // int or string
    required String generatedQuestionsId,
    required int questionsTotal,
    @Default(0) int questionsCompleted,
    @Default(0) int totalXpEarned,
    @Default(0) int avgAccuracy,
    @Default(0) int totalTimeSpent, // seconds
    required DateTime startedAt,
    DateTime? endedAt,
  }) = _LearningSession;

  factory LearningSession.fromJson(Map<String, dynamic> json) =>
      _$LearningSessionFromJson(json);
}

/// Learning Plan Item
@freezed
class LearningPlanItem with _$LearningPlanItem {
  const LearningPlanItem._();

  const factory LearningPlanItem({
    required int id,
    required String title,
    @Default([]) List<String> themes, // Topic keys
    DateTime? examDate,
    String? examTitle,
    @Default(0) int progress, // 0-100
    @Default(0) int completed,
    @Default(0) int total,
    DateTime? lastAccessed,
  }) = _LearningPlanItem;

  factory LearningPlanItem.fromJson(Map<String, dynamic> json) =>
      _$LearningPlanItemFromJson(json);
}
