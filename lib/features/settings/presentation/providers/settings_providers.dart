import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/services/auth_service.dart';

part 'settings_providers.g.dart';

/// Theme Presets
enum AppThemePreset {
  sunsetOrange,
  oceanBlue,
  forestGreen,
  lavenderPurple,
  cherryRed,
}

/// Course Type
enum CourseType {
  grundkurs,
  leistungskurs,
}

// ============================================================================
// THEME CONFIGURATION
// ============================================================================

/// Theme data for Firebase storage
class ThemeConfig {
  final String name;
  final String primary;
  final String gradient;
  final String gradientFrom;
  final String gradientTo;
  final String glow;

  const ThemeConfig({
    required this.name,
    required this.primary,
    required this.gradient,
    required this.gradientFrom,
    required this.gradientTo,
    required this.glow,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'primary': primary,
        'gradient': gradient,
        'gradientFrom': gradientFrom,
        'gradientTo': gradientTo,
        'glow': glow,
      };

  factory ThemeConfig.fromJson(Map<String, dynamic> json) {
    return ThemeConfig(
      name: json['name'] ?? 'Sunset',
      primary: json['primary'] ?? '#f97316',
      gradient: json['gradient'] ?? 'linear-gradient(135deg, #f97316 0%, #ea580c 100%)',
      gradientFrom: json['gradientFrom'] ?? '#f97316',
      gradientTo: json['gradientTo'] ?? '#ea580c',
      glow: json['glow'] ?? 'rgba(249, 115, 22, 0.4)',
    );
  }

  factory ThemeConfig.fromPreset(AppThemePreset preset) {
    switch (preset) {
      case AppThemePreset.sunsetOrange:
        return const ThemeConfig(
          name: 'Sunset',
          primary: '#f97316',
          gradient: 'linear-gradient(135deg, #f97316 0%, #ea580c 100%)',
          gradientFrom: '#f97316',
          gradientTo: '#ea580c',
          glow: 'rgba(249, 115, 22, 0.4)',
        );
      case AppThemePreset.oceanBlue:
        return const ThemeConfig(
          name: 'Ocean',
          primary: '#3b82f6',
          gradient: 'linear-gradient(135deg, #3b82f6 0%, #2563eb 100%)',
          gradientFrom: '#3b82f6',
          gradientTo: '#2563eb',
          glow: 'rgba(59, 130, 246, 0.4)',
        );
      case AppThemePreset.forestGreen:
        return const ThemeConfig(
          name: 'Forest',
          primary: '#22c55e',
          gradient: 'linear-gradient(135deg, #22c55e 0%, #16a34a 100%)',
          gradientFrom: '#22c55e',
          gradientTo: '#16a34a',
          glow: 'rgba(34, 197, 94, 0.4)',
        );
      case AppThemePreset.lavenderPurple:
        return const ThemeConfig(
          name: 'Lavender',
          primary: '#a855f7',
          gradient: 'linear-gradient(135deg, #a855f7 0%, #9333ea 100%)',
          gradientFrom: '#a855f7',
          gradientTo: '#9333ea',
          glow: 'rgba(168, 85, 247, 0.4)',
        );
      case AppThemePreset.cherryRed:
        return const ThemeConfig(
          name: 'Cherry',
          primary: '#ef4444',
          gradient: 'linear-gradient(135deg, #ef4444 0%, #dc2626 100%)',
          gradientFrom: '#ef4444',
          gradientTo: '#dc2626',
          glow: 'rgba(239, 68, 68, 0.4)',
        );
    }
  }

  AppThemePreset toPreset() {
    switch (name.toLowerCase()) {
      case 'ocean':
        return AppThemePreset.oceanBlue;
      case 'forest':
        return AppThemePreset.forestGreen;
      case 'lavender':
        return AppThemePreset.lavenderPurple;
      case 'cherry':
        return AppThemePreset.cherryRed;
      default:
        return AppThemePreset.sunsetOrange;
    }
  }
}

// ============================================================================
// AI MODEL CONFIGURATION (AUTO mode preferences only)
// ============================================================================

/// AI Model settings for AUTO mode behavior (nested in Firebase as settings.aiModel)
/// These are user preferences for AI behavior, not provider/model selection
/// which is now managed by the backend via models.json
class AIModelConfig {
  final bool autoMode;
  final int detailLevel;
  final int helpfulness;
  final double temperature;

