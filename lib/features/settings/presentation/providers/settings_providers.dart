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
// AI MODEL CONFIGURATION
// ============================================================================

/// AI Model settings (nested in Firebase as settings.aiModel)
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
class AppSettings {
  final AIModelConfig aiModel;
  final String aiProvider; // 'claude' or 'gemini'
  final String? claudeApiKey;
  final String? geminiApiKey;
  final String geminiFastModel;
  final String geminiModel;
  final String geminiSmartModel;
  final String modelMode; // 'fast', 'standard', 'smart'
  final String selectedModel;
  final bool showAiAssessments;
  final String courseType; // 'Leistungsfach' or 'Grundkurs'
  final String gradeLevel; // 'Klasse_11', 'Klasse_12', etc.
  final ThemeConfig theme;

  const AppSettings({
    this.aiModel = const AIModelConfig(),
    this.aiProvider = 'gemini',
    this.claudeApiKey,
    this.geminiApiKey,
    this.geminiFastModel = 'gemini-2.0-flash-lite',
    this.geminiModel = 'gemini-2.0-flash',
    this.geminiSmartModel = 'gemini-2.5-pro-preview-05-06',
    this.modelMode = 'fast',
    this.selectedModel = 'gemini-2.0-flash-lite',
    this.showAiAssessments = false,
    this.courseType = 'Leistungsfach',
    this.gradeLevel = 'Klasse_11',
    required this.theme,
  });

  factory AppSettings.initial() {
    return AppSettings(
      theme: ThemeConfig.fromPreset(AppThemePreset.sunsetOrange),
    );
  }

  /// Convert to Firebase JSON structure
  Map<String, dynamic> toJson() => {
        'aiModel': aiModel.toJson(),
        'aiProvider': aiProvider,
        'claudeApiKey': claudeApiKey,
        'geminiApiKey': geminiApiKey,
        'geminiFastModel': geminiFastModel,
        'geminiModel': geminiModel,
        'geminiSmartModel': geminiSmartModel,
        'modelMode': modelMode,
        'selectedModel': selectedModel,
        'showAiAssessments': showAiAssessments,
        'courseType': courseType,
        'gradeLevel': gradeLevel,
        'theme': theme.toJson(),
      };

  /// Create from Firebase JSON
  factory AppSettings.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AppSettings.initial();

