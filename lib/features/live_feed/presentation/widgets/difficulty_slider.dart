import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/design_tokens.dart';
import '../providers/live_feed_providers.dart';

/// AFB Level Selector — lets the user choose between the three
/// Anforderungsbereiche (German curriculum difficulty categories).
///
/// Internally maps to the numeric difficulty provider:
///   AFB I   → 3.0  (Wiedergabe & Verständnis)
///   AFB II  → 6.0  (Anwendung & Verknüpfung)
///   AFB III → 9.0  (Problemlösung & Reflexion)
class DifficultySlider extends ConsumerWidget {
  const DifficultySlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final difficulty = ref.watch(liveFeedDifficultyProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final selected = _toAfb(difficulty);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school, color: cs.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Anforderungsbereich',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: _AfbLevel.values.map((level) {
              final isSelected = selected == level;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _AfbChip(
                    level: level,
                    selected: isSelected,
                    onTap: () => ref
                        .read(liveFeedDifficultyProvider.notifier)
                        .setDifficulty(level.difficulty),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Text(
            selected.description,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  static _AfbLevel _toAfb(double d) {
    if (d <= 4.5) return _AfbLevel.afbI;
    if (d <= 7.5) return _AfbLevel.afbII;
    return _AfbLevel.afbIII;
  }

  // Public helper for use by other widgets (e.g. feed_question_card).
  static String afbLabel(int difficulty) {
    if (difficulty <= 4) return 'AFB I';
    if (difficulty <= 7) return 'AFB II';
    return 'AFB III';
  }
}

enum _AfbLevel {
  afbI(3.0, 'AFB I', 'Wiedergabe & Verständnis', SlamTokens.accentGreen),
  afbII(6.0, 'AFB II', 'Anwendung & Verknüpfung', SlamTokens.accentAmber),
  afbIII(9.0, 'AFB III', 'Problemlösung & Reflexion', SlamTokens.accentRed);

  final double difficulty;
  final String label;
  final String description;
  final Color color;

  const _AfbLevel(this.difficulty, this.label, this.description, this.color);
}

class _AfbChip extends StatelessWidget {
  final _AfbLevel level;
  final bool selected;
  final VoidCallback onTap;

  const _AfbChip({
    required this.level,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? level.color.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? level.color : theme.colorScheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              level.label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: selected ? level.color : theme.colorScheme.onSurfaceVariant,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
