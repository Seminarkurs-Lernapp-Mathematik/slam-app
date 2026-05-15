import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/design_tokens.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../settings/presentation/providers/settings_providers.dart';

class SetupWizardScreen extends ConsumerStatefulWidget {
  const SetupWizardScreen({super.key});

  @override
  ConsumerState<SetupWizardScreen> createState() => _SetupWizardScreenState();
}

class _SetupWizardScreenState extends ConsumerState<SetupWizardScreen>
    with TickerProviderStateMixin {
  final _pageController = PageController();
  int _currentPage = 0;
  static const int _totalPages = 4;

  // Step 0 state
  String _selectedGrade = 'Klasse_11';
  String _selectedCourseType = 'Leistungskurs';
  static const _grades = [
    'Klasse_5', 'Klasse_6', 'Klasse_7', 'Klasse_8', 'Klasse_9',
    'Klasse_10', 'Klasse_11', 'Klasse_12', 'Klasse_13',
  ];
  static const _upperGrades = {'Klasse_11', 'Klasse_12', 'Klasse_13'};
  static const _courseTypes = ['Leistungskurs', 'Grundkurs', 'Basiskurs'];

  // Step 1 state
  final Set<String> _selectedGoals = {};
  DateTime? _examDate;

  // Step 2 state
  AppThemePreset _selectedTheme = AppThemePreset.sunsetOrange;

  // Step 3 state
  bool _dsgvoConsented = false;

  bool _isCompleting = false;

  static const _goals = [
    ('abi', 'Abitur vorbereiten'),
    ('klausur', 'Klausur diese Woche'),
    ('luecken', 'Lücken schließen'),
    ('neues', 'Neues entdecken'),
  ];

  static const _themeOptions = [
    (AppThemePreset.sunsetOrange, 'Sunset', Color(0xFFFF7A3B)),
    (AppThemePreset.oceanBlue, 'Ocean', Color(0xFF3B82F6)),
    (AppThemePreset.forestGreen, 'Forest', Color(0xFF22C55E)),
    (AppThemePreset.lavenderPurple, 'Lavender', Color(0xFFA855F7)),
    (AppThemePreset.cherryRed, 'Cherry', Color(0xFFEF4444)),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goNext() {
    HapticFeedback.selectionClick();
    if (_currentPage < _totalPages - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: SlamTokens.dScreen,
        curve: SlamTokens.curveStandard,
      );
      setState(() => _currentPage++);
    }
  }

  void _goBack() {
    HapticFeedback.selectionClick();
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: SlamTokens.dScreen,
        curve: SlamTokens.curveStandard,
      );
      setState(() => _currentPage--);
    }
  }

  Future<void> _complete() async {
    if (!_dsgvoConsented || _isCompleting) return;
    setState(() => _isCompleting = true);
    HapticFeedback.heavyImpact();

    try {
      final authService = ref.read(authServiceProvider);
      final uid = authService.currentUser?.uid;
      final settingsNotifier = ref.read(appSettingsNotifierProvider.notifier);

      // Persist all wizard choices
      settingsNotifier.setGradeLevel(_selectedGrade);
      if (_upperGrades.contains(_selectedGrade)) {
        settingsNotifier.setCourseType(_selectedCourseType);
      }
      settingsNotifier.setLearningGoals(_selectedGoals.toList());
      settingsNotifier.setTheme(_selectedTheme);
      if (_examDate != null) settingsNotifier.setExamDate(_examDate);

      // Mark onboarding complete in Firestore (includes DSGVO record)
      if (uid != null) {
        await ref.read(firestoreServiceProvider).markOnboardingComplete(uid);
      }

      // Legacy SharedPrefs flag for old code paths
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_done', true);
      await prefs.setBool('dsgvo_consented', true);

      if (mounted) {
        final diagnosticDone = prefs.getBool('diagnostic_done') ?? false;
        context.go(diagnosticDone ? '/home' : '/diagnostic');
      }
    } catch (e) {
      setState(() => _isCompleting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler: $e'),
            backgroundColor: SlamTokens.danger,
          ),
        );
      }
    }
  }

  bool get _canProceed {
    return switch (_currentPage) {
      0 => true,
      1 => true,
      2 => true,
      3 => _dsgvoConsented,
      _ => false,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SlamTokens.bg,
      body: SafeArea(
        child: Column(
          children: [
            _ProgressBar(current: _currentPage, total: _totalPages),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _StepKlasse(
                    selectedGrade: _selectedGrade,
                    selectedCourseType: _selectedCourseType,
                    grades: _grades,
                    upperGrades: _upperGrades,
                    courseTypes: _courseTypes,
                    onGradeChanged: (g) => setState(() => _selectedGrade = g),
                    onCourseTypeChanged: (c) =>
                        setState(() => _selectedCourseType = c),
                  ),
                  _StepGoals(
                    selectedGoals: _selectedGoals,
                    examDate: _examDate,
                    goals: _goals,
                    onGoalToggled: (g) => setState(() {
                      if (_selectedGoals.contains(g)) {
                        _selectedGoals.remove(g);
                      } else {
                        _selectedGoals.add(g);
                      }
                    }),
                    onExamDateChanged: (d) => setState(() => _examDate = d),
                  ),
                  _StepTheme(
                    selectedTheme: _selectedTheme,
                    themeOptions: _themeOptions,
                    onThemeChanged: (t) {
                      setState(() => _selectedTheme = t);
                      // Apply live preview
                      ref
                          .read(appSettingsNotifierProvider.notifier)
                          .setTheme(t);
                    },
                  ),
                  _StepDsgvo(
                    consented: _dsgvoConsented,
                    onConsentChanged: (v) =>
                        setState(() => _dsgvoConsented = v),
                  ),
                ],
              ),
            ),
            _BottomNav(
              currentPage: _currentPage,
              totalPages: _totalPages,
              canProceed: _canProceed,
              isCompleting: _isCompleting,
              onBack: _goBack,
              onNext: _currentPage == _totalPages - 1 ? _complete : _goNext,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Progress Bar ────────────────────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.current, required this.total});
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: SlamTokens.dState,
      curve: SlamTokens.curveStandard,
      height: 3,
      width: double.infinity,
      child: Stack(
        children: [
          Container(color: SlamTokens.surface),
          FractionallySizedBox(
            widthFactor: (current + 1) / total,
            child: Container(
              decoration: BoxDecoration(gradient: SlamTokens.primaryGradient),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bottom Navigation ───────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentPage,
    required this.totalPages,
    required this.canProceed,
    required this.isCompleting,
    required this.onBack,
    required this.onNext,
  });
  final int currentPage;
  final int totalPages;
  final bool canProceed;
  final bool isCompleting;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final isLast = currentPage == totalPages - 1;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Row(
        children: [
          if (currentPage > 0)
            TextButton(
              onPressed: onBack,
              child: Text(
                'Zurück',
                style: GoogleFonts.dmSans(
                  color: SlamTokens.textDim,
                  fontSize: 15,
                ),
              ),
            ),
          const Spacer(),
          AnimatedOpacity(
            duration: SlamTokens.dState,
            opacity: canProceed ? 1.0 : 0.4,
            child: GestureDetector(
              onTap: canProceed ? onNext : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                decoration: BoxDecoration(
                  gradient: canProceed ? SlamTokens.primaryGradient : null,
                  color: canProceed ? null : SlamTokens.surface,
                  borderRadius: BorderRadius.circular(SlamTokens.rCircle),
                  boxShadow: canProceed
                      ? [
                          BoxShadow(
                            color: SlamTokens.primary.withValues(alpha: 0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                            spreadRadius: -4,
                          )
                        ]
                      : null,
                ),
                child: isCompleting
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: SlamTokens.primaryOn,
                        ),
                      )
                    : Text(
                        isLast ? 'Fertig' : 'Weiter',
                        style: GoogleFonts.dmSans(
                          color: canProceed
                              ? SlamTokens.primaryOn
                              : SlamTokens.textDim,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step Heading Widget ─────────────────────────────────────────────────────

class _StepHeading extends StatelessWidget {
  const _StepHeading({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.fraunces(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: SlamTokens.text,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: GoogleFonts.dmSans(
            fontSize: 15,
            color: SlamTokens.textDim,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

// ── Step 0: Klasse & Kursart ────────────────────────────────────────────────

class _StepKlasse extends StatelessWidget {
  const _StepKlasse({
    required this.selectedGrade,
    required this.selectedCourseType,
    required this.grades,
    required this.upperGrades,
    required this.courseTypes,
    required this.onGradeChanged,
    required this.onCourseTypeChanged,
  });
  final String selectedGrade;
  final String selectedCourseType;
  final List<String> grades;
  final Set<String> upperGrades;
  final List<String> courseTypes;
  final ValueChanged<String> onGradeChanged;
  final ValueChanged<String> onCourseTypeChanged;

  @override
  Widget build(BuildContext context) {
    final showCourse = upperGrades.contains(selectedGrade);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(SlamTokens.gutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const _StepHeading(
            title: 'Erzähl uns von dir',
            subtitle: 'Wähle deine Klassenstufe, damit wir die richtigen\nAufgaben für dich finden.',
          ),
          const SizedBox(height: 32),
          Text(
            'Klassenstufe',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: SlamTokens.textDim,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: grades.map((g) {
              final label = g.replaceAll('Klasse_', 'Klasse ');
              final selected = g == selectedGrade;
              return _SelectChip(
                label: label,
                selected: selected,
                onTap: () => onGradeChanged(g),
              );
            }).toList(),
          ),
          if (showCourse) ...[
            const SizedBox(height: 28),
            Text(
              'Kursart',
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: SlamTokens.textDim,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            AnimatedOpacity(
              duration: SlamTokens.dState,
              opacity: 1.0,
              child: Wrap(
                spacing: 8,
                children: courseTypes.map((c) {
                  final selected = c == selectedCourseType;
                  return _SelectChip(
                    label: c,
                    selected: selected,
                    onTap: () => onCourseTypeChanged(c),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Step 1: Lernziele ───────────────────────────────────────────────────────

class _StepGoals extends StatelessWidget {
  const _StepGoals({
    required this.selectedGoals,
    required this.examDate,
    required this.goals,
    required this.onGoalToggled,
    required this.onExamDateChanged,
  });
  final Set<String> selectedGoals;
  final DateTime? examDate;
  final List<(String, String)> goals;
  final ValueChanged<String> onGoalToggled;
  final ValueChanged<DateTime?> onExamDateChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(SlamTokens.gutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const _StepHeading(
            title: 'Was ist dein Ziel?',
            subtitle: 'Wähle aus, was du in SLAM erreichen willst.\nMehrere Ziele sind möglich.',
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: goals.map(((String, String) goal) {
              final (key, label) = goal;
              final selected = selectedGoals.contains(key);
              return _SelectChip(
                label: label,
                selected: selected,
                onTap: () => onGoalToggled(key),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          Text(
            'Klausurdatum',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: SlamTokens.textDim,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: examDate ?? DateTime.now().add(const Duration(days: 14)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                builder: (ctx, child) => Theme(
                  data: Theme.of(ctx).copyWith(
                    colorScheme: ColorScheme.dark(
                      primary: SlamTokens.primary,
                      onPrimary: SlamTokens.primaryOn,
                      surface: SlamTokens.surface,
                      onSurface: SlamTokens.text,
                    ),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) onExamDateChanged(picked);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: SlamTokens.surface,
                borderRadius: BorderRadius.circular(SlamTokens.rInput),
                border: Border.all(
                  color: examDate != null
                      ? SlamTokens.primary.withValues(alpha: 0.5)
                      : SlamTokens.line,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: examDate != null
                        ? SlamTokens.primary
                        : SlamTokens.textDim,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    examDate != null
                        ? '${examDate!.day}.${examDate!.month}.${examDate!.year}'
                        : 'Optional auswählen',
                    style: GoogleFonts.dmSans(
                      color: examDate != null
                          ? SlamTokens.text
                          : SlamTokens.textDim,
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  if (examDate != null)
                    GestureDetector(
                      onTap: () => onExamDateChanged(null),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: SlamTokens.textDim,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step 2: Theme-Picker ────────────────────────────────────────────────────

class _StepTheme extends StatelessWidget {
  const _StepTheme({
    required this.selectedTheme,
    required this.themeOptions,
    required this.onThemeChanged,
  });
  final AppThemePreset selectedTheme;
  final List<(AppThemePreset, String, Color)> themeOptions;
  final ValueChanged<AppThemePreset> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(SlamTokens.gutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const _StepHeading(
            title: 'Dein Look',
            subtitle: 'Wähle eine Farbe für dein SLAM-Erlebnis.',
          ),
          const SizedBox(height: 36),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: themeOptions
                .map(((AppThemePreset, String, Color) opt) {
              final (preset, name, color) = opt;
              final selected = selectedTheme == preset;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onThemeChanged(preset);
                },
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: SlamTokens.dState,
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.5),
                                  blurRadius: 16,
                                  spreadRadius: -2,
                                )
                              ]
                            : null,
                        border: Border.all(
                          color: selected
                              ? SlamTokens.text.withValues(alpha: 0.8)
                              : Colors.transparent,
                          width: 2.5,
                        ),
                      ),
                      child: selected
                          ? const Icon(Icons.check, color: Colors.white, size: 22)
                          : null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: selected ? SlamTokens.text : SlamTokens.textDim,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Step 3: DSGVO ───────────────────────────────────────────────────────────

class _StepDsgvo extends StatelessWidget {
  const _StepDsgvo({required this.consented, required this.onConsentChanged});
  final bool consented;
  final ValueChanged<bool> onConsentChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(SlamTokens.gutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const _StepHeading(
            title: 'Datenschutz',
            subtitle: 'Kurze Info, bevor du loslegst.',
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: SlamTokens.surface,
              borderRadius: BorderRadius.circular(SlamTokens.rCardMd),
              border: Border.all(color: SlamTokens.line),
            ),
            child: Text(
              'SLAM speichert deine Lernfortschritte und Einstellungen in der Cloud, '
              'um dir ein adaptives Lernerlebnis zu bieten. Deine Daten werden '
              'ausschließlich zur Verbesserung deiner Lernergebnisse genutzt und '
              'nicht an Dritte weitergegeben.',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: SlamTokens.textDim,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => onConsentChanged(!consented),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: SlamTokens.dState,
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: consented ? SlamTokens.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: consented
                          ? SlamTokens.primary
                          : SlamTokens.textDim,
                      width: 1.5,
                    ),
                  ),
                  child: consented
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: SlamTokens.text,
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Ich habe die ',
                        ),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () => launchUrl(
                              Uri.parse('https://learn-smart.app/datenschutz'),
                            ),
                            child: Text(
                              'Datenschutzerklärung',
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                color: SlamTokens.primary,
                                decoration: TextDecoration.underline,
                                decorationColor: SlamTokens.primary,
                              ),
                            ),
                          ),
                        ),
                        const TextSpan(
                          text: ' gelesen und stimme der Verarbeitung meiner Daten zu.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared Chip Widget ──────────────────────────────────────────────────────

class _SelectChip extends StatelessWidget {
  const _SelectChip({
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
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: SlamTokens.dState,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? SlamTokens.primary.withValues(alpha: 0.15)
              : SlamTokens.surface,
          borderRadius: BorderRadius.circular(SlamTokens.rOption),
          border: Border.all(
            color: selected
                ? SlamTokens.primary.withValues(alpha: 0.6)
                : SlamTokens.line,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            color: selected ? SlamTokens.primary : SlamTokens.textDim,
          ),
        ),
      ),
    );
  }
}
