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
      appBar: AppBar(
        title: const Text('Dein Fortschritt'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings (Phase 3)
            },
            tooltip: 'Einstellungen',
          ),
        ],
      ),
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
