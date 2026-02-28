import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'lernplan.freezed.dart';

@freezed
class Lernplan with _$Lernplan {
  const factory Lernplan({
    required String id,
    required String userId,
    required List<LernplanTopic> topics,
    @Default(0) int createdAtTimestamp,
    @Default(0) int updatedAtTimestamp,
  }) = _Lernplan;
  const Lernplan._();

  /// Custom fromJson that handles Firestore type variations
  factory Lernplan.fromJson(Map<String, dynamic> json) {
    return Lernplan(
      id: _parseString(json['id']),
      userId: _parseString(json['userId']),
      topics: (json['topics'] as List<dynamic>?)
              ?.map((e) => LernplanTopic.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAtTimestamp: _parseTimestamp(json['createdAt'] ?? json['createdAtTimestamp']),
      updatedAtTimestamp: _parseTimestamp(json['updatedAt'] ?? json['updatedAtTimestamp']),
    );
  }

  /// Custom toJson for Firestore serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'topics': topics.map((t) => t.toJson()).toList(),
      'createdAt': createdAtTimestamp,
      'updatedAt': updatedAtTimestamp,
    };
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static int _parseTimestamp(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

@freezed
class LernplanTopic with _$LernplanTopic {
  const factory LernplanTopic({
    required String leitidee,
    required String thema,
    required String unterthema,
    @Default(0) int addedAtTimestamp,
    required String source,
  }) = _LernplanTopic;
  const LernplanTopic._();

  /// Custom fromJson that handles Firestore type variations
  factory LernplanTopic.fromJson(Map<String, dynamic> json) {
    return LernplanTopic(
      leitidee: Lernplan._parseString(json['leitidee']),
      thema: Lernplan._parseString(json['thema']),
      unterthema: Lernplan._parseString(json['unterthema']),
      addedAtTimestamp: Lernplan._parseTimestamp(json['addedAt'] ?? json['addedAtTimestamp']),
      source: Lernplan._parseString(json['source'] ?? 'manual'),
    );
  }

  /// Custom toJson for Firestore serialization
  Map<String, dynamic> toJson() {
    return {
      'leitidee': leitidee,
      'thema': thema,
      'unterthema': unterthema,
      'addedAt': addedAtTimestamp,
      'source': source,
    };
  }
}
