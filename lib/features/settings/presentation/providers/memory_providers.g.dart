// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userMemoriesHash() => r'6f3b91bb22d926adde0f190d0affbb273fd57587';

/// Streams all non-archived memories for the current user, ordered by next review date.
///
/// Copied from [userMemories].
@ProviderFor(userMemories)
final userMemoriesProvider = AutoDisposeStreamProvider<List<Memory>>.internal(
  userMemories,
  name: r'userMemoriesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userMemoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserMemoriesRef = AutoDisposeStreamProviderRef<List<Memory>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
