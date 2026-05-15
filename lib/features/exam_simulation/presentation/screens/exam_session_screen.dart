import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/design_tokens.dart';
import '../../../../shared/widgets/glass_panel.dart';

// ============================================================================
// Data model
// ============================================================================

class ExamQuestion {
  final String id;
  final String text;
  final int points;
  final String topic;
  final String afbLevel;
  final String? hint;

  const ExamQuestion({
    required this.id,
    required this.text,
    required this.points,
    required this.topic,
    required this.afbLevel,
    this.hint,
  });

  factory ExamQuestion.fromMap(Map<String, dynamic> map) {
    return ExamQuestion(
      id: map['id'] as String? ?? '',
      text: map['text'] as String? ?? '',
      points: (map['points'] as num?)?.toInt() ?? 4,
      topic: map['topic'] as String? ?? '',
      afbLevel: map['afbLevel'] as String? ?? 'II',
      hint: map['hint'] as String?,
    );
  }
}

// ============================================================================
// Exam Session Screen
// ============================================================================

class ExamSessionScreen extends StatefulWidget {
  final List<ExamQuestion> questions;
  final int durationMinutes;
  final int totalPoints;

  const ExamSessionScreen({
    super.key,
    required this.questions,
    required this.durationMinutes,
    required this.totalPoints,
  });

  @override
  State<ExamSessionScreen> createState() => _ExamSessionScreenState();
}

