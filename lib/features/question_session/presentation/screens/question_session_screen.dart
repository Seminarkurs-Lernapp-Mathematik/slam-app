import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/question_session_providers.dart';

/// Question Session Screen - Main Learning Flow
///
/// This screen is a placeholder for the full question session flow.
/// Actual adaptive learning happens in the Live Feed.
class QuestionSessionScreen extends ConsumerStatefulWidget {
  final String sessionId;

  const QuestionSessionScreen({
    super.key,
    required this.sessionId,
  });

  @override
  ConsumerState<QuestionSessionScreen> createState() =>
      _QuestionSessionScreenState();
}

class _QuestionSessionScreenState extends ConsumerState<QuestionSessionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentQuestionIndexProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        title: const Text('Fragen-Session'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.go('/settings'),
            tooltip: 'Einstellungen',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu_book_outlined,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Fragen werden im Live Feed generiert',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Gehe zum Lernplan, um Themen auszuwählen, und nutze dann den Live Feed für adaptive Fragen.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => context.go('/lernplan'),
                icon: const Icon(Icons.add),
                label: const Text('Lernplan öffnen'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => context.go('/home'),
                icon: const Icon(Icons.rss_feed),
                label: const Text('Zum Live Feed'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
