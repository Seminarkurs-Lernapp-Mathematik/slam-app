import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/user_stats.dart';
import '../models/user_settings.dart';
import '../models/question.dart';
import '../models/topic.dart';
import '../constants/firebase_collections.dart';

part 'firestore_service.g.dart';

/// Firestore Service
///
/// Handles all Firestore CRUD operations and real-time listeners.
/// Compatible with React App Firestore structure.
class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService(this._firestore);

  // ============================================================================
  // USER PROFILE & STATS
  // ============================================================================

  /// Initialize user profile (called after registration)
  Future<void> initializeUserProfile({
    required String userId,
    required String displayName,
    required String email,
  }) async {
    final userRef = _firestore
        .collection(FirebaseCollections.users)
        .doc(userId);

    final doc = await userRef.get();
    if (doc.exists) {
      // User already initialized
      return;
    }

    final now = DateTime.now();

    await userRef.set({
      FirebaseCollections.profile: {
        FirebaseFields.displayName: displayName,
        FirebaseFields.email: email,
        FirebaseFields.createdAt: Timestamp.fromDate(now),
        FirebaseFields.lastLogin: Timestamp.fromDate(now),
      },
      FirebaseCollections.stats: UserStats.initial().toJson(),
      FirebaseCollections.settings: UserSettings.initial().toJson(),
      FirebaseCollections.learningPlan: {
        'topics': [],
      },
      FirebaseCollections.memories: [],
      FirebaseCollections.taskHistory: [],
    });
  }

  /// Get user stats
  Future<UserStats?> getUserStats(String userId) async {
    final doc = await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .get();

    final data = doc.data();
    if (data == null) return null;

    final statsData = data[FirebaseCollections.stats] as Map<String, dynamic>?;
    if (statsData == null) return null;

    return UserStats.fromJson(statsData);
  }

  /// Update user stats
  Future<void> updateUserStats(String userId, UserStats stats) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .update({
      FirebaseCollections.stats: stats.toJson(),
    });
  }

  /// User stats stream (real-time)
  Stream<UserStats> userStatsStream(String userId) {
    return _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      if (data == null) return UserStats.initial();

      final statsData =
          data[FirebaseCollections.stats] as Map<String, dynamic>?;
      if (statsData == null) return UserStats.initial();

      return UserStats.fromJson(statsData);
    });
  }

  /// Update streak (call daily)
  Future<void> updateStreak(String userId) async {
    final stats = await getUserStats(userId);
    if (stats == null) return;

    final today = DateTime.now().toIso8601String().substring(0, 10);
    final updatedStats = stats.updateStreak(today);

    await updateUserStats(userId, updatedStats);
  }

  // ============================================================================
  // USER SETTINGS
  // ============================================================================

  /// Get user settings
  Future<UserSettings?> getUserSettings(String userId) async {
    final doc = await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .get();

    final data = doc.data();
    if (data == null) return null;

    final settingsData =
        data[FirebaseCollections.settings] as Map<String, dynamic>?;
    if (settingsData == null) return null;

    return UserSettings.fromJson(settingsData);
  }

  /// Update user settings
  Future<void> updateUserSettings(String userId, UserSettings settings) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .update({
      FirebaseCollections.settings: settings.toJson(),
    });
  }

  /// User settings stream (real-time)
  Stream<UserSettings> userSettingsStream(String userId) {
    return _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      if (data == null) return UserSettings.initial();

      final settingsData =
          data[FirebaseCollections.settings] as Map<String, dynamic>?;
      if (settingsData == null) return UserSettings.initial();

      return UserSettings.fromJson(settingsData);
    });
  }

  // ============================================================================
  // QUESTION SESSIONS
  // ============================================================================

  /// Save generated questions
  Future<void> saveGeneratedQuestions({
    required String userId,
    required QuestionSession session,
  }) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.generatedQuestions)
        .doc(session.sessionId)
        .set(session.toJson());
  }

  /// Get question session
  Future<QuestionSession?> getQuestionSession({
    required String userId,
    required String sessionId,
  }) async {
    final doc = await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.generatedQuestions)
        .doc(sessionId)
        .get();

    final data = doc.data();
    if (data == null) return null;

    return QuestionSession.fromJson(data);
  }

  /// Get all question sessions (last 20)
  Future<List<QuestionSession>> getAllQuestionSessions(String userId) async {
    final querySnapshot = await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.generatedQuestions)
        .orderBy(FirebaseFields.createdAt, descending: true)
        .limit(20)
        .get();

    return querySnapshot.docs
        .map((doc) => QuestionSession.fromJson(doc.data()))
        .toList();
  }

  // ============================================================================
  // QUESTION PROGRESS
  // ============================================================================

  /// Save question progress
  Future<void> saveQuestionProgress({
    required String userId,
    required QuestionProgress progress,
  }) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.questionProgress)
        .doc(progress.questionId)
        .set(progress.toJson());
  }

  /// Get question progress
  Future<QuestionProgress?> getQuestionProgress({
    required String userId,
    required String questionId,
  }) async {
    final doc = await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.questionProgress)
        .doc(questionId)
        .get();

    final data = doc.data();
    if (data == null) return null;

    return QuestionProgress.fromJson(data);
  }

  /// Get session progress (all questions in session)
  Future<List<QuestionProgress>> getSessionProgress({
    required String userId,
    required String sessionId,
  }) async {
    final querySnapshot = await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.questionProgress)
        .where(FirebaseFields.sessionId, isEqualTo: sessionId)
        .get();

    return querySnapshot.docs
        .map((doc) => QuestionProgress.fromJson(doc.data()))
        .toList();
  }

  // ============================================================================
  // TOPIC PROGRESS
  // ============================================================================

  /// Get topic progress
  Future<TopicProgress?> getTopicProgress({
    required String userId,
    required String topicKey,
  }) async {
    final doc = await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.topicProgress)
        .doc(topicKey)
        .get();

    final data = doc.data();
    if (data == null) return null;

    return TopicProgress.fromJson(data);
  }

  /// Update topic progress
  Future<void> updateTopicProgress({
    required String userId,
    required String topicKey,
    required Map<String, dynamic> updates,
  }) async {
    final docRef = _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.topicProgress)
        .doc(topicKey);

    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.update(updates);
    } else {
      // Create new topic progress
      final initial = TopicProgress.initial(topicKey);
      await docRef.set({...initial.toJson(), ...updates});
    }
  }

  /// Get all topics with progress
  Future<List<Topic>> getAllTopicsWithProgress(String userId) async {
    final querySnapshot = await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.topicProgress)
        .get();

    return querySnapshot.docs
        .map((doc) => Topic.fromFirestore(doc.id, doc.data()))
        .toList();
  }

  // ============================================================================
  // LEARNING SESSIONS
  // ============================================================================

  /// Create learning session
  Future<void> createLearningSession({
    required String userId,
    required LearningSession session,
  }) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.learningSessions)
        .doc(session.sessionId)
        .set(session.toJson());
  }

  /// Update learning session
  Future<void> updateLearningSession({
    required String userId,
    required String sessionId,
    required Map<String, dynamic> updates,
  }) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.learningSessions)
        .doc(sessionId)
        .update(updates);
  }

  /// Complete learning session
  Future<void> completeLearningSession({
    required String userId,
    required String sessionId,
    required Map<String, dynamic> finalStats,
  }) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.learningSessions)
        .doc(sessionId)
        .update({
      ...finalStats,
      'endedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  /// Get recent learning sessions
  Future<List<LearningSession>> getRecentLearningSessions({
    required String userId,
    int limit = 10,
  }) async {
    final querySnapshot = await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.learningSessions)
        .orderBy('startedAt', descending: true)
        .limit(limit)
        .get();

    return querySnapshot.docs
        .map((doc) => LearningSession.fromJson(doc.data()))
        .toList();
  }
}

/// Firestore Service Provider
@riverpod
FirestoreService firestoreService(FirestoreServiceRef ref) {
  return FirestoreService(FirebaseFirestore.instance);
}
