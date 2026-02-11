// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lernplan_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lernplanStreamHash() => r'db5cf25c9077070d808f433a86403585b0291d66';

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
String _$lernplanTopicsAsTopicDataProviderHash() =>
    r'9f346697c485776d9725b569c3cbeead90f87d2e';

/// Converts the Lernplan's topics into a List<TopicData> for use with AI services.
///
/// Copied from [lernplanTopicsAsTopicDataProvider].
@ProviderFor(lernplanTopicsAsTopicDataProvider)
final lernplanTopicsAsTopicDataProviderProvider =
    AutoDisposeProvider<List<TopicData>>.internal(
  lernplanTopicsAsTopicDataProvider,
  name: r'lernplanTopicsAsTopicDataProviderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lernplanTopicsAsTopicDataProviderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LernplanTopicsAsTopicDataProviderRef
    = AutoDisposeProviderRef<List<TopicData>>;
String _$lernplanNotifierHash() => r'ad9459956385b963e13416c9a3d9b26181aef61a';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
