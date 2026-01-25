import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/question.dart';
import '../../../../core/services/ai_service.dart';
import '../../../../core/services/auth_service.dart';
import '../providers/live_feed_providers.dart';
import '../widgets/difficulty_slider.dart';
import '../widgets/feed_question_card.dart';

/// Live Feed Screen - Adaptive difficulty question stream
class LiveFeedScreen extends ConsumerStatefulWidget {
  const LiveFeedScreen({super.key});

  @override
  ConsumerState<LiveFeedScreen> createState() => _LiveFeedScreenState();
}

class _LiveFeedScreenState extends ConsumerState<LiveFeedScreen> {
  final PageController _pageController = PageController();
  bool _isGenerating = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Initialize by loading first question
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeQuestionBuffer();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _initializeQuestionBuffer() async {
    final buffer = ref.read(questionBufferProvider);

    // If buffer is empty, generate initial questions
    if (buffer.isEmpty) {
      await _generateQuestion();
      // Load first question
      _loadNextQuestion();
    }
  }

  Future<void> _generateQuestion() async {
    if (_isGenerating) return;

    setState(() {
      _isGenerating = true;
      _errorMessage = null;
    });

    try {
      final difficulty = ref.read(liveFeedDifficultyProvider);
      final aiService = ref.read(aiServiceProvider);

      // Create a simple question generation request
      // In production, you'd call a dedicated /api/generate-single-question endpoint
      // For now, we'll use the existing generateQuestions with a single question
      final session = await aiService.generateQuestions(
        apiKey: 'demo-key', // TODO: Get from user settings
        userId: ref.read(authStateChangesProvider).value?.uid ?? 'demo-user',
        learningPlanItemId: 0,
        topics: [
          const TopicData(
            leitidee: 'Algebra',
            thema: 'Gleichungen',
            unterthema: 'Lineare Gleichungen',
          ),
        ],
        selectedModel: 'claude-sonnet-4-5-20250929',
        userContext: const UserContext(
          gradeLevel: '10',
          courseType: 'Grundkurs',
        ),
      );

      if (session.questions.isNotEmpty) {
        // Add first question to buffer
        final question = session.questions.first.copyWith(
          difficulty: difficulty.round(),
        );
        ref.read(questionBufferProvider.notifier).addQuestion(question);

        // Check if buffer needs refill
        if (ref.read(questionBufferProvider.notifier).needsRefill) {
          // Generate more questions in background
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) _generateQuestion();
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Fehler beim Generieren der Frage: ${e.toString()}';
      });

      // Use demo question as fallback
      _useDemoQuestion();
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  void _useDemoQuestion() {
    final difficulty = ref.read(liveFeedDifficultyProvider);
    final demoQuestion = Question(
      id: 'demo-${DateTime.now().millisecondsSinceEpoch}',
      type: QuestionType.stepByStep,
      difficulty: difficulty.round(),
      topic: 'Algebra',
      subtopic: 'Lineare Gleichungen',
      question: r'Löse die Gleichung: $2x + 5 = 13$',
      hints: const [
        QuestionHint(level: 1, text: 'Subtrahiere 5 von beiden Seiten'),
        QuestionHint(level: 2, text: 'Teile dann beide Seiten durch 2'),
        QuestionHint(level: 3, text: 'Die Lösung ist x = 4'),
      ],
      solution: '4',
      explanation: r'$2x + 5 = 13$\n$2x = 8$\n$x = 4$',
    );

    ref.read(questionBufferProvider.notifier).addQuestion(demoQuestion);
  }

  void _loadNextQuestion() {
    final nextQuestion = ref.read(questionBufferProvider.notifier).getNext();
    if (nextQuestion != null) {
      ref.read(currentLiveFeedQuestionProvider.notifier).setQuestion(nextQuestion);

      // Reset answer and hints
      ref.read(liveFeedAnswerProvider.notifier).clear();
      ref.read(liveFeedHintsUsedProvider.notifier).reset();
      ref.read(liveFeedShowFeedbackProvider.notifier).hide();
      ref.read(lastEvaluationResultProvider.notifier).clear();

      // Refill buffer if needed
      if (ref.read(questionBufferProvider.notifier).needsRefill) {
        _generateQuestion();
      }
    } else {
      // No questions available, generate new one
      _generateQuestion();
    }
  }

  void _handleAnswerSubmitted() {
    // Answer evaluation is handled by FeedQuestionCard
    // This is called after feedback is shown and auto-advance timer completes

    // Load next question
    _loadNextQuestion();

    // Animate to next page if PageView is used for swipe
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

    // Calculate stats
    final correctPercentage = questionsAnswered > 0
        ? (correctAnswers / questionsAnswered * 100).round()
        : 0;
    final currentStreak = ref.watch(consecutiveCorrectProvider);

    return Scaffold(
      body: Column(
        children: [
          // Difficulty Slider
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: DifficultySlider(),
          ),

          // Question Area
          Expanded(
            child: _buildQuestionArea(currentQuestion),
          ),

          // Stats Bar
          _buildStatsBar(questionsAnswered, correctPercentage, currentStreak),
        ],
      ),
    );
  }

  Widget _buildQuestionArea(Question? currentQuestion) {
    if (_errorMessage != null) {
      return _buildErrorView();
    }

    if (_isGenerating && currentQuestion == null) {
      return _buildLoadingView();
    }

    if (currentQuestion == null) {
      return _buildEmptyView();
    }

    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(), // Disable manual swipe
      itemCount: 1, // One question at a time
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FeedQuestionCard(
            question: currentQuestion,
            onAnswerSubmitted: _handleAnswerSubmitted,
          ),
        );
      },
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
            'Generiere Frage...',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
            FilledButton.icon(
              onPressed: () {
                setState(() {
                  _errorMessage = null;
                });
                _generateQuestion();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Erneut versuchen'),
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
            'Klicke auf "Frage generieren" um zu beginnen',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _generateQuestion,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Frage generieren'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBar(int questionsAnswered, int correctPercentage, int streak) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
