import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/models/memory.dart';
import '../../../../core/models/question.dart';
import '../../../../core/services/ai_service.dart';
import '../../../../core/models/question_result.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../learning_plan/presentation/providers/lernplan_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';

part 'live_feed_providers.g.dart';

// ============================================================================
// QUESTION QUEUE CACHE KEYS
// ============================================================================
const String _kQuestionQueueKey = 'live_feed_question_queue';
const String _kQueueIndexKey = 'live_feed_queue_index';
const String _kQueueTimestampKey = 'live_feed_queue_timestamp';
const Duration _kCacheValidityDuration = Duration(hours: 24); // Cache valid for 24 hours

/// Current Difficulty Level Provider (1-10)
@riverpod
class LiveFeedDifficulty extends _$LiveFeedDifficulty {
  @override
  double build() {
    return 5.0; // Start at medium difficulty
  }

  // AFB levels: I=3.0, II=6.0, III=9.0
  void increase() {
    if (state <= 4.5) {
      state = 6.0; // AFB I → AFB II
    } else if (state <= 7.5) {
      state = 9.0; // AFB II → AFB III
    }
    // Already at AFB III — no change
  }

  void decrease() {
    if (state > 7.5) {
      state = 6.0; // AFB III → AFB II
    } else if (state > 4.5) {
      state = 3.0; // AFB II → AFB I
    }
    // Already at AFB I — no change
  }

  void setDifficulty(double value) {
    state = value.clamp(1.0, 10.0);
  }
}

/// Question Buffer Provider (caching system)
@riverpod
class QuestionBuffer extends _$QuestionBuffer {
  static const int bufferSize = 5;

  @override
  List<Question> build() {
    return [];
  }

  void addQuestion(Question question) {
    state = [...state, question];
  }

  Question? getNext() {
    if (state.isEmpty) return null;
    final question = state.first;
    state = state.skip(1).toList();
    return question;
  }

  void clear() {
    state = [];
  }

  bool get needsRefill => state.length < bufferSize;
}

/// Current Live Feed Question Provider
@riverpod
class CurrentLiveFeedQuestion extends _$CurrentLiveFeedQuestion {
  @override
  Question? build() {
    return null;
  }

  void setQuestion(Question question) {
    state = question;
  }

  void clear() {
    state = null;
  }
}

/// Live Feed Answer Provider
@riverpod
class LiveFeedAnswer extends _$LiveFeedAnswer {
  @override
  String build() {
    return '';
  }

  void setAnswer(String answer) {
    state = answer;
  }

  void clear() {
    state = '';
  }
}

/// Consecutive Correct Answers Counter
@riverpod
class ConsecutiveCorrect extends _$ConsecutiveCorrect {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state++;
  }

  void reset() {
    state = 0;
  }
}

/// Consecutive Wrong Answers Counter
@riverpod
class ConsecutiveWrong extends _$ConsecutiveWrong {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state++;
  }

  void reset() {
    state = 0;
  }
}

/// Total Questions Answered in Live Feed
@riverpod
class LiveFeedQuestionsAnswered extends _$LiveFeedQuestionsAnswered {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state++;
  }

  void reset() {
    state = 0;
  }
}

/// Total Correct Answers in Live Feed
@riverpod
class LiveFeedCorrectAnswers extends _$LiveFeedCorrectAnswers {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state++;
  }

  void reset() {
    state = 0;
  }
}

/// Live Feed Hint Count
@riverpod
class LiveFeedHintsUsed extends _$LiveFeedHintsUsed {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state++;
  }

  void reset() {
    state = 0;
  }
}

/// Is Evaluating Answer
@riverpod
class IsEvaluating extends _$IsEvaluating {
  @override
  bool build() {
    return false;
  }

  void setEvaluating(bool value) {
    state = value;
  }
}

/// Show Feedback
@riverpod
class LiveFeedShowFeedback extends _$LiveFeedShowFeedback {
  @override
  bool build() {
    return false;
  }

