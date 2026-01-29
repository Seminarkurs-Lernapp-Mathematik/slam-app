import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/widgets.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../../core/models/user_stats.dart';
import '../widgets/level_progress_circle.dart';
import '../widgets/xp_stats_card.dart';
import '../widgets/streak_calendar.dart';

/// Progress Screen
///
/// Displays user gamification stats:
/// - Level & XP Progress
/// - Streak Calendar
/// - Statistics Overview
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentUser = ref.watch(currentUserProvider);
    final userId = currentUser?.uid ?? '';

    // Watch User Stats Stream
    final userStatsAsync = ref.watch(
      userStatsStreamProvider(userId),
    );

    return Scaffold(
      body: userStatsAsync.when(
        data: (stats) => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Level Progress Circle
                LevelProgressCircle(stats: stats),
                const SizedBox(height: 24),

                // XP Stats Card
                XPStatsCard(stats: stats),
                const SizedBox(height: 24),

                // Streak Section
                GlassPanel(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.local_fire_department,
                              color: theme.colorScheme.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Streak',
                                style: theme.textTheme.titleMedium,
                              ),
                              Text(
                                '${stats.streak} ${stats.streak == 1 ? "Tag" : "Tage"} in Folge',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      StreakCalendar(stats: stats),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Streak Freezes Section
                GlassPanel(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.ac_unit,
                              color: Colors.blue,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Streak Freezes',
                                style: theme.textTheme.titleMedium,
                              ),
                              Text(
                                '${stats.streakFreezes} verfügbar',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          FilledButton.icon(
                            onPressed: stats.totalXp >= 100
                                ? () => _purchaseStreakFreeze(context, ref, userId, stats)
                                : null,
                            icon: const Icon(Icons.add_shopping_cart, size: 18),
                            label: const Text('100 XP'),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Streak Freezes schützen deine Streak vor dem Ablaufen. '
                        'Kaufe sie für 100 XP und nutze sie, wenn du einen Tag verpasst hast.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Statistics Overview
                _buildStatsGrid(context, stats, theme),
                const SizedBox(height: 24),

                // Level Info Card
                _buildLevelInfoCard(context, stats, theme),
              ],
            ),
          ),
        ),
        loading: () => const Center(
          child: LoadingIndicator(message: 'Lade Fortschritt...'),
        ),
        error: (error, stack) => Center(
          child: ErrorMessage(
            message: 'Fehler beim Laden: ${error.toString()}',
            onRetry: () => ref.invalidate(userStatsStreamProvider),
          ),
        ),
      ),
    );
  }

  /// Build Statistics Grid
  Widget _buildStatsGrid(
    BuildContext context,
    dynamic stats,
    ThemeData theme,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.star,
            title: 'Total XP',
            value: stats.totalXp.toString(),
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.emoji_events,
            title: 'Level',
            value: stats.level.toString(),
            color: theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  /// Build Single Stat Card
  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return GlassPanel.inactive(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build Level Info Card
  Widget _buildLevelInfoCard(
    BuildContext context,
    dynamic stats,
    ThemeData theme,
  ) {
    return GlassPanel.accent(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.military_tech,
                color: theme.colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stats.levelTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      'Level ${stats.level}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildLevelReward(context, stats, theme),
        ],
      ),
    );
  }

  /// Build Level Reward Info
  Widget _buildLevelReward(
    BuildContext context,
    dynamic stats,
    ThemeData theme,
  ) {
    if (stats.isMaxLevel) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.workspace_premium,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Maximales Level erreicht! 🎉',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.card_giftcard,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Noch ${stats.xpNeededForNextLevel} XP bis Level ${stats.level + 1}',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  /// Purchase Streak Freeze (costs 100 XP)
  Future<void> _purchaseStreakFreeze(
    BuildContext context,
    WidgetRef ref,
    String userId,
    UserStats currentStats,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Streak Freeze kaufen'),
        content: const Text(
          'Möchtest du einen Streak Freeze für 100 XP kaufen?\n\n'
          'Streak Freezes schützen deine Streak, wenn du einen Tag verpasst.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text('Kaufen'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final updatedStats = currentStats.purchaseStreakFreeze();

        await ref.read(firestoreServiceProvider).updateUserStats(userId, updatedStats);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Streak Freeze gekauft! ❄️'),
              backgroundColor: Colors.blue,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fehler: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}

/// Provider for User Stats Stream
final userStatsStreamProvider =
    StreamProvider.autoDispose.family((ref, String userId) {
  if (userId.isEmpty) {
    // Return initial stats for empty userId (not logged in)
    return Stream.value(UserStats.initial());
  }

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.userStatsStream(userId);
});
