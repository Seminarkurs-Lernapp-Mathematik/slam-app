import 'package:hive_flutter/hive_flutter.dart';
import '../models/result.dart';

/// Local data source using Hive for offline caching
class LocalDataSource {
  static const String _userBox = 'user_cache';
  static const String _lernplanBox = 'lernplan_cache';
  static const String _questionsBox = 'questions_cache';
  static const String _settingsBox = 'settings_cache';
  static const String _syncQueueBox = 'sync_queue';
  
  Box? _userCache;
  Box? _lernplanCache;
  Box? _questionsCache;
  Box? _settingsCache;
  Box? _syncQueue;
  
  bool _isInitialized = false;
  
  /// Initialize Hive boxes
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    await Hive.initFlutter();
    
    _userCache = await Hive.openBox(_userBox);
    _lernplanCache = await Hive.openBox(_lernplanBox);
    _questionsCache = await Hive.openBox(_questionsBox);
    _settingsCache = await Hive.openBox(_settingsBox);
    _syncQueue = await Hive.openBox(_syncQueueBox);
    
    _isInitialized = true;
  }
  
  // ============================================================================
  // USER CACHE
  // ============================================================================
  
  Future<Result<Map<String, dynamic>?, AppError>> getUser(String userId) async {
    try {
      final data = _userCache?.get(userId);
      return Success(data != null ? Map<String, dynamic>.from(data) : null);
    } catch (e, st) {
      return Failure(CacheError('Failed to get user: $e', stackTrace: st));
    }
  }
  
  Future<Result<void, AppError>> cacheUser(String userId, Map<String, dynamic> data) async {
    try {
      await _userCache?.put(userId, {
        ...data,
        '_cachedAt': DateTime.now().toIso8601String(),
      });
      return const Success(null);
    } catch (e, st) {
      return Failure(CacheError('Failed to cache user: $e', stackTrace: st));
    }
  }
  
  // ============================================================================
  // LERNPLAN CACHE
  // ============================================================================
  
  Future<Result<Map<String, dynamic>?, AppError>> getLernplan(String userId) async {
    try {
      final data = _lernplanCache?.get(userId);
      return Success(data != null ? Map<String, dynamic>.from(data) : null);
    } catch (e, st) {
      return Failure(CacheError('Failed to get lernplan: $e', stackTrace: st));
    }
  }
  
  Future<Result<void, AppError>> cacheLernplan(String userId, Map<String, dynamic> data) async {
    try {
      await _lernplanCache?.put(userId, {
        ...data,
        '_cachedAt': DateTime.now().toIso8601String(),
      });
      return const Success(null);
    } catch (e, st) {
      return Failure(CacheError('Failed to cache lernplan: $e', stackTrace: st));
    }
  }
  
  // ============================================================================
  // SETTINGS CACHE
  // ============================================================================
  
  Future<Result<Map<String, dynamic>?, AppError>> getSettings(String userId) async {
    try {
      final data = _settingsCache?.get(userId);
      return Success(data != null ? Map<String, dynamic>.from(data) : null);
    } catch (e, st) {
      return Failure(CacheError('Failed to get settings: $e', stackTrace: st));
    }
  }
  
  Future<Result<void, AppError>> cacheSettings(String userId, Map<String, dynamic> data) async {
    try {
      await _settingsCache?.put(userId, {
        ...data,
        '_cachedAt': DateTime.now().toIso8601String(),
      });
      return const Success(null);
    } catch (e, st) {
      return Failure(CacheError('Failed to cache settings: $e', stackTrace: st));
    }
  }
  
  // ============================================================================
  // QUESTIONS CACHE
  // ============================================================================
  
  Future<Result<List<Map<String, dynamic>>, AppError>> getQuestions(String sessionId) async {
    try {
      final data = _questionsCache?.get(sessionId);
      if (data == null) return const Success([]);
      final list = List<Map<String, dynamic>>.from(data);
      return Success(list);
    } catch (e, st) {
      return Failure(CacheError('Failed to get questions: $e', stackTrace: st));
    }
  }
  
  Future<Result<void, AppError>> cacheQuestions(String sessionId, List<Map<String, dynamic>> questions) async {
    try {
      await _questionsCache?.put(sessionId, {
        'questions': questions,
        '_cachedAt': DateTime.now().toIso8601String(),
      });
      return const Success(null);
    } catch (e, st) {
      return Failure(CacheError('Failed to cache questions: $e', stackTrace: st));
    }
  }
  
  // ============================================================================
  // SYNC QUEUE
  // ============================================================================
  
  Future<Result<void, AppError>> queueOperation(SyncOperation operation) async {
    try {
      final key = '${operation.type}_${operation.id}_${DateTime.now().millisecondsSinceEpoch}';
      await _syncQueue?.put(key, operation.toJson());
      return const Success(null);
    } catch (e, st) {
      return Failure(CacheError('Failed to queue operation: $e', stackTrace: st));
    }
  }
  
  Future<Result<List<SyncOperation>, AppError>> getPendingOperations() async {
    try {
      final operations = _syncQueue?.values.map((v) {
        return SyncOperation.fromJson(Map<String, dynamic>.from(v));
      }).toList() ?? [];
      return Success(operations);
    } catch (e, st) {
      return Failure(CacheError('Failed to get pending operations: $e', stackTrace: st));
    }
  }
  
  Future<Result<void, AppError>> removeOperation(String key) async {
    try {
      await _syncQueue?.delete(key);
      return const Success(null);
    } catch (e, st) {
      return Failure(CacheError('Failed to remove operation: $e', stackTrace: st));
    }
  }
  
  Future<Result<void, AppError>> clearSyncQueue() async {
    try {
      await _syncQueue?.clear();
      return const Success(null);
    } catch (e, st) {
      return Failure(CacheError('Failed to clear sync queue: $e', stackTrace: st));
    }
  }
  
  // ============================================================================
  // CLEAR ALL
  // ============================================================================
  
  Future<Result<void, AppError>> clearAll() async {
    try {
      await _userCache?.clear();
      await _lernplanCache?.clear();
      await _questionsCache?.clear();
      await _settingsCache?.clear();
      await _syncQueue?.clear();
      return const Success(null);
    } catch (e, st) {
      return Failure(CacheError('Failed to clear cache: $e', stackTrace: st));
    }
  }
}

/// Represents a pending sync operation
class SyncOperation {
  final String id;
  final SyncOperationType type;
  final String collection;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final int retryCount;
  
  SyncOperation({
    required this.id,
    required this.type,
    required this.collection,
    required this.data,
    DateTime? timestamp,
    this.retryCount = 0,
  }) : timestamp = timestamp ?? DateTime.now();
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'collection': collection,
    'data': data,
    'timestamp': timestamp.toIso8601String(),
    'retryCount': retryCount,
  };
  
  factory SyncOperation.fromJson(Map<String, dynamic> json) => SyncOperation(
    id: json['id'],
    type: SyncOperationType.values.firstWhere((e) => e.name == json['type']),
    collection: json['collection'],
    data: Map<String, dynamic>.from(json['data']),
    timestamp: DateTime.parse(json['timestamp']),
    retryCount: json['retryCount'] ?? 0,
  );
  
  SyncOperation copyWith({int? retryCount}) => SyncOperation(
    id: id,
    type: type,
    collection: collection,
    data: data,
    timestamp: timestamp,
    retryCount: retryCount ?? this.retryCount,
  );
}

enum SyncOperationType {
  create,
  update,
  delete,
}
