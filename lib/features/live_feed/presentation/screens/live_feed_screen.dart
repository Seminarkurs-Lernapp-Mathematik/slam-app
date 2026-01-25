import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';

/// Live Feed Screen - Adaptive difficulty question stream
/// TODO: Implement full Live Feed functionality in Phase 4
class LiveFeedScreen extends ConsumerWidget {
  const LiveFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Feed'),
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsRegular.gear),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              PhosphorIconsRegular.rss,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Live Feed',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Coming soon in Phase 4',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => context.go('/learning-plan'),
              icon: const Icon(PhosphorIconsRegular.book),
              label: const Text('Neue Lernsession starten'),
            ),
          ],
        ),
      ),
    );
  }
}
