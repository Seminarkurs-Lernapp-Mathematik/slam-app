import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/learning_plan_providers.dart';
import '../../../../shared/widgets/glass_panel.dart';

/// Topic Selection Tree
class TopicTree extends ConsumerWidget {
  const TopicTree({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTopics = ref.watch(selectedTopicsProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildLeitidee(
          context,
          ref,
          'Algebra',
          Icons.functions,
          [
            'Lineare Gleichungen',
            'Quadratische Gleichungen',
            'Binomische Formeln',
            'Lineare Funktionen',
          ],
          selectedTopics,
        ),
        const SizedBox(height: 8),
        _buildLeitidee(
          context,
          ref,
          'Analysis',
          Icons.show_chart,
          [
            'Ableitungsregeln',
            'Kurvendiskussion',
            'Stammfunktionen',
            'Flächenberechnung',
          ],
          selectedTopics,
        ),
        const SizedBox(height: 8),
        _buildLeitidee(
          context,
          ref,
          'Geometrie',
          Icons.hexagon,
          [
            'Trigonometrie',
            'Vektorrechnung',
            'Geraden und Ebenen',
          ],
          selectedTopics,
        ),
        const SizedBox(height: 8),
        _buildLeitidee(
          context,
          ref,
          'Stochastik',
          Icons.bar_chart,
          [
            'Wahrscheinlichkeitsrechnung',
            'Normalverteilung',
            'Statistik',
          ],
          selectedTopics,
        ),
      ],
    );
  }

  Widget _buildLeitidee(
    BuildContext context,
    WidgetRef ref,
    String title,
    IconData icon,
    List<String> topics,
    Set<String> selectedTopics,
  ) {
    final theme = Theme.of(context);

    return GlassPanel(
      child: ExpansionTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: topics.map((topic) {
          final isSelected = selectedTopics.contains(topic);

          return CheckboxListTile(
            title: Text(topic),
            value: isSelected,
            onChanged: (_) =>
                ref.read(selectedTopicsProvider.notifier).toggle(topic),
            controlAffinity: ListTileControlAffinity.leading,
          );
        }).toList(),
      ),
    );
  }
}
