import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import '../../features/settings/presentation/providers/settings_providers.dart'; // For CourseType and GradeLevel

part 'question_result.freezed.dart';
part 'question_result.g.dart';

@freezed
class QuestionResult with _$QuestionResult {
  const factory QuestionResult({
    required String questionId,
    required String userId,
    required String sessionId,
    required String questionText,
    required String correctAnswer,
    required String userAnswer,
    required bool isCorrect,
    required int difficulty,
    required int hintsUsed,
    required int timeSpentSeconds,
    required String leitidee,
    required String thema,
    required String unterthema,
    required String gradeLevel,
    required String courseType,
    @Default(0) @JsonKey(name: 'timestamp') int timestamp, // Use int for Firestore Timestamp
    @Default(0) int xpEarned,
    @Default(0) int coinsEarned,
    String? feedback, // AI feedback
  }) = _QuestionResult;

  factory QuestionResult.fromJson(Map<String, dynamic> json) => _$QuestionResultFromJson(json);
}
