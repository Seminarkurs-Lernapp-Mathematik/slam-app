import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/question.dart';
import '../../../../core/services/auth_service.dart';
import '../../../learning_plan/presentation/providers/lernplan_providers.dart';
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
      // Also listen for when the user logs in (handles auth timing on web)
      ref.listenManual(currentUserProvider, (previous, next) {
        if (previous == null && next != null) {
          // User just became authenticated — try generating if queue is still empty
          if (ref.read(liveFeedQueueProvider).questions.isEmpty &&
              !ref.read(liveFeedQuestionGeneratorProvider)) {
            _generateQuestions();
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _initializeQueue() async {
    final queueNotifier = ref.read(liveFeedQueueProvider.notifier);
    
    // Wait for cache to be loaded (give it a moment)
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Check if we have cached questions
    if (queueNotifier.hasCachedQuestions) {
      debugPrint('✅ LiveFeed: Using ${queueNotifier.remainingCount} cached questions');
      
      // Set the current question from cache if none is showing
      if (ref.read(currentLiveFeedQuestionProvider) == null) {
        final currentQ = ref.read(liveFeedQueueProvider).currentQuestion;
        if (currentQ != null) {
          ref.read(currentLiveFeedQuestionProvider.notifier).setQuestion(currentQ);
        }
      }
      
      // Still prefetch more if running low
      if (queueNotifier.needsMoreQuestions) {
        _generateQuestions();
      }
    } else {
      // No cached questions, generate new ones
      debugPrint('🔄 LiveFeed: No cached questions, generating new ones');
      await _generateQuestions();
    }
  }

  Future<void> _generateQuestions() async {
    // Generator handles its own re-entry guard; just delegate
    setState(() => _errorMessage = null);
    try {
      await ref.read(liveFeedQuestionGeneratorProvider.notifier).generateQuestions();
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'Fehler beim Generieren: ${e.toString()}');
      }
    }
  }

  void _handleAnswerSubmitted() {
    final nextQ = ref.read(liveFeedQueueProvider.notifier).nextQuestion();

    if (nextQ != null) {
      ref.read(currentLiveFeedQuestionProvider.notifier).setQuestion(nextQ);
    } else {
      ref.read(currentLiveFeedQuestionProvider.notifier).clear();
    }

    // Reset card state
    ref.read(selectedOptionProvider.notifier).clear();
    ref.read(liveFeedHintsUsedProvider.notifier).reset();
    ref.read(liveFeedShowFeedbackProvider.notifier).hide();
    ref.read(lastEvaluationResultProvider.notifier).clear();
    ref.read(showWoHaengtsProvider.notifier).hide();
    ref.read(woHaengtsInputProvider.notifier).clear();

    // Prefetch more if queue is running low
    if (ref.read(liveFeedQueueProvider.notifier).needsMoreQuestions) {
      _generateQuestions();
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
    // Auto-trigger generation when showing empty view
    // This ensures questions are always generated automatically
    final isGenerating = ref.read(liveFeedQuestionGeneratorProvider);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !isGenerating && _errorMessage == null) {
        _generateQuestions();
      }
    });

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.psychology,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'Fragen werden generiert...',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Die KI erstellt personalisierte Fragen für dich',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 32),
          const CircularProgressIndicator(),
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
