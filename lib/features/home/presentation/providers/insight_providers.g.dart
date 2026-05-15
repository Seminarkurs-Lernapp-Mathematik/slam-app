// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insight_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todayInsightHash() => r'071a7830a99f7c268f3b879e500d4d756d746de6';

/// Streams today's insight for the current user, or null if none exists.
///
/// Copied from [todayInsight].
@ProviderFor(todayInsight)
final todayInsightProvider = AutoDisposeStreamProvider<DailyInsight?>.internal(
  todayInsight,
  name: r'todayInsightProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$todayInsightHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayInsightRef = AutoDisposeStreamProviderRef<DailyInsight?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
