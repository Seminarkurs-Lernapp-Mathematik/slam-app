// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appSettingsNotifierHash() =>
    r'1b888c15652cca13945741c0c6041595ff86a45e';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
