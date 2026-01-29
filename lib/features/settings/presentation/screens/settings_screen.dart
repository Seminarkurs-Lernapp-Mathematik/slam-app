import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/theme_selector.dart';
import '../widgets/ai_config_panel.dart';
import '../widgets/education_settings.dart';
import '../widgets/account_settings.dart';
import '../widgets/debug_panel.dart';

/// Settings Screen - Theme, AI Config, Account Settings
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Selection
          Text(
            'Erscheinungsbild',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          const ThemeSelector(),

          const SizedBox(height: 32),

          // AI Configuration
          Text(
            'KI-Einstellungen',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          const AIConfigPanel(),

          const SizedBox(height: 32),

          // Education Settings
          Text(
            'Bildungseinstellungen',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          const EducationSettings(),

          const SizedBox(height: 32),

          // Account Settings
          Text(
            'Account',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          const AccountSettings(),

          const SizedBox(height: 32),

          // Debug / Developer Settings
          Text(
            'Debug / Developer',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
          ),
          const SizedBox(height: 12),
          const DebugPanel(),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
