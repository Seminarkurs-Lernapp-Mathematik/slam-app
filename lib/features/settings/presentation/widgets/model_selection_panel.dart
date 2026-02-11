import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_providers.dart';
import '../../../../core/services/ai_service.dart';

/// Model Selection Panel
///
/// Allows users to select specific AI models for each task type
class ModelSelectionPanel extends ConsumerWidget {
  const ModelSelectionPanel({super.key});

  // Task definitions with display names
  static const Map<String, String> _taskDefinitions = {
    'questionGeneration': 'Fragenerstellung',
    'answerEvaluation': 'Antwortbewertung',
    'customHints': 'Individuelle Hinweise',
    'geogebraGeneration': 'GeoGebra-Generierung',
    'miniAppGeneration': 'Mini-App-Generierung',
    'imageAnalysis': 'Bildanalyse',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final modelsAsync = ref.watch(availableModelsProvider);
    final settings = ref.watch(appSettingsNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pro Task können verschiedene Modelle ausgewählt werden',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        modelsAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stack) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: theme.colorScheme.onErrorContainer,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Fehler beim Laden der Modelle: ${error.toString()}',
                    style: TextStyle(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          data: (models) {
            if (models.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Keine Modelle verfügbar'),
              );
            }

            return Column(
              children: _taskDefinitions.entries.map((entry) {
                final taskKey = entry.key;
                final taskName = entry.value;
                final selectedModelId = settings.getModelForTask(taskKey);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildTaskSelector(
                    context: context,
                    ref: ref,
                    theme: theme,
                    taskKey: taskKey,
                    taskName: taskName,
                    models: models.cast<ModelInfo>(),
                    selectedModelId: selectedModelId,
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTaskSelector({
    required BuildContext context,
    required WidgetRef ref,
    required ThemeData theme,
    required String taskKey,
    required String taskName,
    required List<ModelInfo> models,
    required String? selectedModelId,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          taskName,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedModelId,
              hint: const Text('Standard verwenden'),
              items: models.map((model) {
                return DropdownMenuItem<String>(
                  value: model.id,
                  child: Row(
                    children: [
                      _buildTierBadge(theme, model.tier),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              model.name,
                              style: theme.textTheme.bodyMedium,
                            ),
                            Text(
                              model.description,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(appSettingsNotifierProvider.notifier)
                      .setTaskModel(taskKey, value);
                }
              },
            ),
          ),
        ),
        if (selectedModelId != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 14,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                'Ausgewähltes Modell überschreibt Standardeinstellung',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTierBadge(ThemeData theme, String tier) {
    Color badgeColor;
    IconData icon;
    String label;

    switch (tier.toLowerCase()) {
      case 'fast':
        badgeColor = Colors.green;
        icon = Icons.flash_on;
        label = 'Fast';
        break;
      case 'standard':
        badgeColor = Colors.blue;
        icon = Icons.star;
        label = 'Standard';
        break;
      case 'smart':
        badgeColor = Colors.purple;
        icon = Icons.psychology;
        label = 'Smart';
        break;
      default:
        badgeColor = Colors.grey;
        icon = Icons.help_outline;
        label = tier;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: badgeColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
