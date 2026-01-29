// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MemoryImpl _$$MemoryImplFromJson(Map<String, dynamic> json) => _$MemoryImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      questionId: json['questionId'] as String,
      questionText: json['questionText'] as String,
      topic: json['topic'] as String,
      subtopic: json['subtopic'] as String,
      leitidee: json['leitidee'] as String,
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 3,
      afbLevel: (json['afbLevel'] as num?)?.toInt() ?? 1,
      easeFactor: (json['easeFactor'] as num?)?.toDouble() ?? 2.5,
      interval: (json['interval'] as num?)?.toInt() ?? 0,
      repetitions: (json['repetitions'] as num?)?.toInt() ?? 0,
      lastReviewedAt: DateTime.parse(json['lastReviewedAt'] as String),
      nextReviewAt: DateTime.parse(json['nextReviewAt'] as String),
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      averageQuality: (json['averageQuality'] as num?)?.toDouble() ?? 0.0,
      lastQuality: (json['lastQuality'] as num?)?.toInt(),
      reviewHistory: (json['reviewHistory'] as List<dynamic>?)
              ?.map((e) => ReviewRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isArchived: json['isArchived'] as bool? ?? false,
    );

Map<String, dynamic> _$$MemoryImplToJson(_$MemoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'questionId': instance.questionId,
      'questionText': instance.questionText,
      'topic': instance.topic,
      'subtopic': instance.subtopic,
      'leitidee': instance.leitidee,
      'difficulty': instance.difficulty,
      'afbLevel': instance.afbLevel,
      'easeFactor': instance.easeFactor,
      'interval': instance.interval,
      'repetitions': instance.repetitions,
      'lastReviewedAt': instance.lastReviewedAt.toIso8601String(),
      'nextReviewAt': instance.nextReviewAt.toIso8601String(),
      'reviewCount': instance.reviewCount,
      'averageQuality': instance.averageQuality,
      'lastQuality': instance.lastQuality,
      'reviewHistory': instance.reviewHistory,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isArchived': instance.isArchived,
    };

_$ReviewRecordImpl _$$ReviewRecordImplFromJson(Map<String, dynamic> json) =>
    _$ReviewRecordImpl(
      reviewedAt: DateTime.parse(json['reviewedAt'] as String),
      quality: (json['quality'] as num).toInt(),
      easeFactor: (json['easeFactor'] as num).toDouble(),
      interval: (json['interval'] as num).toInt(),
      nextReviewAt: DateTime.parse(json['nextReviewAt'] as String),
      repetitions: (json['repetitions'] as num).toInt(),
    );

Map<String, dynamic> _$$ReviewRecordImplToJson(_$ReviewRecordImpl instance) =>
    <String, dynamic>{
      'reviewedAt': instance.reviewedAt.toIso8601String(),
      'quality': instance.quality,
      'easeFactor': instance.easeFactor,
      'interval': instance.interval,
      'nextReviewAt': instance.nextReviewAt.toIso8601String(),
      'repetitions': instance.repetitions,
    };
