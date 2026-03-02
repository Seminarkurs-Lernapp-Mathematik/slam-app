import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/firebase_collections.dart';
import '../models/result.dart';

/// Remote data source using Firestore
class RemoteDataSource {
  final FirebaseFirestore _firestore;
  
  RemoteDataSource(this._firestore);
  
  // ============================================================================
  // USER OPERATIONS
  // ============================================================================
  
  Future<Result<Map<String, dynamic>?, AppError>> getUser(String userId) async {
    try {
      final doc = await _firestore
          .collection(FirebaseCollections.users)
          .doc(userId)
          .get();
      return Success(doc.data());
    } on FirebaseException catch (e, st) {
      return Failure(DatabaseError('Failed to get user: ${e.message}', code: e.code, stackTrace: st));
    } catch (e, st) {
      return Failure(NetworkError('Network error: $e', stackTrace: st));
    }
  }
  
  Future<Result<void, AppError>> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(FirebaseCollections.users)
          .doc(userId)
          .update(data);
      return const Success(null);
    } on FirebaseException catch (e, st) {
      return Failure(DatabaseError('Failed to update user: ${e.message}', code: e.code, stackTrace: st));
    } catch (e, st) {
      return Failure(NetworkError('Network error: $e', stackTrace: st));
    }
  }
  
  Future<Result<void, AppError>> setUser(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(FirebaseCollections.users)
          .doc(userId)
          .set(data, SetOptions(merge: true));
      return const Success(null);
    } on FirebaseException catch (e, st) {
      return Failure(DatabaseError('Failed to set user: ${e.message}', code: e.code, stackTrace: st));
    } catch (e, st) {
      return Failure(NetworkError('Network error: $e', stackTrace: st));
    }
  }
  
  // ============================================================================
  // LERNPLAN OPERATIONS
  // ============================================================================
  
  Future<Result<Map<String, dynamic>?, AppError>> getLernplan(String userId) async {
    try {
      final doc = await _firestore
          .collection(FirebaseCollections.users)
          .doc(userId)
          .get();
      final data = doc.data();
      return Success(data?[FirebaseCollections.learningPlan] as Map<String, dynamic>?);
    } on FirebaseException catch (e, st) {
      return Failure(DatabaseError('Failed to get lernplan: ${e.message}', code: e.code, stackTrace: st));
    } catch (e, st) {
      return Failure(NetworkError('Network error: $e', stackTrace: st));
    }
  }
  
  Future<Result<void, AppError>> updateLernplan(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(FirebaseCollections.users)
          .doc(userId)
          .update({FirebaseCollections.learningPlan: data});
      return const Success(null);
    } on FirebaseException catch (e, st) {
      return Failure(DatabaseError('Failed to update lernplan: ${e.message}', code: e.code, stackTrace: st));
    } catch (e, st) {
      return Failure(NetworkError('Network error: $e', stackTrace: st));
    }
  }
  
  // ============================================================================
  // SETTINGS OPERATIONS
  // ============================================================================
  
  Future<Result<Map<String, dynamic>?, AppError>> getSettings(String userId) async {
    try {
      final doc = await _firestore
          .collection(FirebaseCollections.users)
          .doc(userId)
          .get();
      final data = doc.data();
      return Success(data?[FirebaseCollections.settings] as Map<String, dynamic>?);
    } on FirebaseException catch (e, st) {
      return Failure(DatabaseError('Failed to get settings: ${e.message}', code: e.code, stackTrace: st));
    } catch (e, st) {
      return Failure(NetworkError('Network error: $e', stackTrace: st));
    }
  }
  
  Future<Result<void, AppError>> updateSettings(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(FirebaseCollections.users)
          .doc(userId)
          .update({FirebaseCollections.settings: data});
      return const Success(null);
    } on FirebaseException catch (e, st) {
      return Failure(DatabaseError('Failed to update settings: ${e.message}', code: e.code, stackTrace: st));
    } catch (e, st) {
      return Failure(NetworkError('Network error: $e', stackTrace: st));
    }
  }
  
  // ============================================================================
  // STATS OPERATIONS
  // ============================================================================
  
  Future<Result<Map<String, dynamic>?, AppError>> getStats(String userId) async {
    try {
      final doc = await _firestore
          .collection(FirebaseCollections.users)
          .doc(userId)
          .get();
      final data = doc.data();
      return Success(data?[FirebaseCollections.stats] as Map<String, dynamic>?);
    } on FirebaseException catch (e, st) {
      return Failure(DatabaseError('Failed to get stats: ${e.message}', code: e.code, stackTrace: st));
    } catch (e, st) {
      return Failure(NetworkError('Network error: $e', stackTrace: st));
    }
  }
  
  Future<Result<void, AppError>> updateStats(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(FirebaseCollections.users)
          .doc(userId)
          .update({FirebaseCollections.stats: data});
      return const Success(null);
    } on FirebaseException catch (e, st) {
      return Failure(DatabaseError('Failed to update stats: ${e.message}', code: e.code, stackTrace: st));
    } catch (e, st) {
      return Failure(NetworkError('Network error: $e', stackTrace: st));
    }
  }
  
  // ============================================================================
  // STREAMS
  // ============================================================================
  
  Stream<Map<String, dynamic>?> watchUser(String userId) {
    return _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .snapshots()
        .map((doc) => doc.data());
  }
  
  Stream<Map<String, dynamic>?> watchLernplan(String userId) {
    return _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .snapshots()
        .map((doc) {
      final data = doc.data();
      return data?[FirebaseCollections.learningPlan] as Map<String, dynamic>?;
    });
  }
  
  Stream<Map<String, dynamic>?> watchSettings(String userId) {
    return _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .snapshots()
        .map((doc) {
      final data = doc.data();
      return data?[FirebaseCollections.settings] as Map<String, dynamic>?;
    });
  }
  
  Stream<Map<String, dynamic>?> watchStats(String userId) {
    return _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .snapshots()
        .map((doc) {
      final data = doc.data();
      return data?[FirebaseCollections.stats] as Map<String, dynamic>?;
    });
  }
  
  // ============================================================================
  // TRANSACTIONS
  // ============================================================================
  
  Future<Result<T, AppError>> runTransaction<T>(
    Future<T> Function(Transaction transaction) operation,
  ) async {
    try {
      final result = await _firestore.runTransaction(operation);
      return Success(result);
    } on FirebaseException catch (e, st) {
      return Failure(DatabaseError('Transaction failed: ${e.message}', code: e.code, stackTrace: st));
    } catch (e, st) {
      return Failure(NetworkError('Network error: $e', stackTrace: st));
    }
  }
  
  // ============================================================================
  // BATCH OPERATIONS
  // ============================================================================
  
  Future<Result<void, AppError>> commitBatch(
    void Function(WriteBatch batch) operation,
  ) async {
    try {
      final batch = _firestore.batch();
      operation(batch);
      await batch.commit();
      return const Success(null);
    } on FirebaseException catch (e, st) {
      return Failure(DatabaseError('Batch failed: ${e.message}', code: e.code, stackTrace: st));
    } catch (e, st) {
      return Failure(NetworkError('Network error: $e', stackTrace: st));
    }
  }
}
