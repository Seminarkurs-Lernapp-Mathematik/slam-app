import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/learning_plan_providers.dart';
import '../widgets/topic_tree.dart';
import '../widgets/smart_learning_toggle.dart';
import '../../../../shared/widgets/glass_panel.dart';

/// Learning Plan Screen - Topic Selection and Question Generation
class LearningPlanScreen extends ConsumerWidget {
  const LearningPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTopics = ref.watch(selectedTopicsProvider);
    final smartMode = ref.watch(smartLearningModeProvider);
    final isGenerating = ref.watch(isGeneratingQuestionsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.go('/settings'),
            tooltip: 'Einstellungen',
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Smart Learning Toggle
              Padding(
                padding: const EdgeInsets.all(16),
                child: SmartLearningToggle(
                  value: smartMode,
                  onChanged: (value) =>
                      ref.read(smartLearningModeProvider.notifier).set(value),
                ),
              ),

              // Selected Topics Count
              if (selectedTopics.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GlassPanel(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${selectedTopics.length} ${selectedTopics.length == 1 ? 'Thema' : 'Themen'} ausgewählt',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () =>
                                ref.read(selectedTopicsProvider.notifier).clear(),
                            child: const Text('Zurücksetzen'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Topic Tree
              const Expanded(
                child: TopicTree(),
              ),
            ],
          ),

          // Loading Overlay
          if (isGenerating)
            Container(
              color: Colors.black54,
              child: Center(
                child: GlassPanel(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          'Fragen werden generiert...',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Dies kann bis zu 30 Sekunden dauern',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: selectedTopics.isNotEmpty && !isGenerating
          ? FloatingActionButton.extended(
              onPressed: () => _generateQuestions(context, ref),
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Fragen generieren'),
            )
          : null,
    );
  }

  Future<void> _generateQuestions(BuildContext context, WidgetRef ref) async {
    final selectedTopics = ref.read(selectedTopicsProvider);
    final smartMode = ref.read(smartLearningModeProvider);

    // Set loading state
    ref.read(isGeneratingQuestionsProvider.notifier).set(true);

    try {
      // TODO: Implement full AI question generation
      // For now, just navigate to a placeholder session
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      // Navigate to question session (placeholder)
      if (context.mounted) {
        context.go('/question-session/demo-session-id');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Generieren: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      // Reset loading state
      ref.read(isGeneratingQuestionsProvider.notifier).set(false);
    }
  }
}
