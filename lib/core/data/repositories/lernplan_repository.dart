import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/firebase_collections.dart';
import '../../models/lernplan.dart';
import '../../services/auth_service.dart';
import '../datasources/local_datasource.dart';
import '../datasources/remote_datasource.dart';
import '../models/result.dart';
import 'base_repository.dart';
import 'settings_repository.dart' show localDataSourceProvider, remoteDataSourceProvider;

part 'lernplan_repository.g.dart';

/// Lernplan Repository with offline-first architecture
class LernplanRepository extends SyncableRepository<Lernplan, String> {
  final LocalDataSource _local;
  final RemoteDataSource _remote;
  final AuthService _auth;
  final FirebaseFirestore _firestore;

  LernplanRepository(this._local, this._remote, this._auth, this._firestore);

  String get _userId => _auth.currentUser?.uid ?? 'anonymous';

  // ============================================================================
  // BASE REPOSITORY IMPLEMENTATION
  // ============================================================================

  @override
  Future<Result<Lernplan, AppError>> getById(String id) async {
    return getLernplan();
  }

  @override
  Future<Result<List<Lernplan>, AppError>> getAll() async {
    final result = await getLernplan();
    return result.map(
      success: (lernplan) => Success([lernplan]),
      failure: (error) => Failure(error),
    );
  }

  @override
  Future<Result<Lernplan, AppError>> create(Lernplan item) async {
    return saveLernplan(item);
  }

  @override
  Future<Result<Lernplan, AppError>> update(Lernplan item) async {
    return saveLernplan(item);
  }

  @override
  Future<Result<void, AppError>> delete(String id) async {
    final emptyLernplan = Lernplan.empty(_userId);
    final result = await saveLernplan(emptyLernplan);
    return result.map(
      success: (_) => const Success(null),
      failure: (error) => Failure(error),
    );
  }

  @override
  Stream<List<Lernplan>> watchAll() {
    return watchLernplan().map((lernplan) => lernplan != null ? [lernplan] : []);
  }

  @override
  Stream<Lernplan?> watchById(String id) {
    return watchLernplan();
  }

  // ============================================================================
  // SYNCABLE REPOSITORY IMPLEMENTATION
  // ============================================================================

  @override
  bool isStale(DateTime lastUpdated, {Duration maxAge = const Duration(minutes: 5)}) {
    return DateTime.now().difference(lastUpdated) > maxAge;
  }

  @override
  Future<Result<void, AppError>> sync() async {
    // Get pending operations from local queue
    final pendingResult = await _local.getPendingOperations();
    if (pendingResult.isFailure) {
      return Failure(pendingResult.failureOrNull!);
    }

    final operations = pendingResult.successOrNull ?? [];
    
    // Filter for lernplan operations
    final lernplanOps = operations.where((op) => 
      op.collection == FirebaseCollections.learningPlan
    ).toList();

    // Execute pending operations
    for (final op in lernplanOps) {
      final result = await _processSyncOperation(op);
      if (result.isFailure) {
        // Continue with other operations but log the error
        debugPrint('Failed to sync operation: ${result.failureOrNull}');
      }
    }

    // Refresh from remote
    return (await refresh()).mapSuccess((_) => null);
  }

  @override
  Future<Result<List<Lernplan>, AppError>> refresh() async {
    final result = await _remote.getLernplan(_userId);
    
    return result.map(
      success: (data) async {
        if (data != null) {
          final lernplan = Lernplan.fromJson(data);
          await _local.cacheLernplan(_userId, lernplan.toJson());
          return Success([lernplan]);
        }
        final empty = Lernplan.empty(_userId);
        return Success([empty]);
      },
      failure: (error) => Failure(error),
    );
  }

  // ============================================================================
  // CORE LERNPLAN OPERATIONS
  // ============================================================================

  Future<Result<Lernplan, AppError>> getLernplan() async {
    // Try local first (offline-first)
    final localResult = await _local.getLernplan(_userId);
    if (localResult.isSuccess) {
      final data = localResult.successOrNull;
      if (data != null) {
        return Success(Lernplan.fromJson(data));
      }
    }

    // Try remote
    final remoteResult = await _remote.getLernplan(_userId);
    return remoteResult.map(
      success: (data) {
        if (data != null) {
          final lernplan = Lernplan.fromJson(data);
          _local.cacheLernplan(_userId, lernplan.toJson());
          return Success(lernplan);
        }
        final empty = Lernplan.empty(_userId);
        return Success(empty);
      },
      failure: (error) {
        // Return empty lernplan on error
        return Success(Lernplan.empty(_userId));
      },
    );
  }

  Future<Result<Lernplan, AppError>> saveLernplan(Lernplan lernplan) async {
    // Save locally first
    await _local.cacheLernplan(_userId, lernplan.toJson());

    // Try to save to remote
    final remoteResult = await _remote.updateLernplan(_userId, _serializeLernplan(lernplan));
    
    return remoteResult.map(
      success: (_) => Success(lernplan),
      failure: (error) {
        // Queue for later sync if remote fails
        _local.queueOperation(SyncOperation(
          id: lernplan.id,
          type: SyncOperationType.update,
          collection: FirebaseCollections.learningPlan,
          data: lernplan.toJson(),
        ));
        return Success(lernplan);
      },
    );
  }

