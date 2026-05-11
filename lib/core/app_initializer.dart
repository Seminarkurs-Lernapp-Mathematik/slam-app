import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../firebase_options.dart';
import 'data/datasources/local_datasource.dart';
import 'data/datasources/remote_datasource.dart';
import 'services/notification_service.dart';
import 'utils/error_handler.dart';
import 'utils/logger.dart';

/// App initialization result
class InitResult {
  final bool success;
  final String? error;
  final InitState state;

  InitResult.success(this.state)
      : success = true,
        error = null;
  InitResult.failure(this.error, this.state) : success = false;
}

/// Initialization states
enum InitState {
  initial,
  firebaseStarting,
  firebaseReady,
  hiveStarting,
  hiveReady,
  servicesStarting,
  servicesReady,
  complete,
  failed,
}

/// App initializer - handles all app startup logic
class AppInitializer {
  static final AppInitializer _instance = AppInitializer._internal();
  factory AppInitializer() => _instance;
  AppInitializer._internal();

  InitState _state = InitState.initial;
  InitState get state => _state;

  /// Main initialization method
  Future<InitResult> initialize() async {
    Logger.configure(minLevel: LogLevel.verbose);
    Logger.info('Starting app initialization...');

    try {
      // Set preferred orientations
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      // Initialize error handling
      ErrorHandler.initialize();

      // Initialize Firebase
      _state = InitState.firebaseStarting;
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _state = InitState.firebaseReady;
      Logger.info('Firebase initialized');

      // Initialize Hive (local cache)
      _state = InitState.hiveStarting;
      await Hive.initFlutter();
      _state = InitState.hiveReady;
      Logger.info('Hive initialized');

      // Initialize services
      _state = InitState.servicesStarting;
      await _initializeServices();
      _state = InitState.servicesReady;
      Logger.info('Services initialized');

      _state = InitState.complete;
      Logger.info('App initialization complete');
      return InitResult.success(_state);
    } catch (e, st) {
      _state = InitState.failed;
      Logger.fatal('App initialization failed', error: e, stackTrace: st);
      return InitResult.failure(e.toString(), _state);
    }
  }

  Future<void> _initializeServices() async {
    await NotificationService.initialize();
    await NotificationService.scheduleDailyReminder();
  }
}

// ============================================================================
// RIVERPOD PROVIDERS FOR DEPENDENCY INJECTION
// ============================================================================

/// Provider for the app initialization result
final appInitializationProvider = FutureProvider<InitResult>((ref) async {
  return await AppInitializer().initialize();
});

/// Provider for initialization state
final initStateProvider = Provider<InitState>((ref) {
  final initAsync = ref.watch(appInitializationProvider);
  return initAsync.when(
    data: (result) => result.state,
    loading: () => InitState.initial,
    error: (_, __) => InitState.failed,
  );
});

/// Provider to check if app is ready
final isAppReadyProvider = Provider<bool>((ref) {
  final initAsync = ref.watch(appInitializationProvider);
  return initAsync.when(
    data: (result) => result.success,
    loading: () => false,
    error: (_, __) => false,
  );
});

/// Override providers for datasources
final remoteDataSourceProvider = Provider<RemoteDataSource>((ref) {
  return RemoteDataSource(FirebaseFirestore.instance);
});

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  final ds = LocalDataSource();
  ds.initialize();
  return ds;
});