class _ExamSessionScreenState extends State<ExamSessionScreen> {
  int _currentIndex = 0;
  final Map<String, String> _answers = {};
  late int _remainingSeconds;
  Timer? _timer;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationMinutes * 60;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          _submitExam();
        }
      });
    });
  }

  String get _timerText {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Color get _timerColor {
    if (_remainingSeconds < 300) return SlamTokens.danger;
    if (_remainingSeconds < 900) return SlamTokens.warn;
    return SlamTokens.success;
  }

  void _submitExam() {
    _timer?.cancel();
    setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) return _ResultScreen(questions: widget.questions, answers: _answers, totalPoints: widget.totalPoints);

    final q = widget.questions[_currentIndex];
    final answer = _answers[q.id] ?? '';

    return Scaffold(
      backgroundColor: SlamTokens.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Timer bar
            _TimerBar(
              timerText: _timerText,
              timerColor: _timerColor,
              current: _currentIndex + 1,
              total: widget.questions.length,
              onSubmit: () => _showSubmitDialog(context),
            ),
            // Question
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: SlamTokens.primarySoft,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Aufgabe ${q.id}',
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: SlamTokens.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${q.points} Punkte · AFB ${q.afbLevel}',
                          style: GoogleFonts.dmSans(
                              fontSize: 12, color: SlamTokens.textDim),
                        ),
                        const Spacer(),
                        Text(
                          q.topic,
                          style: GoogleFonts.dmSans(
                              fontSize: 11, color: SlamTokens.textMute),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Question text
                    GlassPanel(
                      padding: const EdgeInsets.all(18),
                      child: Text(
                        q.text,
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          color: SlamTokens.text,
                          height: 1.5,
                        ),
                      ),
                    ),
                    if (q.hint != null) ...[
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _showHint(context, q.hint!),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.lightbulb_outline,
                                size: 13, color: SlamTokens.warn),
                            const SizedBox(width: 4),
                            Text(
                              'Hinweis anzeigen',
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                color: SlamTokens.warn,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    // Answer input
                    TextField(
                      maxLines: 5,
                      controller: TextEditingController(text: answer)
                        ..selection = TextSelection.collapsed(
                            offset: answer.length),
                      decoration: InputDecoration(
                        hintText: 'Lösung hier eingeben…',
                        hintStyle: GoogleFonts.dmSans(color: SlamTokens.textMute),
                        filled: true,
                        fillColor: SlamTokens.surface,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(SlamTokens.rInput),
                          borderSide: BorderSide(color: SlamTokens.line),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(SlamTokens.rInput),
                          borderSide: BorderSide(color: SlamTokens.line),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(SlamTokens.rInput),
                          borderSide: BorderSide(
                              color: SlamTokens.primary, width: 1.5),
                        ),
                      ),
                      style: GoogleFonts.dmSans(
                          fontSize: 14, color: SlamTokens.text),
                      onChanged: (v) =>
                          setState(() => _answers[q.id] = v),
                    ),
                    const SizedBox(height: 24),
                    // Navigation
                    Row(
                      children: [
                        if (_currentIndex > 0)
                          OutlinedButton(
                            onPressed: () =>
                                setState(() => _currentIndex--),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: SlamTokens.line),
                              foregroundColor: SlamTokens.textDim,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    SlamTokens.rOption),
                              ),
                            ),
                            child: const Text('Zurück'),
                          ),
                        const Spacer(),
                        if (_currentIndex < widget.questions.length - 1)
                          FilledButton(
                            onPressed: () =>
                                setState(() => _currentIndex++),
                            style: FilledButton.styleFrom(
                              backgroundColor: SlamTokens.primary,
                              foregroundColor: SlamTokens.primaryOn,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    SlamTokens.rOption),
                              ),
                            ),
                            child: const Text('Weiter'),
                          )
                        else
                          FilledButton.icon(
                            onPressed: () =>
                                _showSubmitDialog(context),
                            icon: const Icon(Icons.check),
                            label: const Text('Abgeben'),
                            style: FilledButton.styleFrom(
                              backgroundColor: SlamTokens.success,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    SlamTokens.rOption),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Question dots
            _QuestionDots(
              total: widget.questions.length,
              current: _currentIndex,
              answered: _answers.keys.toSet(),
              questions: widget.questions,
              onTap: (i) => setState(() => _currentIndex = i),
            ),
          ],
        ),
      ),
    );
  }

  void _showHint(BuildContext ctx, String hint) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: SlamTokens.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.lightbulb, color: SlamTokens.warn, size: 20),
              const SizedBox(width: 8),
              Text('Hinweis',
                  style: GoogleFonts.fraunces(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: SlamTokens.text)),
            ]),
            const SizedBox(height: 12),
            Text(hint,
                style: GoogleFonts.dmSans(
                    fontSize: 14, color: SlamTokens.text, height: 1.5)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showSubmitDialog(BuildContext ctx) {
    final unanswered = widget.questions
        .where((q) => (_answers[q.id] ?? '').isEmpty)
        .length;
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: SlamTokens.surface,
        title: Text('Klausur abgeben?',
            style: GoogleFonts.fraunces(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: SlamTokens.text)),
        content: Text(
          unanswered > 0
              ? '$unanswered Aufgaben sind noch nicht beantwortet.'
              : 'Alle Aufgaben beantwortet. Jetzt abgeben?',
          style: GoogleFonts.dmSans(color: SlamTokens.textDim),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Zurück'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _submitExam();
            },
            style: FilledButton.styleFrom(
                backgroundColor: SlamTokens.success),
            child: const Text('Abgeben'),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Timer Bar
// ============================================================================

class _TimerBar extends StatelessWidget {
  final String timerText;
  final Color timerColor;
  final int current;
  final int total;
  final VoidCallback onSubmit;

  const _TimerBar({
    required this.timerText,
    required this.timerColor,
    required this.current,
    required this.total,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      decoration: BoxDecoration(
        color: SlamTokens.bg,
        border: Border(bottom: BorderSide(color: SlamTokens.line)),
      ),
      child: Row(
        children: [
          // Timer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: timerColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: timerColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer_outlined, size: 14, color: timerColor),
                const SizedBox(width: 5),
                Text(
                  timerText,
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: timerColor,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Aufgabe $current/$total',
            style:
                GoogleFonts.dmSans(fontSize: 13, color: SlamTokens.textDim),
          ),
          const Spacer(),
          TextButton(
            onPressed: onSubmit,
            style: TextButton.styleFrom(
              foregroundColor: SlamTokens.danger,
              textStyle: GoogleFonts.dmSans(
                  fontSize: 13, fontWeight: FontWeight.w600),
            ),
            child: const Text('Abgeben'),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Question Dots
// ============================================================================

class _QuestionDots extends StatelessWidget {
  final int total;
  final int current;
  final Set<String> answered;
  final List<ExamQuestion> questions;
  final ValueChanged<int> onTap;

  const _QuestionDots({
    required this.total,
    required this.current,
    required this.answered,
    required this.questions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: SlamTokens.bg,
        border: Border(top: BorderSide(color: SlamTokens.line)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(total, (i) {
            final q = questions[i];
            final isAnswered = answered.contains(q.id);
            final isActive = i == current;
            return GestureDetector(
              onTap: () => onTap(i),
              child: Container(
                width: 28,
                height: 28,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? SlamTokens.primary
                      : isAnswered
                          ? SlamTokens.success.withValues(alpha: 0.2)
                          : SlamTokens.surface,
                  border: Border.all(
                    color: isActive
                        ? SlamTokens.primary
                        : isAnswered
                            ? SlamTokens.success.withValues(alpha: 0.5)
                            : SlamTokens.line,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${i + 1}',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isActive
                        ? SlamTokens.primaryOn
                        : isAnswered
                            ? SlamTokens.success
                            : SlamTokens.textDim,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ============================================================================
// Result Screen
// ============================================================================

class _ResultScreen extends StatelessWidget {
  final List<ExamQuestion> questions;
  final Map<String, String> answers;
  final int totalPoints;

  const _ResultScreen({
    required this.questions,
    required this.answers,
    required this.totalPoints,
  });

  @override
  Widget build(BuildContext context) {
    final answered = answers.values.where((a) => a.isNotEmpty).length;
    final unanswered = questions.length - answered;

    return Scaffold(
      backgroundColor: SlamTokens.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: SlamTokens.successSoft,
                  borderRadius: BorderRadius.circular(SlamTokens.rCardLg),
                  border: Border.all(
                      color: SlamTokens.success.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outline,
                        color: SlamTokens.success, size: 36),
                    const SizedBox(height: 12),
                    Text(
                      'Klausur abgegeben!',
                      style: GoogleFonts.fraunces(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: SlamTokens.text,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$answered von ${questions.length} Aufgaben beantwortet\n$unanswered offen gelassen',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: SlamTokens.textDim,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Deine Antworten',
                style: GoogleFonts.fraunces(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: SlamTokens.text,
                ),
              ),
              const SizedBox(height: 12),
              ...questions.map<Widget>((q) {
                final answer = answers[q.id] ?? '';
                return GlassPanel(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: SlamTokens.primarySoft,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'A${q.id}',
                              style: GoogleFonts.dmSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: SlamTokens.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${q.points} Pkt · ${q.topic}',
                            style: GoogleFonts.dmSans(
                                fontSize: 11, color: SlamTokens.textDim),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        q.text,
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: SlamTokens.textDim,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (answer.isNotEmpty) ...[
                        const Divider(height: 16),
                        Text(
                          answer,
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: SlamTokens.text,
                            height: 1.4,
                          ),
                        ),
                      ] else
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Nicht beantwortet',
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: SlamTokens.textMute,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Zurück'),
                style: FilledButton.styleFrom(
                  backgroundColor: SlamTokens.surface,
                  foregroundColor: SlamTokens.text,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SlamTokens.rOption),
                    side: BorderSide(color: SlamTokens.line),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
