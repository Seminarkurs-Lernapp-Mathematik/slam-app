import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/design_tokens.dart';
import '../../../../core/models/question.dart';
import '../../../../core/models/user_stats.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../../features/home/presentation/providers/main_nav_notifier.dart';
import '../../../../features/home/presentation/providers/nav_keys.dart';
import '../../../learning_plan/presentation/providers/lernplan_providers.dart';
import '../providers/live_feed_providers.dart';
import '../widgets/feed_question_card.dart';

/// Live Feed Screen — adaptive question stream.
/// Header: Avatar (profile entry) + global stat pills (§7.1).
class LiveFeedScreen extends ConsumerStatefulWidget {
  const LiveFeedScreen({super.key});

  @override
  ConsumerState<LiveFeedScreen> createState() => _LiveFeedScreenState();
}

class _LiveFeedScreenState extends ConsumerState<LiveFeedScreen> {
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeQueue();
      ref.listenManual(currentUserProvider, (previous, next) {
        if (previous == null && next != null) {
          if (ref.read(liveFeedQueueProvider).questions.isEmpty &&
              !ref.read(liveFeedQuestionGeneratorProvider)) {
            _generateQuestions();
          }
        }
      });
    });
  }

  Future<void> _initializeQueue() async {
    final queueNotifier = ref.read(liveFeedQueueProvider.notifier);
    await queueNotifier.cacheInitialized;

    if (queueNotifier.hasCachedQuestions) {
      if (ref.read(currentLiveFeedQuestionProvider) == null) {
        final currentQ = ref.read(liveFeedQueueProvider).currentQuestion;
        if (currentQ != null) {
          ref.read(currentLiveFeedQuestionProvider.notifier).setQuestion(currentQ);
        }
      }
      if (queueNotifier.needsMoreQuestions) _generateQuestions();
    } else {
      await _generateQuestions();
    }
  }

  Future<void> _generateQuestions() async {
    setState(() => _errorMessage = null);
    try {
      await ref.read(liveFeedQuestionGeneratorProvider.notifier).generateQuestions();
    } catch (e) {
      if (mounted) setState(() => _errorMessage = e.toString());
    }
  }

  void _handleAnswerSubmitted() {
    final nextQ = ref.read(liveFeedQueueProvider.notifier).nextQuestion();
    if (nextQ != null) {
      ref.read(currentLiveFeedQuestionProvider.notifier).setQuestion(nextQ);
    } else {
      ref.read(currentLiveFeedQuestionProvider.notifier).clear();
    }
    ref.read(selectedOptionProvider.notifier).clear();
    ref.read(liveFeedHintsUsedProvider.notifier).reset();
    ref.read(liveFeedShowFeedbackProvider.notifier).hide();
    ref.read(lastEvaluationResultProvider.notifier).clear();
    ref.read(showWoHaengtsProvider.notifier).hide();
    ref.read(woHaengtsInputProvider.notifier).clear();

    if (ref.read(liveFeedQueueProvider.notifier).needsMoreQuestions) {
      _generateQuestions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = ref.watch(currentLiveFeedQuestionProvider);
    final queueState = ref.watch(liveFeedQueueProvider);
    final topics = ref.watch(lernplanTopicsAsTopicDataProvider);
    // Keep watching for adaptive difficulty (not displayed, but drives logic)
    ref.watch(consecutiveCorrectProvider);

    return Scaffold(
      backgroundColor: SlamTokens.bg,
      body: Column(
        children: [
          _FeedHeader(question: currentQuestion),
          Expanded(
            child: _buildQuestionArea(currentQuestion, queueState, topics),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionArea(
    Question? currentQuestion,
    LiveFeedQueueState queueState,
    List<TopicData> topics,
  ) {
    if (topics.isEmpty) return _buildNoTopicsView();
    if (_errorMessage != null && currentQuestion == null) return _buildErrorView();
    if (queueState.isGenerating && currentQuestion == null) return _buildLoadingView();
    if (currentQuestion == null) return _buildEmptyView();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        SlamTokens.gutter, 12, SlamTokens.gutter, SlamTokens.gutter,
      ),
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
          const CircularProgressIndicator(color: SlamTokens.primary),
          const SizedBox(height: 24),
          Text('Generiere Fragen…',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: SlamTokens.textDim,
                  )),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 56, color: SlamTokens.danger),
            const SizedBox(height: 16),
            Text('Fehler', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Unbekannter Fehler',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: SlamTokens.textDim),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                setState(() => _errorMessage = null);
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
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.menu_book_outlined,
                size: 56, color: SlamTokens.textMute),
            const SizedBox(height: 16),
            Text('Kein Lernplan',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Füge Themen zu deinem Lernplan hinzu.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: SlamTokens.textDim),
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
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.psychology,
              size: 56,
              color: SlamTokens.primary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 24),
            Text('Keine Fragen verfügbar',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            Text(
              'Alle Fragen wurden beantwortet.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: SlamTokens.textDim),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _generateQuestions,
              icon: const Icon(Icons.refresh),
              label: const Text('Neue Fragen generieren'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Feed Header (§7.1)
// ─────────────────────────────────────────────────────────────────────────────

class _FeedHeader extends ConsumerWidget {
  const _FeedHeader({this.question});

  final Question? question;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final userId = currentUser?.uid ?? '';
    final userStatsAsync = ref.watch(_feedUserStatsProvider(userId));
    final avatarLetter =
        (currentUser?.displayName ?? currentUser?.email ?? 'U')
            .substring(0, 1)
            .toUpperCase();

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          SlamTokens.gutter, 12, SlamTokens.gutter, 0,
        ),
        child: Row(
          children: [
            // Avatar — swoosh origin, profile entry (§6.7)
            GestureDetector(
              onTap: () =>
                  ref.read(mainNavNotifierProvider.notifier).openProfile(),
              child: Container(
                key: avatarGlobalKey,
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: SlamTokens.primarySoft,
                  shape: BoxShape.circle,
                  border: Border.all(color: SlamTokens.primary, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  avatarLetter,
                  style: GoogleFonts.fraunces(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: SlamTokens.primary,
                  ),
                ),
              ),
            ),

            // Subject tag (derived from current question's topic)
            if (question?.topic != null) ...[
              const SizedBox(width: 10),
              _SubjectTag(topic: question!.topic),
            ],

            const Spacer(),

            // Global stat pills: Streak · Coins · XP
            userStatsAsync.when(
              data: (stats) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _StatPill(
                    icon: Icons.local_fire_department,
                    value: '${stats.streak}',
                    color: SlamTokens.warn,
                  ),
                  const SizedBox(width: 6),
                  _StatPill(
                    icon: Icons.monetization_on,
                    value: _fmt(stats.coins),
                    color: SlamTokens.warn,
                  ),
                  const SizedBox(width: 6),
                  _StatPill(
                    icon: Icons.star,
                    value: _fmt(stats.totalXp),
                    color: SlamTokens.primary,
                  ),
                ],
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  static String _fmt(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(SlamTokens.rCircle),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Colored subject-tag pill based on the question's topic string.
class _SubjectTag extends StatelessWidget {
  const _SubjectTag({required this.topic});

  final String topic;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _hueFor(topic);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(SlamTokens.rCircle),
      ),
      child: Text(
        topic,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: fg,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static (Color bg, Color fg) _hueFor(String topic) {
    final t = topic.toLowerCase();
    if (t.contains('algebra')) return (SlamTokens.algebraSoft, SlamTokens.algebra);
    if (t.contains('analysis') || t.contains('differenzial') || t.contains('integral')) {
      return (SlamTokens.analysisSoft, SlamTokens.analysis);
    }
    if (t.contains('geometrie') || t.contains('trigono')) {
      return (SlamTokens.geometrieSoft, SlamTokens.geometrie);
    }
    if (t.contains('stochastik') || t.contains('statistik') || t.contains('wahrscheinlichkeit')) {
      return (SlamTokens.stochastikSoft, SlamTokens.stochastik);
    }
    return (SlamTokens.primarySoft, SlamTokens.primary);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Providers (local to this file)
// ─────────────────────────────────────────────────────────────────────────────

final _feedUserStatsProvider =
    StreamProvider.autoDispose.family<UserStats, String>((ref, userId) {
  if (userId.isEmpty) return Stream.value(UserStats.initial());
  return ref.watch(firestoreServiceProvider).userStatsStream(userId);
});
