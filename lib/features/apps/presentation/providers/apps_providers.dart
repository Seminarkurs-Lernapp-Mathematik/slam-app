import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/models/question.dart';
import '../../../../core/models/saved_content.dart';
import '../../../../core/services/ai_service.dart';
import '../../../../core/services/auth_service.dart';

part 'apps_providers.g.dart';

// ============================================================================
// STATE PROVIDERS
// ============================================================================

/// Content type filter provider
@riverpod
class ContentTypeFilter extends _$ContentTypeFilter {
  @override
  ContentType? build() => null; // null means "All"

  void setFilter(ContentType? type) {
    state = type;
  }
}

/// Search query provider
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

/// Generated app state provider
@riverpod
class GeneratedAppState extends _$GeneratedAppState {
  @override
  GeneratedApp? build() => null;

  void setApp(GeneratedApp app) {
    state = app;
  }

  void clear() {
    state = null;
  }
}

/// GeoGebra visualization state provider
@riverpod
class GeogebraVisualizationState extends _$GeogebraVisualizationState {
  @override
  GeoGebraData? build() => null;

  void setVisualization(GeoGebraData data) {
    state = data;
  }

  void clear() {
    state = null;
  }
}

// ============================================================================
// SAVED CONTENT PROVIDERS
// ============================================================================

/// Saved content stream provider
@riverpod
Stream<List<SavedContent>> savedContent(SavedContentRef ref) {
  final user = ref.watch(currentUserProvider);

  if (user == null) {
    return Stream.value([]);
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('savedContent')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => SavedContent.fromFirestore(doc.id, doc.data()))
        .toList();
  });
}

/// Filtered saved content provider
@riverpod
Stream<List<SavedContent>> filteredSavedContent(
  FilteredSavedContentRef ref,
) {
  final filter = ref.watch(contentTypeFilterProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

  return ref.watch(savedContentProvider.stream).map((content) {
    var filtered = content;

    // Apply type filter
    if (filter != null) {
      filtered = filtered.where((item) => item.type == filter).toList();
    }

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.title.toLowerCase().contains(searchQuery) ||
            (item.description?.toLowerCase().contains(searchQuery) ?? false) ||
            item.tags.any((tag) => tag.toLowerCase().contains(searchQuery));
      }).toList();
    }

    return filtered;
  });
}

// ============================================================================
// ACTIONS
// ============================================================================

/// Save content to Firestore
@riverpod
Future<void> saveContent(
  SaveContentRef ref,
  SavedContent content,
) async {
  final user = ref.read(currentUserProvider);

  if (user == null) {
    throw Exception('User not authenticated');
  }

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('savedContent')
      .doc(content.id)
      .set(content.toFirestore());
}

/// Delete content from Firestore
@riverpod
Future<void> deleteContent(
  DeleteContentRef ref,
  String contentId,
) async {
  final user = ref.read(currentUserProvider);

  if (user == null) {
    throw Exception('User not authenticated');
  }

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('savedContent')
      .doc(contentId)
      .delete();
}

/// Generate mini app
@riverpod
Future<GeneratedApp> generateMiniApp(
  GenerateMiniAppRef ref, {
  required String description,
  required String selectedModel,
}) async {
  final aiService = ref.read(aiServiceProvider);

  final app = await aiService.generateMiniApp(
    description: description,
    selectedModel: selectedModel,
  );

  // Update state
  ref.read(generatedAppStateProvider.notifier).setApp(app);

  return app;
}

/// Generate GeoGebra visualization
@riverpod
Future<GeoGebraData> generateGeogebra(
  GenerateGeogebraRef ref, {
  required String prompt,
  String? questionText,
  String? topic,
}) async {
  final aiService = ref.read(aiServiceProvider);

  final data = await aiService.generateGeoGebra(
    questionText: questionText ?? prompt,
    topic: topic ?? 'general',
    userPrompt: prompt,
  );

  // Update state
  ref.read(geogebraVisualizationStateProvider.notifier).setVisualization(data);

  return data;
}
