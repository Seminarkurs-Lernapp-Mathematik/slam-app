import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/user_stats.dart';
import '../models/user_settings.dart';
import '../models/question.dart';
import '../models/topic.dart';
import '../models/lernplan.dart'; // New import
import '../models/question_result.dart';
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
        createdAt: now,
        updatedAt: now,
      ).toJson(),
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
  // QUESTION QUEUE CACHE
  // ============================================================================

  /// Save the remaining question queue to Firebase so it survives session restarts.
  /// Only persists the un-answered questions (from currentIndex onwards).
  /// Limited to 20 questions to stay within Firestore's 1 MB document limit.
  Future<void> saveQuestionQueueCache({
    required String userId,
    required List<Question> questions,
    required int currentIndex,
  }) async {
    final cacheRef = _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.questionQueueCache)
        .doc('current');

    final remaining = questions.skip(currentIndex).take(20).toList();

    if (remaining.isEmpty) {
      await cacheRef.delete();
      return;
    }

    final now = DateTime.now();
    await cacheRef.set({
      'questions': remaining.map((q) => q.toJson()).toList(),
      'savedAt': Timestamp.fromDate(now),
      'expiresAt': Timestamp.fromDate(now.add(const Duration(hours: 24))),
    });
  }

  /// Load the cached question queue from Firebase.
  /// Returns null if no cache exists or the cache has expired.
  Future<List<Question>?> loadQuestionQueueCache(String userId) async {
    final doc = await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.questionQueueCache)
        .doc('current')
        .get();

    if (!doc.exists) return null;

    final data = doc.data();
    if (data == null) return null;

    final expiresAt = (data['expiresAt'] as Timestamp?)?.toDate();
    if (expiresAt != null && DateTime.now().isAfter(expiresAt)) {
      await doc.reference.delete();
      return null;
    }

    final questionsJson = data['questions'] as List<dynamic>?;
    if (questionsJson == null || questionsJson.isEmpty) return null;

    return questionsJson
        .map((q) => Question.fromJson(q as Map<String, dynamic>))
        .toList();
  }

  /// Delete the question queue cache (e.g. when the queue is exhausted).
  Future<void> clearQuestionQueueCache(String userId) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.questionQueueCache)
        .doc('current')
        .delete();
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
        return Lernplan.empty(userId); // Return empty Lernplan if not found
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
          topics: newTopics.map((t) => t.copyWith(addedAt: now)).toList(),
          createdAt: now,
          updatedAt: now,
        );
        // Manually serialize to ensure proper JSON conversion
        final jsonData = _lernplanToJson(newLernplan);
        transaction.set(lernplanDoc, {FirebaseCollections.learningPlan: jsonData}, SetOptions(merge: true));
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
            updatedTopics.add(newTopic.copyWith(addedAt: now));
          }
        }

        final updatedLernplan = existingLernplan.copyWith(
          topics: updatedTopics,
          updatedAt: now,
        );
        // Manually serialize to ensure proper JSON conversion
        final jsonData = _lernplanToJson(updatedLernplan);
        transaction.update(lernplanDoc, {FirebaseCollections.learningPlan: jsonData});
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
          updatedAt: DateTime.now(),
        );
        // Manually serialize to ensure proper JSON conversion
        final jsonData = _lernplanToJson(updatedLernplan);
        transaction.update(lernplanDoc, {FirebaseCollections.learningPlan: jsonData});
      }
    });
  }

  // ============================================================================
  // LERNPLAN SERIALIZATION HELPERS
  // ============================================================================

  /// Convert Lernplan to JSON with proper nested serialization
  Map<String, dynamic> _lernplanToJson(Lernplan lernplan) {
    return {
      'id': lernplan.id,
      'userId': lernplan.userId,
      'topics': lernplan.topics.map((t) => _lernplanTopicToJson(t)).toList(),
      'createdAt': Timestamp.fromDate(lernplan.createdAt),
      'updatedAt': Timestamp.fromDate(lernplan.updatedAt),
    };
  }

  /// Convert LernplanTopic to JSON
  Map<String, dynamic> _lernplanTopicToJson(LernplanTopic topic) {
    return {
      'leitidee': topic.leitidee,
      'thema': topic.thema,
      'unterthema': topic.unterthema,
      'addedAt': Timestamp.fromDate(topic.addedAt),
      'source': topic.source,
    };
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
        .collection(FirebaseCollections.memories)
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
        .collection(FirebaseCollections.memories)
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
        .collection(FirebaseCollections.memories)
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
        .collection(FirebaseCollections.memories)
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
    final collectionRef = _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.memories);

    Query<Map<String, dynamic>> query = collectionRef;

    if (includeArchived == false) {
      query = query.where('isArchived', isEqualTo: false);
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
        .collection(FirebaseCollections.memories)
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
        .collection(FirebaseCollections.savedContent)
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
        .collection(FirebaseCollections.savedContent)
        .doc(contentId)
        .get();

    return doc.data();
  }

  /// Get all saved content
  Future<List<Map<String, dynamic>>> getAllSavedContent({
    required String userId,
    String? type,
  }) async {
    final collectionRef = _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.savedContent);

    Query<Map<String, dynamic>> query = collectionRef;

    if (type != null) {
      query = query.where('type', isEqualTo: type);
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
        .collection(FirebaseCollections.savedContent)
        .doc(contentId)
        .delete();
  }

  /// Stream saved content (real-time)
  Stream<List<Map<String, dynamic>>> savedContentStream(String userId) {
    return _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.savedContent)
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

  // ============================================================================
  // SHOP / PURCHASES
  // ============================================================================

  /// Purchase a theme with coins
  Future<Map<String, dynamic>> purchaseTheme({
    required String userId,
    required String themeName,
    required int cost,
  }) async {
    final userRef = _firestore.collection(FirebaseCollections.users).doc(userId);

    return await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);

      if (!snapshot.exists) {
        throw Exception('User document does not exist');
      }

      final data = snapshot.data() ?? {};
      final stats = data['stats'] as Map<String, dynamic>? ?? {};
      final coins = (stats['coins'] as num?)?.toInt() ?? 0;
      final themeUnlocks = data['themeUnlocks'] as Map<String, dynamic>? ?? {};
      final unlockedThemes = List<String>.from(themeUnlocks['unlockedThemes'] ?? ['sunsetOrange']);

      // Check if user has enough coins
      if (coins < cost) {
        return {
          'success': false,
          'message': 'Nicht genügend Münzen. Benötigt: $cost, Vorhanden: $coins',
        };
      }

      // Check if theme is already unlocked
      if (unlockedThemes.contains(themeName)) {
        return {
          'success': false,
          'message': 'Theme bereits freigeschaltet',
        };
      }

      // Perform purchase
      unlockedThemes.add(themeName);
      final newCoins = coins - cost;

      transaction.update(userRef, {
        'stats.coins': newCoins,
        'themeUnlocks.unlockedThemes': unlockedThemes,
      });

      return {
        'success': true,
        'message': 'Theme erfolgreich gekauft',
        'newBalance': newCoins,
        'unlockedThemes': unlockedThemes,
      };
    });
  }

  /// Purchase a streak freeze with coins
  Future<Map<String, dynamic>> purchaseStreakFreezeWithCoins({
    required String userId,
    required int cost,
  }) async {
    final userRef = _firestore.collection(FirebaseCollections.users).doc(userId);

    return await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);

      if (!snapshot.exists) {
        throw Exception('User document does not exist');
      }

      final data = snapshot.data() ?? {};
      final stats = data['stats'] as Map<String, dynamic>? ?? {};
      final coins = (stats['coins'] as num?)?.toInt() ?? 0;
      final streakFreezes = (stats['streakFreezes'] as num?)?.toInt() ?? 0;

      const maxStreakFreezes = 5;

      // Check if user has enough coins
      if (coins < cost) {
        return {
          'success': false,
          'message': 'Nicht genügend Münzen. Benötigt: $cost, Vorhanden: $coins',
        };
      }

      // Check if max streak freezes reached
      if (streakFreezes >= maxStreakFreezes) {
        return {
          'success': false,
          'message': 'Maximale Anzahl an Streak Freezes erreicht ($maxStreakFreezes)',
        };
      }

      // Perform purchase
      final newCoins = coins - cost;
      final newStreakFreezes = streakFreezes + 1;

      transaction.update(userRef, {
        'stats.coins': newCoins,
        'stats.streakFreezes': newStreakFreezes,
      });

      return {
        'success': true,
        'message': 'Streak Freeze erfolgreich gekauft',
        'newBalance': newCoins,
        'streakFreezes': newStreakFreezes,
      };
    });
  }

  /// Purchase a streak freeze with XP
  Future<Map<String, dynamic>> purchaseStreakFreezeWithXP({
    required String userId,
    required int xpCost,
  }) async {
    final userRef = _firestore.collection(FirebaseCollections.users).doc(userId);

    return await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);

      if (!snapshot.exists) {
        throw Exception('User document does not exist');
      }

      final data = snapshot.data() ?? {};
      final stats = data['stats'] as Map<String, dynamic>? ?? {};
      final totalXp = (stats['totalXp'] as num?)?.toInt() ?? 0;
      final streakFreezes = (stats['streakFreezes'] as num?)?.toInt() ?? 0;

      const maxStreakFreezes = 5;

      // Check if user has enough XP
      if (totalXp < xpCost) {
        return {
          'success': false,
          'message': 'Nicht genügend XP. Benötigt: $xpCost, Vorhanden: $totalXp',
        };
      }

      // Check if max streak freezes reached
      if (streakFreezes >= maxStreakFreezes) {
        return {
          'success': false,
          'message': 'Maximale Anzahl an Streak Freezes erreicht ($maxStreakFreezes)',
        };
      }

      // Perform purchase
      final newTotalXp = totalXp - xpCost;
      final newStreakFreezes = streakFreezes + 1;

      transaction.update(userRef, {
        'stats.totalXp': newTotalXp,
        'stats.streakFreezes': newStreakFreezes,
      });

      return {
        'success': true,
        'message': 'Streak Freeze erfolgreich gekauft',
        'newTotalXp': newTotalXp,
        'streakFreezes': newStreakFreezes,
      };
    });
  }

  // ============================================================================
  // SOFT DELETE PATTERN
  // ============================================================================

  /// Soft delete a document (marks as deleted instead of removing)
  Future<void> softDeleteDocument({
    required String userId,
    required String collection,
    required String docId,
    String deletedBy = 'user',
  }) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(collection)
        .doc(docId)
        .update({
      'isDeleted': true,
      'deletedAt': Timestamp.now(),
      'deletedBy': deletedBy,
    });
  }

  /// Restore a soft-deleted document
  Future<void> restoreDocument({
    required String userId,
    required String collection,
    required String docId,
  }) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(collection)
        .doc(docId)
        .update({
      'isDeleted': false,
      'restoredAt': Timestamp.now(),
    });
  }

  /// Get documents with soft delete filtering
  Future<List<Map<String, dynamic>>> getDocuments({
    required String userId,
    required String collection,
    bool includeDeleted = false,
    int limit = 100,
  }) async {
    var query = _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(collection)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (!includeDeleted) {
      query = query.where('isDeleted', isEqualTo: false);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // ============================================================================
  // FRIENDS & SOCIAL (UNUSED COLLECTIONS IMPLEMENTATION)
  // ============================================================================

  /// Send friend request
  Future<void> sendFriendRequest({
    required String userId,
    required String friendId,
    required String friendEmail,
  }) async {
    final requestData = {
      'userId': userId,
      'friendId': friendId,
      'friendEmail': friendEmail,
      'status': 'pending',
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    };

    // Add to sentChallenges (reusing for friend requests)
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.sentChallenges)
        .doc(friendId)
        .set(requestData);

    // Add to receivedChallenges of friend
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(friendId)
        .collection(FirebaseCollections.receivedChallenges)
        .doc(userId)
        .set({
      ...requestData,
      'senderId': userId,
    });
  }

  /// Get friends list
  Stream<List<Map<String, dynamic>>> friendsStream(String userId) {
    return _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.friends)
        .where('status', isEqualTo: 'accepted')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  /// Get pending friend requests
  Stream<List<Map<String, dynamic>>> pendingFriendRequestsStream(String userId) {
    return _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.receivedChallenges)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // ============================================================================
  // LEARNING SESSIONS (UNUSED COLLECTIONS IMPLEMENTATION)
  // ============================================================================

  /// Create a learning session
  Future<void> createLearningSession({
    required String userId,
    required String sessionId,
    required Map<String, dynamic> sessionData,
  }) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.learningSessions)
        .doc(sessionId)
        .set({
      ...sessionData,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });
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
        .update({
      ...updates,
      'updatedAt': Timestamp.now(),
    });
  }

  /// Get learning sessions stream
  Stream<List<Map<String, dynamic>>> learningSessionsStream(String userId) {
    return _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.learningSessions)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // ============================================================================
  // INVENTORY (UNUSED COLLECTIONS IMPLEMENTATION)
  // ============================================================================

  /// Add item to inventory
  Future<void> addInventoryItem({
    required String userId,
    required String itemId,
    required Map<String, dynamic> itemData,
  }) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.inventory)
        .doc(itemId)
        .set({
      ...itemData,
      'acquiredAt': Timestamp.now(),
    });
  }

  /// Get inventory items
  Stream<List<Map<String, dynamic>>> inventoryStream(String userId) {
    return _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.inventory)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // ============================================================================
  // REVIEW QUEUE (UNUSED COLLECTIONS IMPLEMENTATION)
  // ============================================================================

  /// Add to review queue
  Future<void> addToReviewQueue({
    required String userId,
    required String itemId,
    required Map<String, dynamic> reviewData,
  }) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.reviewQueue)
        .doc(itemId)
        .set({
      ...reviewData,
      'addedAt': Timestamp.now(),
      'isDeleted': false,
    });
  }

  /// Get review queue
  Stream<List<Map<String, dynamic>>> reviewQueueStream(String userId) {
    return _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.reviewQueue)
        .where('isDeleted', isEqualTo: false)
        .orderBy('nextReviewDate')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}

/// Firestore Service Provider
@riverpod
FirestoreService firestoreService(FirestoreServiceRef ref) {
  return FirestoreService(FirebaseFirestore.instance);
}
