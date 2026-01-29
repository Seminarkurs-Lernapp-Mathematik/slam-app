import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../live_feed/presentation/screens/live_feed_screen.dart';
import '../../../apps/presentation/screens/apps_hub_screen.dart';
import '../screens/profil_screen.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../../core/models/user_stats.dart';
import '../../../../shared/widgets/glass_panel.dart';

/// Main Navigation with 3 tabs: Feed, Apps, Profil
class MainNavigation extends ConsumerStatefulWidget {
  const MainNavigation({super.key});

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> {
  int _selectedIndex = 0;

  // Keep screens alive with IndexedStack
  final _screens = const [
    LiveFeedScreen(),
    AppsHubScreen(),
    ProfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final userId = currentUser?.uid ?? '';

    // Watch User Stats Stream
    final userStatsAsync = ref.watch(
      userStatsStreamProvider(userId),
    );

    return Scaffold(
      appBar: AppBar(
        actions: [
          // User Stats Display
          userStatsAsync.when(
            data: (stats) => _buildUserStats(context, stats),
            loading: () => const SizedBox(width: 16),
            error: (_, __) => const SizedBox(width: 16),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.rss_feed_outlined),
            selectedIcon: Icon(Icons.rss_feed),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'Apps',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  /// Build User Stats Display in AppBar
  Widget _buildUserStats(BuildContext context, UserStats stats) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // XP
          _buildStatChip(
            context,
            icon: Icons.star,
            value: stats.totalXp.toString(),
            color: Colors.amber,
          ),
          const SizedBox(width: 8),

          // Level
          _buildStatChip(
            context,
            icon: Icons.military_tech,
            value: stats.level.toString(),
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),

          // Streak
          _buildStatChip(
            context,
            icon: Icons.local_fire_department,
            value: stats.streak.toString(),
            color: Colors.deepOrange,
          ),
        ],
      ),
    );
  }

  /// Build Individual Stat Chip
  Widget _buildStatChip(
    BuildContext context, {
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  /// Show Command Center Bottom Sheet
  void _showCommandCenter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _CommandCenterSheet(),
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
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
                'Command Center',
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

          // Quick Actions
          Text(
            'Schnellaktionen',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Action Buttons Grid
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildActionButton(
                context,
                icon: Icons.auto_awesome,
                label: 'Neue Lernsession',
                onTap: () {
                  Navigator.of(context).pop();
                  context.go('/learning-plan');
                },
              ),
              _buildActionButton(
                context,
                icon: Icons.rss_feed,
                label: 'Live Feed',
                onTap: () {
                  Navigator.of(context).pop();
                  // Already on home, just switch to tab 0
                },
              ),
              _buildActionButton(
                context,
                icon: Icons.extension,
                label: 'Apps',
                onTap: () {
                  Navigator.of(context).pop();
                  // Already on home, just switch to tab 1
                },
              ),
              _buildActionButton(
                context,
                icon: Icons.show_chart,
                label: 'Fortschritt',
                onTap: () {
                  Navigator.of(context).pop();
                  context.go('/progress');
                },
              ),
              _buildActionButton(
                context,
                icon: Icons.settings,
                label: 'Einstellungen',
                onTap: () {
                  Navigator.of(context).pop();
                  context.go('/settings');
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Recent Activity Section
          Text(
            'Letzte Aktivität',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          GlassPanel(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildActivityItem(
                    context,
                    icon: Icons.check_circle_outline,
                    title: 'Fragen beantwortet',
                    subtitle: 'Heute',
                    color: Colors.green,
                  ),
                  const Divider(height: 24),
                  _buildActivityItem(
                    context,
                    icon: Icons.star_outline,
                    title: '+25 XP verdient',
                    subtitle: 'Vor 2 Stunden',
                    color: Colors.amber,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Logout Button
          OutlinedButton.icon(
            onPressed: () async {
              await authService.signOut();
              if (context.mounted) {
                Navigator.of(context).pop();
                context.go('/login');
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text('Abmelden'),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              side: BorderSide(color: theme.colorScheme.error),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: (MediaQuery.of(context).size.width - 72) / 2,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Provider for User Stats Stream (same as in progress_screen.dart)
final userStatsStreamProvider =
    StreamProvider.autoDispose.family((ref, String userId) {
  if (userId.isEmpty) {
    // Return initial stats for empty userId (not logged in)
    return Stream.value(UserStats.initial());
  }

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.userStatsStream(userId);
});
