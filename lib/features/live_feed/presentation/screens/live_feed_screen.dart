import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/question.dart';
import '../../../../core/services/ai_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../providers/live_feed_providers.dart';
import '../widgets/feed_question_card.dart';

/// Live Feed Screen - Adaptive difficulty question stream with queue system
class LiveFeedScreen extends ConsumerStatefulWidget {
  const LiveFeedScreen({super.key});

  @override
  ConsumerState<LiveFeedScreen> createState() => _LiveFeedScreenState();
}

class _LiveFeedScreenState extends ConsumerState<LiveFeedScreen> {
  final PageController _pageController = PageController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeQueue();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _initializeQueue() async {
    final queueState = ref.read(liveFeedQueueProvider);

    // If queue is empty, generate initial batch of questions
    if (queueState.questions.isEmpty) {
      await _generateQuestions();
    }
  }

  Future<void> _generateQuestions() async {
    final queue = ref.read(liveFeedQueueProvider.notifier);

    // Prevent double generation
    if (ref.read(liveFeedQueueProvider).isGenerating) return;

    queue.setGenerating(true);
    setState(() {
      _errorMessage = null;
    });

    try {
      final difficulty = ref.read(liveFeedDifficultyProvider);
      final aiService = ref.read(aiServiceProvider);
      final aiConfig = ref.read(aIConfigNotifierProvider);

      // Get API key from Firebase settings based on selected AI provider
      final selectedProvider = aiConfig.provider;
      final apiKey = selectedProvider == AIProvider.claude
          ? (aiConfig.claudeApiKey ?? '')
          : (aiConfig.geminiApiKey ?? '');

      // Get provider string for backend
      final providerString =
          selectedProvider == AIProvider.claude ? 'claude' : 'gemini';

      // Check if API key is configured
      if (apiKey.isEmpty) {
        throw Exception(
          'Kein API-Key konfiguriert. Bitte konfiguriere einen ${selectedProvider == AIProvider.claude ? 'Claude' : 'Gemini'} API-Key in den Einstellungen (Debug Panel).',
        );
      }

      // Generate a batch of questions via backend
      final session = await aiService.generateQuestions(
        apiKey: apiKey,
        userId:
            ref.read(authStateChangesProvider).value?.uid ?? 'demo-user',
        provider: providerString,
        learningPlanItemId: 0,
        topics: [
          const TopicData(
            leitidee: 'Algebra',
            thema: 'Gleichungen',
            unterthema: 'Lineare Gleichungen',
          ),
        ],
        selectedModel: aiConfig.getModelName(),
        userContext: const UserContext(
          gradeLevel: '10',
          courseType: 'Grundkurs',
        ),
      );

      if (session.questions.isNotEmpty) {
        // Adjust difficulty on all returned questions
        final questions = session.questions.map((q) {
          return q.copyWith(difficulty: difficulty.round());
        }).toList();

        queue.addQuestions(questions);

        // If this is the first load, set up the current question
        final currentQuestion = ref.read(currentLiveFeedQuestionProvider);
        if (currentQuestion == null) {
          _loadNextFromQueue();
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Fehler beim Generieren: ${e.toString()}';
      });

      // Use demo questions as fallback
      _useDemoQuestions();
    } finally {
      queue.setGenerating(false);
    }
  }

