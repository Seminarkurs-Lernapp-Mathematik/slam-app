import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../live_feed/presentation/screens/live_feed_screen.dart';
import '../../../apps/presentation/screens/apps_hub_screen.dart';
import '../screens/profil_screen.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../../core/models/user_stats.dart';

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
          // Coins (tappable, opens shop)
          GestureDetector(
            onTap: () => context.go('/shop'),
            child: _buildStatChip(
              context,
              icon: Icons.monetization_on,
              value: _formatNumber(stats.coins),
              color: Colors.amber.shade700,
              showBorder: true,
            ),
          ),
          const SizedBox(width: 8),

          // XP
          _buildStatChip(
            context,
            icon: Icons.star,
            value: _formatNumber(stats.totalXp),
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

  /// Format number with K suffix for large values
  String _formatNumber(int number) {
    if (number >= 10000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  /// Build Individual Stat Chip
  Widget _buildStatChip(
    BuildContext context, {
    required IconData icon,
    required String value,
    required Color color,
    bool showBorder = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: showBorder ? 0.5 : 0.3),
          width: showBorder ? 1.5 : 1,
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