  const AIModelConfig({
    this.autoMode = true,
    this.detailLevel = 5,
    this.helpfulness = 7,
    this.temperature = 0.7,
  });

  Map<String, dynamic> toJson() => {
        'autoMode': autoMode,
        'detailLevel': detailLevel,
        'helpfulness': helpfulness,
        'temperature': temperature,
      };

  factory AIModelConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const AIModelConfig();

    int detailLevel = json['detailLevel'] ?? 5;
    int helpfulness = json['helpfulness'] ?? 7;
    // Clamp to valid range for sliders
    if (detailLevel > 10) detailLevel = 5;
    if (helpfulness > 10) helpfulness = 7;

    return AIModelConfig(
      autoMode: json['autoMode'] ?? true,
      detailLevel: detailLevel.clamp(1, 10),
      helpfulness: helpfulness.clamp(1, 10),
      temperature: (json['temperature'] ?? 0.7).toDouble().clamp(0.0, 1.0),
    );
  }

  AIModelConfig copyWith({
    bool? autoMode,
    int? detailLevel,
    int? helpfulness,
    double? temperature,
  }) {
    return AIModelConfig(
      autoMode: autoMode ?? this.autoMode,
      detailLevel: detailLevel ?? this.detailLevel,
      helpfulness: helpfulness ?? this.helpfulness,
      temperature: temperature ?? this.temperature,
    );
  }
}

// ============================================================================
// COMPLETE SETTINGS MODEL (matches Firebase structure)
// ============================================================================

/// Complete settings model matching Firebase structure:
/// users/{userId}/settings
/// AI provider/model selection is now backend-managed via models.json
class AppSettings {
  final AIModelConfig aiModel;
  final String courseType; // 'Leistungsfach' or 'Grundkurs'
  final String gradeLevel; // 'Klasse_11', 'Klasse_12', etc.
  final ThemeConfig theme;
  final DateTime? examDate; // Optional exam/test date for countdown

  const AppSettings({
    this.aiModel = const AIModelConfig(),
    this.courseType = 'Leistungsfach',
    this.gradeLevel = 'Klasse_11',
    required this.theme,
    this.examDate,
  });

  factory AppSettings.initial() {
    return AppSettings(
      theme: ThemeConfig.fromPreset(AppThemePreset.sunsetOrange),
    );
  }

  /// Convert to Firebase JSON structure
  Map<String, dynamic> toJson() => {
        'aiModel': aiModel.toJson(),
        'courseType': courseType,
        'gradeLevel': gradeLevel,
        'theme': theme.toJson(),
        'examDate': examDate?.toIso8601String(),
      };

  /// Create from Firebase JSON
  factory AppSettings.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AppSettings.initial();

    return AppSettings(
      aiModel: AIModelConfig.fromJson(json['aiModel'] as Map<String, dynamic>?),
      courseType: json['courseType'] ?? 'Leistungsfach',
      gradeLevel: json['gradeLevel'] ?? 'Klasse_11',
      theme: json['theme'] != null
          ? ThemeConfig.fromJson(json['theme'] as Map<String, dynamic>)
          : ThemeConfig.fromPreset(AppThemePreset.sunsetOrange),
      examDate: json['examDate'] != null
          ? DateTime.tryParse(json['examDate'] as String)
          : null,
    );
  }

  AppSettings copyWith({
    AIModelConfig? aiModel,
    String? courseType,
    String? gradeLevel,
    ThemeConfig? theme,
    DateTime? examDate,
    bool clearExamDate = false,
  }) {
    return AppSettings(
      aiModel: aiModel ?? this.aiModel,
      courseType: courseType ?? this.courseType,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      theme: theme ?? this.theme,
      examDate: clearExamDate ? null : (examDate ?? this.examDate),
    );
  }
}

