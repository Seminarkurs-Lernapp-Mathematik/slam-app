import 'package:flutter/material.dart';

import '../../../../core/models/user_stats.dart';
import '../../../../shared/animations/app_animations.dart';
import '../../../../shared/widgets/widgets.dart';

/// XP Stats Card Widget
///
/// Displays XP statistics and progress bar
class XPStatsCard extends StatelessWidget {
  final UserStats stats;

  const XPStatsCard({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SlideInUp(
      delay: const Duration(milliseconds: 60),
      child: GlassPanel(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Erfahrungspunkte',
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      '${stats.currentLevelXp} / ${stats.xpNeededForNextLevel} XP',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress Bar
          _buildProgressBar(context, stats, theme),
          const SizedBox(height: 20),

          // XP Stats Row
          Row(
            children: [
              Expanded(
                child: _buildXPStat(
                  context,
                  icon: Icons.trending_up,
                  label: 'Aktuell',
                  value: '${stats.xp} XP',
                  color: theme.colorScheme.primary,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
              ),
              Expanded(
                child: _buildXPStat(
                  context,
                  icon: Icons.adjust,
                  label: 'Nächstes Level',
                  value: '${stats.xpToNextLevel} XP',
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }

  /// Build Progress Bar
  Widget _buildProgressBar(
    BuildContext context,
    UserStats stats,
    ThemeData theme,
  ) {
    return Column(children: [
      SparkleOverlay(
        active: stats.progressToNextLevel > 0.8,
        color: theme.colorScheme.primary,
        child: AnimatedProgressBar(
          value: stats.progressToNextLevel,
          color: theme.colorScheme.primary,
          height: 12,
          showGlow: true,
        ),
      ),
      const SizedBox(height: 6),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('${(stats.progressToNextLevel * 100).toStringAsFixed(0)}%',
            style: TextStyle(fontSize: 10, color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700)),
        Text('Level ${stats.calculatedLevel + 1}',
            style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                fontWeight: FontWeight.w600)),
      ]),
    ]);
  }

  /// Build Single XP Stat
  Widget _buildXPStat(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    // Parse numeric value if possible for animated counter
    final numericStr = value.replaceAll(RegExp(r'[^0-9]'), '');
    final numericVal = int.tryParse(numericStr);
    final suffix = value.replaceAll(RegExp(r'[0-9]'), '').trim();

    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        numericVal != null
            ? AnimatedCounter(
                value: numericVal,
                suffix: suffix.isNotEmpty ? ' $suffix' : '',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              )
            : Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
