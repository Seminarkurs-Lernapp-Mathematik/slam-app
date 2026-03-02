import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../services/auth_service.dart';
import '../datasources/local_datasource.dart';
import '../datasources/remote_datasource.dart';
import '../models/result.dart';
import 'base_repository.dart';

part 'settings_repository.g.dart';

/// Unified settings model containing all user preferences
@immutable
class UserSettings {
  // AI Settings
  final String aiProvider;
  final String modelMode;
  final String? selectedModel;
  
  // API Keys (stored locally only)
  final String? claudeApiKey;
  final String? geminiApiKey;
  final String? openrouterApiKey;
  
  // AI Model Config
  final int detailLevel;
  final int helpfulness;
  final double temperature;
  final bool autoMode;
  
  // Education
  final String gradeLevel;
  final String courseType;
  
  // Theme
  final String themeName;
  final String primaryColor;
  
  // Flags
  final bool showAiAssessments;
  
  // Timestamps
  final DateTime? lastSyncedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserSettings({
    this.aiProvider = 'gemini',
    this.modelMode = 'fast',
    this.selectedModel,
    this.claudeApiKey,
    this.geminiApiKey,
    this.openrouterApiKey,
    this.detailLevel = 5,
    this.helpfulness = 7,
    this.temperature = 0.7,
    this.autoMode = true,
    this.gradeLevel = 'Klasse_11',
    this.courseType = 'Leistungsfach',
    this.themeName = 'Sunset',
    this.primaryColor = '#f97316',
    this.showAiAssessments = false,
    this.lastSyncedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      aiProvider: json['aiProvider'] ?? 'gemini',
      modelMode: json['modelMode'] ?? 'fast',
      selectedModel: json['selectedModel'],
      detailLevel: json['detailLevel'] ?? 5,
      helpfulness: json['helpfulness'] ?? 7,
      temperature: (json['temperature'] ?? 0.7).toDouble(),
      autoMode: json['autoMode'] ?? true,
      gradeLevel: json['gradeLevel'] ?? 'Klasse_11',
      courseType: json['courseType'] ?? 'Leistungsfach',
      themeName: json['themeName'] ?? 'Sunset',
      primaryColor: json['primaryColor'] ?? '#f97316',
      showAiAssessments: json['showAiAssessments'] ?? false,
      lastSyncedAt: json['lastSyncedAt'] != null 
          ? DateTime.parse(json['lastSyncedAt']) 
          : null,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'aiProvider': aiProvider,
    'modelMode': modelMode,
    'selectedModel': selectedModel,
    'detailLevel': detailLevel,
    'helpfulness': helpfulness,
    'temperature': temperature,
    'autoMode': autoMode,
    'gradeLevel': gradeLevel,
    'courseType': courseType,
    'themeName': themeName,
    'primaryColor': primaryColor,
    'showAiAssessments': showAiAssessments,
    'lastSyncedAt': lastSyncedAt?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': DateTime.now().toIso8601String(),
  };

  Map<String, dynamic> toRemoteJson() => {
    'aiModel': {
      'autoMode': autoMode,
      'detailLevel': detailLevel,
      'helpfulness': helpfulness,
      'temperature': temperature,
    },
    'aiProvider': aiProvider,
    'modelMode': modelMode,
    'selectedModel': selectedModel,
    'gradeLevel': gradeLevel,
    'courseType': courseType,
    'theme': {
      'name': themeName,
      'primary': primaryColor,
    },
    'showAiAssessments': showAiAssessments,
  };

  UserSettings copyWith({
    String? aiProvider,
    String? modelMode,
    String? selectedModel,
    String? claudeApiKey,
    String? geminiApiKey,
    String? openrouterApiKey,
    int? detailLevel,
    int? helpfulness,
    double? temperature,
    bool? autoMode,
    String? gradeLevel,
    String? courseType,
    String? themeName,
    String? primaryColor,
    bool? showAiAssessments,
    DateTime? lastSyncedAt,
  }) {
    return UserSettings(
      aiProvider: aiProvider ?? this.aiProvider,
      modelMode: modelMode ?? this.modelMode,
      selectedModel: selectedModel ?? this.selectedModel,
      claudeApiKey: claudeApiKey ?? this.claudeApiKey,
      geminiApiKey: geminiApiKey ?? this.geminiApiKey,
      openrouterApiKey: openrouterApiKey ?? this.openrouterApiKey,
      detailLevel: detailLevel ?? this.detailLevel,
      helpfulness: helpfulness ?? this.helpfulness,
      temperature: temperature ?? this.temperature,
      autoMode: autoMode ?? this.autoMode,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      courseType: courseType ?? this.courseType,
      themeName: themeName ?? this.themeName,
      primaryColor: primaryColor ?? this.primaryColor,
      showAiAssessments: showAiAssessments ?? this.showAiAssessments,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  bool get isOffline => lastSyncedAt == null;
  bool isStale({Duration maxAge = const Duration(minutes: 5)}) {
    if (lastSyncedAt == null) return true;
    return DateTime.now().difference(lastSyncedAt!) > maxAge;
  }
}

/// Settings Repository - handles all settings operations with offline support
class SettingsRepository with RepositoryCache<UserSettings, String> {
  final LocalDataSource _local;
  final RemoteDataSource _remote;
  final AuthService _auth;

  SettingsRepository(this._local, this._remote, this._auth);

  String get _userId => _auth.currentUser?.uid ?? 'anonymous';

  // ============================================================================
  // CRUD OPERATIONS
  // ============================================================================

  Future<Result<UserSettings, AppError>> getSettings() async {
    // Try cache first
    if (isCacheValid(_userId)) {
      final cached = getFromCache(_userId);
      if (cached != null) return Success(cached);
    }

    // Try local storage
    final localResult = await _local.getSettings(_userId);
    if (localResult.isSuccess) {
      final data = localResult.successOrNull;
      if (data != null) {
        final settings = UserSettings.fromJson(data);
        putInCache(_userId, settings);
        return Success(settings);
      }
    }

    // Try remote
    final remoteResult = await _remote.getSettings(_userId);
    return remoteResult.map(
      success: (data) {
        if (data != null) {
          final settings = UserSettings.fromJson(data);
          putInCache(_userId, settings);
          _local.cacheSettings(_userId, settings.toJson());
          return Success(settings);
        }
        // Return defaults
        final defaults = UserSettings();
        putInCache(_userId, defaults);
        return Success(defaults);
      },
      failure: (error) {
        // Return defaults on error
        final defaults = UserSettings();
        putInCache(_userId, defaults);
        return Success(defaults);
      },
    );
  }

  Future<Result<UserSettings, AppError>> saveSettings(UserSettings settings) async {
    // Always save locally first
    final localResult = await _local.cacheSettings(_userId, settings.toJson());
    if (localResult.isFailure) {
      return Failure(localResult.failureOrNull!);
    }

    // Update cache
    putInCache(_userId, settings);

    // Try to sync to remote
    final remoteResult = await _remote.updateSettings(_userId, settings.toRemoteJson());
    
    return remoteResult.map(
      success: (_) => Success(settings.copyWith(lastSyncedAt: DateTime.now())),
      failure: (error) => Success(settings), // Return local version on sync failure
    );
  }

  Future<Result<void, AppError>> updateSettings({
    String? aiProvider,
    String? modelMode,
    String? selectedModel,
    int? detailLevel,
    int? helpfulness,
    double? temperature,
    bool? autoMode,
    String? gradeLevel,
    String? courseType,
    String? themeName,
    String? primaryColor,
    bool? showAiAssessments,
  }) async {
    final currentResult = await getSettings();
    
    return currentResult.map(
      success: (current) async {
        final updated = current.copyWith(
          aiProvider: aiProvider,
          modelMode: modelMode,
          selectedModel: selectedModel,
          detailLevel: detailLevel,
          helpfulness: helpfulness,
          temperature: temperature,
          autoMode: autoMode,
          gradeLevel: gradeLevel,
          courseType: courseType,
          themeName: themeName,
          primaryColor: primaryColor,
          showAiAssessments: showAiAssessments,
        );
        return (await saveSettings(updated)).mapSuccess((_) => null);
      },
      failure: (error) => Failure(error),
    );
  }

  // ============================================================================
  // API KEYS (Local only, never synced to cloud)
  // ============================================================================

  Future<Result<void, AppError>> saveApiKey(String provider, String? key) async {
    final currentResult = await getSettings();
    
    return currentResult.map(
      success: (current) async {
        UserSettings updated;
        switch (provider) {
          case 'claude':
            updated = current.copyWith(claudeApiKey: key);
            break;
          case 'gemini':
            updated = current.copyWith(geminiApiKey: key);
            break;
          case 'openrouter':
            updated = current.copyWith(openrouterApiKey: key);
            break;
          default:
            return const Failure(ValidationError('Unknown provider'));
        }
        
        // Save locally only
        await _local.cacheSettings(_userId, updated.toJson());
        putInCache(_userId, updated);
        return const Success(null);
      },
      failure: (error) => Failure(error),
    );
  }

  Future<Result<String?, AppError>> getApiKey(String provider) async {
    final result = await getSettings();
    return result.map(
      success: (settings) {
        final key = switch (provider) {
          'claude' => settings.claudeApiKey,
          'gemini' => settings.geminiApiKey,
          'openrouter' => settings.openrouterApiKey,
          _ => null,
        };
        return Success(key);
      },
      failure: (error) => Failure(error),
    );
  }

  // ============================================================================
  // STREAM
  // ============================================================================

  Stream<UserSettings> watchSettings() {
    return _remote.watchSettings(_userId).map((data) {
      if (data != null) {
        final settings = UserSettings.fromJson(data);
        putInCache(_userId, settings);
        _local.cacheSettings(_userId, settings.toJson());
        return settings;
      }
      return UserSettings();
    });
  }

  // ============================================================================
  // SYNC
  // ============================================================================

  Future<Result<void, AppError>> sync() async {
    final remoteResult = await _remote.getSettings(_userId);
    
    return remoteResult.map(
      success: (data) async {
        if (data != null) {
          final settings = UserSettings.fromJson(data).copyWith(
            lastSyncedAt: DateTime.now(),
          );
          await _local.cacheSettings(_userId, settings.toJson());
          putInCache(_userId, settings);
        }
        return const Success(null);
      },
      failure: (error) => Failure(error),
    );
  }

  // ============================================================================
  // RESET
  // ============================================================================

  Future<Result<void, AppError>> resetToDefaults() async {
    final defaults = UserSettings();
    await _local.cacheSettings(_userId, defaults.toJson());
    putInCache(_userId, defaults);
    return const Success(null);
  }
}

// ============================================================================
// RIVERPOD PROVIDERS
// ============================================================================

@riverpod
SettingsRepository settingsRepository(Ref ref) {
  return SettingsRepository(
    ref.watch(localDataSourceProvider),
    ref.watch(remoteDataSourceProvider),
    ref.watch(authServiceProvider),
  );
}

@riverpod
Future<UserSettings> userSettings(Ref ref) async {
  final repository = ref.watch(settingsRepositoryProvider);
  final result = await repository.getSettings();
  return result.getOrThrow();
}

@riverpod
Stream<UserSettings> userSettingsStream(Ref ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return repository.watchSettings();
}

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Future<UserSettings> build() async {
    final repository = ref.read(settingsRepositoryProvider);
    final result = await repository.getSettings();
    return result.getOrElse(UserSettings());
  }

  Future<void> updateSettingsFields({
    String? aiProvider,
    String? modelMode,
    String? selectedModel,
    int? detailLevel,
    int? helpfulness,
    double? temperature,
    bool? autoMode,
    String? gradeLevel,
    String? courseType,
    String? themeName,
    String? primaryColor,
    bool? showAiAssessments,
  }) async {
    state = const AsyncValue.loading();

    final repository = ref.read(settingsRepositoryProvider);
    final result = await repository.updateSettings(
      aiProvider: aiProvider,
      modelMode: modelMode,
      selectedModel: selectedModel,
      detailLevel: detailLevel,
      helpfulness: helpfulness,
      temperature: temperature,
      autoMode: autoMode,
      gradeLevel: gradeLevel,
      courseType: courseType,
      themeName: themeName,
      primaryColor: primaryColor,
      showAiAssessments: showAiAssessments,
    );

    // After update, reload settings
    if (result.isSuccess) {
      final getResult = await ref.read(settingsRepositoryProvider).getSettings();
      state = AsyncValue.data(getResult.getOrElse(UserSettings()));
    } else if (result.isFailure) {
      state = AsyncValue.error(result.failureOrNull!, StackTrace.current);
    }
  }

  Future<void> saveApiKey(String provider, String? key) async {
    final repository = ref.read(settingsRepositoryProvider);
    await repository.saveApiKey(provider, key);
  }

  Future<void> sync() async {
    state = const AsyncValue.loading();
    final repository = ref.read(settingsRepositoryProvider);
    final result = await repository.sync();

    if (result.isSuccess) {
      final settingsResult = await repository.getSettings();
      state = AsyncValue.data(settingsResult.getOrElse(UserSettings()));
    }
  }

  Future<void> reset() async {
    final repository = ref.read(settingsRepositoryProvider);
    await repository.resetToDefaults();
    state = AsyncValue.data(UserSettings());
  }
}

// ============================================================================
// DATASOURCE PROVIDERS
// ============================================================================

@riverpod
LocalDataSource localDataSource(Ref ref) {
  final ds = LocalDataSource();
  ds.initialize();
  return ds;
}

@riverpod
RemoteDataSource remoteDataSource(Ref ref) {
  // This needs to be initialized with FirebaseFirestore instance
  // Will be connected in the main app initialization
  throw UnimplementedError('RemoteDataSource must be initialized with FirebaseFirestore');
}