    return AppSettings(
      aiModel: AIModelConfig.fromJson(json['aiModel'] as Map<String, dynamic>?),
      aiProvider: json['aiProvider'] ?? 'gemini',
      claudeApiKey: json['claudeApiKey'],
      geminiApiKey: json['geminiApiKey'],
      geminiFastModel: json['geminiFastModel'] ?? 'gemini-2.0-flash-lite',
      geminiModel: json['geminiModel'] ?? 'gemini-2.0-flash',
      geminiSmartModel: json['geminiSmartModel'] ?? 'gemini-2.5-pro-preview-05-06',
      modelMode: json['modelMode'] ?? 'fast',
      selectedModel: json['selectedModel'] ?? 'gemini-2.0-flash-lite',
      showAiAssessments: json['showAiAssessments'] ?? false,
      courseType: json['courseType'] ?? 'Leistungsfach',
      gradeLevel: json['gradeLevel'] ?? 'Klasse_11',
      theme: json['theme'] != null
          ? ThemeConfig.fromJson(json['theme'] as Map<String, dynamic>)
          : ThemeConfig.fromPreset(AppThemePreset.sunsetOrange),
    );
  }

  AppSettings copyWith({
    AIModelConfig? aiModel,
    String? aiProvider,
    String? claudeApiKey,
    String? geminiApiKey,
    String? geminiFastModel,
    String? geminiModel,
    String? geminiSmartModel,
    String? modelMode,
    String? selectedModel,
    bool? showAiAssessments,
    String? courseType,
    String? gradeLevel,
    ThemeConfig? theme,
  }) {
    return AppSettings(
      aiModel: aiModel ?? this.aiModel,
      aiProvider: aiProvider ?? this.aiProvider,
      claudeApiKey: claudeApiKey ?? this.claudeApiKey,
      geminiApiKey: geminiApiKey ?? this.geminiApiKey,
      geminiFastModel: geminiFastModel ?? this.geminiFastModel,
      geminiModel: geminiModel ?? this.geminiModel,
      geminiSmartModel: geminiSmartModel ?? this.geminiSmartModel,
      modelMode: modelMode ?? this.modelMode,
      selectedModel: selectedModel ?? this.selectedModel,
      showAiAssessments: showAiAssessments ?? this.showAiAssessments,
      courseType: courseType ?? this.courseType,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      theme: theme ?? this.theme,
    );
  }

  /// Get current model name based on provider and mode
  String getActiveModel() {
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
            debugPrint('✅ Loaded from Firebase - Claude Key: ${state.claudeApiKey?.substring(0, 10)}..., Gemini Key: ${state.geminiApiKey?.substring(0, 10)}...');
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

    final providerIndex = prefs.getInt('ai_provider') ?? 1;
    final detailLevel = (prefs.getInt('ai_detail_level') ?? 5).clamp(1, 10);
    final temperature = (prefs.getDouble('ai_temperature') ?? 0.7).clamp(0.0, 1.0);
    final helpfulness = (prefs.getInt('ai_helpfulness') ?? 7).clamp(1, 10);
    final autoMode = prefs.getBool('ai_auto_mode') ?? true;
    final claudeApiKey = prefs.getString('ai_claude_api_key');
    final geminiApiKey = prefs.getString('ai_gemini_api_key');
    final geminiFastModel = prefs.getString('ai_gemini_fast_model') ?? 'gemini-2.0-flash-lite';
    final geminiModel = prefs.getString('ai_gemini_model') ?? 'gemini-2.0-flash';
    final geminiSmartModel = prefs.getString('ai_gemini_smart_model') ?? 'gemini-2.5-pro-preview-05-06';
    final modelMode = prefs.getString('ai_model_mode') ?? 'fast';
    final showAiAssessments = prefs.getBool('ai_show_assessments') ?? false;
    final courseType = prefs.getString('course_type') ?? 'Leistungsfach';
    final gradeLevel = prefs.getString('grade_level') ?? 'Klasse_11';
    final themeIndex = prefs.getInt('selected_theme') ?? 0;

    debugPrint('📱 Loaded from local - Claude Key: ${claudeApiKey?.substring(0, 10) ?? "null"}..., Gemini Key: ${geminiApiKey?.substring(0, 10) ?? "null"}...');

    state = AppSettings(
      aiModel: AIModelConfig(
        autoMode: autoMode,
        detailLevel: detailLevel,
        helpfulness: helpfulness,
        temperature: temperature,
      ),
      aiProvider: providerIndex == 0 ? 'claude' : 'gemini',
      claudeApiKey: claudeApiKey,
      geminiApiKey: geminiApiKey,
      geminiFastModel: geminiFastModel,
      geminiModel: geminiModel,
      geminiSmartModel: geminiSmartModel,
      modelMode: modelMode,
      selectedModel: '',
      showAiAssessments: showAiAssessments,
      courseType: courseType,
      gradeLevel: gradeLevel,
      theme: ThemeConfig.fromPreset(AppThemePreset.values[themeIndex.clamp(0, 4)]),
    );
  }

  Future<void> _saveToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('ai_provider', state.aiProvider == 'claude' ? 0 : 1);
    await prefs.setInt('ai_detail_level', state.aiModel.detailLevel);
    await prefs.setDouble('ai_temperature', state.aiModel.temperature);
    await prefs.setInt('ai_helpfulness', state.aiModel.helpfulness);
    await prefs.setBool('ai_auto_mode', state.aiModel.autoMode);
    if (state.claudeApiKey != null) {
      await prefs.setString('ai_claude_api_key', state.claudeApiKey!);
      debugPrint('💾 Saved Claude Key to local storage');
    }
    if (state.geminiApiKey != null) {
      await prefs.setString('ai_gemini_api_key', state.geminiApiKey!);
      debugPrint('💾 Saved Gemini Key to local storage');
    }
    await prefs.setString('ai_gemini_fast_model', state.geminiFastModel);
    await prefs.setString('ai_gemini_model', state.geminiModel);
    await prefs.setString('ai_gemini_smart_model', state.geminiSmartModel);
    await prefs.setString('ai_model_mode', state.modelMode);
    await prefs.setBool('ai_show_assessments', state.showAiAssessments);
    await prefs.setString('course_type', state.courseType);
    await prefs.setString('grade_level', state.gradeLevel);
    await prefs.setInt('selected_theme', state.theme.toPreset().index);
  }

  Future<void> _syncToFirebase() async {
    if (_userId == null || _userId!.isEmpty) return;

    try {
      // Update with selected model
      final settingsWithModel = state.copyWith(
        selectedModel: state.getActiveModel(),
      );

      // Use set with merge to create document if it doesn't exist
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .set({
        'settings': settingsWithModel.toJson()
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

  // AI Provider
  void setAIProvider(String provider) {
    state = state.copyWith(aiProvider: provider);
    _saveSettings();
  }

  // AI Model settings
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

  // API Keys
  void setClaudeApiKey(String? key) {
    debugPrint('🔑 Setting Claude API Key: ${key?.substring(0, 10)}...');
    state = state.copyWith(claudeApiKey: key);
    _saveSettings();
    debugPrint('✅ Claude API Key saved to state');
  }

  void setGeminiApiKey(String? key) {
    debugPrint('🔑 Setting Gemini API Key: ${key?.substring(0, 10)}...');
    state = state.copyWith(geminiApiKey: key);
    _saveSettings();
    debugPrint('✅ Gemini API Key saved to state');
  }

  // Model mode
  void setModelMode(String mode) {
    state = state.copyWith(modelMode: mode);
    _saveSettings();
  }

  void setShowAiAssessments(bool show) {
    state = state.copyWith(showAiAssessments: show);
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

/// AI Configuration Model (legacy - for compatibility)
class AIConfig {
  final AIProvider provider;
  final int detailLevel;
  final double temperature;
  final int helpfulness;
  final bool autoMode;
  final String? claudeApiKey;
  final String? geminiApiKey;
  final String geminiFastModel;
  final String geminiModel;
  final String geminiSmartModel;
  final String modelMode;
  final bool showAiAssessments;

  const AIConfig({
    required this.provider,
    required this.detailLevel,
    required this.temperature,
    required this.helpfulness,
    this.autoMode = true,
    this.claudeApiKey,
    this.geminiApiKey,
    this.geminiFastModel = 'gemini-2.0-flash-lite',
    this.geminiModel = 'gemini-2.0-flash',
    this.geminiSmartModel = 'gemini-2.5-pro-preview-05-06',
    this.modelMode = 'fast',
    this.showAiAssessments = false,
  });

  factory AIConfig.fromAppSettings(AppSettings settings) {
    return AIConfig(
      provider: settings.aiProvider == 'claude' ? AIProvider.claude : AIProvider.gemini,
      detailLevel: settings.aiModel.detailLevel,
      temperature: settings.aiModel.temperature,
      helpfulness: settings.aiModel.helpfulness,
      autoMode: settings.aiModel.autoMode,
      claudeApiKey: settings.claudeApiKey,
      geminiApiKey: settings.geminiApiKey,
      geminiFastModel: settings.geminiFastModel,
      geminiModel: settings.geminiModel,
      geminiSmartModel: settings.geminiSmartModel,
      modelMode: settings.modelMode,
      showAiAssessments: settings.showAiAssessments,
    );
  }

  String getModelName() {
    if (provider == AIProvider.claude) {
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

/// AI Config Provider (legacy wrapper)
@riverpod
class AIConfigNotifier extends _$AIConfigNotifier {
  @override
  AIConfig build() {
    final settings = ref.watch(appSettingsNotifierProvider);
    return AIConfig.fromAppSettings(settings);
  }

  void setProvider(AIProvider provider) {
    ref.read(appSettingsNotifierProvider.notifier)
        .setAIProvider(provider == AIProvider.claude ? 'claude' : 'gemini');
  }

  void setDetailLevel(int level) {
    ref.read(appSettingsNotifierProvider.notifier).setDetailLevel(level);
  }

  void setTemperature(double temp) {
    ref.read(appSettingsNotifierProvider.notifier).setTemperature(temp);
  }

  void setHelpfulness(int level) {
    ref.read(appSettingsNotifierProvider.notifier).setHelpfulness(level);
  }

  void setAutoMode(bool enabled) {
    ref.read(appSettingsNotifierProvider.notifier).setAutoMode(enabled);
  }

  void setClaudeApiKey(String? key) {
    ref.read(appSettingsNotifierProvider.notifier).setClaudeApiKey(key);
  }

  void setGeminiApiKey(String? key) {
    ref.read(appSettingsNotifierProvider.notifier).setGeminiApiKey(key);
  }

  void setModelMode(String mode) {
    ref.read(appSettingsNotifierProvider.notifier).setModelMode(mode);
  }

  void setShowAiAssessments(bool show) {
    ref.read(appSettingsNotifierProvider.notifier).setShowAiAssessments(show);
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

/// Debug Configuration Model (local only - not synced to Firebase)
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

/// Debug Configuration Provider with SharedPreferences persistence
@riverpod
class DebugConfigNotifier extends _$DebugConfigNotifier {
  static const String _keyClaudeApiKey = 'debug_claude_api_key';
  static const String _keyGeminiApiKey = 'debug_gemini_api_key';
  static const String _keyBackendUrl = 'debug_backend_url';
  static const String _keyMockMode = 'debug_mock_mode';
  static const String _keyVerboseLogging = 'debug_verbose_logging';
  static const String _keySkipEmailVerification = 'debug_skip_email_verification';

  @override
  DebugConfig build() {
    // Load from SharedPreferences asynchronously
    _loadFromPreferences();

    return const DebugConfig(
      claudeApiKey: '',
      geminiApiKey: '',
      backendUrl: 'https://api.learn-smart.app',
      mockMode: false,
      verboseLogging: false,
      skipEmailVerification: false,
    );
  }

  Future<void> _loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    state = DebugConfig(
      claudeApiKey: prefs.getString(_keyClaudeApiKey) ?? '',
      geminiApiKey: prefs.getString(_keyGeminiApiKey) ?? '',
      backendUrl: prefs.getString(_keyBackendUrl) ?? 'https://api.learn-smart.app',
      mockMode: prefs.getBool(_keyMockMode) ?? false,
      verboseLogging: prefs.getBool(_keyVerboseLogging) ?? false,
      skipEmailVerification: prefs.getBool(_keySkipEmailVerification) ?? false,
    );
  }

  Future<void> _saveToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyClaudeApiKey, state.claudeApiKey);
    await prefs.setString(_keyGeminiApiKey, state.geminiApiKey);
    await prefs.setString(_keyBackendUrl, state.backendUrl);
    await prefs.setBool(_keyMockMode, state.mockMode);
    await prefs.setBool(_keyVerboseLogging, state.verboseLogging);
    await prefs.setBool(_keySkipEmailVerification, state.skipEmailVerification);
  }

  Future<void> setClaudeApiKey(String key) async {
    state = state.copyWith(claudeApiKey: key);
    await _saveToPreferences();
  }

  Future<void> setGeminiApiKey(String key) async {
    state = state.copyWith(geminiApiKey: key);
    await _saveToPreferences();
  }

  Future<void> setBackendUrl(String url) async {
    state = state.copyWith(backendUrl: url);
    await _saveToPreferences();
  }

  Future<void> setMockMode(bool enabled) async {
    state = state.copyWith(mockMode: enabled);
    await _saveToPreferences();
  }

  Future<void> setVerboseLogging(bool enabled) async {
    state = state.copyWith(verboseLogging: enabled);
    await _saveToPreferences();
  }

  Future<void> setSkipEmailVerification(bool enabled) async {
    state = state.copyWith(skipEmailVerification: enabled);
    await _saveToPreferences();
  }

  Future<void> reset() async {
    state = const DebugConfig(
      claudeApiKey: '',
      geminiApiKey: '',
      backendUrl: 'https://api.learn-smart.app',
      mockMode: false,
      verboseLogging: false,
      skipEmailVerification: false,
    );
    await _saveToPreferences();
  }
}
