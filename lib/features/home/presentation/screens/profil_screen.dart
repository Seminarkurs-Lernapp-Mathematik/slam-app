import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../gamification/presentation/screens/progress_screen.dart';
import '../../../gamification/presentation/widgets/level_progress_circle.dart';
import '../../../gamification/presentation/widgets/xp_stats_card.dart';
import '../../../gamification/presentation/widgets/streak_calendar.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../../gamification/presentation/screens/progress_screen.dart' show userStatsStreamProvider;
import '../../../../core/services/auth_service.dart';
import '../../../../shared/widgets/glass_panel.dart';

/// Profil Screen - Combines progress display with quick actions
class ProfilScreen extends ConsumerWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final settings = ref.watch(appSettingsNotifierProvider);
    final userId = currentUser?.uid ?? '';
    final userStatsAsync = ref.watch(userStatsStreamProvider(userId));

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

                  // Streak risk warning & exam countdown
                  userStatsAsync.whenData((stats) {
                    final today = DateTime.now().toIso8601String().substring(0, 10);
                    final atRisk = stats.streak > 0 && stats.isStreakAtRisk(today);
                    return Column(
                      children: [
                        if (atRisk) ...[
                          _StreakRiskBanner(streak: stats.streak),
                          const SizedBox(height: 12),
                        ],
                        if (settings.examDate != null) ...[
                          _ExamCountdownCard(examDate: settings.examDate!),
                          const SizedBox(height: 12),
                        ],
                      ],
                    );
                  }).value ?? const SizedBox.shrink(),

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
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.menu_book,
                label: 'Lernplan',
                onTap: () => context.go('/lernplan'),
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
        ),

      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool highlight = false,
  }) {
    final theme = Theme.of(context);

    if (highlight) {
      return FilledButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          textStyle: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      );
    }

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


// ============================================================================
// STREAK RISK BANNER
// ============================================================================

class _StreakRiskBanner extends StatelessWidget {
  final int streak;

  const _StreakRiskBanner({required this.streak});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department, color: Colors.orange, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Streak in Gefahr! 🔥',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade800,
                  ),
                ),
                Text(
                  '$streak-Tage-Streak – beantworte heute noch eine Frage!',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// EXAM COUNTDOWN CARD
// ============================================================================

class _ExamCountdownCard extends StatelessWidget {
  final DateTime examDate;

  const _ExamCountdownCard({required this.examDate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final diff = examDate.difference(DateTime(now.year, now.month, now.day));
    final days = diff.inDays;

    if (days < 0) return const SizedBox.shrink(); // Past date

    Color cardColor;
    String urgencyText;
    if (days <= 7) {
      cardColor = Colors.red;
      urgencyText = 'Letzte Chance zum Üben!';
    } else if (days <= 30) {
      cardColor = Colors.orange;
      urgencyText = 'Jetzt intensiv üben!';
    } else {
      cardColor = theme.colorScheme.primary;
      urgencyText = 'Bleib dran!';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cardColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cardColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.event, color: cardColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  days == 0
                      ? 'Prüfung: Heute!'
                      : days == 1
                          ? 'Prüfung: Morgen!'
                          : 'Noch $days Tage bis zur Prüfung',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cardColor,
                  ),
                ),
                Text(
                  urgencyText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cardColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$days',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: cardColor,
            ),
          ),
        ],
      ),
    );
  }
}
