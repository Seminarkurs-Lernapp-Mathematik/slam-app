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
  standard,
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
      gradeLevel: '10',
      courseType: CourseType.standard,
    );
  }

  void setGradeLevel(String level) {
    state = state.copyWith(gradeLevel: level);
  }

  void setCourseType(CourseType type) {
    state = state.copyWith(courseType: type);
  }
}
