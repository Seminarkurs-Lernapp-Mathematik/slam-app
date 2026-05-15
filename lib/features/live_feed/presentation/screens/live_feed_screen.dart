import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/design_tokens.dart';
import '../../../../core/models/question.dart';
import '../../../../core/models/user_stats.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../../features/home/presentation/providers/main_nav_notifier.dart';
import '../../../../features/home/presentation/providers/nav_keys.dart';
import '../../../learning_plan/presentation/providers/lernplan_providers.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../home/presentation/widgets/daily_insight_card.dart';
import '../providers/live_feed_providers.dart';
import '../widgets/feed_question_card.dart';

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
          ref
              .read(currentLiveFeedQuestionProvider.notifier)
              .setQuestion(currentQ);
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
      await ref
          .read(liveFeedQuestionGeneratorProvider.notifier)
          .generateQuestions();
    } catch (e) {
      if (mounted) setState(() => _errorMessage = e.toString());
    }
  }

  void _handleAnswerSubmitted() {
    // Step 1: Remove the answered question from the queue and persist the
    // change to both caches. MUST happen before nextQuestion() — otherwise
    // nextQuestion() returns questions[0] which is still the same question.
    ref.read(liveFeedQueueProvider.notifier).persistAnsweredCurrent();

    // Step 2: Advance to the next unanswered question (now at index 0).
    final nextQ = ref.read(liveFeedQueueProvider.notifier).nextQuestion();
    if (nextQ != null) {
      ref.read(currentLiveFeedQuestionProvider.notifier).setQuestion(nextQ);
      debugPrint('➡️ LiveFeed: Next question: ${nextQ.id}');
    } else {
      ref.read(currentLiveFeedQuestionProvider.notifier).clear();
      debugPrint('✅ LiveFeed: Queue exhausted');
    }

    ref.read(selectedOptionProvider.notifier).clear();
    ref.read(liveFeedHintsUsedProvider.notifier).reset();
    ref.read(liveFeedShowFeedbackProvider.notifier).hide();
    ref.read(lastEvaluationResultProvider.notifier).clear();
    ref.read(showWoHaengtsProvider.notifier).hide();
    ref.read(woHaengtsInputProvider.notifier).clear();
    ref.read(liveFeedTimerSecondsProvider.notifier).state = 0;

    // Step 3: Trigger background prefetch when queue runs low (≤ 4 remaining).
    final remaining = ref.read(liveFeedQueueProvider).remainingCount;
    debugPrint('📊 LiveFeed: $remaining questions left in queue');
    if (ref.read(liveFeedQueueProvider.notifier).needsMoreQuestions) {
      debugPrint('🔄 LiveFeed: Below prefetch threshold — fetching more');
      _generateQuestions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = ref.watch(currentLiveFeedQuestionProvider);
    final queueState = ref.watch(liveFeedQueueProvider);
    final topics = ref.watch(lernplanTopicsAsTopicDataProvider);
    ref.watch(consecutiveCorrectProvider);

    return Scaffold(
      backgroundColor: SlamTokens.bg,
      body: Column(
        children: [
          const _FeedHeader(),
          DailyInsightCard(
            onTopicTap: () {
              // Card tap starts the feed — already on this screen
            },
          ),
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
    if (_errorMessage != null && currentQuestion == null)
      return _buildErrorView();
    if (queueState.isGenerating && currentQuestion == null)
      return _buildLoadingView();
    if (currentQuestion == null) return _buildEmptyView();

    return FeedQuestionCard(
      key: ValueKey(currentQuestion.id),
      question: currentQuestion,
      onAnswerSubmitted: _handleAnswerSubmitted,
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: SlamTokens.primary),
          const SizedBox(height: 24),
          Text('Generiere Fragen…',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: SlamTokens.textDim)),
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
            Text(_errorMessage ?? 'Unbekannter Fehler',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: SlamTokens.textDim)),
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
    return SlamEmptyState(
      icon: Icons.menu_book_outlined,
      title: 'Kein Lernplan',
      subtitle:
          'Füge Themen zu deinem Lernplan hinzu, um mit dem Üben zu beginnen.',
      iconColor: SlamTokens.analysis,
      action: () => ref.read(mainNavNotifierProvider.notifier).switchToTab(1),
      actionLabel: 'Lernplan öffnen',
    );
  }

  Widget _buildEmptyView() {
    return SlamEmptyState(
      icon: Icons.check_circle_outline_rounded,
      title: 'Alle Fragen beantwortet!',
      subtitle: 'Gut gemacht! Generiere neue Fragen, um weiter zu üben.',
      iconColor: SlamTokens.success,
      action: _generateQuestions,
      actionLabel: 'Neue Fragen generieren',
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Feed Header — avatar ring + stat pills
// ─────────────────────────────────────────────────────────────────────────────

class _FeedHeader extends ConsumerWidget {
  const _FeedHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final userId = currentUser?.uid ?? '';
    final userStatsAsync = ref.watch(_feedUserStatsProvider(userId));
    final avatarLetter = (currentUser?.displayName ?? currentUser?.email ?? 'U')
        .substring(0, 1)
        .toUpperCase();

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            SlamTokens.gutter, 12, SlamTokens.gutter, 0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () =>
                  ref.read(mainNavNotifierProvider.notifier).openProfile(),
              child: userStatsAsync.when(
                data: (stats) => _AvatarRing(
                  letter: avatarLetter,
                  progress: stats.progressToNextLevel,
                  level: stats.calculatedLevel,
                ),
                loading: () =>
                    _AvatarRing(letter: avatarLetter, progress: 0, level: 1),
                error: (_, __) =>
                    _AvatarRing(letter: avatarLetter, progress: 0, level: 1),
              ),
            ),
            const Spacer(),
            userStatsAsync.when(
              data: (stats) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _StatPill(
                      icon: Icons.local_fire_department,
                      value: '${stats.streak}',
                      color: SlamTokens.danger),
                  const SizedBox(width: 6),
                  _StatPill(
                      icon: Icons.monetization_on,
                      value: _fmt(stats.coins),
                      color: SlamTokens.warn),
                  const SizedBox(width: 6),
                  _StatPill(
                      icon: Icons.star,
                      value: _fmt(stats.totalXp),
                      color: SlamTokens.primary),
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

// Avatar with XP progress ring + level badge
class _AvatarRing extends StatefulWidget {
  const _AvatarRing(
      {required this.letter, required this.progress, required this.level});

  final String letter;
  final double progress;
  final int level;

  @override
  State<_AvatarRing> createState() => _AvatarRingState();
}

class _AvatarRingState extends State<_AvatarRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    if (widget.progress > 0.8) {
      _pulseCtrl.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_AvatarRing old) {
    super.didUpdateWidget(old);
    if (widget.progress > 0.8 && old.progress <= 0.8) {
      _pulseCtrl.repeat(reverse: true);
    } else if (widget.progress <= 0.8 && old.progress > 0.8) {
      _pulseCtrl.stop();
      _pulseCtrl.value = 0;
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.progress > 0.8 ? _pulseAnim.value : 1.0,
          child: child,
        );
      },
      child: SizedBox(
        width: 56,
        height: 56,
        child: Stack(
          children: [
            CustomPaint(
              size: const Size(56, 56),
              painter: _RingPainter(progress: widget.progress),
              child: Container(
                key: avatarGlobalKey,
                width: 56,
                height: 56,
                padding: const EdgeInsets.all(4),
                child: Container(
                  decoration: BoxDecoration(
                    color: SlamTokens.primarySoft,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.letter,
                    style: GoogleFonts.fraunces(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: SlamTokens.primary,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: SlamTokens.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: SlamTokens.bg, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${widget.level}',
                  style: GoogleFonts.fraunces(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: SlamTokens.primaryOn,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 3.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth / 2;

    // background track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = SlamTokens.line
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke,
    );

    // progress arc
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        Paint()
          ..color = SlamTokens.primary
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}

class _StatPill extends StatelessWidget {
  const _StatPill(
      {required this.icon, required this.value, required this.color});
  final IconData icon;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: SlamTokens.surface,
              borderRadius: BorderRadius.circular(SlamTokens.rCircle),
              border: Border.all(color: SlamTokens.line),
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
                    color: SlamTokens.text,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Local provider
// ─────────────────────────────────────────────────────────────────────────────

final _feedUserStatsProvider =
    StreamProvider.autoDispose.family<UserStats, String>((ref, userId) {
  if (userId.isEmpty) return Stream.value(UserStats.initial());
  return ref.watch(firestoreServiceProvider).userStatsStream(userId);
});
