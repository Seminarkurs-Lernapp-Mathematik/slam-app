// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionImpl _$$QuestionImplFromJson(Map<String, dynamic> json) =>
    _$QuestionImpl(
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
      correctFeedback: json['correctFeedback'] as String?,
      incorrectFeedback: json['incorrectFeedback'] as String?,
      stepByStepData: _stepByStepDataFromJson(
          json['stepByStepData'] as Map<String, dynamic>?),
    );

Map<String, dynamic> _$$QuestionImplToJson(_$QuestionImpl instance) =>
    <String, dynamic>{
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
      'correctFeedback': instance.correctFeedback,
      'incorrectFeedback': instance.incorrectFeedback,
      'stepByStepData': _stepByStepDataToJson(instance.stepByStepData),
    };

const _$QuestionTypeEnumMap = {
  QuestionType.multipleChoice: 'multiple-choice',
  QuestionType.stepByStep: 'step-by-step',
};

_$QuestionOptionImpl _$$QuestionOptionImplFromJson(Map<String, dynamic> json) =>
    _$QuestionOptionImpl(
      id: json['id'] as String,
      text: json['text'] as String,
      isCorrect: json['isCorrect'] as bool? ?? false,
    );

Map<String, dynamic> _$$QuestionOptionImplToJson(
        _$QuestionOptionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'isCorrect': instance.isCorrect,
    };

_$QuestionHintImpl _$$QuestionHintImplFromJson(Map<String, dynamic> json) =>
    _$QuestionHintImpl(
      level: (json['level'] as num).toInt(),
      text: json['text'] as String,
    );

Map<String, dynamic> _$$QuestionHintImplToJson(_$QuestionHintImpl instance) =>
    <String, dynamic>{
      'level': instance.level,
      'text': instance.text,
    };

_$GeoGebraDataImpl _$$GeoGebraDataImplFromJson(Map<String, dynamic> json) =>
    _$GeoGebraDataImpl(
      appletId: json['appletId'] as String?,
      commands: (json['commands'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$$GeoGebraDataImplToJson(_$GeoGebraDataImpl instance) =>
    <String, dynamic>{
      'appletId': instance.appletId,
      'commands': instance.commands,
      'description': instance.description,
    };

_$QuestionSessionImpl _$$QuestionSessionImplFromJson(
        Map<String, dynamic> json) =>
    _$QuestionSessionImpl(
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
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      fromCache: json['fromCache'] as bool?,
      cacheKey: json['cacheKey'] as String?,
      modelUsed: json['modelUsed'] as String?,
      providerUsed: json['providerUsed'] as String?,
    );

Map<String, dynamic> _$$QuestionSessionImplToJson(
        _$QuestionSessionImpl instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'learningPlanItemId': instance.learningPlanItemId,
      'topics': instance.topics,
      'userContext': instance.userContext,
      'questions': instance.questions,
      'totalQuestions': instance.totalQuestions,
      'createdAt': instance.createdAt?.toIso8601String(),
      'fromCache': instance.fromCache,
      'cacheKey': instance.cacheKey,
      'modelUsed': instance.modelUsed,
      'providerUsed': instance.providerUsed,
    };

_$TopicDataImpl _$$TopicDataImplFromJson(Map<String, dynamic> json) =>
    _$TopicDataImpl(
      leitidee: json['leitidee'] as String,
      thema: json['thema'] as String,
      unterthema: json['unterthema'] as String,
    );

Map<String, dynamic> _$$TopicDataImplToJson(_$TopicDataImpl instance) =>
    <String, dynamic>{
      'leitidee': instance.leitidee,
      'thema': instance.thema,
      'unterthema': instance.unterthema,
    };

_$UserContextImpl _$$UserContextImplFromJson(Map<String, dynamic> json) =>
    _$UserContextImpl(
      gradeLevel: json['gradeLevel'] as String,
      courseType: json['courseType'] as String,
    );

Map<String, dynamic> _$$UserContextImplToJson(_$UserContextImpl instance) =>
    <String, dynamic>{
      'gradeLevel': instance.gradeLevel,
      'courseType': instance.courseType,
    };

_$QuestionProgressImpl _$$QuestionProgressImplFromJson(
        Map<String, dynamic> json) =>
    _$QuestionProgressImpl(
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

Map<String, dynamic> _$$QuestionProgressImplToJson(
        _$QuestionProgressImpl instance) =>
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

_$HintUsageDetailImpl _$$HintUsageDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$HintUsageDetailImpl(
      level: (json['level'] as num).toInt(),
      usedAt: DateTime.parse(json['usedAt'] as String),
    );

Map<String, dynamic> _$$HintUsageDetailImplToJson(
        _$HintUsageDetailImpl instance) =>
    <String, dynamic>{
      'level': instance.level,
      'usedAt': instance.usedAt.toIso8601String(),
    };

_$XPBreakdownImpl _$$XPBreakdownImplFromJson(Map<String, dynamic> json) =>
    _$XPBreakdownImpl(
      base: (json['base'] as num).toInt(),
      hintPenalty: (json['hintPenalty'] as num).toInt(),
      timeBonus: (json['timeBonus'] as num).toInt(),
      streakBonus: (json['streakBonus'] as num).toInt(),
    );

Map<String, dynamic> _$$XPBreakdownImplToJson(_$XPBreakdownImpl instance) =>
    <String, dynamic>{
      'base': instance.base,
      'hintPenalty': instance.hintPenalty,
      'timeBonus': instance.timeBonus,
      'streakBonus': instance.streakBonus,
    };
