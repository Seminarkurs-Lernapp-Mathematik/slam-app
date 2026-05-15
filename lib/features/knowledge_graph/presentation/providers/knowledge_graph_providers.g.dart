// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledge_graph_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$topicProgressMapHash() => r'45d985a265bd7f342802b9684c245b93926b9397';

/// Stream of all topicProgress documents for the current user.
/// Returns empty map when user is null or has no progress data yet.
///
/// Copied from [topicProgressMap].
@ProviderFor(topicProgressMap)
final topicProgressMapProvider =
    AutoDisposeStreamProvider<Map<String, TopicProgress>>.internal(
  topicProgressMap,
  name: r'topicProgressMapProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$topicProgressMapHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TopicProgressMapRef
    = AutoDisposeStreamProviderRef<Map<String, TopicProgress>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
