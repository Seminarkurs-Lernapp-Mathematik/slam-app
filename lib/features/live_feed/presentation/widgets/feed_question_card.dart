import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/design_tokens.dart';
import '../../../../core/constants/level_thresholds.dart';
import '../../../../core/models/question.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';
import '../providers/live_feed_providers.dart';
import 'wo_haengts_chat_sheet.dart';
import '../../../../shared/widgets/math_text.dart';
import '../../../../shared/widgets/confetti_overlay.dart';

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
    with TickerProviderStateMixin {
  Timer? _autoAdvanceTimer;
  Timer? _questionTimer;
  int _hintsShown = 0;
  int _timeSpentSeconds = 0;
  String? _selectedOptionId;
  bool _answered = false;
  bool _isCorrect = false;
  bool _showWoHaengtsInput = false;

  List<String> _stepOrder = [];
  final int _currentStepIndex = 0;

  // Card entrance
  late AnimationController _entranceCtrl;
  late Animation<double> _entranceFade;
  late Animation<Offset> _entranceSlide;

  // Wrong-answer feedback
  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnim;
  late AnimationController _redCtrl;
  late Animation<double> _redAnim;

  // Correct-answer feedback
  bool _showSuccessBurst = false;
  int _burstXp = 0;

  @override
  void initState() {
    super.initState();
    _startQuestionTimer();
    if (widget.question.type == QuestionType.stepByStep &&
        widget.question.stepByStepData != null) {
      _stepOrder =
          List.from(widget.question.stepByStepData!.steps.map((s) => s.id));
      _stepOrder.shuffle();
    }

    _entranceCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 340));
    _entranceFade =
        CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut);
    _entranceSlide =
        Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(
            CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOutCubic));
    _entranceCtrl.forward();

    _shakeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 520));
    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 11.0), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 11.0, end: -13.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -13.0, end: 9.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 9.0, end: -7.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -7.0, end: 3.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 3.0, end: 0.0), weight: 10),
    ]).animate(_shakeCtrl);

    _redCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 650));
    _redAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.18), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.18, end: 0.0), weight: 80),
    ]).animate(CurvedAnimation(parent: _redCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _questionTimer?.cancel();
    _entranceCtrl.dispose();
    _shakeCtrl.dispose();
    _redCtrl.dispose();
    super.dispose();
  }

  void _startQuestionTimer() {
    _questionTimer?.cancel();
    _timeSpentSeconds = 0;
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _timeSpentSeconds++);
        ref.read(liveFeedTimerSecondsProvider.notifier).state =
            _timeSpentSeconds;
      }
    });
  }

  String _formatTimer(int s) {
    final m = s ~/ 60;
    final r = s % 60;
    return '${m.toString().padLeft(2, '0')}:${r.toString().padLeft(2, '0')}';
  }

  String _difficultyToAfb(int d) {
    if (d <= 4) return 'AFB I';
    if (d <= 7) return 'AFB II';
    return 'AFB III';
  }

  (Color, Color) _subjectColors(String topic) {
    final t = topic.toLowerCase();
    if (t.contains('algebra'))
      return (SlamTokens.algebra, SlamTokens.algebraSoft);
    if (t.contains('analysis') ||
        t.contains('differenzial') ||
        t.contains('integral')) {
      return (SlamTokens.analysis, SlamTokens.analysisSoft);
    }
    if (t.contains('geometrie') || t.contains('trigono')) {
      return (SlamTokens.geometrie, SlamTokens.geometrieSoft);
    }
    if (t.contains('stochastik') ||
        t.contains('statistik') ||
        t.contains('wahrscheinlichkeit')) {
      return (SlamTokens.stochastik, SlamTokens.stochastikSoft);
    }
    return (SlamTokens.primary, SlamTokens.primarySoft);
  }

  void _selectOption(String optionId) {
    if (_answered) return;
    HapticFeedback.selectionClick();
    setState(() => _selectedOptionId = optionId);

    final selectedOption =
        widget.question.options?.firstWhere((o) => o.id == optionId);
    if (selectedOption == null) return;

    _questionTimer?.cancel();
    final isCorrect = selectedOption.isCorrect;
    setState(() {
      _answered = true;
      _isCorrect = isCorrect;
    });

    ref.read(selectedOptionProvider.notifier).select(optionId);
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

    ref.read(lastEvaluationResultProvider.notifier).setResult({
      'isCorrect': isCorrect,
      'feedback': feedback,
      'xpEarned': xpEarned,
      'coinsEarned': coinsEarned,
    });

    _updateStats(isCorrect, xpEarned, coinsEarned);
    _updateAdaptiveDifficulty(isCorrect);

    if (isCorrect && mounted) {
      HapticFeedback.heavyImpact();
      Future.delayed(const Duration(milliseconds: 50),
          () => HapticFeedback.mediumImpact());
      setState(() {
        _showSuccessBurst = true;
        _burstXp = xpEarned;
      });
    } else if (mounted) {
      HapticFeedback.heavyImpact();
      Future.delayed(const Duration(milliseconds: 100),
          () => HapticFeedback.mediumImpact());
      Future.delayed(const Duration(milliseconds: 200),
          () => HapticFeedback.lightImpact());
      _shakeCtrl.forward(from: 0);
      _redCtrl.forward(from: 0);
    }
    _saveProgress(isCorrect, xpEarned, coinsEarned, userAnswer: userAnswer);

    if (!isCorrect) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() => _showWoHaengtsInput = true);
          ref.read(showWoHaengtsProvider.notifier).show();
        }
      });
    }

    if (isCorrect) {
      _autoAdvanceTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) widget.onAnswerSubmitted();
      });
    }
  }

  void _revealHint() {
    final maxHints = widget.question.hints.length;
    if (_hintsShown >= maxHints || _answered) return;
    HapticFeedback.mediumImpact();
    setState(() => _hintsShown++);
    ref.read(liveFeedHintsUsedProvider.notifier).increment();

    if (_hintsShown >= maxHints && !_answered) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted && !_answered) {
          setState(() => _showWoHaengtsInput = true);
          ref.read(showWoHaengtsProvider.notifier).show();
        }
      });
    }
  }

  void _openWoHaengtsChat() {
    _autoAdvanceTimer?.cancel();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          WoHaengtsChatSheet(questionText: widget.question.question),
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
      await ref
          .read(firestoreServiceProvider)
          .addXpAndCoins(userId, xpEarned, coinsEarned);
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
    } else if (!isCorrect && consecutiveWrong >= 2) {
      ref.read(liveFeedDifficultyProvider.notifier).decrease();
      ref.read(consecutiveWrongProvider.notifier).reset();
    }
  }

  Future<void> _saveProgress(bool isCorrect, int xpEarned, int coinsEarned,
      {String? userAnswer}) async {
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
          userId: userId, progress: progress);
    } catch (e) {
      debugPrint('Error saving question progress: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final (subjectColor, subjectSoft) = _subjectColors(widget.question.topic);
    final afb = _difficultyToAfb(widget.question.difficulty);
    final timer = _formatTimer(_timeSpentSeconds);

    return ConfettiOverlay(
      show: _showSuccessBurst,
      xpEarned: _burstXp,
      child: FadeTransition(
        opacity: _entranceFade,
        child: SlideTransition(
          position: _entranceSlide,
          child: AnimatedBuilder(
            animation: _shakeAnim,
            builder: (_, child) => Transform.translate(
              offset: Offset(_shakeAnim.value, 0),
              child: child,
            ),
            child: Stack(
              children: [
                // Scrollable content
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    SlamTokens.gutter,
                    8,
                    SlamTokens.gutter,
                    80,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Subject row ──────────────────────────────────────
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: subjectColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.question.topic.toUpperCase(),
                            style: GoogleFonts.dmSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.4,
                              color: subjectColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('·',
                              style: GoogleFonts.dmSans(
                                  fontSize: 11, color: SlamTokens.textDim)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.question.subtopic,
                              style: GoogleFonts.dmSans(
                                  fontSize: 11,
                                  color: SlamTokens.textDim,
                                  fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: SlamTokens.surfaceHi,
                              borderRadius:
                                  BorderRadius.circular(SlamTokens.rCircle),
                              border: Border.all(color: SlamTokens.line),
                            ),
                            child: Text(
                              '$afb · $timer',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: SlamTokens.textDim,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // ── Question text ─────────────────────────────────────
                      SelectionContainer.disabled(
                        child: AnimatedDefaultTextStyle(
                          duration: SlamTokens.dState,
                          curve: SlamTokens.curveStandard,
                          style: GoogleFonts.fraunces(
                            fontSize: _answered ? 17 : 22,
                            fontWeight: FontWeight.w700,
                            color: SlamTokens.text,
                            letterSpacing: -0.4,
                            height: 1.28,
                          ),
                          child: _buildQuestionText(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ── Hints cloud ───────────────────────────────────────
                      if (_hintsShown > 0 && !_answered)
                        ...List.generate(_hintsShown, (i) {
                          if (i >= widget.question.hints.length)
                            return const SizedBox();
                          final hint = widget.question.hints[i];
                          return _AnimatedReveal(
                            key: ValueKey('hint_$i'),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: subjectSoft,
                                  borderRadius:
                                      BorderRadius.circular(SlamTokens.rInput),
                                  border: Border.all(
                                      color:
                                          subjectColor.withValues(alpha: 0.3)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'HINT ${i + 1} · ${widget.question.hints.length}',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: subjectColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    MathText(hint.text,
                                        style: GoogleFonts.dmSans(
                                            fontSize: 14,
                                            color: SlamTokens.text)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),

                      // ── Options ───────────────────────────────────────────
                      if (widget.question.type == QuestionType.multipleChoice)
                        _buildOptions(subjectColor, subjectSoft),
                      if (widget.question.type == QuestionType.stepByStep)
                        _buildStepByStepArea(),

                      // ── Feedback ──────────────────────────────────────────
                      if (_answered) ...[
                        const SizedBox(height: 16),
                        _AnimatedReveal(
                          key: ValueKey('feedback_${widget.question.id}'),
                          child: _buildFeedback(),
                        ),
                        if (!_isCorrect && _showWoHaengtsInput) ...[
                          const SizedBox(height: 10),
                          _AnimatedReveal(
                            key: ValueKey('wohaengts_${widget.question.id}'),
                            child: _buildWoHaengtsButton(
                                subjectColor, subjectSoft),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),

                // ── Action bar — flush at bottom, directly above nav bar ──
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildActionBar(subjectColor),
                ),

                // ── Wrong-answer red flash ─────────────────────────────────
                AnimatedBuilder(
                  animation: _redAnim,
                  builder: (_, __) => _redAnim.value > 0
                      ? Positioned.fill(
                          child: IgnorePointer(
                            child: Container(
                              color: SlamTokens.danger
                                  .withValues(alpha: _redAnim.value),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                // ── Correct-answer burst ───────────────────────────────────
                if (_showSuccessBurst)
                  Positioned.fill(
                    child: _SuccessBurst(
                      xp: _burstXp,
                      onComplete: () {
                        if (mounted) setState(() => _showSuccessBurst = false);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionText() {
    final questionText = widget.question.question;
    final parts = questionText.split(r'$');
    if (parts.length <= 1) {
      return Text(questionText);
    }
    final style = GoogleFonts.fraunces(
      fontSize: _answered ? 17 : 22,
      fontWeight: FontWeight.w700,
      color: SlamTokens.text,
      letterSpacing: -0.4,
      height: 1.28,
    );
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

  Widget _buildOptions(Color subjectColor, Color subjectSoft) {
    final options = widget.question.options;
    if (options == null || options.isEmpty) {
      return Text('Keine Antwortoptionen verfügbar',
          style: GoogleFonts.dmSans(color: SlamTokens.textDim));
    }

    return Column(
      children: options.map((opt) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _buildOptionButton(opt, subjectColor, subjectSoft),
        );
      }).toList(),
    );
  }

  Widget _buildOptionButton(
      QuestionOption option, Color subjectColor, Color subjectSoft) {
    final isSelected = _selectedOptionId == option.id;

    Color bg, border, textColor;
    Color badgeBg;
    Color badgeFg;
    double radius = SlamTokens.rOption;
    double scale = 1.0;
    double opacity = 1.0;

    if (!_answered) {
      bg = SlamTokens.surface;
      border = isSelected ? subjectColor : SlamTokens.line;
      textColor = SlamTokens.text;
      badgeBg =
          isSelected ? subjectColor : SlamTokens.text.withValues(alpha: 0.06);
      badgeFg = isSelected ? SlamTokens.primaryOn : SlamTokens.textDim;
    } else if (option.isCorrect) {
      bg = SlamTokens.successSoft;
      border = SlamTokens.success;
      textColor = SlamTokens.text;
      badgeBg = SlamTokens.success;
      badgeFg = SlamTokens.successBgDark;
      radius = 20;
      scale = 1.02;
    } else if (isSelected && !option.isCorrect) {
      bg = SlamTokens.dangerSoft;
      border = SlamTokens.danger;
      textColor = SlamTokens.text;
      badgeBg = SlamTokens.danger;
      badgeFg = SlamTokens.dangerBgDark;
    } else {
      bg = Colors.transparent;
      border = SlamTokens.line;
      textColor = SlamTokens.textMute;
      badgeBg = SlamTokens.text.withValues(alpha: 0.06);
      badgeFg = SlamTokens.textMute;
      opacity = 0.45;
      scale = 0.96;
    }

    return AnimatedOpacity(
      duration: SlamTokens.dState,
      opacity: opacity,
      child: AnimatedScale(
        scale: scale,
        duration: SlamTokens.dState,
        curve: SlamTokens.curveStandard,
        child: GestureDetector(
          onTap: _answered ? null : () => _selectOption(option.id),
          child: AnimatedContainer(
            duration: SlamTokens.dState,
            curve: SlamTokens.curveStandard,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: border,
                width: isSelected || (_answered && option.isCorrect) ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: SlamTokens.dState,
                  curve: SlamTokens.curveStandard,
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: _answered &&
                          (option.isCorrect ||
                              (isSelected && !option.isCorrect))
                      ? Icon(
                          option.isCorrect ? Icons.check : Icons.close,
                          size: 18,
                          color: badgeFg,
                        )
                      : Text(
                          option.id,
                          style: GoogleFonts.fraunces(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: badgeFg,
                          ),
                        ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildOptionText(option.text, textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionText(String text, Color textColor) {
    if (text.contains(r'$')) {
      final parts = text.split(r'$');
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: List.generate(parts.length, (index) {
          final part = parts[index];
          if (part.isEmpty) return const SizedBox.shrink();
          if (index % 2 == 1) {
            try {
              return Math.tex(part,
                  textStyle: TextStyle(color: textColor, fontSize: 16));
            } catch (_) {
              return Text(part, style: TextStyle(color: textColor));
            }
          }
          return Text(
            part,
            style: GoogleFonts.dmSans(
                fontSize: 16, color: textColor, fontWeight: FontWeight.w500),
          );
        }),
      );
    }
    return Text(text,
        style: GoogleFonts.dmSans(
            fontSize: 16, color: textColor, fontWeight: FontWeight.w500));
  }

  Widget _buildFeedback() {
    final feedbackColor = _isCorrect ? SlamTokens.success : SlamTokens.danger;
    final feedbackSoft =
        _isCorrect ? SlamTokens.successSoft : SlamTokens.dangerSoft;

    String feedbackText;
    if (_isCorrect) {
      feedbackText = widget.question.correctFeedback ?? 'Richtig! Gut gemacht.';
    } else {
      feedbackText =
          widget.question.incorrectFeedback ?? 'Leider nicht richtig.';
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: feedbackSoft,
        borderRadius: BorderRadius.circular(SlamTokens.rCardSm),
        border:
            Border.all(color: feedbackColor.withValues(alpha: 0.5), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration:
                    BoxDecoration(color: feedbackColor, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Icon(_isCorrect ? Icons.check : Icons.close,
                    size: 18, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Text(
                _isCorrect ? 'Stark gelöst!' : 'Knapp daneben',
                style: GoogleFonts.fraunces(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: feedbackColor,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(feedbackText,
              style: GoogleFonts.dmSans(
                  fontSize: 14, color: SlamTokens.text, height: 1.55)),
          if (!_isCorrect) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: SlamTokens.text.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Lösung: ',
                      style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: SlamTokens.text)),
                  Expanded(
                    child: MathText(
                      widget.question.solution,
                      style: GoogleFonts.dmSans(
                          fontSize: 13, color: SlamTokens.textDim),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWoHaengtsButton(Color subjectColor, Color subjectSoft) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _openWoHaengtsChat();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: SlamTokens.surface,
          borderRadius: BorderRadius.circular(SlamTokens.rInput),
          border: Border.all(color: SlamTokens.line),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration:
                  BoxDecoration(color: subjectSoft, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Icon(Icons.chat_bubble_outline,
                  size: 16, color: subjectColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Wo hängts? Frag die KI',
                style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: SlamTokens.text),
              ),
            ),
            const Icon(Icons.chevron_right,
                size: 16, color: SlamTokens.textDim),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBar(Color subjectColor) {
    final canHint = _hintsShown < widget.question.hints.length;

    return Container(
      decoration: BoxDecoration(
        color: SlamTokens.bg,
        border: Border(top: BorderSide(color: SlamTokens.line)),
      ),
      padding: const EdgeInsets.fromLTRB(
          SlamTokens.gutter, 10, SlamTokens.gutter, 12),
      child: _answered
          ? _AnimatedReveal(
              key: ValueKey('actionbar_answered_${widget.question.id}'),
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _skipToNext();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: _isCorrect ? SlamTokens.success : SlamTokens.primary,
                    borderRadius: BorderRadius.circular(SlamTokens.rCircle),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Nächste Frage',
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: _isCorrect
                              ? SlamTokens.successBgDark
                              : SlamTokens.primaryOn,
                          letterSpacing: -0.1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_forward,
                          size: 18,
                          color: _isCorrect
                              ? SlamTokens.successBgDark
                              : SlamTokens.primaryOn),
                    ],
                  ),
                ),
              ),
            )
          : Row(
              children: [
                // Hint button
                GestureDetector(
                  onTap: canHint ? _revealHint : null,
                  child: AnimatedContainer(
                    duration: SlamTokens.dState,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: _hintsShown > 0
                          ? subjectColor.withValues(alpha: 0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(SlamTokens.rCircle),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lightbulb_outline,
                            size: 16,
                            color:
                                canHint ? subjectColor : SlamTokens.textMute),
                        const SizedBox(width: 6),
                        Text(
                          _hintsShown == 0
                              ? 'Hinweis'
                              : canHint
                                  ? '$_hintsShown/${widget.question.hints.length}'
                                  : 'Max',
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: canHint ? subjectColor : SlamTokens.textMute,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Center text
                Expanded(
                  child: Text(
                    'Tippe auf eine Antwort',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: SlamTokens.textDim,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3),
                  ),
                ),

                // Skip button
                GestureDetector(
                  onTap: _skipToNext,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Text('Überspringen',
                            style: GoogleFonts.dmSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: SlamTokens.textDim)),
                        const SizedBox(width: 4),
                        const Icon(Icons.skip_next,
                            size: 14, color: SlamTokens.textDim),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // ── Step-by-step (unchanged logic, minimal styling update) ──────────────────
  Widget _buildStepByStepArea() {
    final stepData = widget.question.stepByStepData;
    if (stepData == null)
      return _buildOptions(SlamTokens.primary, SlamTokens.primarySoft);

    if (stepData.type == 'sort-steps') {
      return _buildSortableSteps(stepData);
    }
    return _buildNextActionSteps(stepData);
  }

  Widget _buildSortableSteps(StepByStepData stepData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Bringe die Schritte in die richtige Reihenfolge:',
            style: GoogleFonts.dmSans(
                color: SlamTokens.textDim, fontWeight: FontWeight.w500)),
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
            final step = stepData.steps.firstWhere((s) => s.id == stepId);
            final isCorrectPosition = _answered &&
                stepData.correctOrder.length > index &&
                stepData.correctOrder[index] == stepId;

            return Container(
              key: ValueKey(stepId),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _answered
                    ? isCorrectPosition
                        ? SlamTokens.successSoft
                        : SlamTokens.dangerSoft
                    : SlamTokens.surface,
                borderRadius: BorderRadius.circular(SlamTokens.rOption),
                border: Border.all(
                  color: _answered
                      ? isCorrectPosition
                          ? SlamTokens.success
                          : SlamTokens.danger
                      : SlamTokens.line,
                ),
              ),
              child: Row(
                children: [
                  if (!_answered)
                    const Icon(Icons.drag_handle, color: SlamTokens.textDim),
                  if (_answered)
                    Icon(
                      isCorrectPosition ? Icons.check_circle : Icons.cancel,
                      color: isCorrectPosition
                          ? SlamTokens.success
                          : SlamTokens.danger,
                      size: 20,
                    ),
                  const SizedBox(width: 12),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                        color: SlamTokens.surfaceHi, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Text('${index + 1}',
                        style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: SlamTokens.textDim)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                      child: MathText(step.text,
                          style: GoogleFonts.dmSans(color: SlamTokens.text))),
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
            style: FilledButton.styleFrom(shape: const StadiumBorder()),
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

  Widget _buildNextActionSteps(StepByStepData stepData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Was ist der nächste Schritt?',
            style: GoogleFonts.dmSans(
                color: SlamTokens.textDim, fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        ...stepData.steps.map((step) {
          final isSelected = _selectedOptionId == step.id;
          final isCorrectStep = stepData.correctOrder.isNotEmpty &&
              stepData.correctOrder[_currentStepIndex] == step.id;

          Color bg = SlamTokens.surface, border = SlamTokens.line;
          if (_answered) {
            if (isCorrectStep) {
              bg = SlamTokens.successSoft;
              border = SlamTokens.success;
            } else if (isSelected) {
              bg = SlamTokens.dangerSoft;
              border = SlamTokens.danger;
            }
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
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
              child: AnimatedContainer(
                duration: SlamTokens.dState,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(SlamTokens.rOption),
                  border: Border.all(color: border),
                ),
                child: MathText(step.text,
                    style: GoogleFonts.dmSans(
                        fontSize: 16, color: SlamTokens.text)),
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Animated reveal — fade + slide-up entrance for conditionally shown widgets
// ─────────────────────────────────────────────────────────────────────────────

class _AnimatedReveal extends StatelessWidget {
  const _AnimatedReveal({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      builder: (_, v, c) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, (1 - v) * 14), child: c),
      ),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Success burst overlay — particle ring + check circle + floating XP chip
// ─────────────────────────────────────────────────────────────────────────────

class _SuccessBurst extends StatefulWidget {
  const _SuccessBurst({required this.xp, required this.onComplete});
  final int xp;
  final VoidCallback onComplete;

  @override
  State<_SuccessBurst> createState() => _SuccessBurstState();
}

class _SuccessBurstState extends State<_SuccessBurst>
    with TickerProviderStateMixin {
  late AnimationController _particleCtrl;
  late AnimationController _checkCtrl;
  late AnimationController _xpCtrl;
  late AnimationController _fadeCtrl;

  @override
  void initState() {
    super.initState();
    _particleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..forward();
    _checkCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 380));
    _xpCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) _checkCtrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 160), () {
      if (mounted) _xpCtrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _fadeCtrl.forward().then((_) => widget.onComplete());
    });
  }

  @override
  void dispose() {
    _particleCtrl.dispose();
    _checkCtrl.dispose();
    _xpCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeCtrl,
      builder: (_, child) => Opacity(
        opacity: 1 - _fadeCtrl.value,
        child: child,
      ),
      child: IgnorePointer(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Expanding green radial glow
            AnimatedBuilder(
              animation: _particleCtrl,
              builder: (_, __) {
                final t = Curves.easeOut.transform(_particleCtrl.value);
                return Container(
                  width: t * 220,
                  height: t * 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: SlamTokens.success.withValues(alpha: (1 - t) * 0.13),
                  ),
                );
              },
            ),

            // Particle ring
            AnimatedBuilder(
              animation: _particleCtrl,
              builder: (_, __) => CustomPaint(
                painter: _BurstParticlePainter(progress: _particleCtrl.value),
                child: const SizedBox(width: 240, height: 240),
              ),
            ),

            // Check circle with spring scale
            AnimatedBuilder(
              animation: _checkCtrl,
              builder: (_, __) {
                final t = Curves.easeOutBack.transform(_checkCtrl.value);
                return Transform.scale(
                  scale: t,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: SlamTokens.success,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: SlamTokens.success.withValues(alpha: 0.55),
                          blurRadius: 24,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.check_rounded,
                        color: Colors.white, size: 34),
                  ),
                );
              },
            ),

            // Floating XP chip
            if (widget.xp > 0)
              AnimatedBuilder(
                animation: _xpCtrl,
                builder: (_, __) {
                  final t = Curves.easeOut.transform(_xpCtrl.value);
                  final opacity =
                      _xpCtrl.value < 0.75 ? 1.0 : (1 - _xpCtrl.value) / 0.25;
                  return Transform.translate(
                    offset: Offset(0, 44 - t * 90),
                    child: Opacity(
                      opacity: opacity.clamp(0.0, 1.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: SlamTokens.primary,
                          borderRadius:
                              BorderRadius.circular(SlamTokens.rCircle),
                          boxShadow: [
                            BoxShadow(
                              color: SlamTokens.primary.withValues(alpha: 0.55),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Text('+${widget.xp} XP',
                            style: GoogleFonts.fraunces(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: SlamTokens.primaryOn)),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _BurstParticlePainter extends CustomPainter {
  const _BurstParticlePainter({required this.progress});
  final double progress;

  static final _colors = [
    SlamTokens.accentGreenLight, // success green
    SlamTokens.primary, // primary orange
    SlamTokens.warn, // warn yellow
    SlamTokens.algebra, // algebra amber
    SlamTokens.geometrie, // geometrie purple
    SlamTokens.analysis, // analysis blue
    SlamTokens.stochastik, // stochastik teal
    SlamTokens.accentPinkLight, // pink
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final maxR = size.width * 0.42;
    final t = Curves.easeOut.transform(progress);

    for (int i = 0; i < _colors.length; i++) {
      final angle = (i / _colors.length) * 2 * math.pi - math.pi / 2;
      final r = t * maxR;
      final opacity = (1 - progress).clamp(0.0, 1.0);
      final pR = (1 - t * 0.5) * 5.5;

      canvas.drawCircle(
        Offset(cx + r * math.cos(angle), cy + r * math.sin(angle)),
        pR,
        Paint()..color = _colors[i].withValues(alpha: opacity),
      );
    }
  }

  @override
  bool shouldRepaint(_BurstParticlePainter old) => old.progress != progress;
}
