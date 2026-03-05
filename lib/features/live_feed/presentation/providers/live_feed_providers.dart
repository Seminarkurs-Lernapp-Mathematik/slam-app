import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/models/question.dart';
import '../../../../core/services/ai_service.dart';
import '../../../../core/models/question_result.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../learning_plan/presentation/providers/lernplan_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';

part 'live_feed_providers.g.dart';

/// Current Difficulty Level Provider (1-10)
@riverpod
class LiveFeedDifficulty extends _$LiveFeedDifficulty {
  @override
  double build() {
    return 5.0; // Start at medium difficulty
  }

  void increase() {
    state = (state + 0.5).clamp(1.0, 10.0);
  }

  void decrease() {
    state = (state - 0.5).clamp(1.0, 10.0);
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
    // Auto-increase difficulty after 2 correct in a row
    if (state >= 2) {
      // Trigger difficulty increase
      state = 0;
    }
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
    // Auto-decrease difficulty after 2 wrong in a row
    if (state >= 2) {
      // Trigger difficulty decrease
      state = 0;
    }
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
      final user = ref.read(currentUserProvider); // ref.read — not ref.watch
      final userId = user?.uid;
      final lernplanTopics = ref.read(lernplanTopicsAsTopicDataProvider);

      if (userId == null || userId.isEmpty) {
        debugPrint('❌ LiveFeed: User not logged in');
        return;
      }

      if (lernplanTopics.isEmpty) {
        debugPrint('⚠️ LiveFeed: Lernplan is empty, cannot generate');
        return;
      }

      final String? apiKey = appSettings.getApiKey();
      if (apiKey == null || apiKey.isEmpty) {
        debugPrint('❌ LiveFeed: No API key configured for ${appSettings.getProviderName()}');
        return;
      }

      debugPrint('🔄 LiveFeed: Generating questions via ${appSettings.aiProvider}…');

      final topicsForAI = lernplanTopics
          .map((t) => TopicData(leitidee: t.leitidee, thema: t.thema, unterthema: t.unterthema))
          .toList();

      // Pass recent performance so the AI can adapt difficulty
      final questionsAnswered = ref.read(liveFeedQuestionsAnsweredProvider);
      final correctAnswers = ref.read(liveFeedCorrectAnswersProvider);
      final correctRate = questionsAnswered > 0 ? correctAnswers / questionsAnswered : 0.5;

      final session = await aiService.generateQuestions(
        apiKey: apiKey,
        userId: userId,
        learningPlanItemId: 0,
        topics: topicsForAI,
        selectedModel: appSettings.getModelForTask('questionGeneration'),
        questionCount: 10, // Smaller batch = faster background prefetch
        userContext: UserContext(
          gradeLevel: appSettings.gradeLevel.replaceAll('Klasse_', ''),
          courseType: appSettings.courseType,
        ),
        provider: appSettings.aiProvider,
        recentPerformance: questionsAnswered > 0
            ? {'averageScore': correctRate, 'totalAnswered': questionsAnswered}
            : null,
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

/// Live Feed Queue Provider
@riverpod
class LiveFeedQueue extends _$LiveFeedQueue {
  @override
  LiveFeedQueueState build() {
    return LiveFeedQueueState();
  }

  /// Add a batch of questions to the queue
  void addQuestions(List<Question> newQuestions) {
    state = state.copyWith(
      questions: [...state.questions, ...newQuestions],
    );
  }

  /// Move to the next question in the queue
  Question? nextQuestion() {
    if (!state.hasNext) return null;
    final nextIndex = state.currentIndex + 1;
    state = state.copyWith(currentIndex: nextIndex);
    return state.currentQuestion;
  }

  /// Set the current question (first question load)
  void setCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  /// Set generating state
  void setGenerating(bool generating) {
    state = state.copyWith(isGenerating: generating);
  }

  /// Clear the queue and reset
  void clear() {
    state = LiveFeedQueueState();
  }

  /// Get remaining question count
  int get remainingCount => state.remainingCount;

  /// Whether more questions should be generated (prefetch at 10 remaining)
  bool get needsMoreQuestions => state.remainingCount <= 10;
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
  }
}