  void show() {
    state = true;
  }

  void hide() {
    state = false;
  }
}

/// Last Evaluation Result
@riverpod
class LastEvaluationResult extends _$LastEvaluationResult {
  @override
  Map<String, dynamic>? build() {
    return null;
  }

  void setResult(Map<String, dynamic> result) {
    state = result;
  }

  void clear() {
    state = null;
  }
}

/// Live Feed Question Generator
@riverpod
class LiveFeedQuestionGenerator extends _$LiveFeedQuestionGenerator {
  @override
  bool build() {
    return false; // Represents if questions are currently being generated
  }

  Future<void> generateQuestions({bool force = false}) async {
    if (state && !force) return;

    state = true;
    ref.read(liveFeedQueueProvider.notifier).setGenerating(true);

    try {
      final aiService = ref.read(aiServiceProvider);
      final appSettings = ref.read(appSettingsNotifierProvider);
      final user = ref.read(currentUserProvider);
      final userId = user?.uid;
      if (userId == null || userId.isEmpty) {
        debugPrint('❌ LiveFeed: User not logged in');
        return;
      }

      // Wait for the Lernplan stream to emit its first value (avoids race
      // condition where the generator fires before Firestore data arrives and
      // incorrectly sees an empty topic list).
      debugPrint('🔄 LiveFeed: Waiting for Lernplan data...');
      final lernplan = await ref.read(lernplanStreamProvider.future);
      final lernplanTopics = lernplan.topics;

      if (lernplanTopics.isEmpty) {
        debugPrint('⚠️ LiveFeed: Lernplan is empty, cannot generate');
        return;
      }

      debugPrint('🔄 LiveFeed: Generating questions via backend-managed AI...');

      final topicsForAI = lernplanTopics
          .map((t) => TopicData(leitidee: t.leitidee, thema: t.thema, unterthema: t.unterthema))
          .toList();

      // Pass recent performance so the AI can adapt difficulty
      final questionsAnswered = ref.read(liveFeedQuestionsAnsweredProvider);
      final correctAnswers = ref.read(liveFeedCorrectAnswersProvider);
      final correctRate = questionsAnswered > 0 ? correctAnswers / questionsAnswered : 0.5;

      // Map current difficulty to AFB level string for the backend
      final difficulty = ref.read(liveFeedDifficultyProvider);
      final afbLevel = difficulty <= 4.5 ? 'I' : (difficulty <= 7.5 ? 'II' : 'III');
      debugPrint('🔄 LiveFeed: Requesting 5 questions at AFB $afbLevel');

      // Build memories context: due spaced-repetition items + user preferences
      List<Map<String, dynamic>>? memoriesContext;
      try {
        final firestoreService = ref.read(firestoreServiceProvider);
        final dueMemories = await firestoreService.getDueMemories(userId);
        final preferences = appSettings.aiPreferences;
        if (dueMemories.isNotEmpty || preferences.isNotEmpty) {
          memoriesContext = [
            for (final m in dueMemories.take(5))
              {
                'topic': m['topic'] ?? '',
                'subtopic': m['subtopic'] ?? '',
                'quality': m['lastQuality'] ?? 3,
              },
            if (preferences.isNotEmpty)
              {'userPreferences': preferences.join('. ')},
          ];
        }
      } catch (e) {
        debugPrint('⚠️ LiveFeed: Could not fetch memories/preferences: $e');
      }

      final session = await aiService.generateQuestions(
        userId: userId,
        learningPlanItemId: 0,
        topics: topicsForAI,
        questionCount: 5,
        afbLevel: afbLevel,
        userContext: UserContext(
          gradeLevel: appSettings.gradeLevel.replaceAll('Klasse_', ''),
          courseType: appSettings.courseType,
        ),
        recentPerformance: questionsAnswered > 0
            ? {'averageScore': correctRate, 'totalAnswered': questionsAnswered}
            : null,
        recentMemories: memoriesContext,
      );

      if (session.questions.isNotEmpty) {
        ref.read(liveFeedQueueProvider.notifier).addQuestions(session.questions);
        debugPrint('✅ LiveFeed: ${session.questions.length} questions added to queue');

        // Automatically load the first question if nothing is showing yet
        if (ref.read(currentLiveFeedQuestionProvider) == null) {
          final first = ref.read(liveFeedQueueProvider).currentQuestion;
          if (first != null) {
            ref.read(currentLiveFeedQuestionProvider.notifier).setQuestion(first);
          }
        }
      } else {
        debugPrint('⚠️ LiveFeed: AI returned no questions');
      }
    } catch (e, st) {
      debugPrint('❌ LiveFeed: Error generating questions: $e\n$st');
      rethrow; // Surface error to the screen so it can display it
    } finally {
      state = false;
      ref.read(liveFeedQueueProvider.notifier).setGenerating(false);
    }
  }
}