  void _useDemoQuestions() {
    final difficulty = ref.read(liveFeedDifficultyProvider);
    final queue = ref.read(liveFeedQueueProvider.notifier);

    final demoQuestions = [
      Question(
        id: 'demo-${DateTime.now().millisecondsSinceEpoch}-1',
        type: QuestionType.multipleChoice,
        difficulty: difficulty.round(),
        topic: 'Algebra',
        subtopic: 'Lineare Gleichungen',
        question: r'Loese die Gleichung: $2x + 5 = 13$',
        options: const [
          QuestionOption(id: 'A', text: 'x = 3', isCorrect: false),
          QuestionOption(id: 'B', text: 'x = 4', isCorrect: true),
          QuestionOption(id: 'C', text: 'x = 5', isCorrect: false),
          QuestionOption(id: 'D', text: 'x = 6', isCorrect: false),
        ],
        hints: const [
          QuestionHint(
              level: 1, text: 'Subtrahiere 5 von beiden Seiten'),
          QuestionHint(
              level: 2, text: 'Teile dann beide Seiten durch 2'),
          QuestionHint(level: 3, text: 'Die Loesung ist x = 4'),
        ],
        solution: '4',
        explanation: r'$2x + 5 = 13$ -> $2x = 8$ -> $x = 4$',
        correctFeedback:
            'Sehr gut! Du hast die lineare Gleichung korrekt geloest.',
        incorrectFeedback:
            'Denke daran: Zuerst 5 von beiden Seiten abziehen, dann durch 2 teilen.',
      ),
      Question(
        id: 'demo-${DateTime.now().millisecondsSinceEpoch}-2',
        type: QuestionType.multipleChoice,
        difficulty: difficulty.round(),
        topic: 'Algebra',
        subtopic: 'Quadratische Gleichungen',
        question: r'Was ist die Loesung von $x^2 - 9 = 0$?',
        options: const [
          QuestionOption(
              id: 'A', text: 'x = 3 oder x = -3', isCorrect: true),
          QuestionOption(id: 'B', text: 'x = 9', isCorrect: false),
          QuestionOption(
              id: 'C', text: 'x = 3 oder x = 0', isCorrect: false),
          QuestionOption(id: 'D', text: 'x = -9', isCorrect: false),
        ],
        hints: const [
          QuestionHint(
              level: 1,
              text:
                  'Denke an die dritte binomische Formel: a^2 - b^2 = (a-b)(a+b)'),
          QuestionHint(
              level: 2, text: 'x^2 - 9 = (x-3)(x+3) = 0'),
          QuestionHint(level: 3, text: 'x = 3 oder x = -3'),
        ],
        solution: 'x = 3 oder x = -3',
        explanation:
            r'$x^2 - 9 = 0$ -> $(x-3)(x+3) = 0$ -> $x = 3$ oder $x = -3$',
        correctFeedback:
            'Perfekt! Du hast die dritte binomische Formel richtig angewandt.',
        incorrectFeedback:
            'Nutze die dritte binomische Formel: a^2 - b^2 = (a-b)(a+b)',
      ),
      Question(
        id: 'demo-${DateTime.now().millisecondsSinceEpoch}-3',
        type: QuestionType.multipleChoice,
        difficulty: difficulty.round(),
        topic: 'Analysis',
        subtopic: 'Ableitungen',
        question: r'Was ist die Ableitung von $f(x) = 3x^2 + 2x - 1$?',
        options: const [
          QuestionOption(
              id: 'A', text: "f'(x) = 6x + 2", isCorrect: true),
          QuestionOption(
              id: 'B', text: "f'(x) = 3x + 2", isCorrect: false),
          QuestionOption(
              id: 'C', text: "f'(x) = 6x^2 + 2", isCorrect: false),
          QuestionOption(
              id: 'D', text: "f'(x) = 6x - 1", isCorrect: false),
        ],
        hints: const [
          QuestionHint(
              level: 1,
              text:
                  "Die Potenzregel lautet: (x^n)' = n * x^(n-1)"),
          QuestionHint(
              level: 2,
              text:
                  '3x^2 wird zu 6x, 2x wird zu 2, -1 wird zu 0'),
          QuestionHint(
              level: 3, text: "f'(x) = 6x + 2"),
        ],
        solution: "f'(x) = 6x + 2",
        explanation:
            r"Potenzregel: $f'(x) = 2 \cdot 3x^{2-1} + 1 \cdot 2x^{1-1} - 0 = 6x + 2$",
        correctFeedback:
            'Super! Du beherrschst die Potenzregel.',
        incorrectFeedback:
            'Wende die Potenzregel an: Exponent nach vorne, Exponent minus 1.',
      ),
    ];

    queue.addQuestions(demoQuestions);

    // Load first question if none loaded yet
    final currentQuestion = ref.read(currentLiveFeedQuestionProvider);
    if (currentQuestion == null) {
      _loadNextFromQueue();
    }
  }

