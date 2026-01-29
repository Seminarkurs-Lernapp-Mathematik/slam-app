import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/question_card.dart';
import '../widgets/hint_panel.dart';
import '../providers/question_session_providers.dart';
import '../../../../shared/widgets/glass_panel.dart';

/// Question Session Screen - Main Learning Flow
class QuestionSessionScreen extends ConsumerStatefulWidget {
  final String sessionId;

  const QuestionSessionScreen({
    super.key,
    required this.sessionId,
  });

  @override
  ConsumerState<QuestionSessionScreen> createState() => _QuestionSessionScreenState();
}

class _QuestionSessionScreenState extends ConsumerState<QuestionSessionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentQuestionIndexProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentQuestionIndexProvider);
    final demoQuestions = ref.watch(demoQuestionsProvider);
    final hintsUsed = ref.watch(hintsUsedProvider);
    final showFeedback = ref.watch(showFeedbackProvider);

    if (currentIndex >= demoQuestions.length) {
      return _SessionCompleteScreen(
        sessionId: widget.sessionId,
        totalQuestions: demoQuestions.length,
      );
    }

    final currentQuestion = demoQuestions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _showExitConfirmation(context),
        ),
        title: Text('Frage ${currentIndex + 1} / ${demoQuestions.length}'),
        actions: [
          IconButton(
            icon: Icon(
              hintsUsed < 3
                  ? Icons.lightbulb_outline
                  : Icons.lightbulb,
            ),
            onPressed: () => _showHintPanel(context),
            tooltip: 'Hinweis',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.go('/settings'),
            tooltip: 'Einstellungen',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (currentIndex + 1) / demoQuestions.length,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 24),

            QuestionCard(
              question: currentQuestion,
              questionIndex: currentIndex,
            ),

            const SizedBox(height: 24),

            if (showFeedback)
              const FeedbackPanel(),

            const SizedBox(height: 24),

            if (!showFeedback)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton.icon(
                    onPressed: () => _submitAnswer(context),
                    icon: const Icon(Icons.check),
                    label: const Text('Antwort prüfen'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: currentIndex > 0
                              ? _previousQuestion
                              : null,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Zurück'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _skipQuestion,
                          icon: const Icon(Icons.skip_next),
                          label: const Text('Überspringen'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pauseSession(context),
                          icon: const Icon(Icons.pause),
                          label: const Text('Pause'),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            else
              FilledButton.icon(
                onPressed: _nextQuestion,
                icon: const Icon(Icons.arrow_forward),
                label: Text(
                  currentIndex < demoQuestions.length - 1
                      ? 'Nächste Frage'
                      : 'Session beenden',
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showHintPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const HintPanel(),
    );
  }

  void _submitAnswer(BuildContext context) {
    final answer = ref.read(currentAnswerProvider);

    if (answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte gib eine Antwort ein')),
      );
      return;
    }

    ref.read(showFeedbackProvider.notifier).show();

    final hintsUsed = ref.read(hintsUsedProvider);
    final baseXP = 25;
    final hintPenalty = hintsUsed * 5;
    final xpEarned = (baseXP - hintPenalty).clamp(5, baseXP);

    ref.read(lastXPEarnedProvider.notifier).setXP(xpEarned);

    _showXPAnimation(context, xpEarned);
  }

  void _showXPAnimation(BuildContext context, int xp) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: GlassPanel(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star,
                  size: 64,
                  color: Colors.amber,
                ),
                const SizedBox(height: 16),
                Text(
                  '+$xp XP',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  void _nextQuestion() {
    ref.read(currentQuestionIndexProvider.notifier).increment();
    ref.read(showFeedbackProvider.notifier).hide();
    ref.read(currentAnswerProvider.notifier).clear();
    ref.read(hintsUsedProvider.notifier).reset();
  }

  void _previousQuestion() {
    ref.read(currentQuestionIndexProvider.notifier).decrement();
    ref.read(showFeedbackProvider.notifier).hide();
    ref.read(currentAnswerProvider.notifier).clear();
    ref.read(hintsUsedProvider.notifier).reset();
  }

  void _skipQuestion() {
    final currentIndex = ref.read(currentQuestionIndexProvider);
    ref.read(skippedQuestionsProvider.notifier).addSkipped(currentIndex);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Frage ${currentIndex + 1} übersprungen'),
        duration: const Duration(seconds: 2),
      ),
    );

    _nextQuestion();
  }

  void _pauseSession(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Session pausieren?'),
        content: const Text(
          'Dein Fortschritt wird gespeichert. Du kannst später weitermachen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/home');
            },
            child: const Text('Pausieren'),
          ),
        ],
      ),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Session beenden?'),
        content: const Text(
          'Möchtest du die Session wirklich beenden? Dein Fortschritt wird gespeichert.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/home');
            },
            child: const Text('Beenden'),
          ),
        ],
      ),
    );
  }
}

class _SessionCompleteScreen extends StatelessWidget {
  final String sessionId;
  final int totalQuestions;

  const _SessionCompleteScreen({
    required this.sessionId,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.emoji_events,
                size: 96,
                color: Colors.amber,
              ),
              const SizedBox(height: 24),
              Text(
                'Session Abgeschlossen!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Du hast $totalQuestions Fragen bearbeitet',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              FilledButton.icon(
                onPressed: () => context.go('/home'),
                icon: const Icon(Icons.home),
                label: const Text('Zurück zur Startseite'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeedbackPanel extends ConsumerWidget {
  const FeedbackPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentQuestionIndexProvider);
    final demoQuestions = ref.watch(demoQuestionsProvider);
    final currentQuestion = demoQuestions[currentIndex];
    final userAnswer = ref.watch(currentAnswerProvider);
    final xpEarned = ref.watch(lastXPEarnedProvider);

    final expectedAnswer = currentQuestion['expectedAnswer'] as String?;
    final isCorrect = userAnswer.toLowerCase().trim() ==
                      expectedAnswer?.toLowerCase().trim();

    return GlassPanel(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isCorrect
                      ? Icons.check_circle
                      : Icons.cancel,
                  color: isCorrect ? Colors.green : Colors.red,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  isCorrect ? 'Richtig!' : 'Nicht ganz',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: isCorrect ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              (currentQuestion['feedback'] as String?) ??
                  (isCorrect
                      ? 'Super! Du hast die Frage richtig beantwortet.'
                      : 'Die richtige Antwort ist: $expectedAnswer'),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (xpEarned > 0) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '+$xpEarned XP',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