// ============================================================================
// QUEUE SYSTEM
// ============================================================================

/// Queue state for live feed questions
class LiveFeedQueueState {
  final List<Question> questions;
  final bool isGenerating;
  final int currentIndex;

  LiveFeedQueueState({
    this.questions = const [],
    this.isGenerating = false,
    this.currentIndex = 0,
  });

  LiveFeedQueueState copyWith({
    List<Question>? questions,
    bool? isGenerating,
    int? currentIndex,
  }) {
    return LiveFeedQueueState(
      questions: questions ?? this.questions,
      isGenerating: isGenerating ?? this.isGenerating,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  int get remainingCount => questions.length - currentIndex;
  Question? get currentQuestion =>
      currentIndex < questions.length ? questions[currentIndex] : null;
  bool get hasNext => currentIndex + 1 < questions.length;
}

/// Live Feed Queue Provider with Caching
@riverpod
class LiveFeedQueue extends _$LiveFeedQueue {
  SharedPreferences? _prefs;
  final Completer<void> _cacheReady = Completer<void>();

  /// Resolves once the initial cache load (Firebase or SharedPreferences) is done.
  Future<void> get cacheInitialized => _cacheReady.future;

  @override
  LiveFeedQueueState build() {
    // Initialize and try to load cached questions
    _initializeCache();
    return LiveFeedQueueState();
  }

  Future<void> _initializeCache() async {
    try {
      _prefs = await SharedPreferences.getInstance();

      // Firebase is the primary cache source (cross-device / cross-session).
      // Fall back to SharedPreferences when the user is not authenticated.
      //
      // IMPORTANT: Use authService.currentUser (synchronous FirebaseAuth state)
      // rather than currentUserProvider, which is a StreamProvider and returns
      // null until the authStateChanges stream emits — even if Firebase Auth
      // already has the user in memory. By the time LiveFeedScreen is shown the
      // SplashScreen has already awaited authStateChanges().first, so
      // FirebaseAuth.instance.currentUser is guaranteed to be non-null here.
      final userId = ref.read(authServiceProvider).currentUser?.uid;
      if (userId != null && userId.isNotEmpty) {
        await _loadFromFirebase(userId);
      } else {
        await _loadCachedQuestions();
      }
    } catch (e) {
      debugPrint('❌ LiveFeedQueue: Error initializing cache: $e');
    } finally {
      if (!_cacheReady.isCompleted) _cacheReady.complete();
    }
  }

  /// Load cached questions from Firebase.
  /// Falls back to SharedPreferences if Firebase returns nothing.
  Future<void> _loadFromFirebase(String userId) async {
    try {
      final firestoreService = ref.read(firestoreServiceProvider);
      final questions = await firestoreService.loadQuestionQueueCache(userId);

      if (questions != null && questions.isNotEmpty) {
        state = state.copyWith(questions: questions, currentIndex: 0);
        debugPrint(
          '✅ LiveFeedQueue: Loaded ${questions.length} questions from Firebase',
        );
        return;
      }
    } catch (e) {
      debugPrint('❌ LiveFeedQueue: Error loading from Firebase: $e');
    }

    // Nothing in Firebase — try the local cache as a last resort.
    await _loadCachedQuestions();
  }

  /// Load cached questions from local SharedPreferences storage
  Future<void> _loadCachedQuestions() async {
    if (_prefs == null) return;

    try {
      final cachedJson = _prefs!.getString(_kQuestionQueueKey);
      final cachedIndex = _prefs!.getInt(_kQueueIndexKey) ?? 0;
      final cachedTimestamp = _prefs!.getInt(_kQueueTimestampKey) ?? 0;

      // Check if cache is still valid
      final now = DateTime.now().millisecondsSinceEpoch;
      final cacheAge = Duration(milliseconds: now - cachedTimestamp);

      if (cachedJson != null && cacheAge < _kCacheValidityDuration) {
        final List<dynamic> decoded = jsonDecode(cachedJson);
        final questions = decoded
            .map((q) => Question.fromJson(q as Map<String, dynamic>))
            .toList();

        if (questions.isNotEmpty) {
          // Restore the queue state
          state = state.copyWith(
            questions: questions,
            currentIndex: cachedIndex.clamp(0, questions.length - 1),
          );
          debugPrint('✅ LiveFeedQueue: Loaded ${questions.length} cached questions (index: $cachedIndex)');
        }
      } else if (cachedJson != null) {
        // Cache expired, clear it
        debugPrint('🗑️ LiveFeedQueue: Cache expired, clearing');
        await _clearCache();
      }
    } catch (e) {
      debugPrint('❌ LiveFeedQueue: Error loading cached questions: $e');
    }
  }

  /// Save current queue to local storage and Firebase
  Future<void> _saveCache() async {
    // Local cache (SharedPreferences)
    if (_prefs != null) {
      try {
        final questionsJson = state.questions.map((q) => q.toJson()).toList();
        await _prefs!.setString(_kQuestionQueueKey, jsonEncode(questionsJson));
        await _prefs!.setInt(_kQueueIndexKey, state.currentIndex);
        await _prefs!.setInt(_kQueueTimestampKey, DateTime.now().millisecondsSinceEpoch);
      } catch (e) {
        debugPrint('❌ LiveFeedQueue: Error saving local cache: $e');
      }
    }

    // Firebase cache (primary — survives browser refreshes and new devices)
    final userId = ref.read(authServiceProvider).currentUser?.uid;
    if (userId != null && userId.isNotEmpty) {
      try {
        final firestoreService = ref.read(firestoreServiceProvider);
        await firestoreService.saveQuestionQueueCache(
          userId: userId,
          questions: state.questions,
          currentIndex: state.currentIndex,
        );
      } catch (e) {
        debugPrint('❌ LiveFeedQueue: Error saving to Firebase: $e');
      }
    }
  }

  /// Clear the cache (local + Firebase)
  Future<void> _clearCache() async {
    // Clear local cache
    if (_prefs != null) {
      try {
        await _prefs!.remove(_kQuestionQueueKey);
        await _prefs!.remove(_kQueueIndexKey);
        await _prefs!.remove(_kQueueTimestampKey);
      } catch (e) {
        debugPrint('❌ LiveFeedQueue: Error clearing local cache: $e');
      }
    }

    // Clear Firebase cache
    final userId = ref.read(authServiceProvider).currentUser?.uid;
    if (userId != null && userId.isNotEmpty) {
      try {
        final firestoreService = ref.read(firestoreServiceProvider);
        await firestoreService.clearQuestionQueueCache(userId);
      } catch (e) {
        debugPrint('❌ LiveFeedQueue: Error clearing Firebase cache: $e');
      }
    }
  }

  /// Add a batch of questions to the queue
  void addQuestions(List<Question> newQuestions) {
    state = state.copyWith(
      questions: [...state.questions, ...newQuestions],
    );
    // Persist to cache
    _saveCache();
    debugPrint('💾 LiveFeedQueue: Saved ${state.questions.length} questions to cache');
  }

  /// Move to the next question in the queue
  Question? nextQuestion() {
    if (!state.hasNext) {
      // No more questions, clear cache
      _clearCache();
      return null;
    }
    final nextIndex = state.currentIndex + 1;
    state = state.copyWith(currentIndex: nextIndex);
    // Update cache with new index
    _saveCache();
    return state.currentQuestion;
  }

  /// Set the current question (first question load)
  void setCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
    _saveCache();
  }

  /// Set generating state
  void setGenerating(bool generating) {
    state = state.copyWith(isGenerating: generating);
  }

  /// Clear the queue and reset
  void clear() {
    state = LiveFeedQueueState();
    _clearCache();
    debugPrint('🗑️ LiveFeedQueue: Queue cleared and cache removed');
  }

  /// Get remaining question count
  int get remainingCount => state.remainingCount;

  /// Whether more questions should be generated (prefetch at 2 remaining)
  bool get needsMoreQuestions => state.remainingCount <= 2;
  
  /// Check if there are cached questions available
  bool get hasCachedQuestions => state.questions.isNotEmpty && state.currentIndex < state.questions.length;
}

/// Selected Option Provider (tracks which MCQ option was selected)
@riverpod
class SelectedOption extends _$SelectedOption {
  @override
  String? build() {
    return null;
  }