// ============================================================================
// MAIN SETTINGS PROVIDER (syncs everything to Firebase)
// ============================================================================

@riverpod
class AppSettingsNotifier extends _$AppSettingsNotifier {
  String? _userId;
  bool _isLoading = false;

  @override
  AppSettings build() {
    final authService = ref.watch(authServiceProvider);
    _userId = authService.currentUser?.uid;

    // Load settings from Firebase/local
    _loadSettings();

    return AppSettings.initial();
  }

  Future<void> _loadSettings() async {
    if (_isLoading) return;
    _isLoading = true;

    try {
      debugPrint('🔄 Loading settings for user: $_userId');

      // First try Firebase if logged in
      if (_userId != null && _userId!.isNotEmpty) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_userId)
            .get();

        debugPrint('📄 Firebase document exists: ${doc.exists}');

        if (doc.exists) {
          final data = doc.data();
          final settings = data?['settings'] as Map<String, dynamic>?;

          debugPrint('⚙️ Settings data from Firebase: ${settings?.keys.toList()}');

          if (settings != null) {
            state = AppSettings.fromJson(settings);
            debugPrint('✅ Loaded from Firebase');
            await _saveToLocalStorage();
            _isLoading = false;
            return;
          }
        } else {
          debugPrint('⚠️ Firebase document does not exist, will be created on first save');
        }
      }

