import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_providers.dart';
import '../../../../shared/widgets/glass_panel.dart';

/// AI Configuration Panel - Provider, Detail Level, Temperature, Helpfulness
class AIConfigPanel extends ConsumerWidget {
  const AIConfigPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(aIConfigNotifierProvider);

    return GlassPanel(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.psychology, size: 20),
                const SizedBox(width: 8),
                Text(
                  'KI-Modell',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Provider Selection
            Center(
              child: SegmentedButton<AIProvider>(
                segments: const [
                  ButtonSegment(
                    value: AIProvider.claude,
                    label: Text('Claude'),
                    icon: Icon(Icons.psychology),
                  ),
                  ButtonSegment(
                    value: AIProvider.gemini,
                    label: Text('Gemini'),
                    icon: Icon(Icons.auto_awesome),
                  ),
                ],
                selected: {config.provider},
                onSelectionChanged: (Set<AIProvider> selection) {
                  ref.read(aIConfigNotifierProvider.notifier).setProvider(selection.first);
                },
              ),
            ),

            const SizedBox(height: 16),

            // Auto Button
            Center(
              child: OutlinedButton.icon(
                onPressed: () {
                  ref.read(aIConfigNotifierProvider.notifier).setDetailLevel(5);
                  ref.read(aIConfigNotifierProvider.notifier).setTemperature(0.7);
                  ref.read(aIConfigNotifierProvider.notifier).setHelpfulness(7);
                },
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Auto'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(120, 36),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Detail Level Slider
            _SliderSetting(
              label: 'Detailgrad',
              icon: Icons.format_list_numbered,
              value: config.detailLevel.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              displayValue: config.detailLevel.toString(),
              onChanged: (value) {
                ref.read(aIConfigNotifierProvider.notifier).setDetailLevel(value.toInt());
              },
            ),

            const SizedBox(height: 16),

            // Temperature Slider
            _SliderSetting(
              label: 'Kreativität',
              icon: Icons.palette,
              value: config.temperature,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              displayValue: config.temperature.toStringAsFixed(1),
              onChanged: (value) {
                ref.read(aIConfigNotifierProvider.notifier).setTemperature(value);
              },
            ),

            const SizedBox(height: 16),

            // Helpfulness Slider
            _SliderSetting(
              label: 'Hilfsbereitschaft',
              icon: Icons.handshake,
              value: config.helpfulness.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              displayValue: config.helpfulness.toString(),
              onChanged: (value) {
                ref.read(aIConfigNotifierProvider.notifier).setHelpfulness(value.toInt());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SliderSetting extends StatelessWidget {
  final String label;
  final IconData icon;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String displayValue;
  final ValueChanged<double> onChanged;

  const _SliderSetting({
    required this.label,
    required this.icon,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.displayValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                displayValue,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
