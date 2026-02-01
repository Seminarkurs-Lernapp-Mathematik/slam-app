import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_providers.g.dart';

/// Theme Presets
enum AppThemePreset {
  sunsetOrange,
  oceanBlue,
  forestGreen,
  lavenderPurple,
  cherryRed,
}

/// AI Provider
enum AIProvider {
  claude,
  gemini,
}

/// Course Type
enum CourseType {
  grundkurs,
  leistungskurs,
}

/// Selected Theme Provider
@riverpod
class SelectedTheme extends _$SelectedTheme {
  static const _keyTheme = 'selected_theme';

  @override
  AppThemePreset build() {
    _loadTheme();
    return AppThemePreset.sunsetOrange;
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_keyTheme) ?? 0;
    state = AppThemePreset.values[themeIndex];
  }

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyTheme, state.index);
  }

  void setTheme(AppThemePreset theme) {
    state = theme;
    _saveTheme();
  }
}

/// AI Configuration Model
class AIConfig {
  final AIProvider provider;
  final int detailLevel;
  final double temperature;
  final int helpfulness;

  const AIConfig({
    required this.provider,
    required this.detailLevel,
    required this.temperature,
    required this.helpfulness,
  });

  AIConfig copyWith({
    AIProvider? provider,
    int? detailLevel,
    double? temperature,
    int? helpfulness,
  }) {
    return AIConfig(
      provider: provider ?? this.provider,
      detailLevel: detailLevel ?? this.detailLevel,
      temperature: temperature ?? this.temperature,
      helpfulness: helpfulness ?? this.helpfulness,
    );
  }

  /// Get the model name for API calls
  String getModelName() {
    switch (provider) {
      case AIProvider.claude:
        return 'claude-sonnet-4-5-20250929';
      case AIProvider.gemini:
        return 'gemini-2.5-flash';
    }
  }
}

/// AI Configuration Provider
@riverpod
class AIConfigNotifier extends _$AIConfigNotifier {
  static const _keyProvider = 'ai_provider';
  static const _keyDetailLevel = 'ai_detail_level';
  static const _keyTemperature = 'ai_temperature';
  static const _keyHelpfulness = 'ai_helpfulness';

  @override
  AIConfig build() {
    _loadSettings();
    return const AIConfig(
      provider: AIProvider.claude,
      detailLevel: 5,
      temperature: 0.7,
      helpfulness: 7,
    );
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final providerIndex = prefs.getInt(_keyProvider) ?? 0;
    final detailLevel = prefs.getInt(_keyDetailLevel) ?? 5;
    final temperature = prefs.getDouble(_keyTemperature) ?? 0.7;
    final helpfulness = prefs.getInt(_keyHelpfulness) ?? 7;

    state = AIConfig(
      provider: AIProvider.values[providerIndex],
      detailLevel: detailLevel,
      temperature: temperature,
      helpfulness: helpfulness,
    );
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyProvider, state.provider.index);
    await prefs.setInt(_keyDetailLevel, state.detailLevel);
    await prefs.setDouble(_keyTemperature, state.temperature);
    await prefs.setInt(_keyHelpfulness, state.helpfulness);
  }

  void setProvider(AIProvider provider) {
    state = state.copyWith(provider: provider);
    _saveSettings();
  }

  void setDetailLevel(int level) {
    state = state.copyWith(detailLevel: level);
    _saveSettings();
  }

  void setTemperature(double temperature) {
    state = state.copyWith(temperature: temperature);
    _saveSettings();
  }

  void setHelpfulness(int helpfulness) {
    state = state.copyWith(helpfulness: helpfulness);
    _saveSettings();
  }
}

/// Education Configuration Model
class EducationConfig {
  final String gradeLevel;
  final CourseType courseType;

  const EducationConfig({
    required this.gradeLevel,
    required this.courseType,
  });

  EducationConfig copyWith({
    String? gradeLevel,
    CourseType? courseType,
  }) {
    return EducationConfig(
      gradeLevel: gradeLevel ?? this.gradeLevel,
      courseType: courseType ?? this.courseType,
    );
  }
}

/// Education Configuration Provider
@riverpod
class EducationConfigNotifier extends _$EducationConfigNotifier {
  @override
  EducationConfig build() {
    return const EducationConfig(
      gradeLevel: '11',
      courseType: CourseType.leistungskurs,
    );
  }

  void setGradeLevel(String level) {
    state = state.copyWith(gradeLevel: level);
  }

  void setCourseType(CourseType type) {
    state = state.copyWith(courseType: type);
  }
}

/// Debug Configuration Model
class DebugConfig {
  final String claudeApiKey;
  final String geminiApiKey;
  final String backendUrl;
  final bool mockMode;
  final bool verboseLogging;
  final bool skipEmailVerification;

  const DebugConfig({
    required this.claudeApiKey,
    required this.geminiApiKey,
    required this.backendUrl,
    required this.mockMode,
    required this.verboseLogging,
    required this.skipEmailVerification,
  });

  DebugConfig copyWith({
    String? claudeApiKey,
    String? geminiApiKey,
    String? backendUrl,
    bool? mockMode,
    bool? verboseLogging,
    bool? skipEmailVerification,
  }) {
    return DebugConfig(
      claudeApiKey: claudeApiKey ?? this.claudeApiKey,
      geminiApiKey: geminiApiKey ?? this.geminiApiKey,
      backendUrl: backendUrl ?? this.backendUrl,
      mockMode: mockMode ?? this.mockMode,
      verboseLogging: verboseLogging ?? this.verboseLogging,
      skipEmailVerification: skipEmailVerification ?? this.skipEmailVerification,
    );
  }
}

/// Debug Configuration Provider
@riverpod
class DebugConfigNotifier extends _$DebugConfigNotifier {
  @override
  DebugConfig build() {
    return const DebugConfig(
      claudeApiKey: '',
      geminiApiKey: '',
      backendUrl: 'https://api.slam-learning.de',
      mockMode: false,
      verboseLogging: false,
      skipEmailVerification: false,
    );
  }

  void setClaudeApiKey(String key) {
    state = state.copyWith(claudeApiKey: key);
  }

  void setGeminiApiKey(String key) {
    state = state.copyWith(geminiApiKey: key);
  }

  void setBackendUrl(String url) {
    state = state.copyWith(backendUrl: url);
  }

  void setMockMode(bool enabled) {
    state = state.copyWith(mockMode: enabled);
  }

  void setVerboseLogging(bool enabled) {
    state = state.copyWith(verboseLogging: enabled);
  }

  void setSkipEmailVerification(bool enabled) {
    state = state.copyWith(skipEmailVerification: enabled);
  }

  void reset() {
    state = const DebugConfig(
      claudeApiKey: '',
      geminiApiKey: '',
      backendUrl: 'https://api.slam-learning.de',
      mockMode: false,
      verboseLogging: false,
      skipEmailVerification: false,
    );
  }
}
