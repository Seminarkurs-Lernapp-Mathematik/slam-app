import 'package:freezed_annotation/freezed_annotation.dart';

part 'question.freezed.dart';
part 'question.g.dart';

/// Question Model
///
/// Kompatibel mit React App Question Structure
@freezed
class Question with _$Question {
  const factory Question({
    required String id,
    required QuestionType type,
    required int difficulty, // 1-10
    required String topic,
    required String subtopic,
    required String question, // LaTeX formatted
    List<QuestionOption>? options, // For multiple-choice
    @Default([]) List<QuestionHint> hints,
    required String solution,
    required String explanation,
    GeoGebraData? geogebra,
    @Default(false) bool hasGeoGebraVisualization,
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}

/// Question Type Enum
@JsonEnum(valueField: 'value')
enum QuestionType {
  multipleChoice('multiple-choice'),
  stepByStep('step-by-step');

  const QuestionType(this.value);
  final String value;
}

/// Question Option (for multiple-choice)
@freezed
class QuestionOption with _$QuestionOption {
  const factory QuestionOption({
    required String id, // A, B, C, D
    required String text,
    @Default(false) bool isCorrect,
  }) = _QuestionOption;

  factory QuestionOption.fromJson(Map<String, dynamic> json) =>
      _$QuestionOptionFromJson(json);
}

/// Question Hint
@freezed
class QuestionHint with _$QuestionHint {
  const factory QuestionHint({
    required int level, // 1, 2, 3
    required String text,
  }) = _QuestionHint;

  factory QuestionHint.fromJson(Map<String, dynamic> json) =>
      _$QuestionHintFromJson(json);
}

/// GeoGebra Data
@freezed
class GeoGebraData with _$GeoGebraData {
  const factory GeoGebraData({
    String? appletId,
    @Default([]) List<String> commands,
    @Default('') String description,
  }) = _GeoGebraData;

  factory GeoGebraData.fromJson(Map<String, dynamic> json) =>
      _$GeoGebraDataFromJson(json);
}

/// Question Session Model
///
/// Firestore: users/{userId}/generatedQuestions/{sessionId}
@freezed
class QuestionSession with _$QuestionSession {
  const factory QuestionSession({
    required String sessionId,
    required int learningPlanItemId,
    required List<TopicData> topics,
    required UserContext userContext,
    required List<Question> questions,
    required int totalQuestions,
    required DateTime createdAt,
  }) = _QuestionSession;

  factory QuestionSession.fromJson(Map<String, dynamic> json) =>
      _$QuestionSessionFromJson(json);
}

/// Topic Data
@freezed
class TopicData with _$TopicData {
  const factory TopicData({
    required String leitidee,
    required String thema,
    required String unterthema,
  }) = _TopicData;

  factory TopicData.fromJson(Map<String, dynamic> json) =>
      _$TopicDataFromJson(json);
}

/// User Context
@freezed
class UserContext with _$UserContext {
  const factory UserContext({
    required String gradeLevel,
    required String courseType,
  }) = _UserContext;

  factory UserContext.fromJson(Map<String, dynamic> json) =>
      _$UserContextFromJson(json);
}

/// Question Progress Model
///
/// Firestore: users/{userId}/questionProgress/{questionId}
@freezed
class QuestionProgress with _$QuestionProgress {
  const factory QuestionProgress({
    required String questionId,
    required String sessionId,
    required DateTime startedAt,
    DateTime? completedAt,
    required QuestionStatus status,
    @Default(0) int hintsUsed,
    @Default([]) List<HintUsageDetail> hintsUsedDetails,
    @Default(false) bool isCorrect,
    String? userAnswer,
    @Default(0) int timeSpent, // seconds
    @Default(0) int xpEarned,
    XPBreakdown? xpBreakdown,
    required String topic,
    required int difficulty,
  }) = _QuestionProgress;

  factory QuestionProgress.fromJson(Map<String, dynamic> json) =>
      _$QuestionProgressFromJson(json);
}

/// Question Status Enum
@JsonEnum(valueField: 'value')
enum QuestionStatus {
  completed('completed'),
  skipped('skipped');

  const QuestionStatus(this.value);
  final String value;
}

/// Hint Usage Detail
@freezed
class HintUsageDetail with _$HintUsageDetail {
  const factory HintUsageDetail({
    required int level, // 1-3
    required DateTime usedAt,
  }) = _HintUsageDetail;

  factory HintUsageDetail.fromJson(Map<String, dynamic> json) =>
      _$HintUsageDetailFromJson(json);
}

/// XP Breakdown
@freezed
class XPBreakdown with _$XPBreakdown {
  const factory XPBreakdown({
    required int base,
    required int hintPenalty,
    required int timeBonus,
    required int streakBonus,
  }) = _XPBreakdown;

  factory XPBreakdown.fromJson(Map<String, dynamic> json) =>
      _$XPBreakdownFromJson(json);
}
