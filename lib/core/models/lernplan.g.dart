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
      createdAtTimestamp: (json['createdAt'] as num?)?.toInt() ?? 0,
      updatedAtTimestamp: (json['updatedAt'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$LernplanImplToJson(_$LernplanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'topics': instance.topics,
      'createdAt': instance.createdAtTimestamp,
      'updatedAt': instance.updatedAtTimestamp,
    };

_$LernplanTopicImpl _$$LernplanTopicImplFromJson(Map<String, dynamic> json) =>
    _$LernplanTopicImpl(
      leitidee: json['leitidee'] as String,
      thema: json['thema'] as String,
      unterthema: json['unterthema'] as String,
      addedAtTimestamp: (json['addedAt'] as num?)?.toInt() ?? 0,
      source: json['source'] as String,
    );

Map<String, dynamic> _$$LernplanTopicImplToJson(_$LernplanTopicImpl instance) =>
    <String, dynamic>{
      'leitidee': instance.leitidee,
      'thema': instance.thema,
      'unterthema': instance.unterthema,
      'addedAt': instance.addedAtTimestamp,
      'source': instance.source,
    };
