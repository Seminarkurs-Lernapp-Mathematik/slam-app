import 'dart:async';
import '../models/result.dart';

/// Base repository interface defining common CRUD operations
abstract class BaseRepository<T, ID> {
  /// Get a single item by ID
  Future<Result<T, AppError>> getById(ID id);

  /// Get all items
  Future<Result<List<T>, AppError>> getAll();

  /// Create a new item
  Future<Result<T, AppError>> create(T item);

  /// Update an existing item
  Future<Result<T, AppError>> update(T item);

  /// Delete an item by ID
  Future<Result<void, AppError>> delete(ID id);

  /// Stream of all items for real-time updates
  Stream<List<T>> watchAll();

  /// Stream of a single item for real-time updates
  Stream<T?> watchById(ID id);
}

/// Repository with sync capabilities (local + remote)
abstract class SyncableRepository<T, ID> extends BaseRepository<T, ID> {
  /// Sync local cache with remote
  Future<Result<void, AppError>> sync();

  /// Force refresh from remote
  Future<Result<List<T>, AppError>> refresh();

  /// Check if data is stale
  bool isStale(DateTime lastUpdated,
      {Duration maxAge = const Duration(minutes: 5)});
}

/// Mixin for caching logic
mixin RepositoryCache<T, ID> {
  final Map<ID, T> _cache = {};
  final Map<ID, DateTime> _cacheTimestamps = {};

  T? getFromCache(ID id) => _cache[id];
  void putInCache(ID id, T value) {
    _cache[id] = value;
    _cacheTimestamps[id] = DateTime.now();
  }

  void removeFromCache(ID id) {
    _cache.remove(id);
    _cacheTimestamps.remove(id);
  }

  void clearCache() {
    _cache.clear();
    _cacheTimestamps.clear();
  }

  bool isCacheValid(ID id, {Duration maxAge = const Duration(minutes: 5)}) {
    final timestamp = _cacheTimestamps[id];
    if (timestamp == null) return false;
    return DateTime.now().difference(timestamp) < maxAge;
  }
}
