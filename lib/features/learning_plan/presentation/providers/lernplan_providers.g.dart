// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lernplan_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lernplanStreamHash() => r'e18f264da3371066a5ed27bc9361e3ae1a55608a';

/// Provides the current user's Lernplan in real-time.
/// Returns an empty Lernplan if no user is logged in or if the Lernplan doesn't exist.
///
/// Copied from [lernplanStream].
@ProviderFor(lernplanStream)
final lernplanStreamProvider = AutoDisposeStreamProvider<Lernplan>.internal(
  lernplanStream,
  name: r'lernplanStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lernplanStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LernplanStreamRef = AutoDisposeStreamProviderRef<Lernplan>;
String _$lernplanNotifierHash() => r'32a269f9a7d0962f8a6200876c7da232aae70a88';

/// Notifier to manage the user's Lernplan.
/// Allows adding and removing topics, persisting changes to Firestore.
///
/// Copied from [LernplanNotifier].
@ProviderFor(LernplanNotifier)
final lernplanNotifierProvider =
    AutoDisposeAsyncNotifierProvider<LernplanNotifier, Lernplan>.internal(
  LernplanNotifier.new,
  name: r'lernplanNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lernplanNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LernplanNotifier = AutoDisposeAsyncNotifier<Lernplan>;
String _$lernplanTopicsAsTopicDataHash() =>
    r'7e2c7443701fbdf97da101bfd00e98a2975ca9f9';

/// Converts the Lernplan's topics into a `List<TopicData>` for use with AI services.
///
/// Copied from [LernplanTopicsAsTopicData].
@ProviderFor(LernplanTopicsAsTopicData)
final lernplanTopicsAsTopicDataProvider = AutoDisposeNotifierProvider<
    LernplanTopicsAsTopicData, List<TopicData>>.internal(
  LernplanTopicsAsTopicData.new,
  name: r'lernplanTopicsAsTopicDataProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lernplanTopicsAsTopicDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LernplanTopicsAsTopicData = AutoDisposeNotifier<List<TopicData>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
