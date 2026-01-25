import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/question_session_providers.dart';
import '../../../../shared/widgets/glass_panel.dart';

/// Hint Panel Widget - 3-level hint system
class HintPanel extends ConsumerWidget {
  const HintPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentQuestionIndexProvider);
    final demoQuestions = ref.watch(demoQuestionsProvider);
    final hintsUsed = ref.watch(hintsUsedProvider);
    final currentQuestion = demoQuestions[currentIndex];
    final hints = currentQuestion['hints'] as List<dynamic>? ?? [];

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      builder: (_, controller) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(
          controller: controller,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Hilfen',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            Text(
              'Hilfen kosten jeweils -5 XP',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Hint Level 1
            _HintCard(
              level: 1,
              hint: hints.isNotEmpty ? hints[0] as String : 'Überlege dir die Grundlagen',
              isRevealed: hintsUsed >= 1,
              onReveal: () => _revealHint(ref, 1),
            ),

            const SizedBox(height: 12),

            // Hint Level 2
            _HintCard(
              level: 2,
              hint: hints.length > 1 ? hints[1] as String : 'Verwende eine passende Formel',
              isRevealed: hintsUsed >= 2,
              onReveal: () => _revealHint(ref, 2),
            ),

            const SizedBox(height: 12),

            // Hint Level 3
            _HintCard(
              level: 3,
              hint: hints.length > 2 ? hints[2] as String : 'Schritt für Schritt vorgehen',
              isRevealed: hintsUsed >= 3,
              onReveal: () => _revealHint(ref, 3),
            ),

            const SizedBox(height: 24),

            // Custom Hint Button (TODO: Implement AI-powered hints)
            OutlinedButton.icon(
              onPressed: null, // TODO: Implement custom hint request
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Individuelle Hilfe anfragen'),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _revealHint(WidgetRef ref, int level) {
    final currentHints = ref.read(hintsUsedProvider);
    if (currentHints < level) {
      ref.read(hintsUsedProvider.notifier).state = level;
    }
  }
}

class _HintCard extends StatelessWidget {
  final int level;
  final String hint;
  final bool isRevealed;
  final VoidCallback onReveal;

  const _HintCard({
    required this.level,
    required this.hint,
    required this.isRevealed,
    required this.onReveal,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isRevealed
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$level',
                      style: TextStyle(
                        color: isRevealed ? Colors.white : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Hilfe $level',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                if (!isRevealed)
                  TextButton.icon(
                    onPressed: onReveal,
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('-5 XP'),
                  ),
              ],
            ),
            if (isRevealed) ...[
              const SizedBox(height: 12),
              Text(
                hint,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
