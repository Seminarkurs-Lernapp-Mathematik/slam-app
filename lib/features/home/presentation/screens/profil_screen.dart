import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../gamification/presentation/screens/progress_screen.dart';
import '../../../gamification/presentation/widgets/level_progress_circle.dart';
import '../../../gamification/presentation/widgets/xp_stats_card.dart';
import '../../../gamification/presentation/widgets/streak_calendar.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../shared/widgets/glass_panel.dart';

/// Profil Screen - Combines progress display with quick actions
class ProfilScreen extends ConsumerWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Profile Header with Actions
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Profile Avatar and Name
                  _buildProfileHeader(context, currentUser?.displayName ?? currentUser?.email ?? 'Benutzer'),

                  const SizedBox(height: 16),

                  // Quick Action Buttons
                  _buildQuickActions(context),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Progress Content (embedded from ProgressScreen)
          SliverToBoxAdapter(
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: _EmbeddedProgressContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, String name) {
    final theme = Theme.of(context);

    return GlassPanel(
      child: InkWell(
        onTap: () => _showProfileDialog(context, name),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              // Avatar
              Hero(
                tag: 'profile-avatar',
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    name.substring(0, 1).toUpperCase(),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Name and Email
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Profil anzeigen',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              // Profile icon
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProfileDialog(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (context) => _ProfileStatisticsDialog(name: name),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            context,
            icon: Icons.dashboard_customize,
            label: 'App Center',
            onTap: () => _showCommandCenter(context),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionCard(
            context,
            icon: Icons.settings,
            label: 'Einstellungen',
            onTap: () => context.go('/settings'),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GlassPanel(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCommandCenter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _CommandCenterSheet(),
    );
  }
}

/// Embedded Progress Content (reuses Progress Screen content)
class _EmbeddedProgressContent extends ConsumerWidget {
  const _EmbeddedProgressContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final userId = currentUser?.uid ?? '';

    // Watch User Stats Stream from progress screen
    final userStatsAsync = ref.watch(userStatsStreamProvider(userId));

    return userStatsAsync.when(
      data: (stats) => _ProgressContent(stats: stats),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Fehler beim Laden: ${error.toString()}'),
      ),
    );
  }
}

/// Profile Statistics Dialog
class _ProfileStatisticsDialog extends ConsumerWidget {
  final String name;

  const _ProfileStatisticsDialog({required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentUser = ref.watch(currentUserProvider);
    final userId = currentUser?.uid ?? '';
    final userStatsAsync = ref.watch(userStatsStreamProvider(userId));

    return AlertDialog(
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Text(
              name.substring(0, 1).toUpperCase(),
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: userStatsAsync.when(
        data: (stats) => SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStatRow(context, 'Level', stats.calculatedLevel.toString(), Icons.military_tech, theme.colorScheme.primary),
              const Divider(),
              _buildStatRow(context, 'Gesamt XP', stats.totalXp.toString(), Icons.star, Colors.amber),
              const Divider(),
              _buildStatRow(context, 'Streak', '${stats.streak} Tage', Icons.local_fire_department, Colors.deepOrange),
              const Divider(),
              _buildStatRow(context, 'Level Titel', stats.levelTitle, Icons.emoji_events, theme.colorScheme.secondary),
              const Divider(),
              _buildStatRow(context, 'Streak Freezes', stats.streakFreezes.toString(), Icons.ac_unit, Colors.blue),
            ],
          ),
        ),
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) => Text('Fehler: ${error.toString()}'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Schließen'),
        ),
      ],
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Progress Content Widget (extracted from ProgressScreen)
class _ProgressContent extends ConsumerWidget {
  final dynamic stats;

  const _ProgressContent({required this.stats});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
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
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
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
                      Text('Streak', style: theme.textTheme.titleMedium),
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
      ],
    );
  }
}

/// Command Center Bottom Sheet
class _CommandCenterSheet extends ConsumerWidget {
  const _CommandCenterSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authService = ref.watch(authServiceProvider);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Row(
            children: [
              Icon(
                Icons.dashboard_customize,
                color: theme.colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'App Center',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Quick Actions Grid
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildActionButton(
                context,
                icon: Icons.auto_awesome,
                label: 'Neue Lernsession',
                color: theme.colorScheme.primary,
                onTap: () {
                  Navigator.of(context).pop();
                  context.go('/learning-plan');
                },
              ),
              _buildActionButton(
                context,
                icon: Icons.rss_feed,
                label: 'Live Feed',
                color: Colors.orange,
                onTap: () => Navigator.of(context).pop(),
              ),
              _buildActionButton(
                context,
                icon: Icons.extension,
                label: 'Apps Hub',
                color: Colors.purple,
                onTap: () => Navigator.of(context).pop(),
              ),
              _buildActionButton(
                context,
                icon: Icons.psychology,
                label: 'KI-Labor',
                color: Colors.cyan,
                onTap: () {
                  Navigator.of(context).pop();
                  context.go('/apps/generative');
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Logout Button
          FilledButton.tonalIcon(
            onPressed: () async {
              await authService.signOut();
              if (context.mounted) {
                Navigator.of(context).pop();
                context.go('/login');
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text('Abmelden'),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.errorContainer,
              foregroundColor: theme.colorScheme.onErrorContainer,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: (MediaQuery.of(context).size.width - 72) / 2,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 12),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
