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
  // Education
  final String gradeLevel;
  final String courseType;
  
  // Theme
  final String themeName;
  final String primaryColor;
  
  // Timestamps
  final DateTime? lastSyncedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserSettings({
    this.gradeLevel = 'Klasse_11',
    this.courseType = 'Leistungsfach',
    this.themeName = 'Sunset',
    this.primaryColor = '#f97316',
    this.lastSyncedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      gradeLevel: json['gradeLevel'] ?? 'Klasse_11',
      courseType: json['courseType'] ?? 'Leistungsfach',
      themeName: json['themeName'] ?? 'Sunset',
      primaryColor: json['primaryColor'] ?? '#f97316',
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
    'gradeLevel': gradeLevel,
    'courseType': courseType,
    'themeName': themeName,
    'primaryColor': primaryColor,
    'lastSyncedAt': lastSyncedAt?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': DateTime.now().toIso8601String(),
  };

  Map<String, dynamic> toRemoteJson() => {
    'gradeLevel': gradeLevel,
    'courseType': courseType,
    'theme': {
      'name': themeName,
      'primary': primaryColor,
    },
  };

  UserSettings copyWith({
    String? gradeLevel,
    String? courseType,
    String? themeName,
    String? primaryColor,
    DateTime? lastSyncedAt,
  }) {
    return UserSettings(
      gradeLevel: gradeLevel ?? this.gradeLevel,
      courseType: courseType ?? this.courseType,
      themeName: themeName ?? this.themeName,
      primaryColor: primaryColor ?? this.primaryColor,
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
    String? gradeLevel,
    String? courseType,
    String? themeName,
    String? primaryColor,
  }) async {
    final currentResult = await getSettings();
    
    return currentResult.map(
      success: (current) async {
        final updated = current.copyWith(
          gradeLevel: gradeLevel,
          courseType: courseType,
          themeName: themeName,
          primaryColor: primaryColor,
        );
        return (await saveSettings(updated)).mapSuccess((_) => null);
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
    String? gradeLevel,
    String? courseType,
    String? themeName,
    String? primaryColor,
  }) async {
    state = const AsyncValue.loading();

    final repository = ref.read(settingsRepositoryProvider);
    final result = await repository.updateSettings(
      gradeLevel: gradeLevel,
      courseType: courseType,
      themeName: themeName,
      primaryColor: primaryColor,
    );

    // After update, reload settings
    if (result.isSuccess) {
      final getResult = await ref.read(settingsRepositoryProvider).getSettings();
      state = AsyncValue.data(getResult.getOrElse(UserSettings()));
    } else if (result.isFailure) {
      state = AsyncValue.error(result.failureOrNull!, StackTrace.current);
    }
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
