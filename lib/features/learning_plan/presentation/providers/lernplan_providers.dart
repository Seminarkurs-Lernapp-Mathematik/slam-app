import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/models/lernplan.dart';
import '../../../../core/models/topic.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';

part 'lernplan_providers.g.dart';

/// Provides the current user's Lernplan in real-time.
/// Returns an empty Lernplan if no user is logged in or if the Lernplan doesn't exist.
@riverpod
Stream<Lernplan> lernplanStream(LernplanStreamRef ref) {
  final userId = ref.watch(currentUserProvider)?.uid;

  if (userId == null) {
    return Stream.value(
      const Lernplan(
        id: 'empty',
        userId: 'empty',
        topics: [],
        createdAtTimestamp: 0,
        updatedAtTimestamp: 0,
      ),
    );
  }
  return ref.watch(firestoreServiceProvider).getLernplanStream(userId);
}

/// Notifier to manage the user's Lernplan.
/// Allows adding and removing topics, persisting changes to Firestore.
@riverpod
class LernplanNotifier extends _$LernplanNotifier {
  @override
  Future<Lernplan> build() async {
    final userId = ref.watch(currentUserProvider)?.uid;
    if (userId == null) {
      return const Lernplan(
        id: 'empty',
        userId: 'empty',
        topics: [],
        createdAtTimestamp: 0,
        updatedAtTimestamp: 0,
      );
    }
    return ref.watch(lernplanStreamProvider).first;
  }

  Future<void> addTopics(List<LernplanTopic> newTopics) async {
    final userId = ref.read(currentUserProvider)?.uid;
    if (userId == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(firestoreServiceProvider).addTopicsToLernplan(userId, newTopics);
      return ref.read(lernplanStreamProvider).first;
    });
  }

  Future<void> removeTopic(LernplanTopic topicToRemove) async {
    final userId = ref.read(currentUserProvider)?.uid;
    if (userId == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(firestoreServiceProvider).removeTopicFromLernplan(userId, topicToRemove);
      return ref.read(lernplanStreamProvider).first;
    });
  }
}

/// Converts the Lernplan's topics into a List<TopicData> for use with AI services.
@riverpod
List<TopicData> lernplanTopicsAsTopicDataProvider(LernplanTopicsAsTopicDataProviderRef ref) {
  final lernplanAsync = ref.watch(lernplanStreamProvider);

  return lernplanAsync.when(
    data: (lernplan) {
      return lernplan.topics.map((lernplanTopic) => TopicData(
        leitidee: lernplanTopic.leitidee,
        thema: lernplanTopic.thema,
        unterthema: lernplanTopic.unterthema,
      )).toList();
    },
    loading: () => [], // Return empty list while loading
    error: (err, stack) => [], // Return empty list on error
  );
}
