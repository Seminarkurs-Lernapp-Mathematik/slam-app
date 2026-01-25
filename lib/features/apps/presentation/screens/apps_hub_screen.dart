import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'geogebra_screen.dart';
import 'generative_apps_screen.dart';
import 'content_library_screen.dart';

/// Apps Hub Screen - GeoGebra, KI-Labor, Content Library
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
    return Column(
      children: [
        TabBar(
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
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              GeogebraScreen(),
              GenerativeAppsScreen(),
              ContentLibraryScreen(),
            ],
          ),
        ),
      ],
    );
  }
}
