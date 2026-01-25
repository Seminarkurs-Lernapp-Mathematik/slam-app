import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../../../core/models/question.dart';
import '../../../../core/services/ai_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../../features/gamification/presentation/widgets/xp_animation.dart';
import '../providers/live_feed_providers.dart';
import 'feed_feedback_overlay.dart';

/// Feed Question Card - Single question display with answer input
class FeedQuestionCard extends ConsumerStatefulWidget {
  final Question question;
  final VoidCallback onAnswerSubmitted;

  const FeedQuestionCard({
    super.key,
    required this.question,
    required this.onAnswerSubmitted,
  });

  @override
  ConsumerState<FeedQuestionCard> createState() => _FeedQuestionCardState();
}

class _FeedQuestionCardState extends ConsumerState<FeedQuestionCard> {
  final TextEditingController _answerController = TextEditingController();
  Timer? _autoAdvanceTimer;
  int _hintsShown = 0;
  int _timeSpentSeconds = 0;
  Timer? _questionTimer;

  @override
  void initState() {
    super.initState();
    // Start timer when question loads
    _startQuestionTimer();
  }

  @override
  void dispose() {
    _answerController.dispose();
    _autoAdvanceTimer?.cancel();
    _questionTimer?.cancel();
    super.dispose();
  }