      // Fallback to local storage
      debugPrint('📱 Loading from local storage');
      await _loadFromLocalStorage();
    } catch (e) {
      debugPrint('❌ Error loading settings: $e');
      await _loadFromLocalStorage();
    } finally {
      _isLoading = false;
    }
  }

  Future<void> _loadFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();

    final detailLevel = (prefs.getInt('ai_detail_level') ?? 5).clamp(1, 10);
    final temperature = (prefs.getDouble('ai_temperature') ?? 0.7).clamp(0.0, 1.0);
    final helpfulness = (prefs.getInt('ai_helpfulness') ?? 7).clamp(1, 10);
    final autoMode = prefs.getBool('ai_auto_mode') ?? true;
    final courseType = prefs.getString('course_type') ?? 'Leistungsfach';
    final gradeLevel = prefs.getString('grade_level') ?? 'Klasse_11';
    final themeIndex = prefs.getInt('selected_theme') ?? 0;
    final examDateStr = prefs.getString('exam_date');
    final examDate = examDateStr != null ? DateTime.tryParse(examDateStr) : null;

    state = AppSettings(
      aiModel: AIModelConfig(
        autoMode: autoMode,
        detailLevel: detailLevel,
        helpfulness: helpfulness,
        temperature: temperature,
      ),
      courseType: courseType,
      gradeLevel: gradeLevel,
      theme: ThemeConfig.fromPreset(AppThemePreset.values[themeIndex.clamp(0, 4)]),
      examDate: examDate,
    );
  }

  Future<void> _saveToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('ai_detail_level', state.aiModel.detailLevel);
    await prefs.setDouble('ai_temperature', state.aiModel.temperature);
    await prefs.setInt('ai_helpfulness', state.aiModel.helpfulness);
    await prefs.setBool('ai_auto_mode', state.aiModel.autoMode);
    await prefs.setString('course_type', state.courseType);
    await prefs.setString('grade_level', state.gradeLevel);
    await prefs.setInt('selected_theme', state.theme.toPreset().index);
    if (state.examDate != null) {
      await prefs.setString('exam_date', state.examDate!.toIso8601String());
    } else {
      await prefs.remove('exam_date');
    }
  }

  Future<void> _syncToFirebase() async {
    if (_userId == null || _userId!.isEmpty) return;

    try {
      // Use set with merge to create document if it doesn't exist
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .set({
        'settings': state.toJson()
      }, SetOptions(merge: true));

      debugPrint('✅ Settings synced to Firebase successfully');
    } catch (e) {
      debugPrint('❌ Failed to sync settings to Firebase: $e');
    }
  }

  Future<void> _saveSettings() async {
    await _saveToLocalStorage();
    await _syncToFirebase();
  }

  // AI Model settings (AUTO mode preferences only)
  void setDetailLevel(int level) {
    state = state.copyWith(
      aiModel: state.aiModel.copyWith(detailLevel: level.clamp(1, 10)),
    );
    _saveSettings();
  }

  void setTemperature(double temp) {
    state = state.copyWith(
      aiModel: state.aiModel.copyWith(temperature: temp.clamp(0.0, 1.0)),
    );
    _saveSettings();
  }

  void setHelpfulness(int level) {
    state = state.copyWith(
      aiModel: state.aiModel.copyWith(helpfulness: level.clamp(1, 10)),
    );
    _saveSettings();
  }

  void setAutoMode(bool enabled) {
    state = state.copyWith(
      aiModel: state.aiModel.copyWith(autoMode: enabled),
    );
    _saveSettings();
  }

  // Education settings
  void setCourseType(String type) {
    state = state.copyWith(courseType: type);
    _saveSettings();
  }

  void setGradeLevel(String level) {
    state = state.copyWith(gradeLevel: level);
    _saveSettings();
  }

  // Theme
  void setTheme(AppThemePreset preset) {
    state = state.copyWith(theme: ThemeConfig.fromPreset(preset));
    _saveSettings();
  }

  // Reset to auto defaults
  void resetToAuto() {
    state = state.copyWith(
      aiModel: const AIModelConfig(
        autoMode: true,
        detailLevel: 5,
        helpfulness: 7,
        temperature: 0.7,
      ),
    );
    _saveSettings();
  }

  // Exam date
  void setExamDate(DateTime? date) {
    state = date != null
        ? state.copyWith(examDate: date)
        : state.copyWith(clearExamDate: true);
    _saveSettings();
  }

  // Force reload from Firebase
  Future<void> reloadFromFirebase() async {
    _isLoading = false;
    await _loadSettings();
  }
}

// ============================================================================
// LEGACY PROVIDERS (for backwards compatibility)
// ============================================================================

/// Selected Theme Provider (legacy - now uses AppSettingsNotifier)
@riverpod
class SelectedTheme extends _$SelectedTheme {
  @override
  AppThemePreset build() {
    final settings = ref.watch(appSettingsNotifierProvider);
    return settings.theme.toPreset();
  }

  void setTheme(AppThemePreset theme) {
    ref.read(appSettingsNotifierProvider.notifier).setTheme(theme);
  }
}

/// Education Configuration Model (legacy)
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

/// Education Configuration Provider (legacy wrapper)
@riverpod
class EducationConfigNotifier extends _$EducationConfigNotifier {
  @override
  EducationConfig build() {
    final settings = ref.watch(appSettingsNotifierProvider);
    return EducationConfig(
      gradeLevel: settings.gradeLevel.replaceAll('Klasse_', ''),
      courseType: settings.courseType == 'Grundkurs'
          ? CourseType.grundkurs
          : CourseType.leistungskurs,
    );
  }

  void setGradeLevel(String level) {
    ref.read(appSettingsNotifierProvider.notifier).setGradeLevel('Klasse_$level');
  }

  void setCourseType(CourseType type) {
    ref.read(appSettingsNotifierProvider.notifier).setCourseType(
          type == CourseType.grundkurs ? 'Grundkurs' : 'Leistungsfach',
        );
  }
}
