import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'lernplan.freezed.dart';
part 'lernplan.g.dart';

@freezed
class Lernplan with _$Lernplan {
  const factory Lernplan({
    required String id,
    required String userId,
    required List<LernplanTopic> topics,
    @Default(0) @JsonKey(name: 'createdAt') int createdAtTimestamp,
    @Default(0) @JsonKey(name: 'updatedAt') int updatedAtTimestamp,
  }) = _Lernplan;
  const Lernplan._();

  factory Lernplan.fromJson(Map<String, dynamic> json) => _$LernplanFromJson(json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType &&
          other is Lernplan &&
          other.id == id &&
          other.userId == userId &&
          other.topics == topics &&
          other.createdAtTimestamp == createdAtTimestamp &&
          other.updatedAtTimestamp == updatedAtTimestamp);

  @override
  int get hashCode => Object.hash(runtimeType, id, userId, topics, createdAtTimestamp, updatedAtTimestamp);
}

@freezed
class LernplanTopic with _$LernplanTopic {
  const factory LernplanTopic({
    required String leitidee,
    required String thema,
    required String unterthema,
    @Default(0) @JsonKey(name: 'addedAt') int addedAtTimestamp,
    required String source, // e.g., 'manual', 'upload'
  }) = _LernplanTopic;
  const LernplanTopic._();

  factory LernplanTopic.fromJson(Map<String, dynamic> json) => _$LernplanTopicFromJson(json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType &&
          other is LernplanTopic &&
          other.leitidee == leitidee &&
          other.thema == thema &&
          other.unterthema == unterthema &&
          other.addedAtTimestamp == addedAtTimestamp &&
          other.source == source);

  @override
  int get hashCode => Object.hash(runtimeType, leitidee, thema, unterthema, addedAtTimestamp, source);
}