  void _loadNextFromQueue() {
    final queueState = ref.read(liveFeedQueueProvider);

    // Get current question from queue
    final question = queueState.currentQuestion;
    if (question != null) {
      ref
          .read(currentLiveFeedQuestionProvider.notifier)
          .setQuestion(question);

      // Reset card state
      ref.read(selectedOptionProvider.notifier).clear();
      ref.read(liveFeedHintsUsedProvider.notifier).reset();
      ref.read(liveFeedShowFeedbackProvider.notifier).hide();
      ref.read(lastEvaluationResultProvider.notifier).clear();
      ref.read(showWoHaengtsProvider.notifier).hide();
      ref.read(woHaengtsInputProvider.notifier).clear();
    }

    // Check if we need to prefetch more questions
    final queue = ref.read(liveFeedQueueProvider.notifier);
    if (queue.needsMoreQuestions) {
      _generateQuestions();
    }
  }

  void _handleAnswerSubmitted() {
    // Advance to next question in queue
    final nextQ = ref.read(liveFeedQueueProvider.notifier).nextQuestion();

    if (nextQ != null) {
      // Reset and load new question
      ref
          .read(currentLiveFeedQuestionProvider.notifier)
          .setQuestion(nextQ);
      ref.read(selectedOptionProvider.notifier).clear();
      ref.read(liveFeedHintsUsedProvider.notifier).reset();
      ref.read(liveFeedShowFeedbackProvider.notifier).hide();
      ref.read(lastEvaluationResultProvider.notifier).clear();
      ref.read(showWoHaengtsProvider.notifier).hide();
      ref.read(woHaengtsInputProvider.notifier).clear();

      // Check if we need more questions
      final queue = ref.read(liveFeedQueueProvider.notifier);
      if (queue.needsMoreQuestions) {
        _generateQuestions();
      }
    } else {
      // Queue empty, generate more
      ref.read(currentLiveFeedQuestionProvider.notifier).clear();
      _generateQuestions().then((_) {
        if (mounted) {
          _loadNextFromQueue();
        }
      });
    }

    // Animate page transition if PageView is used
    if (_pageController.hasClients) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = ref.watch(currentLiveFeedQuestionProvider);
    final questionsAnswered = ref.watch(liveFeedQuestionsAnsweredProvider);
    final correctAnswers = ref.watch(liveFeedCorrectAnswersProvider);
    final queueState = ref.watch(liveFeedQueueProvider);

    // Calculate stats
    final correctPercentage = questionsAnswered > 0
        ? (correctAnswers / questionsAnswered * 100).round()
        : 0;
    final currentStreak = ref.watch(consecutiveCorrectProvider);

    return Scaffold(
      body: Column(
        children: [
          // Question Area
          Expanded(
            child: _buildQuestionArea(currentQuestion, queueState),
          ),

          // Stats Bar
          _buildStatsBar(questionsAnswered, correctPercentage, currentStreak),
        ],
      ),
    );
  }

  Widget _buildQuestionArea(
      Question? currentQuestion, LiveFeedQueueState queueState) {
    if (_errorMessage != null && currentQuestion == null) {
      return _buildErrorView();
    }

    if (queueState.isGenerating && currentQuestion == null) {
      return _buildLoadingView();
    }

    if (currentQuestion == null) {
      return _buildEmptyView();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: FeedQuestionCard(
        key: ValueKey(currentQuestion.id),
        question: currentQuestion,
        onAnswerSubmitted: _handleAnswerSubmitted,
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            'Generiere Fragen...',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Die KI erstellt personalisierte Fragen',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Fehler',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Ein unbekannter Fehler ist aufgetreten',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: () {
                    setState(() {
                      _errorMessage = null;
                    });
                    _generateQuestions();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Erneut versuchen'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _errorMessage = null;
                    });
                    _useDemoQuestions();
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Demo-Fragen'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rss_feed,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Bereit zum Starten?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Klicke auf "Fragen generieren" um zu beginnen',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _generateQuestions,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Fragen generieren'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBar(
      int questionsAnswered, int correctPercentage, int streak) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            icon: Icons.quiz_outlined,
            label: 'Beantwortet',
            value: '$questionsAnswered',
            color: Theme.of(context).colorScheme.primary,
          ),
          _buildStatItem(
            icon: Icons.check_circle_outline,
            label: 'Korrekt',
            value: '$correctPercentage%',
            color: const Color(0xFF10b981),
          ),
          _buildStatItem(
            icon: Icons.local_fire_department_outlined,
            label: 'Streak',
            value: '$streak',
            color: const Color(0xFFf59e0b),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
