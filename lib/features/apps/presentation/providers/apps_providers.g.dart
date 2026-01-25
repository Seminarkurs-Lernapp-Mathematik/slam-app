// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apps_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$savedContentHash() => r'a7ca6f65d55b9f31bc4b2ca2d8e5b87257b4a3ed';

/// Saved content stream provider
///
/// Copied from [savedContent].
@ProviderFor(savedContent)
final savedContentProvider =
    AutoDisposeStreamProvider<List<SavedContent>>.internal(
  savedContent,
  name: r'savedContentProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$savedContentHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SavedContentRef = AutoDisposeStreamProviderRef<List<SavedContent>>;
String _$filteredSavedContentHash() =>
    r'453eb87ec6d7256819df57a58369d7abcbd748a6';

/// Filtered saved content provider
///
/// Copied from [filteredSavedContent].
@ProviderFor(filteredSavedContent)
final filteredSavedContentProvider =
    AutoDisposeStreamProvider<List<SavedContent>>.internal(
  filteredSavedContent,
  name: r'filteredSavedContentProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredSavedContentHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredSavedContentRef
    = AutoDisposeStreamProviderRef<List<SavedContent>>;
String _$saveContentHash() => r'e91d7e50f5dc0af02096577f1aec2f6a914b7921';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Save content to Firestore
///
/// Copied from [saveContent].
@ProviderFor(saveContent)
const saveContentProvider = SaveContentFamily();

/// Save content to Firestore
///
/// Copied from [saveContent].
class SaveContentFamily extends Family<AsyncValue<void>> {
  /// Save content to Firestore
  ///
  /// Copied from [saveContent].
  const SaveContentFamily();

  /// Save content to Firestore
  ///
  /// Copied from [saveContent].
  SaveContentProvider call(
    SavedContent content,
  ) {
    return SaveContentProvider(
      content,
    );
  }

  @override
  SaveContentProvider getProviderOverride(
    covariant SaveContentProvider provider,
  ) {
    return call(
      provider.content,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'saveContentProvider';
}

/// Save content to Firestore
///
/// Copied from [saveContent].
class SaveContentProvider extends AutoDisposeFutureProvider<void> {
  /// Save content to Firestore
  ///
  /// Copied from [saveContent].
  SaveContentProvider(
    SavedContent content,
  ) : this._internal(
          (ref) => saveContent(
            ref as SaveContentRef,
            content,
          ),
          from: saveContentProvider,
          name: r'saveContentProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$saveContentHash,
          dependencies: SaveContentFamily._dependencies,
          allTransitiveDependencies:
              SaveContentFamily._allTransitiveDependencies,
          content: content,
        );

  SaveContentProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.content,
  }) : super.internal();

  final SavedContent content;

  @override
  Override overrideWith(
    FutureOr<void> Function(SaveContentRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SaveContentProvider._internal(
        (ref) => create(ref as SaveContentRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        content: content,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _SaveContentProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SaveContentProvider && other.content == content;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, content.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SaveContentRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `content` of this provider.
  SavedContent get content;
}

class _SaveContentProviderElement extends AutoDisposeFutureProviderElement<void>
    with SaveContentRef {
  _SaveContentProviderElement(super.provider);

  @override
  SavedContent get content => (origin as SaveContentProvider).content;
}

String _$deleteContentHash() => r'0b9adf8728c89a905070127dd392f65cdfb4e87c';

/// Delete content from Firestore
///
/// Copied from [deleteContent].
@ProviderFor(deleteContent)
const deleteContentProvider = DeleteContentFamily();

/// Delete content from Firestore
///
/// Copied from [deleteContent].
class DeleteContentFamily extends Family<AsyncValue<void>> {
  /// Delete content from Firestore
  ///
  /// Copied from [deleteContent].
  const DeleteContentFamily();

  /// Delete content from Firestore
  ///
  /// Copied from [deleteContent].
  DeleteContentProvider call(
    String contentId,
  ) {
    return DeleteContentProvider(
      contentId,
    );
  }

  @override
  DeleteContentProvider getProviderOverride(
    covariant DeleteContentProvider provider,
  ) {
    return call(
      provider.contentId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'deleteContentProvider';
}

/// Delete content from Firestore
///
/// Copied from [deleteContent].
class DeleteContentProvider extends AutoDisposeFutureProvider<void> {
  /// Delete content from Firestore
  ///
  /// Copied from [deleteContent].
  DeleteContentProvider(
    String contentId,
  ) : this._internal(
          (ref) => deleteContent(
            ref as DeleteContentRef,
            contentId,
          ),
          from: deleteContentProvider,
          name: r'deleteContentProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$deleteContentHash,
          dependencies: DeleteContentFamily._dependencies,
          allTransitiveDependencies:
              DeleteContentFamily._allTransitiveDependencies,
          contentId: contentId,
        );

  DeleteContentProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.contentId,
  }) : super.internal();

  final String contentId;

  @override
  Override overrideWith(
    FutureOr<void> Function(DeleteContentRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteContentProvider._internal(
        (ref) => create(ref as DeleteContentRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        contentId: contentId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _DeleteContentProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteContentProvider && other.contentId == contentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, contentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeleteContentRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `contentId` of this provider.
  String get contentId;
}

class _DeleteContentProviderElement
    extends AutoDisposeFutureProviderElement<void> with DeleteContentRef {
  _DeleteContentProviderElement(super.provider);

  @override
  String get contentId => (origin as DeleteContentProvider).contentId;
}

String _$generateMiniAppHash() => r'67c5af97622ba4d0cf767363b3165b817dcc6efc';

/// Generate mini app
///
/// Copied from [generateMiniApp].
@ProviderFor(generateMiniApp)
const generateMiniAppProvider = GenerateMiniAppFamily();

/// Generate mini app
///
/// Copied from [generateMiniApp].
class GenerateMiniAppFamily extends Family<AsyncValue<GeneratedApp>> {
  /// Generate mini app
  ///
  /// Copied from [generateMiniApp].
  const GenerateMiniAppFamily();

  /// Generate mini app
  ///
  /// Copied from [generateMiniApp].
  GenerateMiniAppProvider call({
    required String description,
    required String selectedModel,
  }) {
    return GenerateMiniAppProvider(
      description: description,
      selectedModel: selectedModel,
    );
  }

  @override
  GenerateMiniAppProvider getProviderOverride(
    covariant GenerateMiniAppProvider provider,
  ) {
    return call(
      description: provider.description,
      selectedModel: provider.selectedModel,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'generateMiniAppProvider';
}

/// Generate mini app
///
/// Copied from [generateMiniApp].
class GenerateMiniAppProvider extends AutoDisposeFutureProvider<GeneratedApp> {
  /// Generate mini app
  ///
  /// Copied from [generateMiniApp].
  GenerateMiniAppProvider({
    required String description,
    required String selectedModel,
  }) : this._internal(
          (ref) => generateMiniApp(
            ref as GenerateMiniAppRef,
            description: description,
            selectedModel: selectedModel,
          ),
          from: generateMiniAppProvider,
          name: r'generateMiniAppProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$generateMiniAppHash,
          dependencies: GenerateMiniAppFamily._dependencies,
          allTransitiveDependencies:
              GenerateMiniAppFamily._allTransitiveDependencies,
          description: description,
          selectedModel: selectedModel,
        );

  GenerateMiniAppProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.description,
    required this.selectedModel,
  }) : super.internal();

  final String description;
  final String selectedModel;

  @override
  Override overrideWith(
    FutureOr<GeneratedApp> Function(GenerateMiniAppRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GenerateMiniAppProvider._internal(
        (ref) => create(ref as GenerateMiniAppRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        description: description,
        selectedModel: selectedModel,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<GeneratedApp> createElement() {
    return _GenerateMiniAppProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GenerateMiniAppProvider &&
        other.description == description &&
        other.selectedModel == selectedModel;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, description.hashCode);
    hash = _SystemHash.combine(hash, selectedModel.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GenerateMiniAppRef on AutoDisposeFutureProviderRef<GeneratedApp> {
  /// The parameter `description` of this provider.
  String get description;

  /// The parameter `selectedModel` of this provider.
  String get selectedModel;
}

class _GenerateMiniAppProviderElement
    extends AutoDisposeFutureProviderElement<GeneratedApp>
    with GenerateMiniAppRef {
  _GenerateMiniAppProviderElement(super.provider);

  @override
  String get description => (origin as GenerateMiniAppProvider).description;
  @override
  String get selectedModel => (origin as GenerateMiniAppProvider).selectedModel;
}

String _$generateGeogebraHash() => r'032f444ea17824336ee653cddb906c35abe52418';

/// Generate GeoGebra visualization
///
/// Copied from [generateGeogebra].
@ProviderFor(generateGeogebra)
const generateGeogebraProvider = GenerateGeogebraFamily();

/// Generate GeoGebra visualization
///
/// Copied from [generateGeogebra].
class GenerateGeogebraFamily extends Family<AsyncValue<GeoGebraData>> {
  /// Generate GeoGebra visualization
  ///
  /// Copied from [generateGeogebra].
  const GenerateGeogebraFamily();

  /// Generate GeoGebra visualization
  ///
  /// Copied from [generateGeogebra].
  GenerateGeogebraProvider call({
    required String prompt,
    String? questionText,
    String? topic,
  }) {
    return GenerateGeogebraProvider(
      prompt: prompt,
      questionText: questionText,
      topic: topic,
    );
  }

  @override
  GenerateGeogebraProvider getProviderOverride(
    covariant GenerateGeogebraProvider provider,
  ) {
    return call(
      prompt: provider.prompt,
      questionText: provider.questionText,
      topic: provider.topic,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'generateGeogebraProvider';
}

/// Generate GeoGebra visualization
///
/// Copied from [generateGeogebra].
class GenerateGeogebraProvider extends AutoDisposeFutureProvider<GeoGebraData> {
  /// Generate GeoGebra visualization
  ///
  /// Copied from [generateGeogebra].
  GenerateGeogebraProvider({
    required String prompt,
    String? questionText,
    String? topic,
  }) : this._internal(
          (ref) => generateGeogebra(
            ref as GenerateGeogebraRef,
            prompt: prompt,
            questionText: questionText,
            topic: topic,
          ),
          from: generateGeogebraProvider,
          name: r'generateGeogebraProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$generateGeogebraHash,
          dependencies: GenerateGeogebraFamily._dependencies,
          allTransitiveDependencies:
              GenerateGeogebraFamily._allTransitiveDependencies,
          prompt: prompt,
          questionText: questionText,
          topic: topic,
        );

  GenerateGeogebraProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.prompt,
    required this.questionText,
    required this.topic,
  }) : super.internal();

  final String prompt;
  final String? questionText;
  final String? topic;

  @override
  Override overrideWith(
    FutureOr<GeoGebraData> Function(GenerateGeogebraRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GenerateGeogebraProvider._internal(
        (ref) => create(ref as GenerateGeogebraRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        prompt: prompt,
        questionText: questionText,
        topic: topic,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<GeoGebraData> createElement() {
    return _GenerateGeogebraProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GenerateGeogebraProvider &&
        other.prompt == prompt &&
        other.questionText == questionText &&
        other.topic == topic;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, prompt.hashCode);
    hash = _SystemHash.combine(hash, questionText.hashCode);
    hash = _SystemHash.combine(hash, topic.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GenerateGeogebraRef on AutoDisposeFutureProviderRef<GeoGebraData> {
  /// The parameter `prompt` of this provider.
  String get prompt;

  /// The parameter `questionText` of this provider.
  String? get questionText;

  /// The parameter `topic` of this provider.
  String? get topic;
}

class _GenerateGeogebraProviderElement
    extends AutoDisposeFutureProviderElement<GeoGebraData>
    with GenerateGeogebraRef {
  _GenerateGeogebraProviderElement(super.provider);

  @override
  String get prompt => (origin as GenerateGeogebraProvider).prompt;
  @override
  String? get questionText => (origin as GenerateGeogebraProvider).questionText;
  @override
  String? get topic => (origin as GenerateGeogebraProvider).topic;
}

String _$contentTypeFilterHash() => r'8f2ba757c9c3c41da9d9c56767e50b08f6ff41f6';

/// Content type filter provider
///
/// Copied from [ContentTypeFilter].
@ProviderFor(ContentTypeFilter)
final contentTypeFilterProvider =
    AutoDisposeNotifierProvider<ContentTypeFilter, ContentType?>.internal(
  ContentTypeFilter.new,
  name: r'contentTypeFilterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$contentTypeFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ContentTypeFilter = AutoDisposeNotifier<ContentType?>;
String _$searchQueryHash() => r'a2de29f344488b8b351fbfcf9c230f993798b9ea';

/// Search query provider
///
/// Copied from [SearchQuery].
@ProviderFor(SearchQuery)
final searchQueryProvider =
    AutoDisposeNotifierProvider<SearchQuery, String>.internal(
  SearchQuery.new,
  name: r'searchQueryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$searchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchQuery = AutoDisposeNotifier<String>;
String _$generatedAppStateHash() => r'7ee9792fce0b200f22e628014c1f1fe309462a5d';

/// Generated app state provider
///
/// Copied from [GeneratedAppState].
@ProviderFor(GeneratedAppState)
final generatedAppStateProvider =
    AutoDisposeNotifierProvider<GeneratedAppState, GeneratedApp?>.internal(
  GeneratedAppState.new,
  name: r'generatedAppStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$generatedAppStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GeneratedAppState = AutoDisposeNotifier<GeneratedApp?>;
String _$geogebraVisualizationStateHash() =>
    r'f38f209bbd47f0bdf34530d0ea99ba1d0fe2cf61';

/// GeoGebra visualization state provider
///
/// Copied from [GeogebraVisualizationState].
@ProviderFor(GeogebraVisualizationState)
final geogebraVisualizationStateProvider = AutoDisposeNotifierProvider<
    GeogebraVisualizationState, GeoGebraData?>.internal(
  GeogebraVisualizationState.new,
  name: r'geogebraVisualizationStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$geogebraVisualizationStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GeogebraVisualizationState = AutoDisposeNotifier<GeoGebraData?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