  void _startQuestionTimer() {
    _questionTimer?.cancel();
    _timeSpentSeconds = 0;
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _timeSpentSeconds++;
        });
      }
    });
  }

  Future<void> _submitAnswer() async {
    final answer = _answerController.text.trim();
    if (answer.isEmpty) {
      _showSnackBar('Bitte gib eine Antwort ein');
      return;
    }

    // Stop timer
    _questionTimer?.cancel();

    // Set evaluating state
    ref.read(isEvaluatingProvider.notifier).setEvaluating(true);

    try {
      final aiService = ref.read(aiServiceProvider);
      final currentStreak = ref.read(consecutiveCorrectProvider);

      // Evaluate answer via API
      final evaluation = await aiService.evaluateAnswer(
        questionId: widget.question.id,
        userAnswer: answer,
        correctAnswer: widget.question.solution,
        questionType: widget.question.type,
        difficulty: widget.question.difficulty,
        hintsUsed: _hintsShown,
        timeSpentSeconds: _timeSpentSeconds,
        correctStreak: currentStreak,
      );

      // Store evaluation result
      ref.read(lastEvaluationResultProvider.notifier).setResult({
        'isCorrect': evaluation.isCorrect,
        'feedback': evaluation.feedback,
        'xpEarned': evaluation.xpEarned,
        'xpBreakdown': evaluation.xpBreakdown,
        'misconceptions': evaluation.misconceptions,
      });

      // Update stats
      _updateStats(evaluation.isCorrect, evaluation.xpEarned);

      // Update adaptive difficulty
      _updateAdaptiveDifficulty(evaluation.isCorrect);

      // Show feedback overlay
      ref.read(liveFeedShowFeedbackProvider.notifier).show();

      // Show XP animation if correct
      if (evaluation.isCorrect && mounted) {
        XPAnimation.show(
          context,
          xpAmount: evaluation.xpEarned,
        );
      }

      // Save progress to Firestore
      _saveProgress(evaluation.isCorrect, evaluation.xpEarned);

      // Auto-advance after 3 seconds
      _autoAdvanceTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          ref.read(liveFeedShowFeedbackProvider.notifier).hide();
          widget.onAnswerSubmitted();
        }
      });
    } catch (e) {
      _showSnackBar('Fehler beim Evaluieren: ${e.toString()}');
    } finally {
      ref.read(isEvaluatingProvider.notifier).setEvaluating(false);
    }
  }

  void _updateStats(bool isCorrect, int xpEarned) {
    // Update questions answered
    ref.read(liveFeedQuestionsAnsweredProvider.notifier).increment();

    if (isCorrect) {
      // Update correct answers
      ref.read(liveFeedCorrectAnswersProvider.notifier).increment();

      // Update consecutive correct
      ref.read(consecutiveCorrectProvider.notifier).increment();
      ref.read(consecutiveWrongProvider.notifier).reset();
    } else {
      // Update consecutive wrong
      ref.read(consecutiveWrongProvider.notifier).increment();
      ref.read(consecutiveCorrectProvider.notifier).reset();
    }

    // Update user stats (XP) in Firestore
    _updateUserXP(xpEarned);
  }

  Future<void> _updateUserXP(int xpEarned) async {
    final userId = ref.read(authStateChangesProvider).value?.uid;
    if (userId == null) return;

    try {
      final firestoreService = ref.read(firestoreServiceProvider);
      final currentStats = await firestoreService.getUserStats(userId);

      if (currentStats != null) {
        final updatedStats = currentStats.addXp(xpEarned);
        await firestoreService.updateUserStats(userId, updatedStats);
      }
    } catch (e) {
      debugPrint('Error updating user XP: $e');
    }
  }

  void _updateAdaptiveDifficulty(bool isCorrect) {
    final consecutiveCorrect = ref.read(consecutiveCorrectProvider);
    final consecutiveWrong = ref.read(consecutiveWrongProvider);

    if (isCorrect && consecutiveCorrect >= 2) {
      // Increase difficulty
      ref.read(liveFeedDifficultyProvider.notifier).increase();
      _showSnackBar('Schwierigkeitsgrad erhöht!', icon: Icons.trending_up);
    } else if (!isCorrect && consecutiveWrong >= 2) {
      // Decrease difficulty
      ref.read(liveFeedDifficultyProvider.notifier).decrease();
      _showSnackBar('Schwierigkeitsgrad angepasst', icon: Icons.trending_down);
    }
  }

  Future<void> _saveProgress(bool isCorrect, int xpEarned) async {
    final userId = ref.read(authStateChangesProvider).value?.uid;
    if (userId == null) return;

    try {
      final firestoreService = ref.read(firestoreServiceProvider);
      final progress = QuestionProgress(
        questionId: widget.question.id,
        sessionId: 'live-feed-${DateTime.now().toIso8601String().substring(0, 10)}',
        startedAt: DateTime.now().subtract(Duration(seconds: _timeSpentSeconds)),
        completedAt: DateTime.now(),
        status: QuestionStatus.completed,
        hintsUsed: _hintsShown,
        hintsUsedDetails: [],
        isCorrect: isCorrect,
        userAnswer: _answerController.text.trim(),
        timeSpent: _timeSpentSeconds,
        xpEarned: xpEarned,
        topic: widget.question.topic,
        difficulty: widget.question.difficulty,
      );

      await firestoreService.saveQuestionProgress(
        userId: userId,
        progress: progress,
      );
    } catch (e) {
      debugPrint('Error saving question progress: $e');
    }
  }

  void _showHints() {
    if (widget.question.hints.isEmpty) {
      _showSnackBar('Keine Hinweise verfügbar');
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _HintsBottomSheet(
        hints: widget.question.hints,
        onHintShown: (level) {
          setState(() {
            _hintsShown = level;
          });
          ref.read(liveFeedHintsUsedProvider.notifier).increment();
        },
      ),
    );
  }

  void _showSnackBar(String message, {IconData? icon}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
            ],
            Expanded(child: Text(message)),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isEvaluating = ref.watch(isEvaluatingProvider);
    final showFeedback = ref.watch(liveFeedShowFeedbackProvider);
    final evaluationResult = ref.watch(lastEvaluationResultProvider);

    return Stack(
      children: [
        // Main Question Card
        Card(
          elevation: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Timer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      avatar: const Icon(Icons.timer_outlined, size: 18),
                      label: Text(_formatTime(_timeSpentSeconds)),
                    ),
                    Chip(
                      avatar: const Icon(Icons.speed, size: 18),
                      label: Text('Level ${widget.question.difficulty}'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Question Text with LaTeX
                _buildQuestionText(),
                const SizedBox(height: 24),

                // Answer Input
                TextField(
                  controller: _answerController,
                  decoration: InputDecoration(
                    labelText: 'Deine Antwort',
                    hintText: 'Gib deine Antwort ein...',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.edit_outlined),
                    enabled: !isEvaluating && !showFeedback,
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submitAnswer(),
                ),
                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed:
                            isEvaluating || showFeedback ? null : _showHints,
                        icon: const Icon(Icons.lightbulb_outline),
                        label: Text('Hinweis ${_hintsShown > 0 ? '($_hintsShown)' : ''}'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: FilledButton.icon(
                        onPressed: isEvaluating || showFeedback
                            ? null
                            : _submitAnswer,
                        icon: isEvaluating
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.check),
                        label: Text(isEvaluating ? 'Prüfe...' : 'Absenden'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Feedback Overlay
        if (showFeedback && evaluationResult != null)
          FeedFeedbackOverlay(
            isCorrect: evaluationResult['isCorrect'] as bool,
            feedback: evaluationResult['feedback'] as String,
            xpEarned: evaluationResult['xpEarned'] as int,
            correctAnswer: widget.question.solution,
            explanation: widget.question.explanation,
          ),
      ],
    );
  }

  Widget _buildQuestionText() {
    try {
      // Parse LaTeX in question text
      return Math.tex(
        widget.question.question,
        textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
        mathStyle: MathStyle.display,
      );
    } catch (e) {
      // Fallback to plain text if LaTeX parsing fails
      return Text(
        widget.question.question,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
      );
    }
  }
}

/// Hints Bottom Sheet
class _HintsBottomSheet extends StatefulWidget {
  final List<QuestionHint> hints;
  final Function(int level) onHintShown;

  const _HintsBottomSheet({
    required this.hints,
    required this.onHintShown,
  });

  @override
  State<_HintsBottomSheet> createState() => _HintsBottomSheetState();
}

class _HintsBottomSheetState extends State<_HintsBottomSheet> {
  int _currentHintLevel = 0;

  void _showNextHint() {
    if (_currentHintLevel < widget.hints.length) {
      setState(() {
        _currentHintLevel++;
      });
      widget.onHintShown(_currentHintLevel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hinweise',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Hints List
          if (_currentHintLevel > 0)
            ...List.generate(_currentHintLevel, (index) {
              final hint = widget.hints[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb,
                              color:
                                  Theme.of(context).colorScheme.onPrimaryContainer,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Hinweis ${hint.level}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          hint.text,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Hinweise kosten XP',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Jeder Hinweis reduziert deine XP-Belohnung um 5 Punkte.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Show Next Hint Button
          if (_currentHintLevel < widget.hints.length)
            FilledButton.icon(
              onPressed: _showNextHint,
              icon: const Icon(Icons.lightbulb_outline),
              label: Text(
                _currentHintLevel == 0
                    ? 'Ersten Hinweis anzeigen'
                    : 'Nächsten Hinweis anzeigen ($_currentHintLevel/${widget.hints.length})',
              ),
            )
          else
            const Text(
              'Alle Hinweise angezeigt',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }
}
