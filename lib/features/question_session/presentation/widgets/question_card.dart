import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../providers/question_session_providers.dart';
import '../../../../shared/widgets/glass_panel.dart';

/// Question Card Widget with LaTeX Support
class QuestionCard extends ConsumerWidget {
  final Map<String, dynamic> question;
  final int questionIndex;

  const QuestionCard({
    super.key,
    required this.question,
    required this.questionIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionText = question['text'] as String? ?? '';
    final latexFormula = question['latex'] as String?;

    return GlassPanel(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Text
            Text(
              questionText,
              style: Theme.of(context).textTheme.titleLarge,
            ),

            // LaTeX Formula (if present)
            if (latexFormula != null) ...[
              const SizedBox(height: 16),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Math.tex(
                    latexFormula,
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Answer Input
            TextField(
              onChanged: (value) {
                ref.read(currentAnswerProvider.notifier).setAnswer(value);
              },
              decoration: InputDecoration(
                labelText: 'Deine Antwort',
                hintText: 'Gib deine Antwort ein...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.edit),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      ),
    );
  }
}