  Future<Result<Lernplan, AppError>> addTopics(List<LernplanTopic> topics) async {
    final currentResult = await getLernplan();
    
    return currentResult.map(
      success: (current) async {
        final now = DateTime.now();
        final existingTopics = current.topics;
        
        // Filter duplicates
        final newTopics = topics.where((newTopic) {
          return !existingTopics.any((existing) =>
            existing.leitidee == newTopic.leitidee &&
            existing.thema == newTopic.thema &&
            existing.unterthema == newTopic.unterthema
          );
        }).map((t) => t.copyWith(addedAt: now)).toList();

        if (newTopics.isEmpty) {
          return Success(current); // No new topics to add
        }

        final updated = current.copyWith(
          topics: [...existingTopics, ...newTopics],
          updatedAt: now,
        );

        return saveLernplan(updated);
      },
      failure: (error) => Failure(error),
    );
  }

  Future<Result<Lernplan, AppError>> removeTopic(LernplanTopic topicToRemove) async {
    final currentResult = await getLernplan();
    
    return currentResult.map(
      success: (current) async {
        final updatedTopics = current.topics.where((t) =>
          t.leitidee != topicToRemove.leitidee ||
          t.thema != topicToRemove.thema ||
          t.unterthema != topicToRemove.unterthema
        ).toList();

        final updated = current.copyWith(
          topics: updatedTopics,
          updatedAt: DateTime.now(),
        );

        return saveLernplan(updated);
      },
      failure: (error) => Failure(error),
    );
  }

  Future<Result<bool, AppError>> hasTopic(LernplanTopic topic) async {
    final result = await getLernplan();
    return result.map(
      success: (lernplan) {
        final exists = lernplan.topics.any((t) =>
          t.leitidee == topic.leitidee &&
          t.thema == topic.thema &&
          t.unterthema == topic.unterthema
        );
        return Success(exists);
      },
      failure: (error) => Failure(error),
    );
  }

  Stream<Lernplan?> watchLernplan() {
    return _firestore
        .collection(FirebaseCollections.users)
        .doc(_userId)
        .snapshots()
        .asyncMap((doc) async {
      final data = doc.data();
      if (data != null && data[FirebaseCollections.learningPlan] != null) {
        final lernplanData = data[FirebaseCollections.learningPlan] as Map<String, dynamic>;
        final lernplan = Lernplan.fromJson(lernplanData);
        // Update local cache
        await _local.cacheLernplan(_userId, lernplan.toJson());
        return lernplan;
      }
      return null;
    });
  }

  // ============================================================================
  // HELPERS
  // ============================================================================

  Map<String, dynamic> _serializeLernplan(Lernplan lernplan) {
    return {
      'id': lernplan.id,
      'userId': lernplan.userId,
      'topics': lernplan.topics.map((t) => {
        'leitidee': t.leitidee,
        'thema': t.thema,
        'unterthema': t.unterthema,
        'addedAt': Timestamp.fromDate(t.addedAt),
        'source': t.source,
      }).toList(),
      'createdAt': Timestamp.fromDate(lernplan.createdAt),
      'updatedAt': Timestamp.fromDate(lernplan.updatedAt),
    };
  }

  Future<Result<void, AppError>> _processSyncOperation(SyncOperation op) async {
    switch (op.type) {
      case SyncOperationType.update:
        final lernplan = Lernplan.fromJson(op.data);
        return await _remote.updateLernplan(_userId, _serializeLernplan(lernplan));
      default:
        return const Success(null);
    }
  }
}

// ============================================================================
// RIVERPOD PROVIDERS
// ============================================================================

@riverpod
LernplanRepository lernplanRepository(Ref ref) {
  return LernplanRepository(
    ref.watch(localDataSourceProvider),
    ref.watch(remoteDataSourceProvider),
    ref.watch(authServiceProvider),
    FirebaseFirestore.instance,
  );
}

@riverpod
Future<Lernplan> lernplan(Ref ref) async {
  final repository = ref.watch(lernplanRepositoryProvider);
  final result = await repository.getLernplan();
  return result.getOrThrow();
}

@riverpod
Stream<Lernplan> lernplanStream(Ref ref) {
  final repository = ref.watch(lernplanRepositoryProvider);
  return repository.watchLernplan().map((l) => l ?? Lernplan.empty('anonymous'));
}

@riverpod
class LernplanNotifier extends _$LernplanNotifier {
  @override
  Future<Lernplan> build() async {
    final repository = ref.read(lernplanRepositoryProvider);
    final result = await repository.getLernplan();
    return result.getOrElse(Lernplan.empty('anonymous'));
  }

  Future<void> addTopics(List<LernplanTopic> topics) async {
    state = const AsyncValue.loading();
    
    final repository = ref.read(lernplanRepositoryProvider);
    final result = await repository.addTopics(topics);
    
    state = result.when(
      success: (lernplan) => AsyncValue.data(lernplan),
      failure: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }

  Future<void> removeTopic(LernplanTopic topic) async {
    state = const AsyncValue.loading();
    
    final repository = ref.read(lernplanRepositoryProvider);
    final result = await repository.removeTopic(topic);
    
    state = result.when(
      success: (lernplan) => AsyncValue.data(lernplan),
      failure: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }

  Future<bool> hasTopic(LernplanTopic topic) async {
    final repository = ref.read(lernplanRepositoryProvider);
    final result = await repository.hasTopic(topic);
    return result.getOrElse(false);
  }

  Future<void> sync() async {
    state = const AsyncValue.loading();
    final repository = ref.read(lernplanRepositoryProvider);
    await repository.sync();
    
    final result = await repository.getLernplan();
    state = AsyncValue.data(result.getOrElse(Lernplan.empty('anonymous')));
  }
}
