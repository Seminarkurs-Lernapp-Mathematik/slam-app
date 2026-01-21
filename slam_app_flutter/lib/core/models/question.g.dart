// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Question _$QuestionFromJson(Map<String, dynamic> json) => _Question(
      id: json['id'] as String,
      type: $enumDecode(_$QuestionTypeEnumMap, json['type']),
      difficulty: (json['difficulty'] as num).toInt(),
      topic: json['topic'] as String,
      subtopic: json['subtopic'] as String,
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => QuestionOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      hints: (json['hints'] as List<dynamic>?)
              ?.map((e) => QuestionHint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      solution: json['solution'] as String,
      explanation: json['explanation'] as String,
      geogebra: json['geogebra'] == null
          ? null
          : GeoGebraData.fromJson(json['geogebra'] as Map<String, dynamic>),
      hasGeoGebraVisualization:
          json['hasGeoGebraVisualization'] as bool? ?? false,
    );

Map<String, dynamic> _$QuestionToJson(_Question instance) => <String, dynamic>{
      'id': instance.id,
      'type': _$QuestionTypeEnumMap[instance.type]!,
      'difficulty': instance.difficulty,
      'topic': instance.topic,
      'subtopic': instance.subtopic,
      'question': instance.question,
      'options': instance.options,
      'hints': instance.hints,
      'solution': instance.solution,
      'explanation': instance.explanation,
      'geogebra': instance.geogebra,
      'hasGeoGebraVisualization': instance.hasGeoGebraVisualization,
    };

const _$QuestionTypeEnumMap = {
  QuestionType.multipleChoice: 'multiple-choice',
  QuestionType.stepByStep: 'step-by-step',
};

_QuestionOption _$QuestionOptionFromJson(Map<String, dynamic> json) =>
    _QuestionOption(
      id: json['id'] as String,
      text: json['text'] as String,
      isCorrect: json['isCorrect'] as bool? ?? false,
    );

Map<String, dynamic> _$QuestionOptionToJson(_QuestionOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'isCorrect': instance.isCorrect,
    };

_QuestionHint _$QuestionHintFromJson(Map<String, dynamic> json) =>
    _QuestionHint(
      level: (json['level'] as num).toInt(),
      text: json['text'] as String,
    );

Map<String, dynamic> _$QuestionHintToJson(_QuestionHint instance) =>
    <String, dynamic>{
      'level': instance.level,
      'text': instance.text,
    };

_GeoGebraData _$GeoGebraDataFromJson(Map<String, dynamic> json) =>
    _GeoGebraData(
      appletId: json['appletId'] as String?,
      commands: (json['commands'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$GeoGebraDataToJson(_GeoGebraData instance) =>
    <String, dynamic>{
      'appletId': instance.appletId,
      'commands': instance.commands,
      'description': instance.description,
    };

_QuestionSession _$QuestionSessionFromJson(Map<String, dynamic> json) =>
    _QuestionSession(
      sessionId: json['sessionId'] as String,
      learningPlanItemId: (json['learningPlanItemId'] as num).toInt(),
      topics: (json['topics'] as List<dynamic>)
          .map((e) => TopicData.fromJson(e as Map<String, dynamic>))
          .toList(),
      userContext:
          UserContext.fromJson(json['userContext'] as Map<String, dynamic>),
      questions: (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalQuestions: (json['totalQuestions'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$QuestionSessionToJson(_QuestionSession instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'learningPlanItemId': instance.learningPlanItemId,
      'topics': instance.topics,
      'userContext': instance.userContext,
      'questions': instance.questions,
      'totalQuestions': instance.totalQuestions,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_TopicData _$TopicDataFromJson(Map<String, dynamic> json) => _TopicData(
      leitidee: json['leitidee'] as String,
      thema: json['thema'] as String,
      unterthema: json['unterthema'] as String,
    );

Map<String, dynamic> _$TopicDataToJson(_TopicData instance) =>
    <String, dynamic>{
      'leitidee': instance.leitidee,
      'thema': instance.thema,
      'unterthema': instance.unterthema,
    };

_UserContext _$UserContextFromJson(Map<String, dynamic> json) => _UserContext(
      gradeLevel: json['gradeLevel'] as String,
      courseType: json['courseType'] as String,
    );

Map<String, dynamic> _$UserContextToJson(_UserContext instance) =>
    <String, dynamic>{
      'gradeLevel': instance.gradeLevel,
      'courseType': instance.courseType,
    };

_QuestionProgress _$QuestionProgressFromJson(Map<String, dynamic> json) =>
    _QuestionProgress(
      questionId: json['questionId'] as String,
      sessionId: json['sessionId'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      status: $enumDecode(_$QuestionStatusEnumMap, json['status']),
      hintsUsed: (json['hintsUsed'] as num?)?.toInt() ?? 0,
      hintsUsedDetails: (json['hintsUsedDetails'] as List<dynamic>?)
              ?.map((e) => HintUsageDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isCorrect: json['isCorrect'] as bool? ?? false,
      userAnswer: json['userAnswer'] as String?,
      timeSpent: (json['timeSpent'] as num?)?.toInt() ?? 0,
      xpEarned: (json['xpEarned'] as num?)?.toInt() ?? 0,
      xpBreakdown: json['xpBreakdown'] == null
          ? null
          : XPBreakdown.fromJson(json['xpBreakdown'] as Map<String, dynamic>),
      topic: json['topic'] as String,
      difficulty: (json['difficulty'] as num).toInt(),
    );

Map<String, dynamic> _$QuestionProgressToJson(_QuestionProgress instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'sessionId': instance.sessionId,
      'startedAt': instance.startedAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'status': _$QuestionStatusEnumMap[instance.status]!,
      'hintsUsed': instance.hintsUsed,
      'hintsUsedDetails': instance.hintsUsedDetails,
      'isCorrect': instance.isCorrect,
      'userAnswer': instance.userAnswer,
      'timeSpent': instance.timeSpent,
      'xpEarned': instance.xpEarned,
      'xpBreakdown': instance.xpBreakdown,
      'topic': instance.topic,
      'difficulty': instance.difficulty,
    };

const _$QuestionStatusEnumMap = {
  QuestionStatus.completed: 'completed',
  QuestionStatus.skipped: 'skipped',
};

_HintUsageDetail _$HintUsageDetailFromJson(Map<String, dynamic> json) =>
    _HintUsageDetail(
      level: (json['level'] as num).toInt(),
      usedAt: DateTime.parse(json['usedAt'] as String),
    );

Map<String, dynamic> _$HintUsageDetailToJson(_HintUsageDetail instance) =>
    <String, dynamic>{
      'level': instance.level,
      'usedAt': instance.usedAt.toIso8601String(),
    };

_XPBreakdown _$XPBreakdownFromJson(Map<String, dynamic> json) => _XPBreakdown(
      base: (json['base'] as num).toInt(),
      hintPenalty: (json['hintPenalty'] as num).toInt(),
      timeBonus: (json['timeBonus'] as num).toInt(),
      streakBonus: (json['streakBonus'] as num).toInt(),
    );

Map<String, dynamic> _$XPBreakdownToJson(_XPBreakdown instance) =>
    <String, dynamic>{
      'base': instance.base,
      'hintPenalty': instance.hintPenalty,
      'timeBonus': instance.timeBonus,
      'streakBonus': instance.streakBonus,
    };
