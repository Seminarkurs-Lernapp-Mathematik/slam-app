import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/auth_service.dart';

part 'usage_providers.g.dart';

class UsageStats {
  final int sessionCount;
  final int dayCount;
  final int weekCount;

  const UsageStats({
    this.sessionCount = 0,
    this.dayCount = 0,
    this.weekCount = 0,
  });

  factory UsageStats.fromMap(Map<String, dynamic> map) {
    return UsageStats(
      sessionCount: (map['sessionCount'] as num?)?.toInt() ?? 0,
      dayCount: (map['dayCount'] as num?)?.toInt() ?? 0,
      weekCount: (map['weekCount'] as num?)?.toInt() ?? 0,
    );
  }
}

@riverpod
Stream<UsageStats> usageStats(Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(const UsageStats());

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('usage')
      .doc('current')
      .snapshots()
      .map((snap) {
    if (!snap.exists || snap.data() == null) return const UsageStats();
    return UsageStats.fromMap(snap.data()!);
  });
}
