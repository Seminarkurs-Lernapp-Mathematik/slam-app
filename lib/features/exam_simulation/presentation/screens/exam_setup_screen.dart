import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';

import '../../../../app/design_tokens.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/topic_catalog.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../shared/widgets/glass_panel.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import 'exam_session_screen.dart';

class ExamSetupScreen extends ConsumerStatefulWidget {
  const ExamSetupScreen({super.key});

  @override
  ConsumerState<ExamSetupScreen> createState() => _ExamSetupScreenState();
}

class _ExamSetupScreenState extends ConsumerState<ExamSetupScreen> {
  int _selectedDuration = 60;
  final Set<String> _selectedTopics = {};
  bool _isLoading = false;
  String? _errorMessage;

  static const _durations = [45, 60, 90, 180];

  @override
  void initState() {
    super.initState();
    // Pre-select topics from learning plan (first 3)
    _preselectFromLernplan();
  }

  void _preselectFromLernplan() {
    for (final group in topicCatalog.take(2)) {
      for (final thema in group.themen.take(1)) {
        if (thema.unterthemen.isNotEmpty) {
          _selectedTopics.add('${group.name}|${thema.name}|${thema.unterthemen.first}');
        }
      }
    }
  }

  Future<void> _startExam() async {
    if (_selectedTopics.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final settings = ref.read(appSettingsNotifierProvider);
      final user = ref.read(currentUserProvider);
      if (user == null) throw Exception('Not authenticated');

      final token = await user.getIdToken();
      final dio = Dio(BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        receiveTimeout: const Duration(seconds: 120),
      ));

      final response = await dio.post(
        ApiEndpoints.generateExam,
        data: {
          'topics': _selectedTopics.toList(),
          'gradeLevel': settings.gradeLevel,
          'courseType': settings.courseType,
          'durationMinutes': _selectedDuration,
          'examFormat': 'klausur',
        },
      );

      final examData = (response.data['exam'] as Map<String, dynamic>);
      final questions = (examData['questions'] as List<dynamic>)
          .map((q) => ExamQuestion.fromMap(q as Map<String, dynamic>))
          .toList();

      if (!mounted) return;
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ExamSessionScreen(
          questions: questions,
          durationMinutes: _selectedDuration,
          totalPoints: (examData['totalPoints'] as num?)?.toInt() ?? 0,
        ),
      ));
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'Fehler beim Generieren: ${e.toString()}');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SlamTokens.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Prüfungs\nsimulation',
                style: GoogleFonts.fraunces(
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                  color: SlamTokens.text,
                  letterSpacing: -0.8,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Bereite dich auf die Klausur vor.',
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  color: SlamTokens.textDim,
                ),
              ),
              const SizedBox(height: 28),

              // Duration picker
              GlassPanel(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dauer',
                      style: GoogleFonts.fraunces(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: SlamTokens.text,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _durations.map((d) {
                        final selected = d == _selectedDuration;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedDuration = d),
                          child: AnimatedContainer(
                            duration: SlamTokens.dState,
                            curve: SlamTokens.curveStandard,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(
                              color: selected
                                  ? SlamTokens.primarySoft
                                  : SlamTokens.surface,
                              borderRadius:
                                  BorderRadius.circular(SlamTokens.rOption),
                              border: Border.all(
                                color: selected
                                    ? SlamTokens.primary
                                    : SlamTokens.line,
                                width: selected ? 1.5 : 1.0,
                              ),
                            ),
                            child: Text(
                              d >= 60 ? '${d ~/ 60} h ${d % 60 > 0 ? "${d % 60} min" : ""}'.trim() : '$d min',
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: selected
                                    ? SlamTokens.primary
                                    : SlamTokens.text,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Topic selector
              GlassPanel(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Themen',
                          style: GoogleFonts.fraunces(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: SlamTokens.text,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${_selectedTopics.length} ausgewählt',
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: SlamTokens.textDim,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: topicCatalog.expand((leitideeGroup) {
                        return leitideeGroup.themen.expand((thema) {
                          return thema.unterthemen.map((unter) {
                            final key =
                                '${leitideeGroup.name}|${thema.name}|$unter';
                            final selected = _selectedTopics.contains(key);
                            final subjectColor =
                                _subjectColor(leitideeGroup.name);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (selected) {
                                    _selectedTopics.remove(key);
                                  } else {
                                    _selectedTopics.add(key);
                                  }
                                });
                              },
                              child: AnimatedContainer(
                                duration: SlamTokens.dState,
                                curve: SlamTokens.curveStandard,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? subjectColor.withValues(alpha: 0.15)
                                      : SlamTokens.surface,
                                  borderRadius:
                                      BorderRadius.circular(SlamTokens.rOption),
                                  border: Border.all(
                                    color: selected
                                        ? subjectColor.withValues(alpha: 0.6)
                                        : SlamTokens.line,
                                  ),
                                ),
                                child: Text(
                                  unter,
                                  style: GoogleFonts.dmSans(
                                    fontSize: 12,
                                    fontWeight: selected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color:
                                        selected ? subjectColor : SlamTokens.textDim,
                                  ),
                                ),
                              ),
                            );
                          });
                        });
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,
                  style: GoogleFonts.dmSans(
                      fontSize: 13, color: SlamTokens.danger),
                ),
                const SizedBox(height: 12),
              ],

              GradientButton(
                text: 'Klausur generieren',
                onPressed: _selectedTopics.isEmpty ? null : _startExam,
                isLoading: _isLoading,
                icon: Icons.edit_document,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _subjectColor(String leitidee) {
  switch (leitidee) {
    case 'Algebra':
      return SlamTokens.algebra;
    case 'Analysis':
      return SlamTokens.analysis;
    case 'Geometrie':
      return SlamTokens.geometrie;
    case 'Stochastik':
      return SlamTokens.stochastik;
    default:
      return SlamTokens.primary;
  }
}
