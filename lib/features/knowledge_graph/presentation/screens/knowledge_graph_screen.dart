import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphview/graphview.dart';

import '../../../../app/design_tokens.dart';
import '../../../../core/constants/topic_catalog.dart';
import '../../../../core/models/topic.dart';
import '../../../../core/services/auth_service.dart';
import '../../data/topic_progress_projector.dart';
import '../providers/knowledge_graph_providers.dart';
import '../widgets/time_scrubber.dart';

// ============================================================================
// Subject color mapping
// ============================================================================

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

// ============================================================================
// Knowledge Graph Widget — embeddable in Profil tab
// ============================================================================

class KnowledgeGraphSection extends ConsumerStatefulWidget {
  const KnowledgeGraphSection({super.key});

  @override
  ConsumerState<KnowledgeGraphSection> createState() =>
      _KnowledgeGraphSectionState();
}

class _KnowledgeGraphSectionState
    extends ConsumerState<KnowledgeGraphSection> {
  final Graph _graph = Graph()..isTree = true;
  final BuchheimWalkerConfiguration _walkerConfig =
      BuchheimWalkerConfiguration()
        ..siblingSeparation = 24
        ..levelSeparation = 52
        ..subtreeSeparation = 24
        ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

  final Map<String, Node> _nodes = {};
  bool _graphBuilt = false;

  // Time-travel state
  TopicProgressProjector? _projector;
  DateTime? _selectedTime;
  Map<String, TopicProgress>? _projectedProgress;
  bool _historyLoading = false;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _buildGraph() {
    if (_graphBuilt) return;
    _graphBuilt = true;

    for (final leitideeGroup in topicCatalog) {
      final leitideeKey = leitideeGroup.name;
      final leiNode = Node.Id(leitideeKey);
      _nodes[leitideeKey] = leiNode;
      _graph.addNode(leiNode);

      for (final themaGroup in leitideeGroup.themen) {
        final themaKey = '$leitideeKey|${themaGroup.name}';
        final themaNode = Node.Id(themaKey);
        _nodes[themaKey] = themaNode;
        _graph.addEdge(leiNode, themaNode);

        for (final unterthema in themaGroup.unterthemen) {
          final unterKey = '$themaKey|$unterthema';
          final unterNode = Node.Id(unterKey);
          _nodes[unterKey] = unterNode;
          _graph.addEdge(themaNode, unterNode);
        }
      }
    }
  }

  Future<void> _ensureProjector() async {
    if (_projector != null) return;
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    _projector = TopicProgressProjector(user.uid);
    setState(() => _historyLoading = true);
    await _projector!.loadHistory();
    if (mounted) setState(() => _historyLoading = false);
  }

  void _onTimeSelected(DateTime? t) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 150), () async {
      if (!mounted) return;
      await _ensureProjector();
      if (_projector == null) return;

      final projected = t != null ? _projector!.at(t) : null;
      if (mounted) {
        setState(() {
          _selectedTime = t;
          _projectedProgress = projected;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final progressAsync = ref.watch(topicProgressMapProvider);

    return progressAsync.when(
      data: (realtimeProgress) {
        _buildGraph();
        final effectiveProgress = _projectedProgress ?? realtimeProgress;
        final firstDate = _projector?.firstEventTime;
        final activeDays = _projector?.activeDays ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GraphHeader(progress: effectiveProgress),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: _historyLoading
                  ? const Center(
                      child: CircularProgressIndicator(strokeWidth: 1.5))
                  : InteractiveViewer(
                      constrained: false,
                      boundaryMargin: const EdgeInsets.all(40),
                      minScale: 0.35,
                      maxScale: 2.0,
                      child: GraphView(
                        graph: _graph,
                        algorithm: BuchheimWalkerAlgorithm(
                            _walkerConfig, TreeEdgeRenderer(_walkerConfig)),
                        paint: Paint()
                          ..color = SlamTokens.line
                          ..strokeWidth = 1.0
                          ..style = PaintingStyle.stroke,
                        builder: (Node node) {
                          final key = node.key!.value as String;
                          final parts = key.split('|');
                          final level = parts.length - 1;
                          final leitidee = parts.first;
                          final tp = effectiveProgress[key];
                          return _TopicNode(
                            label: parts.last,
                            level: level,
                            subjectColor: _subjectColor(leitidee),
                            mastery: tp?.mastery ?? 0.0,
                            attempts: tp?.questionsCompleted ?? 0,
                          );
                        },
                      ),
                    ),
            ),
            const SizedBox(height: 12),
            // Time-travel scrubber — tap the history icon to expand
            _TimeTravelToggle(
              firstDate: firstDate,
              activeDays: activeDays,
              selectedTime: _selectedTime,
              onTimeSelected: _onTimeSelected,
              onExpand: _ensureProjector,
            ),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 260,
        child: Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

// ============================================================================
// Graph Header
// ============================================================================

class _GraphHeader extends StatelessWidget {
  final Map<String, TopicProgress> progress;
  const _GraphHeader({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: SlamTokens.primarySoft,
            borderRadius: BorderRadius.circular(12),
          ),
          child:
              Icon(Icons.hub_outlined, color: SlamTokens.primary, size: 18),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wissensgraph',
              style: GoogleFonts.fraunces(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: SlamTokens.text,
              ),
            ),
            Text(
              '${progress.length} Themen mit Fortschritt',
              style: GoogleFonts.dmSans(
                  fontSize: 12, color: SlamTokens.textDim),
            ),
          ],
        ),
        const Spacer(),
        _SubjectLegend(),
      ],
    );
  }
}

