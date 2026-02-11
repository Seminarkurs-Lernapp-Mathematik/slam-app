import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/models/question.dart';
import '../../../../core/services/ai_service.dart';
import '../../../../core/models/topic.dart';
import '../../../../core/models/question_result.dart'; // New import
import '../../../../core/services/firestore_service.dart'; // New import
import '../../../learning_plan/presentation/providers/lernplan_providers.dart';
import '../../settings/presentation/providers/settings_providers.dart';

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
    if (state && !force) return; // Already generating, prevent re-entry

    state = true; // Set generating state to true

    try {
      final aiService = ref.read(aiServiceProvider);
      final appSettings = ref.read(appSettingsNotifierProvider);
      final userId = ref.read(currentUserProvider)?.uid;
      final lernplanTopics = ref.read(lernplanTopicsAsTopicDataProvider);

      if (userId == null) {
        debugPrint('❌ LiveFeedQuestionGenerator: User not logged in.');
        return;
      }

      if (lernplanTopics.isEmpty) {
        debugPrint('⚠️ LiveFeedQuestionGenerator: Lernplan topics are empty. Cannot generate questions.');
        // Optionally, show a message to the user via a different provider/snack bar
        return;
      }

      final currentDifficulty = ref.read(liveFeedDifficultyProvider);
      final existingQuestions = ref.read(liveFeedQueueProvider).questions;

      // Extract only topics without addedAtTimestamp or source from LernplanTopic
      final topicsForAI = lernplanTopics.map((topic) => TopicData(
        leitidee: topic.leitidee,
        thema: topic.thema,
        unterthema: topic.unterthema,
      )).toList();

      // Read education settings
      final gradeLevel = appSettings.gradeLevel.replaceAll('Klasse_', '');
      final courseType = appSettings.courseType; // e.g., 'Leistungskurs' or 'Grundkurs'

      // Get API Key
      final String? apiKey = appSettings.aiProvider == 'claude'
          ? appSettings.claudeApiKey
          : appSettings.geminiApiKey;

      if (apiKey == null || apiKey.isEmpty) {
        debugPrint('❌ LiveFeedQuestionGenerator: API key not configured. Cannot generate questions.');
        // Notify user about missing API key
        return;
      }

      // Call AI service to generate questions
      final session = await aiService.generateQuestions(
        apiKey: apiKey,
        userId: userId,
        // learningPlanItemId: 123, // Not directly used in this context
        topics: topicsForAI,
        selectedModel: appSettings.getActiveModel(), // Use active model for generation
        userContext: UserContext(
          gradeLevel: gradeLevel,
          courseType: courseType,
          difficulty: currentDifficulty.round(), // Pass current difficulty
        ),
      );

      if (session.questions.isNotEmpty) {
        ref.read(liveFeedQueueProvider.notifier).addQuestions(session.questions);
        debugPrint('✅ Generated ${session.questions.length} questions and added to queue.');
      } else {
        debugPrint('⚠️ AI Service returned no questions.');
      }
    } catch (e, st) {
      debugPrint('❌ Error generating questions: $e\n$st');
      // Handle error, e.g., show a snackbar to the user
    } finally {
      state = false; // Reset generating state
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

  /// Whether more questions should be generated
  bool get needsMoreQuestions => state.remainingCount <= 2;
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

    // Extract topic info from the current question's metadata or assume a generic one
    // For now, let's assume a generic one if not available directly in question.
    // In a real scenario, question object would contain this.
    final leitidee = currentQuestion.topics.isNotEmpty ? currentQuestion.topics.first.leitidee : 'Unknown';
    final thema = currentQuestion.topics.isNotEmpty ? currentQuestion.topics.first.thema : 'Unknown';
    final unterthema = currentQuestion.topics.isNotEmpty ? currentQuestion.topics.first.unterthema : 'Unknown';

    final gradeLevel = appSettings.gradeLevel.replaceAll('Klasse_', '');
    final courseType = appSettings.courseType;

    final questionResult = QuestionResult(
      questionId: currentQuestion.id,
      userId: userId,
      sessionId: currentQuestion.sessionId, // Assuming question has a sessionId
      questionText: currentQuestion.questionText,
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

