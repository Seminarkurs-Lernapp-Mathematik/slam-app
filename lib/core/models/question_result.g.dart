// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionResultImpl _$$QuestionResultImplFromJson(Map<String, dynamic> json) =>
    _$QuestionResultImpl(
      questionId: json['questionId'] as String,
      userId: json['userId'] as String,
      sessionId: json['sessionId'] as String,
      questionText: json['questionText'] as String,
      correctAnswer: json['correctAnswer'] as String,
      userAnswer: json['userAnswer'] as String,
      isCorrect: json['isCorrect'] as bool,
      difficulty: (json['difficulty'] as num).toInt(),
      hintsUsed: (json['hintsUsed'] as num).toInt(),
      timeSpentSeconds: (json['timeSpentSeconds'] as num).toInt(),
      leitidee: json['leitidee'] as String,
      thema: json['thema'] as String,
      unterthema: json['unterthema'] as String,
      gradeLevel: json['gradeLevel'] as String,
      courseType: json['courseType'] as String,
      timestamp: (json['timestamp'] as num?)?.toInt() ?? 0,
      xpEarned: (json['xpEarned'] as num?)?.toInt() ?? 0,
      coinsEarned: (json['coinsEarned'] as num?)?.toInt() ?? 0,
      feedback: json['feedback'] as String?,
    );

Map<String, dynamic> _$$QuestionResultImplToJson(
        _$QuestionResultImpl instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'userId': instance.userId,
      'sessionId': instance.sessionId,
      'questionText': instance.questionText,
      'correctAnswer': instance.correctAnswer,
      'userAnswer': instance.userAnswer,
      'isCorrect': instance.isCorrect,
      'difficulty': instance.difficulty,
      'hintsUsed': instance.hintsUsed,
      'timeSpentSeconds': instance.timeSpentSeconds,
      'leitidee': instance.leitidee,
      'thema': instance.thema,
      'unterthema': instance.unterthema,
      'gradeLevel': instance.gradeLevel,
      'courseType': instance.courseType,
      'timestamp': instance.timestamp,
      'xpEarned': instance.xpEarned,
      'coinsEarned': instance.coinsEarned,
      'feedback': instance.feedback,
    };
