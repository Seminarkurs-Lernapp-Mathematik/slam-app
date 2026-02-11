import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/user_stats.dart';
import '../models/user_settings.dart';
import '../models/question.dart';
import '../models/topic.dart';
import '../models/lernplan.dart'; // New import
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
      FirebaseCollections.learningPlan: Lernplan(
        id: userId, // Lernplan ID same as User ID for single Lernplan per user
        userId: userId,
        topics: [],
        createdAtTimestamp: now.millisecondsSinceEpoch,
        updatedAtTimestamp: now.millisecondsSinceEpoch,
      ).toJson(),
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
  // QUESTION HISTORY
  // ============================================================================

  /// Save question result
  Future<void> saveQuestionResult(String userId, QuestionResult result) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.questionHistory) // new subcollection
        .add(result.toJson()); // add document with auto-generated ID
  }

  /// Get recent performance (last N results)
  Future<List<QuestionResult>> getRecentPerformance(String userId,
      {int limit = 10}) async {
    final querySnapshot = await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.questionHistory)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();

    return querySnapshot.docs
        .map((doc) => QuestionResult.fromJson(doc.data()))
        .toList();
  }

  // ============================================================================
  // LERNPLAN
  // ============================================================================

  /// Save Lernplan (updates the Lernplan field on the user document)
  Future<void> saveLernplan(String userId, Lernplan lernplan) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .set({
      FirebaseCollections.learningPlan: lernplan.toJson(),
    }, SetOptions(merge: true));
  }

  /// Get Lernplan stream (real-time updates for the Lernplan field on the user document)
  Stream<Lernplan> getLernplanStream(String userId) {
    return _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      if (data == null || !data.containsKey(FirebaseCollections.learningPlan)) {
        return Lernplan(
          id: userId,
          userId: userId,
          topics: [],
          createdAtTimestamp: 0,
          updatedAtTimestamp: 0,
        ); // Return empty Lernplan if not found
      }

      final lernplanData =
          data[FirebaseCollections.learningPlan] as Map<String, dynamic>;

      return Lernplan.fromJson(lernplanData);
    });
  }

  /// Add topics to an existing Lernplan
  Future<void> addTopicsToLernplan(String userId, List<LernplanTopic> newTopics) async {
    final lernplanDoc = _firestore
        .collection(FirebaseCollections.users)
        .doc(userId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(lernplanDoc);
      final data = snapshot.data();

      if (data == null || !data.containsKey(FirebaseCollections.learningPlan)) {
        // Lernplan not found, create a new one with new topics
        final now = DateTime.now();
        final newLernplan = Lernplan(
          id: userId,
          userId: userId,
          topics: newTopics,
          createdAtTimestamp: now.millisecondsSinceEpoch,
          updatedAtTimestamp: now.millisecondsSinceEpoch,
        );
        transaction.set(lernplanDoc, {FirebaseCollections.learningPlan: newLernplan.toJson()}, SetOptions(merge: true));
      } else {
        // Lernplan found, update it
        final existingLernplanData = data[FirebaseCollections.learningPlan] as Map<String, dynamic>;
        final existingLernplan = Lernplan.fromJson(existingLernplanData);

        // Filter out topics that already exist to avoid duplicates
        final updatedTopics = List<LernplanTopic>.from(existingLernplan.topics);
        final now = DateTime.now();
        for (var newTopic in newTopics) {
          if (!updatedTopics.any((t) =>
              t.leitidee == newTopic.leitidee &&
              t.thema == newTopic.thema &&
              t.unterthema == newTopic.unterthema)) {
            updatedTopics.add(newTopic.copyWith(addedAtTimestamp: now.millisecondsSinceEpoch));
          }
        }

        final updatedLernplan = existingLernplan.copyWith(
          topics: updatedTopics,
          updatedAtTimestamp: now.millisecondsSinceEpoch,
        );
        transaction.update(lernplanDoc, {FirebaseCollections.learningPlan: updatedLernplan.toJson()});
      }
    });
  }

  /// Remove a topic from an existing Lernplan
  Future<void> removeTopicFromLernplan(String userId, LernplanTopic topicToRemove) async {
    final lernplanDoc = _firestore
        .collection(FirebaseCollections.users)
        .doc(userId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(lernplanDoc);
      final data = snapshot.data();

      if (data != null && data.containsKey(FirebaseCollections.learningPlan)) {
        final existingLernplanData = data[FirebaseCollections.learningPlan] as Map<String, dynamic>;
        final existingLernplan = Lernplan.fromJson(existingLernplanData);

        final updatedTopics = existingLernplan.topics
            .where((t) =>
                t.leitidee != topicToRemove.leitidee ||
                t.thema != topicToRemove.thema ||
                t.unterthema != topicToRemove.unterthema)
            .toList();

        final updatedLernplan = existingLernplan.copyWith(
          topics: updatedTopics,
          updatedAtTimestamp: DateTime.now().millisecondsSinceEpoch,
        );
        transaction.update(lernplanDoc, {FirebaseCollections.learningPlan: updatedLernplan.toJson()});
      }
    });
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
