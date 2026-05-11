import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/design_tokens.dart';

/// Cold-start self-assessment quiz shown once after onboarding.
/// Asks students to rate their confidence in 5 math topics.
/// The result is saved as an initial AFB level hint for the live feed.
class DiagnosticQuizScreen extends StatefulWidget {
  const DiagnosticQuizScreen({super.key});

  @override
  State<DiagnosticQuizScreen> createState() => _DiagnosticQuizScreenState();
}

class _DiagnosticQuizScreenState extends State<DiagnosticQuizScreen> {
  static const _topics = [
    ('Terme & Gleichungen', Icons.calculate_outlined),
    ('Geometrie', Icons.change_history_outlined),
    ('Funktionen & Graphen', Icons.show_chart_rounded),
    ('Stochastik', Icons.bar_chart_rounded),
    ('Analysis', Icons.functions_rounded),
  ];

  static const _levels = ['Anfänger', 'Mittel', 'Fortgeschritten'];

  // null = not yet selected
  final Map<int, int> _answers = {};

  bool get _allAnswered => _answers.length == _topics.length;

  // Returns 3.0 / 6.0 / 9.0 — the initial difficulty for live feed
  double _computeDifficulty() {
    final avg = _answers.values.fold(0, (a, b) => a + b) / _answers.length;
    if (avg < 1.5) return 3.0;
    if (avg < 2.5) return 6.0;
    return 9.0;
  }

  Future<void> _finish() async {
    HapticFeedback.mediumImpact();
    final difficulty = _computeDifficulty();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('diagnostic_initial_difficulty', difficulty);
    await prefs.setBool('diagnostic_done', true);
    if (!mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SlamTokens.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                    SlamTokens.gutter, 8, SlamTokens.gutter, 16),
                itemCount: _topics.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) => _buildTopicCard(i),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          SlamTokens.gutter, 24, SlamTokens.gutter, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: SlamTokens.primaryGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.assessment_outlined,
                size: 24, color: Colors.white),
          ),
          const SizedBox(height: 14),
          Text(
            'Dein Startlevel',
            style: GoogleFonts.fraunces(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: SlamTokens.text,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Schätze kurz deinen Wissensstand ein – damit SLAM von Anfang an das richtige Niveau wählt.',
            style: GoogleFonts.dmSans(
                fontSize: 14, color: SlamTokens.textDim, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCard(int index) {
    final (topic, icon) = _topics[index];
    final selected = _answers[index];
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: SlamTokens.surface,
        borderRadius: BorderRadius.circular(SlamTokens.rCardMd),
        border: Border.all(
          color: selected != null
              ? SlamTokens.primary.withValues(alpha: 0.4)
              : SlamTokens.line,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: SlamTokens.primary),
              const SizedBox(width: 8),
              Text(
                topic,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: SlamTokens.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(
              _levels.length,
              (lvl) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: lvl < _levels.length - 1 ? 6 : 0),
                  child: _LevelChip(
                    label: _levels[lvl],
                    selected: selected == lvl,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _answers[index] = lvl);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    final answered = _answers.length;
    final total = _topics.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          SlamTokens.gutter, 0, SlamTokens.gutter, 24),
      child: Column(
        children: [
          if (!_allAnswered)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                '$answered / $total Themen bewertet',
                style: GoogleFonts.dmSans(
                    fontSize: 13, color: SlamTokens.textDim),
                textAlign: TextAlign.center,
              ),
            ),
          GestureDetector(
            onTap: _allAnswered ? _finish : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _allAnswered
                      ? [SlamTokens.primary, SlamTokens.accentPink]
                      : [
                          SlamTokens.primary.withValues(alpha: 0.3),
                          SlamTokens.accentPink.withValues(alpha: 0.3),
                        ],
                ),
                borderRadius: BorderRadius.circular(SlamTokens.rCircle),
                boxShadow: _allAnswered
                    ? [
                        BoxShadow(
                          color: SlamTokens.primary.withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                          spreadRadius: -4,
                        )
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                'Loslegen!',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? SlamTokens.primary.withValues(alpha: 0.15)
              : SlamTokens.bg,
          borderRadius: BorderRadius.circular(SlamTokens.rInput),
          border: Border.all(
            color: selected ? SlamTokens.primary : SlamTokens.line,
            width: selected ? 1.5 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? SlamTokens.primary : SlamTokens.textDim,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
