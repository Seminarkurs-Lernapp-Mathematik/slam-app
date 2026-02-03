// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appSettingsNotifierHash() =>
    r'5b80e6d8436f2e7e32e53ac07228c149a56aae60';

/// See also [AppSettingsNotifier].
@ProviderFor(AppSettingsNotifier)
final appSettingsNotifierProvider =
    AutoDisposeNotifierProvider<AppSettingsNotifier, AppSettings>.internal(
  AppSettingsNotifier.new,
  name: r'appSettingsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appSettingsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AppSettingsNotifier = AutoDisposeNotifier<AppSettings>;
String _$selectedThemeHash() => r'e00d40fccb484ce7cf51d211722f1ac8bd93279f';

/// Selected Theme Provider (legacy - now uses AppSettingsNotifier)
///
/// Copied from [SelectedTheme].
@ProviderFor(SelectedTheme)
final selectedThemeProvider =
    AutoDisposeNotifierProvider<SelectedTheme, AppThemePreset>.internal(
  SelectedTheme.new,
  name: r'selectedThemeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedThemeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedTheme = AutoDisposeNotifier<AppThemePreset>;
String _$aIConfigNotifierHash() => r'2d5344399353fadc5d3a3da5e17588b41da21899';

/// AI Config Provider (legacy wrapper)
///
/// Copied from [AIConfigNotifier].
@ProviderFor(AIConfigNotifier)
final aIConfigNotifierProvider =
    AutoDisposeNotifierProvider<AIConfigNotifier, AIConfig>.internal(
  AIConfigNotifier.new,
  name: r'aIConfigNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$aIConfigNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AIConfigNotifier = AutoDisposeNotifier<AIConfig>;
String _$educationConfigNotifierHash() =>
    r'5240e895ff7dc59ec0a4a3bc20fc28fd50a2edac';

/// Education Configuration Provider (legacy wrapper)
///
/// Copied from [EducationConfigNotifier].
@ProviderFor(EducationConfigNotifier)
final educationConfigNotifierProvider = AutoDisposeNotifierProvider<
    EducationConfigNotifier, EducationConfig>.internal(
  EducationConfigNotifier.new,
  name: r'educationConfigNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$educationConfigNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EducationConfigNotifier = AutoDisposeNotifier<EducationConfig>;
String _$debugConfigNotifierHash() =>
    r'3fdd4001eaa345f5ed7b03d22c2ca3c450a43608';

/// Debug Configuration Provider
///
/// Copied from [DebugConfigNotifier].
@ProviderFor(DebugConfigNotifier)
final debugConfigNotifierProvider =
    AutoDisposeNotifierProvider<DebugConfigNotifier, DebugConfig>.internal(
  DebugConfigNotifier.new,
  name: r'debugConfigNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$debugConfigNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DebugConfigNotifier = AutoDisposeNotifier<DebugConfig>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