  void select(String optionId) {
    state = optionId;
  }

  void clear() {
    state = null;
  }
}

/// "Wo haengts?" text input provider
@riverpod
class WoHaengtsInput extends _$WoHaengtsInput {
  @override
  String build() {
    return '';
  }

  void setText(String text) {
    state = text;
  }

  void clear() {
    state = '';
  }
}

/// Whether "Wo haengts?" section should be shown
@riverpod
class ShowWoHaengts extends _$ShowWoHaengts {
  @override
  bool build() {
    return false;
  }

  void show() {
    state = true;
  }

  void hide() {
    state = false;
  }
}

/// Live Feed Evaluator Provider
/// This provider listens for new evaluation results and saves them to Firestore.
@riverpod
class LiveFeedEvaluator extends _$LiveFeedEvaluator {
  @override
  void build() {
    ref.listen(lastEvaluationResultProvider, (previous, next) async {
      if (next != null) {
        await _saveEvaluationResult(next);
      }
    });
  }

  Future<void> _saveEvaluationResult(Map<String, dynamic> evaluationResult) async {
    final userId = ref.read(currentUserProvider)?.uid;
    final currentQuestion = ref.read(currentLiveFeedQuestionProvider);
    final currentAnswer = ref.read(liveFeedAnswerProvider);
    final hintsUsed = ref.read(liveFeedHintsUsedProvider);
    final appSettings = ref.read(appSettingsNotifierProvider);

    if (userId == null || currentQuestion == null) {
      debugPrint('❌ LiveFeedEvaluator: userId or currentQuestion is null. Cannot save question result.');
      return;
    }

    // Extract topic info from the current question's metadata
    // Question model has 'topic' and 'subtopic' fields, use those
    final leitidee = 'Unknown'; // Not stored directly in Question
    final thema = currentQuestion.topic;
    final unterthema = currentQuestion.subtopic;

    final gradeLevel = appSettings.gradeLevel.replaceAll('Klasse_', '');
    final courseType = appSettings.courseType;

    final questionResult = QuestionResult(
      questionId: currentQuestion.id,
      userId: userId,
      sessionId: 'live-feed-session', // Live feed questions don't have a real session
      questionText: currentQuestion.question,
      correctAnswer: evaluationResult['correctAnswer'] ?? 'N/A',
      userAnswer: currentAnswer,
      isCorrect: evaluationResult['isCorrect'] ?? false,
      difficulty: currentQuestion.difficulty,
      hintsUsed: hintsUsed,
      timeSpentSeconds: 0, // TODO: Implement time tracking
      leitidee: leitidee,
      thema: thema,
      unterthema: unterthema,
      gradeLevel: gradeLevel,
      courseType: courseType,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      xpEarned: evaluationResult['xpEarned'] ?? 0,
      coinsEarned: evaluationResult['coinsEarned'] ?? 0,
      feedback: evaluationResult['feedback'],
    );

    try {
      await ref.read(firestoreServiceProvider).saveQuestionResult(userId, questionResult);
      debugPrint('✅ Question result saved successfully: ${questionResult.questionId}');
    } catch (e, st) {
      debugPrint('❌ Error saving question result: $e\n$st');
    }

    // Update spaced-repetition memory (fire-and-forget — non-fatal)
    _upsertMemory(
      userId: userId,
      question: currentQuestion,
      isCorrect: evaluationResult['isCorrect'] ?? false,
      hintsUsed: hintsUsed,
    );
  }

