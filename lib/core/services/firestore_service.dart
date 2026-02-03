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

  // ============================================================================
  // LEARNING PLANS
  // ============================================================================

  /// Create learning plan
  Future<void> createLearningPlan({
    required String userId,
    required Map<String, dynamic> planData,
  }) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection('learningPlans')
        .doc(planData['id'] as String)
        .set(planData);
  }

  /// Update learning plan
  Future<void> updateLearningPlan({
    required String userId,
    required String planId,
    required Map<String, dynamic> updates,
  }) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection('learningPlans')
        .doc(planId)
        .update(updates);
  }

  /// Get learning plan
  Future<Map<String, dynamic>?> getLearningPlan({
    required String userId,
    required String planId,
  }) async {
    final doc = await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection('learningPlans')
        .doc(planId)
        .get();

    return doc.data();
  }

  /// Get active learning plan
  Future<Map<String, dynamic>?> getActiveLearningPlan(String userId) async {
    final querySnapshot = await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection('learningPlans')
        .where('isActive', isEqualTo: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) return null;
    return querySnapshot.docs.first.data();
  }

  /// Get all learning plans
  Future<List<Map<String, dynamic>>> getAllLearningPlans(String userId) async {
    final querySnapshot = await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection('learningPlans')
        .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Delete learning plan
  Future<void> deleteLearningPlan({
    required String userId,
    required String planId,
  }) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection('learningPlans')
        .doc(planId)
        .delete();
  }

  // ============================================================================
  // MEMORIES (SPACED REPETITION)
  // ============================================================================

  /// Create memory
  Future<void> createMemory({
    required String userId,
    required Map<String, dynamic> memoryData,
  }) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection('memories')
        .doc(memoryData['id'] as String)
        .set(memoryData);
  }

  /// Update memory
  Future<void> updateMemory({
    required String userId,
    required String memoryId,
    required Map<String, dynamic> updates,
  }) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection('memories')
        .doc(memoryId)
        .update(updates);
  }

  /// Get memory
  Future<Map<String, dynamic>?> getMemory({
    required String userId,
    required String memoryId,
  }) async {
    final doc = await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection('memories')
        .doc(memoryId)
        .get();

    return doc.data();
  }

  /// Get due memories
  Future<List<Map<String, dynamic>>> getDueMemories(String userId) async {
    final now = Timestamp.fromDate(DateTime.now());
    final querySnapshot = await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection('memories')
        .where('nextReviewAt', isLessThanOrEqualTo: now)
        .where('isArchived', isEqualTo: false)
        .orderBy('nextReviewAt')
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Get all memories
  Future<List<Map<String, dynamic>>> getAllMemories({
    required String userId,
    bool? includeArchived,
  }) async {
    var query = _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection('memories');

    if (includeArchived == false) {
      query = query.where('isArchived', isEqualTo: false) as CollectionReference<Map<String, dynamic>>;
    }

    final querySnapshot = await query
        .orderBy('nextReviewAt')
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Delete memory
  Future<void> deleteMemory({
    required String userId,
    required String memoryId,
  }) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection('memories')
        .doc(memoryId)
        .delete();
  }

  // ============================================================================
  // SAVED CONTENT (Generative Apps, GeoGebra, etc.)
  // ============================================================================

  /// Save content
  Future<void> saveContent({
    required String userId,
    required Map<String, dynamic> contentData,
  }) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection('savedContent')
        .doc(contentData['id'] as String)
        .set(contentData);
  }

  /// Get saved content
  Future<Map<String, dynamic>?> getSavedContent({
    required String userId,
    required String contentId,
  }) async {
    final doc = await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection('savedContent')
        .doc(contentId)
        .get();

    return doc.data();
  }

  /// Get all saved content
  Future<List<Map<String, dynamic>>> getAllSavedContent({
    required String userId,
    String? type,
  }) async {
    var query = _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection('savedContent');

    if (type != null) {
      query = query.where('type', isEqualTo: type) as CollectionReference<Map<String, dynamic>>;
    }

    final querySnapshot = await query
        .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Delete saved content
  Future<void> deleteSavedContent({
    required String userId,
    required String contentId,
  }) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection('savedContent')
        .doc(contentId)
        .delete();
  }

  /// Stream saved content (real-time)
  Stream<List<Map<String, dynamic>>> savedContentStream(String userId) {
    return _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection('savedContent')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  // ============================================================================
  // THEME UNLOCKS
  // ============================================================================

  /// Get theme unlocks
  Future<Map<String, dynamic>?> getThemeUnlocks(String userId) async {
    final doc = await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .get();

    if (!doc.exists) return null;

    final data = doc.data();
    return data?['themeUnlocks'] as Map<String, dynamic>?;
  }

  /// Unlock theme
  Future<void> unlockTheme({
    required String userId,
    required String themeName,
  }) async {
    final userRef = _firestore
        .collection(FirebaseCollections.users)
        .doc(userId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);

      if (!snapshot.exists) {
        throw Exception('User document does not exist');
      }

      final data = snapshot.data() ?? {};
      final themeUnlocks = data['themeUnlocks'] as Map<String, dynamic>? ?? {};
      final unlockedThemes = List<String>.from(themeUnlocks['unlockedThemes'] ?? []);

      if (!unlockedThemes.contains(themeName)) {
        unlockedThemes.add(themeName);

        transaction.update(userRef, {
          'themeUnlocks.unlockedThemes': unlockedThemes,
        });
      }
    });
  }

  /// Stream theme unlocks
  Stream<Map<String, dynamic>> themeUnlocksStream(String userId) {
    return _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return {'unlockedThemes': ['sunsetOrange']};
      }

      final data = snapshot.data();
      final themeUnlocks = data?['themeUnlocks'] as Map<String, dynamic>?;

      return themeUnlocks ?? {'unlockedThemes': ['sunsetOrange']};
    });
  }
}

/// Firestore Service Provider
@riverpod
FirestoreService firestoreService(FirestoreServiceRef ref) {
  return FirestoreService(FirebaseFirestore.instance);
}
