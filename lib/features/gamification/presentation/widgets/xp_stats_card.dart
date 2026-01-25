import 'package:flutter/material.dart';

import '../../../../core/models/user_stats.dart';
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

    return GlassPanel(
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
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
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
    );
  }

  /// Build Progress Bar
  Widget _buildProgressBar(
    BuildContext context,
    UserStats stats,
    ThemeData theme,
  ) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutCubic,
            tween: Tween<double>(
              begin: 0.0,
              end: stats.progressToNextLevel,
            ),
            builder: (context, value, child) {
              return Stack(
                children: [
                  // Background
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  // Progress
                  FractionallySizedBox(
                    widthFactor: value,
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.secondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
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

    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
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