  /// Creates or updates the SM-2 spaced-repetition memory for a question.
  Future<void> _upsertMemory({
    required String userId,
    required Question question,
    required bool isCorrect,
    required int hintsUsed,
  }) async {
    try {
      final firestoreService = ref.read(firestoreServiceProvider);
      final quality = SM2Calculator.getQualityFromPerformance(
        isCorrect: isCorrect,
        hintsUsed: hintsUsed,
        timeSpentSeconds: 0,
        expectedTimeSeconds: 60,
      );

      final existing = await firestoreService.getMemory(
        userId: userId,
        memoryId: question.id,
      );

      final now = DateTime.now();

      if (existing == null) {
        // First time seeing this question — create a new memory
        final sm2 = SM2Calculator.calculateNextReview(
          quality: quality,
          easeFactor: 2.5,
          repetitions: 0,
          interval: 0,
        );
        final memory = Memory(
          id: question.id,
          userId: userId,
          questionId: question.id,
          questionText: question.question,
          topic: question.topic,
          subtopic: question.subtopic,
          leitidee: '',
          difficulty: question.difficulty,
          easeFactor: sm2.easeFactor,
          interval: sm2.interval,
          repetitions: sm2.repetitions,
          nextReviewAt: sm2.nextReviewDate,
          lastReviewedAt: now,
          lastQuality: quality,
          reviewCount: 1,
          averageQuality: quality.toDouble(),
          createdAt: now,
          updatedAt: now,
        );
        await firestoreService.createMemory(
          userId: userId,
          memoryData: memory.toJson(),
        );
      } else {
        // Update existing memory with SM-2
        final prev = Memory.fromJson(existing);
        final sm2 = SM2Calculator.calculateNextReview(
          quality: quality,
          easeFactor: prev.easeFactor,
          repetitions: prev.repetitions,
          interval: prev.interval,
        );
        final newCount = prev.reviewCount + 1;
        final newAvg =
            (prev.averageQuality * prev.reviewCount + quality) / newCount;
        await firestoreService.updateMemory(
          userId: userId,
          memoryId: question.id,
          updates: {
            'easeFactor': sm2.easeFactor,
            'interval': sm2.interval,
            'repetitions': sm2.repetitions,
            'nextReviewAt': Timestamp.fromDate(sm2.nextReviewDate),
            'lastReviewedAt': Timestamp.fromDate(now),
            'lastQuality': quality,
            'reviewCount': newCount,
            'averageQuality': newAvg,
            'updatedAt': Timestamp.fromDate(now),
          },
        );
      }
      debugPrint('✅ Memory upserted for: ${question.id}');
    } catch (e) {
      debugPrint('❌ Memory upsert failed (non-fatal): $e');
    }
  }
}


/// Timer seconds for the current question — updated by FeedQuestionCard, read by _FeedHeader.
final liveFeedTimerSecondsProvider = StateProvider<int>((ref) => 0);
