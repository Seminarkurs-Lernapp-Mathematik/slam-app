// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LearningPlanImpl _$$LearningPlanImplFromJson(Map<String, dynamic> json) =>
    _$LearningPlanImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      goals:
          (json['goals'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      selectedTopics: (json['selectedTopics'] as List<dynamic>?)
              ?.map((e) => TopicSelection.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      smartLearningEnabled: json['smartLearningEnabled'] as bool? ?? false,
      targetDate: json['targetDate'] == null
          ? null
          : DateTime.parse(json['targetDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      progress: LearningPlanProgress.fromJson(
          json['progress'] as Map<String, dynamic>),
      sessions: (json['sessions'] as List<dynamic>?)
              ?.map((e) => SessionSummary.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      metadata: LearningPlanMetadata.fromJson(
          json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$LearningPlanImplToJson(_$LearningPlanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'goals': instance.goals,
      'selectedTopics': instance.selectedTopics,
      'smartLearningEnabled': instance.smartLearningEnabled,
      'targetDate': instance.targetDate?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isActive': instance.isActive,
      'progress': instance.progress,
      'sessions': instance.sessions,
      'metadata': instance.metadata,
    };

_$TopicSelectionImpl _$$TopicSelectionImplFromJson(Map<String, dynamic> json) =>
    _$TopicSelectionImpl(
      leitidee: json['leitidee'] as String,
      thema: json['thema'] as String,
      unterthema: json['unterthema'] as String,
      priority: (json['priority'] as num?)?.toInt() ?? 0,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$$TopicSelectionImplToJson(
        _$TopicSelectionImpl instance) =>
    <String, dynamic>{
      'leitidee': instance.leitidee,
      'thema': instance.thema,
      'unterthema': instance.unterthema,
      'priority': instance.priority,
      'reason': instance.reason,
    };

_$LearningPlanProgressImpl _$$LearningPlanProgressImplFromJson(
        Map<String, dynamic> json) =>
    _$LearningPlanProgressImpl(
      totalTopics: (json['totalTopics'] as num).toInt(),
      completedTopics: (json['completedTopics'] as num).toInt(),
      avgAccuracy: (json['avgAccuracy'] as num).toDouble(),
      totalQuestions: (json['totalQuestions'] as num).toInt(),
      correctAnswers: (json['correctAnswers'] as num).toInt(),
      totalXpEarned: (json['totalXpEarned'] as num).toInt(),
    );

Map<String, dynamic> _$$LearningPlanProgressImplToJson(
        _$LearningPlanProgressImpl instance) =>
    <String, dynamic>{
      'totalTopics': instance.totalTopics,
      'completedTopics': instance.completedTopics,
      'avgAccuracy': instance.avgAccuracy,
      'totalQuestions': instance.totalQuestions,
      'correctAnswers': instance.correctAnswers,
      'totalXpEarned': instance.totalXpEarned,
    };

_$SessionSummaryImpl _$$SessionSummaryImplFromJson(Map<String, dynamic> json) =>
    _$SessionSummaryImpl(
      sessionId: json['sessionId'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: DateTime.parse(json['completedAt'] as String),
      questionsAnswered: (json['questionsAnswered'] as num).toInt(),
      correctAnswers: (json['correctAnswers'] as num).toInt(),
      xpEarned: (json['xpEarned'] as num).toInt(),
    );

Map<String, dynamic> _$$SessionSummaryImplToJson(
        _$SessionSummaryImpl instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'startedAt': instance.startedAt.toIso8601String(),
      'completedAt': instance.completedAt.toIso8601String(),
      'questionsAnswered': instance.questionsAnswered,
      'correctAnswers': instance.correctAnswers,
      'xpEarned': instance.xpEarned,
    };

_$LearningPlanMetadataImpl _$$LearningPlanMetadataImplFromJson(
        Map<String, dynamic> json) =>
    _$LearningPlanMetadataImpl(
      gradeLevel: json['gradeLevel'] as String,
      courseType: json['courseType'] as String,
    );

Map<String, dynamic> _$$LearningPlanMetadataImplToJson(
        _$LearningPlanMetadataImpl instance) =>
    <String, dynamic>{
      'gradeLevel': instance.gradeLevel,
      'courseType': instance.courseType,
    };
