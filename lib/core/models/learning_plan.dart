import 'package:freezed_annotation/freezed_annotation.dart';

part 'learning_plan.freezed.dart';
part 'learning_plan.g.dart';

/// Learning Plan Model
@freezed
class LearningPlan with _$LearningPlan {
  const factory LearningPlan({
    required String id,
    required String userId,
    required String name,
    @Default([]) List<String> goals,
    @Default([]) List<TopicSelection> selectedTopics,
    @Default(false) bool smartLearningEnabled,
    DateTime? targetDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(true) bool isActive,
    required LearningPlanProgress progress,
    @Default([]) List<SessionSummary> sessions,
    required LearningPlanMetadata metadata,
  }) = _LearningPlan;

  factory LearningPlan.fromJson(Map<String, dynamic> json) =>
      _$LearningPlanFromJson(json);

  /// Create initial learning plan
  factory LearningPlan.initial({
    required String userId,
    required String name,
    required List<TopicSelection> selectedTopics,
    String? gradeLevel,
    String? courseType,
  }) {
    final now = DateTime.now();
    return LearningPlan(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      name: name,
      selectedTopics: selectedTopics,
      smartLearningEnabled: false,
      createdAt: now,
      updatedAt: now,
      progress: LearningPlanProgress.initial(totalTopics: selectedTopics.length),
      metadata: LearningPlanMetadata(
        gradeLevel: gradeLevel ?? 'Klasse_11',
        courseType: courseType ?? 'Leistungskurs',
      ),
    );
  }
}

/// Topic Selection
@freezed
class TopicSelection with _$TopicSelection {
  const factory TopicSelection({
    required String leitidee,
    required String thema,
    required String unterthema,
    @Default(0) int priority,
    String? reason,
  }) = _TopicSelection;

  factory TopicSelection.fromJson(Map<String, dynamic> json) =>
      _$TopicSelectionFromJson(json);
}

/// Learning Plan Progress
@freezed
class LearningPlanProgress with _$LearningPlanProgress {
  const factory LearningPlanProgress({
    required int totalTopics,
    required int completedTopics,
    required double avgAccuracy,
    required int totalQuestions,
    required int correctAnswers,
    required int totalXpEarned,
  }) = _LearningPlanProgress;

  factory LearningPlanProgress.fromJson(Map<String, dynamic> json) =>
      _$LearningPlanProgressFromJson(json);

  factory LearningPlanProgress.initial({required int totalTopics}) {
    return LearningPlanProgress(
      totalTopics: totalTopics,
      completedTopics: 0,
      avgAccuracy: 0.0,
      totalQuestions: 0,
      correctAnswers: 0,
      totalXpEarned: 0,
    );
  }
}

/// Session Summary
@freezed
class SessionSummary with _$SessionSummary {
  const factory SessionSummary({
    required String sessionId,
    required DateTime startedAt,
    required DateTime completedAt,
    required int questionsAnswered,
    required int correctAnswers,
    required int xpEarned,
  }) = _SessionSummary;

  factory SessionSummary.fromJson(Map<String, dynamic> json) =>
      _$SessionSummaryFromJson(json);
}

/// Learning Plan Metadata
@freezed
class LearningPlanMetadata with _$LearningPlanMetadata {
  const factory LearningPlanMetadata({
    required String gradeLevel,
    required String courseType,
  }) = _LearningPlanMetadata;

  factory LearningPlanMetadata.fromJson(Map<String, dynamic> json) =>
      _$LearningPlanMetadataFromJson(json);
}
