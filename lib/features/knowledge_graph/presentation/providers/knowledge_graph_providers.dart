import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/firebase_collections.dart';
import '../../../../core/models/topic.dart';
import '../../../../core/services/auth_service.dart';

part 'knowledge_graph_providers.g.dart';

/// Stream of all topicProgress documents for the current user.
/// Returns empty map when user is null or has no progress data yet.
@riverpod
Stream<Map<String, TopicProgress>> topicProgressMap(Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value({});

  return FirebaseFirestore.instance
      .collection(FirebaseCollections.users)
      .doc(user.uid)
      .collection(FirebaseCollections.topicProgress)
      .snapshots()
      .map((snapshot) {
    final map = <String, TopicProgress>{};
    for (final doc in snapshot.docs) {
      try {
        map[doc.id] = TopicProgress.fromJson({'topicKey': doc.id, ...doc.data()});
      } catch (_) {
        // Skip malformed documents
      }
    }
    return map;
  });
}
