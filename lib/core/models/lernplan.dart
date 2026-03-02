import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import '../utils/timestamp_converter.dart';

part 'lernplan.freezed.dart';
part 'lernplan.g.dart';

@freezed
class Lernplan with _$Lernplan {
  const factory Lernplan({
    required String id,
    required String userId,
    required List<LernplanTopic> topics,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _Lernplan;
  const Lernplan._();

  factory Lernplan.fromJson(Map<String, dynamic> json) =>
      _$LernplanFromJson(json);

  /// Create an empty Lernplan for a user
  factory Lernplan.empty(String userId) => Lernplan(
        id: userId,
        userId: userId,
        topics: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
}

@freezed
class LernplanTopic with _$LernplanTopic {
  const factory LernplanTopic({
    required String leitidee,
    required String thema,
    required String unterthema,
    @TimestampConverter() required DateTime addedAt,
    @Default('manual') String source,
  }) = _LernplanTopic;
  const LernplanTopic._();

  factory LernplanTopic.fromJson(Map<String, dynamic> json) =>
      _$LernplanTopicFromJson(json);

  /// Create a unique key for this topic
  String get uniqueKey => '${leitidee}_${thema}_$unterthema${addedAt.millisecondsSinceEpoch}';
}
