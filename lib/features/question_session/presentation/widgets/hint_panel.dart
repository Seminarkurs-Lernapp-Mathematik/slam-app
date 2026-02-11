import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/question_session_providers.dart';
import '../../../../shared/widgets/glass_panel.dart';
import '../../../../core/services/ai_service.dart'; // New import
import '../../../settings/presentation/providers/settings_providers.dart'; // New import
import '../../../../core/services/auth_service.dart'; // New import for userId

final customHintProvider = StateNotifierProvider.autoDispose<CustomHintNotifier, AsyncValue<String?>>((ref) {
  return CustomHintNotifier(ref);
});

class CustomHintNotifier extends StateNotifier<AsyncValue<String?>> {
  CustomHintNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> requestCustomHint({
    required String questionText,
    required String userAnswer,
    required int hintsUsed,
  }) async {
    state = const AsyncValue.loading();

    try {
      final appSettings = ref.read(appSettingsNotifierProvider);
      final aiProvider = appSettings.aiProvider;
      final selectedModel = appSettings.getActiveModel();
      final apiKey = aiProvider == 'claude'
          ? appSettings.claudeApiKey
          : appSettings.geminiApiKey;

      if (apiKey == null || apiKey.isEmpty) {
        throw Exception(
          'Kein API-Key konfiguriert. Bitte konfiguriere einen ${aiProvider == 'claude' ? 'Claude' : 'Gemini'} API-Key in den Einstellungen (Debug Panel).',
        );
      }

      final hint = await ref.read(aiServiceProvider).getCustomHint(
            questionText: questionText,
            userAnswer: userAnswer,
            hintsAlreadyUsed: hintsUsed,
            apiKey: apiKey,
            provider: aiProvider,
            selectedModel: selectedModel,
          );
      state = AsyncValue.data(hint);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Hint Panel Widget - 3-level hint system
///
/// This panel displays progressive hints for a question.
/// Hints are provided as a list of strings from the parent widget.
class HintPanel extends ConsumerWidget {
  final List<String> hints;

  const HintPanel({
    super.key,
    this.hints = const [],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hintsUsed = ref.watch(hintsUsedProvider);

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
              hint: hints.isNotEmpty ? hints[0] : 'Überlege dir die Grundlagen',
              isRevealed: hintsUsed >= 1,
              onReveal: () => _revealHint(ref, 1),
            ),

            const SizedBox(height: 12),

            // Hint Level 2
            _HintCard(
              level: 2,
              hint: hints.length > 1 ? hints[1] : 'Verwende eine passende Formel',
              isRevealed: hintsUsed >= 2,
              onReveal: () => _revealHint(ref, 2),
            ),

            const SizedBox(height: 12),

            // Hint Level 3
            _HintCard(
              level: 3,
              hint: hints.length > 2 ? hints[2] : 'Schritt für Schritt vorgehen',
              isRevealed: hintsUsed >= 3,
              onReveal: () => _revealHint(ref, 3),
            ),

            const SizedBox(height: 24),

            // Custom Hint Section
            _CustomHintSection(hints: hints),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _revealHint(WidgetRef ref, int level) {
    final currentHints = ref.read(hintsUsedProvider);
    if (currentHints < level) {
      ref.read(hintsUsedProvider.notifier).setLevel(level);
    }
  }
}

class _CustomHintSection extends ConsumerWidget {
  final List<String> hints;

  const _CustomHintSection({required this.hints});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customHintAsync = ref.watch(customHintProvider);
    final currentQuestion = ref.watch(currentQuestionProvider);
    final currentAnswer = ref.watch(currentAnswerProvider);
    final hintsUsedCount = ref.watch(hintsUsedProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: customHintAsync.isLoading
              ? null
              : () {
                  if (currentQuestion != null) {
                    ref.read(customHintProvider.notifier).requestCustomHint(
                          questionText: currentQuestion.questionText,
                          userAnswer: currentAnswer,
                          hintsUsed: hintsUsedCount,
                        );
                  }
                },
          icon: customHintAsync.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.auto_awesome),
          label: Text(
            customHintAsync.isLoading
                ? 'Individuelle Hilfe wird generiert...'
                : 'Individuelle Hilfe anfragen',
          ),
        ),
        if (customHintAsync.hasValue && customHintAsync.value != null) ...[
          const SizedBox(height: 12),
          GlassPanel(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'KI-Hilfe:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    customHintAsync.value!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        ],
        if (customHintAsync.hasError) ...[
          const SizedBox(height: 12),
          Text(
            'Fehler beim Abrufen der KI-Hilfe: ${customHintAsync.error}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
        ],
      ],
    );
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