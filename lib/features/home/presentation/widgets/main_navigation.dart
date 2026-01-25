import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../live_feed/presentation/screens/live_feed_screen.dart';
import '../../../apps/presentation/screens/apps_hub_screen.dart';
import '../../../gamification/presentation/screens/progress_screen.dart';

/// Main Navigation with 3 tabs: Feed, Apps, Progress
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
    ProgressScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            icon: Icon(PhosphorIconsRegular.rss),
            selectedIcon: Icon(PhosphorIconsFill.rss),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(PhosphorIconsRegular.sparkle),
            selectedIcon: Icon(PhosphorIconsFill.sparkle),
            label: 'Apps',
          ),
          NavigationDestination(
            icon: Icon(PhosphorIconsRegular.chartLine),
            selectedIcon: Icon(PhosphorIconsFill.chartLine),
            label: 'Fortschritt',
          ),
        ],
      ),
    );
  }
}
