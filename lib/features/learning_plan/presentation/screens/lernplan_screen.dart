import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/design_tokens.dart';
import '../../../../core/constants/topic_catalog.dart';
import '../../../../core/models/lernplan.dart';
import '../../../../core/services/ai_service.dart';
import '../../../../shared/widgets/glass_panel.dart';
import '../providers/lernplan_providers.dart';

class LernplanScreen extends ConsumerWidget {
  const LernplanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lernplanAsync = ref.watch(lernplanStreamProvider);

    return Scaffold(
      backgroundColor: SlamTokens.bg,
      body: lernplanAsync.when(
        data: (lernplan) {
          final validTopics = lernplan.topics
              .where((t) =>
                  t.leitidee.isNotEmpty ||
                  t.thema.isNotEmpty ||
                  t.unterthema.isNotEmpty)
              .toList();
          return _LernplanBody(activeTopics: validTopics);
        },
        loading: () =>
            Center(child: CircularProgressIndicator(color: SlamTokens.primary)),
        error: (error, _) => Center(
          child: Text('Fehler: $error',
              style: const TextStyle(color: SlamTokens.danger)),
        ),
      ),
    );
  }
}

class _LernplanBody extends ConsumerWidget {
  const _LernplanBody({required this.activeTopics});
  final List<LernplanTopic> activeTopics;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Header ──────────────────────────────────────────────
        SliverToBoxAdapter(
            child: _LernplanHeader(activeCount: activeTopics.length)),

        // ── Topic groups ─────────────────────────────────────────
        ...topicCatalog.map((leitidee) => SliverToBoxAdapter(
              child: _LeitideeSection(
                leitidee: leitidee,
                activeTopics: activeTopics,
              ),
            )),

        // ── Upload section ────────────────────────────────────────
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                SlamTokens.gutter, 8, SlamTokens.gutter, 32),
            child: _UploadSection(),
          ),
        ),
      ],
    );
  }
}

