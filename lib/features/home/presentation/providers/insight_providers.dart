import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/auth_service.dart';

part 'insight_providers.g.dart';

class DailyInsight {
  final String text;
  final String? recommendedTopic;
  final String date;
  final String generatedAt;

  const DailyInsight({
    required this.text,
    this.recommendedTopic,
    required this.date,
    required this.generatedAt,
  });

  factory DailyInsight.fromMap(Map<String, dynamic> map) {
    return DailyInsight(
      text: map['text'] as String? ?? '',
      recommendedTopic: map['recommendedTopic'] as String?,
      date: map['date'] as String? ?? '',
      generatedAt: map['generatedAt'] as String? ?? '',
    );
  }
}

/// Streams today's insight for the current user, or null if none exists.
@riverpod
Stream<DailyInsight?> todayInsight(Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(null);

  final today = DateTime.now().toIso8601String().substring(0, 10);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('insights')
      .doc(today)
      .snapshots()
      .map((snap) {
    if (!snap.exists || snap.data() == null) return null;
    return DailyInsight.fromMap(snap.data()!);
  });
}
