import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/design_tokens.dart';
import '../../../../core/constants/level_thresholds.dart';

import '../../../../core/models/question.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../../features/gamification/presentation/widgets/xp_animation.dart';
import '../providers/live_feed_providers.dart';
import 'wo_haengts_chat_sheet.dart';
import '../../../../shared/widgets/math_text.dart';

/// Feed Question Card - Single question display with MCQ options and inline feedback
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

class _FeedQuestionCardState extends ConsumerState<FeedQuestionCard>
    with SingleTickerProviderStateMixin {
  Timer? _autoAdvanceTimer;
  int _hintsShown = 0;
  int _timeSpentSeconds = 0;
  Timer? _questionTimer;
  String? _selectedOptionId;
  bool _answered = false;
  bool _isCorrect = false;
  bool _showWoHaengtsInput = false;

  // Step-by-step state
  List<String> _stepOrder = [];
  final int _currentStepIndex = 0;

  @override
  void initState() {
    super.initState();
    _startQuestionTimer();
    // Initialize step order for step-by-step questions
    if (widget.question.type == QuestionType.stepByStep &&
        widget.question.stepByStepData != null) {
      _stepOrder = List.from(
        widget.question.stepByStepData!.steps.map((s) => s.id),
      );
      _stepOrder.shuffle();
    }
  }

  @override
  void dispose() {
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

  void _selectOption(String optionId) {
    if (_answered) return;

    setState(() {
      _selectedOptionId = optionId;
    });

    // Find selected option
    final selectedOption = widget.question.options?.firstWhere(
      (o) => o.id == optionId,
    );

    if (selectedOption == null) return;

    // Stop timer
    _questionTimer?.cancel();

    final isCorrect = selectedOption.isCorrect;

    setState(() {
      _answered = true;
      _isCorrect = isCorrect;
    });

    // Update providers
    ref.read(selectedOptionProvider.notifier).select(optionId);

    // Process the answer
    _processAnswer(isCorrect, optionId);
  }

  Future<void> _processAnswer(bool isCorrect, String userAnswer) async {
    final difficulty = widget.question.difficulty;
    final xpEarned = isCorrect
        ? XPSystem.calculateXP(
            difficulty: difficulty,
            hintsUsed: _hintsShown,
            timeSpentSeconds: _timeSpentSeconds,
            correctStreak: ref.read(consecutiveCorrectProvider),
          )
        : 0;
    final coinsEarned = isCorrect
        ? CoinSystem.calculateCoins(
            difficulty: difficulty,
            isFirstQuestionToday: false,
            currentStreak: 0,
            isPerfectAnswer: _hintsShown == 0,
          )
        : 0;

    final feedback = isCorrect
        ? (widget.question.correctFeedback ?? 'Richtig! Gut gemacht.')
        : (widget.question.incorrectFeedback ?? 'Nicht ganz richtig.');

    // Store result for feedback display
    ref.read(lastEvaluationResultProvider.notifier).setResult({
      'isCorrect': isCorrect,
      'feedback': feedback,
      'xpEarned': xpEarned,
      'coinsEarned': coinsEarned,
    });

    // Update in-session stats and Firestore
    _updateStats(isCorrect, xpEarned, coinsEarned);
    _updateAdaptiveDifficulty(isCorrect);

    // Show XP animation if correct
    if (isCorrect && mounted) {
      XPAnimation.show(context, xpAmount: xpEarned);
    }

    // Save progress to Firestore
    _saveProgress(isCorrect, xpEarned, coinsEarned, userAnswer: userAnswer);

    // If wrong, show "Wo hängts?" after a delay
    if (!isCorrect) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() => _showWoHaengtsInput = true);
          ref.read(showWoHaengtsProvider.notifier).show();
        }
      });
    }

    // Auto-advance only for correct answers — wrong answers stay until the user
    // manually taps "Nächste Frage" so they can use "Wo hängts?"
    if (isCorrect) {
      _autoAdvanceTimer = Timer(
        const Duration(seconds: 3),
        () {
          if (mounted) widget.onAnswerSubmitted();
        },
      );
    }
  }

  void _revealHint() {
    final maxHints = widget.question.hints.length;
    if (_hintsShown >= maxHints || _answered) return;

    setState(() {
      _hintsShown++;
    });
    ref.read(liveFeedHintsUsedProvider.notifier).increment();

    // After all 3 hints used, show "Wo haengts?" input
    if (_hintsShown >= maxHints && !_answered) {
      setState(() {
        _showWoHaengtsInput = true;
      });
      ref.read(showWoHaengtsProvider.notifier).show();
    }
  }

  void _openWoHaengtsChat() {
    _autoAdvanceTimer?.cancel();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WoHaengtsChatSheet(
        questionText: widget.question.question,
      ),
    );
  }

  void _skipToNext() {
    _autoAdvanceTimer?.cancel();
    _questionTimer?.cancel();
    widget.onAnswerSubmitted();
  }

  void _updateStats(bool isCorrect, int xpEarned, int coinsEarned) {
    ref.read(liveFeedQuestionsAnsweredProvider.notifier).increment();

    if (isCorrect) {
      ref.read(liveFeedCorrectAnswersProvider.notifier).increment();
      ref.read(consecutiveCorrectProvider.notifier).increment();
      ref.read(consecutiveWrongProvider.notifier).reset();
    } else {
      ref.read(consecutiveWrongProvider.notifier).increment();
      ref.read(consecutiveCorrectProvider.notifier).reset();
    }

    _updateUserStats(xpEarned, coinsEarned);
  }

  Future<void> _updateUserStats(int xpEarned, int coinsEarned) async {
    final userId = ref.read(authServiceProvider).currentUser?.uid;
    if (userId == null) return;

    try {
      await ref.read(firestoreServiceProvider).addXpAndCoins(userId, xpEarned, coinsEarned);
    } catch (e) {
      debugPrint('Error updating user stats: $e');
    }
  }

  void _updateAdaptiveDifficulty(bool isCorrect) {
    final consecutiveCorrect = ref.read(consecutiveCorrectProvider);
    final consecutiveWrong = ref.read(consecutiveWrongProvider);

    if (isCorrect && consecutiveCorrect >= 2) {
      ref.read(liveFeedDifficultyProvider.notifier).increase();
      ref.read(consecutiveCorrectProvider.notifier).reset();
      _showSnackBar('Schwierigkeitsgrad erhöht!', icon: Icons.trending_up);
    } else if (!isCorrect && consecutiveWrong >= 2) {
      ref.read(liveFeedDifficultyProvider.notifier).decrease();
      ref.read(consecutiveWrongProvider.notifier).reset();
      _showSnackBar('Schwierigkeitsgrad angepasst', icon: Icons.trending_down);
    }
  }

  Future<void> _saveProgress(
    bool isCorrect,
    int xpEarned,
    int coinsEarned, {
    String? userAnswer,
  }) async {
    final userId = ref.read(authServiceProvider).currentUser?.uid;
    if (userId == null) return;

    try {
      final firestoreService = ref.read(firestoreServiceProvider);
      final progress = QuestionProgress(
        questionId: widget.question.id,
        sessionId:
            'live-feed-${DateTime.now().toIso8601String().substring(0, 10)}',
        startedAt:
            DateTime.now().subtract(Duration(seconds: _timeSpentSeconds)),
        completedAt: DateTime.now(),
        status: QuestionStatus.completed,
        hintsUsed: _hintsShown,
        hintsUsedDetails: [],
        isCorrect: isCorrect,
        userAnswer: userAnswer ?? _selectedOptionId,
        timeSpent: _timeSpentSeconds,
        xpEarned: xpEarned,
        topic: widget.question.topic,
        difficulty: widget.question.difficulty,
      );

      await firestoreService.saveQuestionProgress(
        userId: userId,
        progress: progress,
      );

      debugPrint('Coins earned: $coinsEarned');
    } catch (e) {
      debugPrint('Error saving question progress: $e');
    }
  }

  void _showSnackBar(String message, {IconData? icon}) {
    if (!mounted) return;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: SlamTokens.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SlamTokens.rCardLg),
        side: const BorderSide(color: SlamTokens.line),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: Timer + Difficulty
            _buildHeader(theme, colorScheme),
            const SizedBox(height: 16),

            // Question Text with LaTeX
            _buildQuestionText(theme),
            const SizedBox(height: 20),

            // Answer Area (MCQ or Step-by-Step)
            if (widget.question.type == QuestionType.multipleChoice)
              _buildMultipleChoiceOptions(theme, colorScheme),

            if (widget.question.type == QuestionType.stepByStep)
              _buildStepByStepArea(theme, colorScheme),

            // Pre-generated Feedback (shown after answering)
            if (_answered) ...[
              const SizedBox(height: 16),
              _buildInlineFeedback(theme, colorScheme),
            ],

            // Hint Button (shown before answering)
            if (!_answered && widget.question.hints.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildHintSection(theme, colorScheme),
            ],

            // Revealed hints inline
            if (_hintsShown > 0) ...[
              const SizedBox(height: 12),
              _buildRevealedHints(theme, colorScheme),
            ],

            // "Wo haengts?" input section
            if (_showWoHaengtsInput) ...[
              const SizedBox(height: 16),
              _buildWoHaengtsSection(theme, colorScheme),
            ],

            // Skip / Next button
            if (_answered) ...[
              const SizedBox(height: 16),
              _buildNextButton(theme, colorScheme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    final queueState = ref.watch(liveFeedQueueProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _QuietTimerChip(seconds: _timeSpentSeconds),
        if (queueState.remainingCount > 0)
          Chip(
            avatar: Icon(Icons.queue, size: 16, color: colorScheme.primary),
            label: Text(
              '${queueState.remainingCount} uebrig',
              style: theme.textTheme.labelSmall,
            ),
            visualDensity: VisualDensity.compact,
          ),
        Chip(
          avatar: const Icon(Icons.school, size: 16),
          label: Text(_difficultyToAfb(widget.question.difficulty)),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }

  Widget _buildQuestionText(ThemeData theme) {
    final questionText = widget.question.question;

    // Split by $ to handle mixed text and LaTeX
    final parts = questionText.split(r'$');
    if (parts.length <= 1) {
      // No LaTeX delimiters — render as plain text (Math.tex strips whitespace)
      return Text(
        questionText,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
      );
    }

    // Mixed text and LaTeX
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: List.generate(parts.length, (index) {
        final part = parts[index];
        if (part.isEmpty) return const SizedBox.shrink();

        if (index % 2 == 1) {
          // LaTeX part (between $ delimiters)
          try {
            return Math.tex(
              part,
              textStyle: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              mathStyle: MathStyle.text,
            );
          } catch (e) {
            return Text(
              part,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            );
          }
        } else {
          // Plain text part
          return Text(
            part,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          );
        }
      }),
    );
  }

  /// Renders a string that may contain inline LaTeX ($...$) mixed with plain text.
  Widget _buildMixedText(String text, TextStyle style) {
    final parts = text.split(r'$');
    if (parts.length <= 1) {
      return Text(text, style: style);
    }
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: List.generate(parts.length, (index) {
        final part = parts[index];
        if (part.isEmpty) return const SizedBox.shrink();
        if (index % 2 == 1) {
          try {
            return Math.tex(part, textStyle: style, mathStyle: MathStyle.text);
          } catch (_) {
            return Text(part, style: style);
          }
        }
        return Text(part, style: style);
      }),
    );
  }

  // ============================================================================
  // MULTIPLE CHOICE OPTIONS
  // ============================================================================

  Widget _buildMultipleChoiceOptions(ThemeData theme, ColorScheme colorScheme) {
    final options = widget.question.options;
    if (options == null || options.isEmpty) {
      return Text(
        'Keine Antwortoptionen verfügbar',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      );
    }

    return Column(
      children: options.map((option) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _buildOptionButton(option, theme, colorScheme),
        );
      }).toList(),
    );
  }

  Widget _buildOptionButton(
    QuestionOption option,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final isSelected = _selectedOptionId == option.id;
    final isAnswered = _answered;

    // Determine colors based on state
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    IconData? trailingIcon;

    if (!isAnswered) {
      backgroundColor = SlamTokens.surfaceHi;
      borderColor = SlamTokens.line;
      textColor = SlamTokens.text;
    } else if (option.isCorrect) {
      backgroundColor = SlamTokens.successSoft;
      borderColor = SlamTokens.success;
      textColor = SlamTokens.success;
      trailingIcon = Icons.check_circle;
    } else if (isSelected && !option.isCorrect) {
      backgroundColor = SlamTokens.dangerSoft;
      borderColor = SlamTokens.danger;
      textColor = SlamTokens.danger;
      trailingIcon = Icons.cancel;
    } else {
      backgroundColor = SlamTokens.surfaceHi.withValues(alpha: 0.4);
      borderColor = SlamTokens.line.withValues(alpha: 0.4);
      textColor = SlamTokens.textMute;
    }

    final badgeColor = isSelected && !isAnswered
        ? SlamTokens.primary
        : isAnswered && option.isCorrect
            ? SlamTokens.success
            : isAnswered && isSelected && !option.isCorrect
                ? SlamTokens.danger
                : SlamTokens.surfaceHi;
    final badgeText = isSelected && !isAnswered
        ? SlamTokens.primaryOn
        : isAnswered && (option.isCorrect || (isSelected && !option.isCorrect))
            ? Colors.white
            : SlamTokens.textDim;

    return AnimatedContainer(
      duration: SlamTokens.dState,
      curve: SlamTokens.curveStandard,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isAnswered ? null : () => _selectOption(option.id),
          borderRadius: BorderRadius.circular(SlamTokens.rOption),
          child: AnimatedContainer(
            duration: SlamTokens.dState,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(SlamTokens.rOption),
              border: Border.all(
                color: borderColor,
                width: isSelected || (isAnswered && option.isCorrect) ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: badgeColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    option.id,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: badgeText,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: _buildOptionText(option.text, theme, textColor)),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 8),
                  Icon(
                    trailingIcon,
                    color: option.isCorrect ? SlamTokens.success : SlamTokens.danger,
                    size: 20,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionText(String text, ThemeData theme, Color textColor) {
    // Check if option text contains LaTeX
    if (text.contains(r'$')) {
      final parts = text.split(r'$');
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: List.generate(parts.length, (index) {
          final part = parts[index];
          if (part.isEmpty) return const SizedBox.shrink();
          if (index % 2 == 1) {
            try {
              return Math.tex(
                part,
                textStyle: TextStyle(color: textColor, fontSize: 16),
              );
            } catch (e) {
              return Text(part, style: TextStyle(color: textColor));
            }
          }
          return Text(
            part,
            style: theme.textTheme.bodyLarge?.copyWith(color: textColor),
          );
        }),
      );
    }

    return Text(
      text,
      style: theme.textTheme.bodyLarge?.copyWith(color: textColor),
    );
  }

  // ============================================================================
  // STEP-BY-STEP QUESTIONS
  // ============================================================================

  Widget _buildStepByStepArea(ThemeData theme, ColorScheme colorScheme) {
    final stepData = widget.question.stepByStepData;
    if (stepData == null) {
      // Fallback: Show as plain options if stepByStepData is missing
      return _buildMultipleChoiceOptions(theme, colorScheme);
    }

    if (stepData.type == 'sort-steps') {
      return _buildSortableSteps(stepData, theme, colorScheme);
    }

    // 'next-action' type: Show options for what comes next
    return _buildNextActionSteps(stepData, theme, colorScheme);
  }

  Widget _buildSortableSteps(
    StepByStepData stepData,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Bringe die Schritte in die richtige Reihenfolge:',
          style: theme.textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: _answered
              ? (_, __) {}
              : (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final item = _stepOrder.removeAt(oldIndex);
                    _stepOrder.insert(newIndex, item);
                  });
                },
          children: _stepOrder.asMap().entries.map((entry) {
            final index = entry.key;
            final stepId = entry.value;
            final step =
                stepData.steps.firstWhere((s) => s.id == stepId);
            final isCorrectPosition = _answered &&
                stepData.correctOrder.length > index &&
                stepData.correctOrder[index] == stepId;
            final isWrongPosition = _answered && !isCorrectPosition;

            return Container(
              key: ValueKey(stepId),
              margin: const EdgeInsets.only(bottom: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _answered
                    ? isCorrectPosition
                        ? const Color(0xFF10b981).withValues(alpha: 0.15)
                        : const Color(0xFFef4444).withValues(alpha: 0.15)
                    : colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _answered
                      ? isCorrectPosition
                          ? const Color(0xFF10b981)
                          : const Color(0xFFef4444)
                      : colorScheme.outlineVariant,
                ),
              ),
              child: Row(
                children: [
                  if (!_answered)
                    Icon(Icons.drag_handle,
                        color: colorScheme.onSurfaceVariant),
                  if (_answered)
                    Icon(
                      isCorrectPosition ? Icons.check_circle : Icons.cancel,
                      color: isCorrectPosition
                          ? const Color(0xFF10b981)
                          : const Color(0xFFef4444),
                      size: 20,
                    ),
                  const SizedBox(width: 12),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MathText(
                      step.text,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isWrongPosition
                            ? const Color(0xFF991b1b)
                            : colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        if (!_answered) ...[
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {
              setState(() {
                _answered = true;
                _isCorrect = _checkStepOrder(stepData);
              });
              _questionTimer?.cancel();
              _processAnswer(_isCorrect, _stepOrder.join(','));
            },
            icon: const Icon(Icons.check),
            label: const Text('Reihenfolge prüfen'),
          ),
        ],
      ],
    );
  }

  bool _checkStepOrder(StepByStepData stepData) {
    if (_stepOrder.length != stepData.correctOrder.length) return false;
    for (int i = 0; i < _stepOrder.length; i++) {
      if (_stepOrder[i] != stepData.correctOrder[i]) return false;
    }
    return true;
  }

  Widget _buildNextActionSteps(
    StepByStepData stepData,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    // Show steps as sequential MCQ options
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Was ist der nächste Schritt?',
          style: theme.textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        ...stepData.steps.map((step) {
          final isSelected = _selectedOptionId == step.id;
          final isCorrectStep = stepData.correctOrder.isNotEmpty &&
              stepData.correctOrder[_currentStepIndex] == step.id;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildStepOptionButton(
              step,
              isSelected,
              isCorrectStep,
              theme,
              colorScheme,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStepOptionButton(
    StepOption step,
    bool isSelected,
    bool isCorrectStep,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    Color backgroundColor;
    Color borderColor;

    if (!_answered) {
      backgroundColor = colorScheme.surfaceContainerLow;
      borderColor = colorScheme.outlineVariant;
    } else if (isCorrectStep) {
      backgroundColor = const Color(0xFF10b981).withValues(alpha: 0.15);
      borderColor = const Color(0xFF10b981);
    } else if (isSelected && !isCorrectStep) {
      backgroundColor = const Color(0xFFef4444).withValues(alpha: 0.15);
      borderColor = const Color(0xFFef4444);
    } else {
      backgroundColor = colorScheme.surfaceContainerLow.withValues(alpha: 0.5);
      borderColor = colorScheme.outlineVariant.withValues(alpha: 0.3);
    }

    return InkWell(
      onTap: _answered
          ? null
          : () {
              setState(() {
                _selectedOptionId = step.id;
                _answered = true;
                _isCorrect = isCorrectStep;
              });
              _questionTimer?.cancel();
              _processAnswer(_isCorrect, step.id);
            },
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
        ),
        child: MathText(
          step.text,
          style: theme.textTheme.bodyLarge,
        ),
      ),
    );
  }

  // ============================================================================
  // INLINE FEEDBACK
  // ============================================================================

  Widget _buildInlineFeedback(ThemeData theme, ColorScheme colorScheme) {
    final feedbackColor = _isCorrect
        ? const Color(0xFF10b981)
        : const Color(0xFFef4444);

    // Use pre-generated feedback if available, fallback to evaluation result
    String feedbackText;
    if (_isCorrect) {
      feedbackText = widget.question.correctFeedback ??
          ref.read(lastEvaluationResultProvider)?['feedback'] as String? ??
          'Richtig!';
    } else {
      feedbackText = widget.question.incorrectFeedback ??
          ref.read(lastEvaluationResultProvider)?['feedback'] as String? ??
          'Leider nicht richtig.';
    }

    return AnimatedSize(
      duration: SlamTokens.dState,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: feedbackColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(SlamTokens.rCardSm),
          border: Border.all(color: feedbackColor.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _isCorrect ? Icons.check_circle : Icons.info_outline,
                  color: feedbackColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _isCorrect ? 'Richtig!' : 'Nicht ganz richtig',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: feedbackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              feedbackText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            if (!_isCorrect) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.school,
                      color: colorScheme.onSurfaceVariant,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMixedText(
                        'Lösung: ${widget.question.solution}',
                        theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ) ??
                            const TextStyle(),
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

  // ============================================================================
  // HINT SECTION
  // ============================================================================

  Widget _buildHintSection(ThemeData theme, ColorScheme colorScheme) {
    final maxHints = widget.question.hints.length;
    final hintLabel = _hintsShown == 0
        ? 'Hinweis anzeigen'
        : 'Hinweis ($_hintsShown/$maxHints)';

    return OutlinedButton.icon(
      onPressed: _hintsShown < maxHints ? _revealHint : null,
      icon: const Icon(Icons.lightbulb_outline, size: 18),
      label: Text(hintLabel),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: const StadiumBorder(),
        foregroundColor: SlamTokens.textDim,
        side: const BorderSide(color: SlamTokens.line),
      ),
    );
  }

  Widget _buildRevealedHints(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: List.generate(_hintsShown, (index) {
        if (index >= widget.question.hints.length) return const SizedBox();
        final hint = widget.question.hints[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb,
                  color: colorScheme.primary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hinweis ${hint.effectiveLevel}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      MathText(
                        hint.text,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ============================================================================
  // "WO HAENGTS?" SECTION
  // ============================================================================

  Widget _buildWoHaengtsSection(ThemeData theme, ColorScheme colorScheme) {
    return FilledButton.tonalIcon(
      onPressed: _openWoHaengtsChat,
      icon: const Icon(Icons.chat_bubble_outline, size: 18),
      label: const Text('Wo hängts? — KI-Chat öffnen'),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ============================================================================
  // NEXT BUTTON
  // ============================================================================

  Widget _buildNextButton(ThemeData theme, ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: _skipToNext,
        icon: const Icon(Icons.arrow_forward, size: 18),
        label: const Text('Nächste Frage'),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const StadiumBorder(),
        ),
      ),
    );
  }
}

/// Subtle timer chip — shows elapsed time without distracting animations.
class _QuietTimerChip extends StatelessWidget {
  final int seconds;
  const _QuietTimerChip({required this.seconds});

  String _formatTime(int s) {
    final m = s ~/ 60;
    final r = s % 60;
    return '${m.toString().padLeft(2, '0')}:${r.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Chip(
      avatar: Icon(Icons.schedule, size: 14,
          color: cs.onSurfaceVariant.withValues(alpha: 0.5)),
      label: Text(
        _formatTime(seconds),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: cs.onSurfaceVariant.withValues(alpha: 0.6),
            ),
      ),
      backgroundColor: Colors.transparent,
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
    );
  }
}

/// Maps a numeric difficulty (1–10) to the German Anforderungsbereich label.
String _difficultyToAfb(int difficulty) {
  if (difficulty <= 4) return 'AFB I';
  if (difficulty <= 7) return 'AFB II';
  return 'AFB III';
}
