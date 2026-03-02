// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lernplan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LernplanImpl _$$LernplanImplFromJson(Map<String, dynamic> json) =>
    _$LernplanImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      topics: (json['topics'] as List<dynamic>)
          .map((e) => LernplanTopic.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$LernplanImplToJson(_$LernplanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'topics': instance.topics,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };

_$LernplanTopicImpl _$$LernplanTopicImplFromJson(Map<String, dynamic> json) =>
    _$LernplanTopicImpl(
      leitidee: json['leitidee'] as String,
      thema: json['thema'] as String,
      unterthema: json['unterthema'] as String,
      addedAt: const TimestampConverter().fromJson(json['addedAt']),
      source: json['source'] as String? ?? 'manual',
    );

Map<String, dynamic> _$$LernplanTopicImplToJson(_$LernplanTopicImpl instance) =>
    <String, dynamic>{
      'leitidee': instance.leitidee,
      'thema': instance.thema,
      'unterthema': instance.unterthema,
      'addedAt': const TimestampConverter().toJson(instance.addedAt),
      'source': instance.source,
    };
