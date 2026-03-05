// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$availableModelsHash() => r'a43b05f41a57c9674e60017b89045f0a79b13d0e';

/// Available models from backend — live-fetched using the user's API key.
/// Falls back to the backend's curated list if no key is configured.
///
/// Copied from [availableModels].
@ProviderFor(availableModels)
final availableModelsProvider =
    AutoDisposeFutureProvider<List<dynamic>>.internal(
  availableModels,
  name: r'availableModelsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$availableModelsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableModelsRef = AutoDisposeFutureProviderRef<List<dynamic>>;
String _$appSettingsNotifierHash() =>
    r'ddd47502936a778cd2756d7693fdbdce48b82f7f';

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
String _$aIConfigNotifierHash() => r'1f79cc70372d4d4b32f958e04bfde64babb8d148';

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
    r'975ca8f5a862cf5ca95e9b773ad129bd48bbadec';

/// Debug Configuration Provider with SharedPreferences persistence
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
