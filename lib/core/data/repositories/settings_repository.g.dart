// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settingsRepositoryHash() =>
    r'2a1dda93f4cbe1921c667cb7f1caef450105bf4f';

/// See also [settingsRepository].
@ProviderFor(settingsRepository)
final settingsRepositoryProvider =
    AutoDisposeProvider<SettingsRepository>.internal(
  settingsRepository,
  name: r'settingsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settingsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SettingsRepositoryRef = AutoDisposeProviderRef<SettingsRepository>;
String _$userSettingsHash() => r'03f2a09553f73d9c0e7d6532e08d4fbf48bb9734';

/// See also [userSettings].
@ProviderFor(userSettings)
final userSettingsProvider = AutoDisposeFutureProvider<UserSettings>.internal(
  userSettings,
  name: r'userSettingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserSettingsRef = AutoDisposeFutureProviderRef<UserSettings>;
String _$userSettingsStreamHash() =>
    r'9e82fccacd881f51386b3d5dae50ea40570f1a35';

/// See also [userSettingsStream].
@ProviderFor(userSettingsStream)
final userSettingsStreamProvider =
    AutoDisposeStreamProvider<UserSettings>.internal(
  userSettingsStream,
  name: r'userSettingsStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userSettingsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserSettingsStreamRef = AutoDisposeStreamProviderRef<UserSettings>;
String _$localDataSourceHash() => r'6bda3316aff15afc5e1fe3151877a0d08a295382';

/// See also [localDataSource].
@ProviderFor(localDataSource)
final localDataSourceProvider = AutoDisposeProvider<LocalDataSource>.internal(
  localDataSource,
  name: r'localDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocalDataSourceRef = AutoDisposeProviderRef<LocalDataSource>;
String _$remoteDataSourceHash() => r'd7e4750bd5c8fc712336afce20619eb205e95393';

/// See also [remoteDataSource].
@ProviderFor(remoteDataSource)
final remoteDataSourceProvider = AutoDisposeProvider<RemoteDataSource>.internal(
  remoteDataSource,
  name: r'remoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$remoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RemoteDataSourceRef = AutoDisposeProviderRef<RemoteDataSource>;
String _$settingsNotifierHash() => r'7b62141a76837ab67185512c09c396b7759e077d';

/// See also [SettingsNotifier].
@ProviderFor(SettingsNotifier)
final settingsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<SettingsNotifier, UserSettings>.internal(
  SettingsNotifier.new,
  name: r'settingsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settingsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SettingsNotifier = AutoDisposeAsyncNotifier<UserSettings>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