class _LernplanHeader extends StatelessWidget {
  const _LernplanHeader({required this.activeCount});
  final int activeCount;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            SlamTokens.gutter, 24, SlamTokens.gutter, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LERNPLAN',
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: SlamTokens.textDim,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Woran willst\ndu arbeiten?',
                    style: GoogleFonts.fraunces(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: SlamTokens.text,
                      letterSpacing: -0.8,
                      height: 1.05,
                    ),
                  ),
                ],
              ),
            ),
            if (activeCount > 0)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: SlamTokens.primarySoft,
                  borderRadius: BorderRadius.circular(SlamTokens.rCircle),
                ),
                child: Text(
                  '$activeCount aktiv',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: SlamTokens.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LeitideeSection extends ConsumerWidget {
  const _LeitideeSection({required this.leitidee, required this.activeTopics});
  final LeitideeGroup leitidee;
  final List<LernplanTopic> activeTopics;

  (Color, Color) get _colors {
    switch (leitidee.name) {
      case 'Algebra':
        return (SlamTokens.algebra, SlamTokens.algebraSoft);
      case 'Analysis':
        return (SlamTokens.analysis, SlamTokens.analysisSoft);
      case 'Geometrie':
        return (SlamTokens.geometrie, SlamTokens.geometrieSoft);
      case 'Stochastik':
        return (SlamTokens.stochastik, SlamTokens.stochastikSoft);
      default:
        return (SlamTokens.primary, SlamTokens.primarySoft);
    }
  }

  IconData get _icon {
    switch (leitidee.icon) {
      case IconType.functions:
        return Icons.functions;
      case IconType.showChart:
        return Icons.show_chart;
      case IconType.hexagon:
        return Icons.hexagon;
      case IconType.barChart:
        return Icons.bar_chart;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (hue, soft) = _colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          SlamTokens.gutter, 14, SlamTokens.gutter, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Leitidee label row
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(color: soft, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Icon(_icon, size: 16, color: hue),
              ),
              const SizedBox(width: 10),
              Text(
                leitidee.name,
                style: GoogleFonts.fraunces(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: SlamTokens.text,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Card with topic groups
          Container(
            decoration: BoxDecoration(
              color: SlamTokens.surface,
              borderRadius: BorderRadius.circular(SlamTokens.rCardMd),
              border: Border.all(color: SlamTokens.line),
            ),
            child: Column(
              children: leitidee.themen.asMap().entries.map((entry) {
                final i = entry.key;
                final thema = entry.value;
                return Column(
                  children: [
                    if (i > 0) const Divider(color: SlamTokens.line, height: 1),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            thema.name,
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: hue,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: thema.unterthemen.map((sub) {
                              final isSelected = activeTopics.any((t) =>
                                  t.leitidee == leitidee.name &&
                                  t.thema == thema.name &&
                                  t.unterthema == sub);
                              return _TopicChip(
                                label: sub,
                                isSelected: isSelected,
                                selectedColor: hue,
                                onTap: () {
                                  final topic = LernplanTopic(
                                    leitidee: leitidee.name,
                                    thema: thema.name,
                                    unterthema: sub,
                                    source: 'manual',
                                    addedAt: DateTime.now(),
                                  );
                                  if (isSelected) {
                                    ref
                                        .read(lernplanNotifierProvider.notifier)
                                        .removeTopic(topic);
                                  } else {
                                    ref
                                        .read(lernplanNotifierProvider.notifier)
                                        .addTopics([topic]);
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
  });
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: SlamTokens.dState,
        curve: SlamTokens.curveStandard,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 14 : 12,
          vertical: isSelected ? 9 : 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : SlamTokens.surfaceHi,
          borderRadius: BorderRadius.circular(SlamTokens.rCircle),
          border: Border.all(
            color: isSelected ? selectedColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          isSelected ? '✓ $label' : label,
          style: GoogleFonts.dmSans(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: isSelected ? SlamTokens.primaryOn : SlamTokens.textDim,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Upload Section (unchanged functionality, updated visuals)
// ─────────────────────────────────────────────────────────────────────────────

class _UploadSection extends ConsumerStatefulWidget {
  const _UploadSection();

  @override
  ConsumerState<_UploadSection> createState() => _UploadSectionState();
}

class _UploadSectionState extends ConsumerState<_UploadSection> {
  bool _isLoading = false;

  Future<void> _pickAndAnalyze(ImageSource source) async {
    final picker = ImagePicker();
    XFile? file;
    try {
      file = await picker.pickImage(source: source, imageQuality: 85);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kamera/Galerie-Zugriff fehlgeschlagen: $e')),
        );
      }
      return;
    }
    if (file == null) return;

    setState(() => _isLoading = true);
    try {
      final bytes = await file.readAsBytes();
      final aiService = ref.read(aiServiceProvider);
      final result = await aiService.analyzeImage(
        imageBytes: bytes,
        analysisType: 'learning_plan',
      );

      if (!mounted) return;

      if (result.topics.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Keine Themen erkannt. Versuche ein klareres Foto.')),
        );
        return;
      }

      final matched = <LernplanTopic>[];
      for (final topicName in result.topics) {
        final lower = topicName.toLowerCase();
        for (final leitidee in topicCatalog) {
          for (final thema in leitidee.themen) {
            for (final unterthema in thema.unterthemen) {
              if (unterthema.toLowerCase().contains(lower) ||
                  lower.contains(unterthema.toLowerCase())) {
                matched.add(LernplanTopic(
                  leitidee: leitidee.name,
                  thema: thema.name,
                  unterthema: unterthema,
                  source: 'image_upload',
                  addedAt: DateTime.now(),
                ));
              }
            }
          }
        }
      }

      if (matched.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'KI erkannte: ${result.topics.join(', ')} — keine Zuordnung möglich.'),
              duration: const Duration(seconds: 6),
            ),
          );
        }
        return;
      }

      await ref.read(lernplanNotifierProvider.notifier).addTopics(matched);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${matched.length} Themen hinzugefügt!'),
            backgroundColor: SlamTokens.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler bei der Analyse: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      color: SlamTokens.primarySoft, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Icon(Icons.camera_alt,
                      size: 16, color: SlamTokens.primary),
                ),
                const SizedBox(width: 10),
                Text(
                  'Themenliste hochladen',
                  style: GoogleFonts.fraunces(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: SlamTokens.text,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Mache ein Foto deiner Themenliste – die KI erkennt die Themen und fügt sie hinzu.',
              style: GoogleFonts.dmSans(
                  fontSize: 13, color: SlamTokens.textDim, height: 1.5),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              Center(
                  child: CircularProgressIndicator(color: SlamTokens.primary))
            else
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _pickAndAnalyze(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt, size: 16),
                      label: const Text('Foto aufnehmen'),
                      style:
                          FilledButton.styleFrom(shape: const StadiumBorder()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    onPressed: () => _pickAndAnalyze(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library, size: 16),
                    label: const Text('Galerie'),
                    style: OutlinedButton.styleFrom(
                      shape: const StadiumBorder(),
                      foregroundColor: SlamTokens.textDim,
                      side: const BorderSide(color: SlamTokens.line),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
