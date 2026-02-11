import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/question.dart';
import '../../../../core/services/ai_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../learning_plan/presentation/providers/lernplan_providers.dart';
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
    if (ref.read(liveFeedQuestionGeneratorProvider)) return; // Check if generator is active

    setState(() {
      _errorMessage = null;
    });

    try {
      await ref.read(liveFeedQuestionGeneratorProvider.notifier).generateQuestions();
    } catch (e) {
      setState(() {
        _errorMessage = 'Fehler beim Generieren: ${e.toString()}';
      });
    } finally {
      // The generator provider handles its own state
      // We only need to check if we can load the next question
      final currentQuestion = ref.read(currentLiveFeedQuestionProvider);
      if (currentQuestion == null && ref.read(liveFeedQueueProvider).currentQuestion != null) {
        _loadNextFromQueue();
      }
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
    final topics = ref.watch(lernplanTopicsAsTopicDataProvider);

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
            child: _buildQuestionArea(
                currentQuestion, queueState, topics),
          ),

          // Stats Bar
          _buildStatsBar(questionsAnswered, correctPercentage, currentStreak),
        ],
      ),
    );
  }

  Widget _buildQuestionArea(
    Question? currentQuestion,
    LiveFeedQueueState queueState,
    List<TopicData> topics,
  ) {
    // Show empty Lernplan state when no topics are configured
    if (topics.isEmpty) {
      return _buildNoTopicsView();
    }

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
          ],
        ),
      ),
    );
  }

  Widget _buildNoTopicsView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Kein Lernplan vorhanden',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Füge Themen zu deinem Lernplan hinzu, um Fragen zu erhalten.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.go('/lernplan'),
              icon: const Icon(Icons.add),
              label: const Text('Lernplan öffnen'),
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
