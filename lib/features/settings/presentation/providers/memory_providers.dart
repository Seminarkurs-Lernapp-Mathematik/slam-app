import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/models/memory.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';

part 'memory_providers.g.dart';

/// Streams all non-archived memories for the current user, ordered by next review date.
@riverpod
Stream<List<Memory>> userMemories(UserMemoriesRef ref) {
  final userId = ref.watch(currentUserProvider)?.uid;
  if (userId == null) return Stream.value([]);

  return ref
      .watch(firestoreServiceProvider)
      .getMemoriesStream(userId)
      .map((list) => list.map((m) => Memory.fromJson(m)).toList());
}