// ============================================================================
// Time-Travel Toggle — starts collapsed, tapping reveals the scrubber
// ============================================================================

class _TimeTravelToggle extends StatefulWidget {
  final DateTime? firstDate;
  final List<DateTime> activeDays;
  final DateTime? selectedTime;
  final ValueChanged<DateTime?> onTimeSelected;
  final Future<void> Function() onExpand;

  const _TimeTravelToggle({
    required this.firstDate,
    required this.activeDays,
    required this.selectedTime,
    required this.onTimeSelected,
    required this.onExpand,
  });

  @override
  State<_TimeTravelToggle> createState() => _TimeTravelToggleState();
}

class _TimeTravelToggleState extends State<_TimeTravelToggle> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () async {
            if (!_expanded) await widget.onExpand();
            setState(() => _expanded = !_expanded);
          },
          child: Row(
            children: [
              Icon(
                Icons.history_toggle_off,
                size: 14,
                color: _expanded
                    ? SlamTokens.primary
                    : SlamTokens.textMute,
              ),
              const SizedBox(width: 4),
              Text(
                'Zeitreise',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _expanded
                      ? SlamTokens.primary
                      : SlamTokens.textMute,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                _expanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 14,
                color: _expanded
                    ? SlamTokens.primary
                    : SlamTokens.textMute,
              ),
            ],
          ),
        ),
        if (_expanded && widget.firstDate != null) ...[
          const SizedBox(height: 8),
          TimeScrubber(
            firstDate: widget.firstDate!,
            activeDays: widget.activeDays,
            selectedTime: widget.selectedTime,
            onTimeSelected: widget.onTimeSelected,
          ),
        ],
        if (_expanded && widget.firstDate == null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Noch keine Lernhistorie vorhanden.',
              style: GoogleFonts.dmSans(
                  fontSize: 12, color: SlamTokens.textMute),
            ),
          ),
      ],
    );
  }
}

// ============================================================================
// Topic Node Widget
// ============================================================================

class _TopicNode extends StatelessWidget {
  final String label;
  final int level;
  final Color subjectColor;
  final double mastery;
  final int attempts;

  const _TopicNode({
    required this.label,
    required this.level,
    required this.subjectColor,
    required this.mastery,
    required this.attempts,
  });

  @override
  Widget build(BuildContext context) {
    const sizes = [52.0, 44.0, 36.0];
    const fontSizes = [10.0, 9.0, 8.0];
    final size = sizes[level.clamp(0, 2)];
    final fontSize = fontSizes[level.clamp(0, 2)];

    final fillAlpha = 0.10 + 0.70 * mastery;
    final borderAlpha = 0.25 + 0.75 * mastery;
    final hasMastery = mastery > 0.05;

    final labelText = label.length > 12 ? '${label.substring(0, 10)}…' : label;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: subjectColor.withValues(alpha: fillAlpha),
        border: Border.all(
          color: subjectColor.withValues(alpha: borderAlpha),
          width: hasMastery ? 1.5 : 1.0,
        ),
        boxShadow: hasMastery
            ? [
                BoxShadow(
                  color: subjectColor.withValues(alpha: mastery * 0.3),
                  blurRadius: 10,
                  spreadRadius: -2,
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Text(
          labelText,
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: subjectColor,
            height: 1.1,
          ),
          maxLines: 2,
          overflow: TextOverflow.clip,
        ),
      ),
    );
  }
}

// ============================================================================
// Subject Legend
// ============================================================================

class _SubjectLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final subjects = [
      ('A', SlamTokens.algebra),
      ('Ana', SlamTokens.analysis),
      ('G', SlamTokens.geometrie),
      ('S', SlamTokens.stochastik),
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: subjects.map((s) {
        return Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: s.$2.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: s.$2.withValues(alpha: 0.6)),
            ),
            alignment: Alignment.center,
            child: Text(
              s.$1,
              style: GoogleFonts.dmSans(
                fontSize: 6,
                fontWeight: FontWeight.w700,
                color: s.$2,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
