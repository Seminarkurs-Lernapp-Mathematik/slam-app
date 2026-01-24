// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TopicImpl _$$TopicImplFromJson(Map<String, dynamic> json) => _$TopicImpl(
      id: json['id'] as String,
      topicKey: json['topicKey'] as String,
      title: json['title'] as String,
      mainTopic: json['mainTopic'] as String,
      subtopic: json['subtopic'] as String?,
      description: json['description'] as String?,
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      completed: (json['completed'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      needsMoreQuestions: json['needsMoreQuestions'] as bool? ?? false,
      lastSessionId: json['lastSessionId'] as String?,
      avgAccuracy: (json['avgAccuracy'] as num?)?.toInt() ?? 0,
      level: json['level'] as String?,
    );

Map<String, dynamic> _$$TopicImplToJson(_$TopicImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'topicKey': instance.topicKey,
      'title': instance.title,
      'mainTopic': instance.mainTopic,
      'subtopic': instance.subtopic,
      'description': instance.description,
      'progress': instance.progress,
      'completed': instance.completed,
      'total': instance.total,
      'needsMoreQuestions': instance.needsMoreQuestions,
      'lastSessionId': instance.lastSessionId,
      'avgAccuracy': instance.avgAccuracy,
      'level': instance.level,
    };

_$TopicProgressImpl _$$TopicProgressImplFromJson(Map<String, dynamic> json) =>
    _$TopicProgressImpl(
      topicKey: json['topicKey'] as String,
      questionsCompleted: (json['questionsCompleted'] as num?)?.toInt() ?? 0,
      totalQuestions: (json['totalQuestions'] as num?)?.toInt() ?? 0,
      lastSessionId: json['lastSessionId'] as String?,
      lastAccessed: json['lastAccessed'] == null
          ? null
          : DateTime.parse(json['lastAccessed'] as String),
      needsMoreQuestions: json['needsMoreQuestions'] as bool? ?? false,
      avgAccuracy: (json['avgAccuracy'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TopicProgressImplToJson(_$TopicProgressImpl instance) =>
    <String, dynamic>{
      'topicKey': instance.topicKey,
      'questionsCompleted': instance.questionsCompleted,
      'totalQuestions': instance.totalQuestions,
      'lastSessionId': instance.lastSessionId,
      'lastAccessed': instance.lastAccessed?.toIso8601String(),
      'needsMoreQuestions': instance.needsMoreQuestions,
      'avgAccuracy': instance.avgAccuracy,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$LearningSessionImpl _$$LearningSessionImplFromJson(
        Map<String, dynamic> json) =>
    _$LearningSessionImpl(
      sessionId: json['sessionId'] as String,
      learningPlanItemId: json['learningPlanItemId'],
      generatedQuestionsId: json['generatedQuestionsId'] as String,
      questionsTotal: (json['questionsTotal'] as num).toInt(),
      questionsCompleted: (json['questionsCompleted'] as num?)?.toInt() ?? 0,
      totalXpEarned: (json['totalXpEarned'] as num?)?.toInt() ?? 0,
      avgAccuracy: (json['avgAccuracy'] as num?)?.toInt() ?? 0,
      totalTimeSpent: (json['totalTimeSpent'] as num?)?.toInt() ?? 0,
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: json['endedAt'] == null
          ? null
          : DateTime.parse(json['endedAt'] as String),
    );

Map<String, dynamic> _$$LearningSessionImplToJson(
        _$LearningSessionImpl instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'learningPlanItemId': instance.learningPlanItemId,
      'generatedQuestionsId': instance.generatedQuestionsId,
      'questionsTotal': instance.questionsTotal,
      'questionsCompleted': instance.questionsCompleted,
      'totalXpEarned': instance.totalXpEarned,
      'avgAccuracy': instance.avgAccuracy,
      'totalTimeSpent': instance.totalTimeSpent,
      'startedAt': instance.startedAt.toIso8601String(),
      'endedAt': instance.endedAt?.toIso8601String(),
    };

_$LearningPlanItemImpl _$$LearningPlanItemImplFromJson(
        Map<String, dynamic> json) =>
    _$LearningPlanItemImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      themes: (json['themes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      examDate: json['examDate'] == null
          ? null
          : DateTime.parse(json['examDate'] as String),
      examTitle: json['examTitle'] as String?,
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      completed: (json['completed'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      lastAccessed: json['lastAccessed'] == null
          ? null
          : DateTime.parse(json['lastAccessed'] as String),
    );

Map<String, dynamic> _$$LearningPlanItemImplToJson(
        _$LearningPlanItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'themes': instance.themes,
      'examDate': instance.examDate?.toIso8601String(),
      'examTitle': instance.examTitle,
      'progress': instance.progress,
      'completed': instance.completed,
      'total': instance.total,
      'lastAccessed': instance.lastAccessed?.toIso8601String(),
    };
