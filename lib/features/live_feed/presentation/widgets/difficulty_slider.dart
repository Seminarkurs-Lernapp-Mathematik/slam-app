import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/live_feed_providers.dart';

/// Difficulty Slider Widget - 1-10 scale with visual feedback
class DifficultySlider extends ConsumerWidget {
  const DifficultySlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final difficulty = ref.watch(liveFeedDifficultyProvider);

    // Color based on difficulty
    final color = _getDifficultyColor(difficulty);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.adjust, color: color, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Schwierigkeitsgrad',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${difficulty.toStringAsFixed(1)} / 10',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              thumbColor: color,
              overlayColor: color.withValues(alpha: 0.2),
              inactiveTrackColor: color.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: difficulty,
              min: 1.0,
              max: 10.0,
              divisions: 18, // 0.5 increments
              label: difficulty.toStringAsFixed(1),
              onChanged: (value) {
                ref.read(liveFeedDifficultyProvider.notifier).setDifficulty(value);
              },
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getDifficultyLabel(1),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              Text(
                _getDifficultyLabel(difficulty),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                _getDifficultyLabel(10),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(double difficulty) {
    if (difficulty <= 3) {
      return const Color(0xFF10b981); // Green (easy)
    } else if (difficulty <= 6) {
      return const Color(0xFFf59e0b); // Amber (medium)
    } else if (difficulty <= 8) {
      return const Color(0xFFf97316); // Orange (hard)
    } else {
      return const Color(0xFFef4444); // Red (extreme)
    }
  }

  String _getDifficultyLabel(double difficulty) {
    if (difficulty <= 3) {
      return 'Leicht';
    } else if (difficulty <= 6) {
      return 'Mittel';
    } else if (difficulty <= 8) {
      return 'Schwer';
    } else {
      return 'Extrem';
    }
  }
}
