import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

/// User Settings Model
///
/// Kompatibel mit React App Firestore Structure:
/// users/{userId}/settings
@freezed
class UserSettings with _$UserSettings {
  const UserSettings._();

  const factory UserSettings({
    required ThemeSettings theme,
    required AIModelSettings aiModel,
    @Default('Klasse_11') String gradeLevel,
    @Default('Leistungsfach') String courseType,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);

  /// Default settings (Sunset theme)
  factory UserSettings.initial() {
    return UserSettings(
      theme: ThemeSettings.sunset(),
      aiModel: AIModelSettings.initial(),
      gradeLevel: 'Klasse_11',
      courseType: 'Leistungsfach',
    );
  }
}

/// Theme Settings
@freezed
class ThemeSettings with _$ThemeSettings {
  const ThemeSettings._();

  const factory ThemeSettings({
    required String name,
    required String primary,
    required String gradient,
    required String gradientFrom,
    required String gradientTo,
    required String glow,
  }) = _ThemeSettings;

  factory ThemeSettings.fromJson(Map<String, dynamic> json) =>
      _$ThemeSettingsFromJson(json);

  /// Sunset Theme (Default - Orange)
  factory ThemeSettings.sunset() {
    return const ThemeSettings(
      name: 'Sunset',
      primary: '#f97316',
      gradient: 'linear-gradient(135deg, #f97316 0%, #ea580c 100%)',
      gradientFrom: '#f97316',
      gradientTo: '#ea580c',
      glow: 'rgba(249, 115, 22, 0.4)',
    );
  }

  /// Ocean Theme (Blue)
  factory ThemeSettings.ocean() {
    return const ThemeSettings(
      name: 'Ocean',
      primary: '#3b82f6',
      gradient: 'linear-gradient(135deg, #3b82f6 0%, #2563eb 100%)',
      gradientFrom: '#3b82f6',
      gradientTo: '#2563eb',
      glow: 'rgba(59, 130, 246, 0.4)',
    );
  }

  /// Forest Theme (Green)
  factory ThemeSettings.forest() {
    return const ThemeSettings(
      name: 'Forest',
      primary: '#22c55e',
      gradient: 'linear-gradient(135deg, #22c55e 0%, #16a34a 100%)',
      gradientFrom: '#22c55e',
      gradientTo: '#16a34a',
      glow: 'rgba(34, 197, 94, 0.4)',
    );
  }

  /// Purple Theme
  factory ThemeSettings.purple() {
    return const ThemeSettings(
      name: 'Purple',
      primary: '#a855f7',
      gradient: 'linear-gradient(135deg, #a855f7 0%, #9333ea 100%)',
      gradientFrom: '#a855f7',
      gradientTo: '#9333ea',
      glow: 'rgba(168, 85, 247, 0.4)',
    );
  }
}

/// AI Model Settings
@freezed
class AIModelSettings with _$AIModelSettings {
  const AIModelSettings._();

  const factory AIModelSettings({
    @Default(5) int detailLevel, // 1-10
    @Default(0.7) double temperature, // 0-1
    @Default(7) int helpfulness, // 1-10
    @Default(true) bool autoMode,
    @Default('gemini') String aiProvider, // 'claude' or 'gemini'
    String? claudeApiKey,
    String? geminiApiKey,
    @Default('gemini-2.0-flash-lite') String geminiFastModel,
    @Default('gemini-2.0-flash') String geminiModel,
    @Default('gemini-2.5-pro-preview-05-06') String geminiSmartModel,
    @Default('fast') String modelMode, // 'fast', 'standard', 'smart'
    String? selectedModel, // Current active model (derived from provider + mode)
    @Default(false) bool showAiAssessments,
  }) = _AIModelSettings;

  factory AIModelSettings.fromJson(Map<String, dynamic> json) =>
      _$AIModelSettingsFromJson(json);

  factory AIModelSettings.initial() {
    return const AIModelSettings(
      detailLevel: 5,
      temperature: 0.7,
      helpfulness: 7,
      autoMode: true,
      aiProvider: 'gemini',
      geminiFastModel: 'gemini-2.0-flash-lite',
      geminiModel: 'gemini-2.0-flash',
      geminiSmartModel: 'gemini-2.5-pro-preview-05-06',
      modelMode: 'fast',
      showAiAssessments: false,
    );
  }

  /// Get the current active model based on provider and mode
  String get activeModel {
    if (selectedModel != null && selectedModel!.isNotEmpty) {
      return selectedModel!;
    }

    if (aiProvider == 'claude') {
      switch (modelMode) {
        case 'fast':
          return 'claude-haiku-4-5-20251001';
        case 'standard':
          return 'claude-sonnet-4-5-20250929';
        case 'smart':
          return 'claude-sonnet-4-5-20250929';
        default:
          return 'claude-sonnet-4-5-20250929';
      }
    } else {
      switch (modelMode) {
        case 'fast':
          return geminiFastModel;
        case 'standard':
          return geminiModel;
        case 'smart':
          return geminiSmartModel;
        default:
          return geminiModel;
      }
    }
  }
}
