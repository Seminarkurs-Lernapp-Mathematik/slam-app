import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Apps Hub Screen - GeoGebra, KI-Labor, Content Library
/// TODO: Implement full Apps Hub functionality in Phase 5
class AppsHubScreen extends ConsumerStatefulWidget {
  const AppsHubScreen({super.key});

  @override
  ConsumerState<AppsHubScreen> createState() => _AppsHubScreenState();
}

class _AppsHubScreenState extends ConsumerState<AppsHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apps'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.functions),
              text: 'GeoGebra',
            ),
            Tab(
              icon: Icon(Icons.auto_awesome),
              text: 'KI-Labor',
            ),
            Tab(
              icon: Icon(Icons.folder),
              text: 'Meine Inhalte',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _PlaceholderTab(
            icon: Icons.functions,
            title: 'GeoGebra',
            subtitle: 'Coming soon in Phase 5',
          ),
          _PlaceholderTab(
            icon: Icons.auto_awesome,
            title: 'KI-Labor',
            subtitle: 'Coming soon in Phase 5',
          ),
          _PlaceholderTab(
            icon: Icons.folder,
            title: 'Meine Inhalte',
            subtitle: 'Coming soon in Phase 5',
          ),
        ],
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _PlaceholderTab({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
