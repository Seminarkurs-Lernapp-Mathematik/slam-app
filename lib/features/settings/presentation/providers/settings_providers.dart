import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_providers.g.dart';

/// Theme Presets
enum AppThemePreset {
  sunsetOrange,
  oceanBlue,
  forestGreen,
  lavenderPurple,
  midnightDark,
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
  @override
  AppThemePreset build() {
    return AppThemePreset.sunsetOrange;
  }

  void setTheme(AppThemePreset theme) {
    state = theme;
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
}

/// AI Configuration Provider
@riverpod
class AIConfigNotifier extends _$AIConfigNotifier {
  @override
  AIConfig build() {
    return const AIConfig(
      provider: AIProvider.claude,
      detailLevel: 5,
      temperature: 0.7,
      helpfulness: 7,
    );
  }

  void setProvider(AIProvider provider) {
    state = state.copyWith(provider: provider);
  }

  void setDetailLevel(int level) {
    state = state.copyWith(detailLevel: level);
  }

  void setTemperature(double temperature) {
    state = state.copyWith(temperature: temperature);
  }

  void setHelpfulness(int helpfulness) {
    state = state.copyWith(helpfulness: helpfulness);
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
