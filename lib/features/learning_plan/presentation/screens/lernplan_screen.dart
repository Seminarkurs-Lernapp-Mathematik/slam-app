import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/topic_catalog.dart';
import '../../../../shared/widgets/glass_panel.dart';
import '../providers/lernplan_providers.dart';
import '../../../../core/models/lernplan.dart';

/// Lernplan Screen
/// Allows users to manage their learning plan by adding/removing topics.
class LernplanScreen extends ConsumerWidget {
  const LernplanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final lernplanAsync = ref.watch(lernplanStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lernplan'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: lernplanAsync.when(
        data: (lernplan) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dein aktueller Lernplan',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Wähle Themen aus, zu denen du im Feed Fragen erhalten möchtest.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildCurrentLernplan(context, ref, lernplan.topics),
                      const SizedBox(height: 24),
                      _buildAddTopicsSection(context, ref),
                      const SizedBox(height: 24),
                      _buildUploadSection(context, theme),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Fehler beim Laden des Lernplans: $error'),
        ),
      ),
    );
  }

  Widget _buildCurrentLernplan(
      BuildContext context, WidgetRef ref, List<LernplanTopic> topics) {
    final theme = Theme.of(context);

    if (topics.isEmpty) {
      return GlassPanel(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.lightbulb_outline,
                size: 48, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Noch keine Themen hinzugefügt',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Füge Themen hinzu, um im Feed Fragen zu erhalten!',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return GlassPanel(
      padding: EdgeInsets.zero,
      child: Column(
        children: topics.map((topic) {
          return Dismissible(
            key: ValueKey(
                '${topic.leitidee}-${topic.thema}-${topic.unterthema}'),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: theme.colorScheme.errorContainer,
              child: Icon(Icons.delete_forever,
                  color: theme.colorScheme.onErrorContainer),
            ),
            onDismissed: (direction) {
              ref.read(lernplanNotifierProvider.notifier).removeTopic(topic);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${topic.unterthema} aus Lernplan entfernt'),
                  backgroundColor: theme.colorScheme.tertiary,
                ),
              );
            },
            child: ListTile(
              title: Text(topic.unterthema),
              subtitle: Text('${topic.leitidee} > ${topic.thema}'),
              trailing: const Icon(Icons.arrow_back, size: 18),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAddTopicsSection(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Themen manuell hinzufügen',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GlassPanel(
          child: ExpansionTile(
            leading: Icon(Icons.functions, color: theme.colorScheme.primary),
            title: Text(
              'Algebra',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            children: _buildTopicCheckboxes(context, ref, 'Algebra', LeitideeGroup(name: 'Algebra', icon: IconType.functions, themen: topicCatalog[0].themen)),
          ),
        ),
        const SizedBox(height: 8),
        GlassPanel(
          child: ExpansionTile(
            leading: Icon(Icons.show_chart, color: theme.colorScheme.primary),
            title: Text(
              'Analysis',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            children: _buildTopicCheckboxes(context, ref, 'Analysis', LeitideeGroup(name: 'Analysis', icon: IconType.showChart, themen: topicCatalog[1].themen)),
          ),
        ),
        const SizedBox(height: 8),
        GlassPanel(
          child: ExpansionTile(
            leading: Icon(Icons.hexagon, color: theme.colorScheme.primary),
            title: Text(
              'Geometrie',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            children: _buildTopicCheckboxes(context, ref, 'Geometrie', LeitideeGroup(name: 'Geometrie', icon: IconType.hexagon, themen: topicCatalog[2].themen)),
          ),
        ),
        const SizedBox(height: 8),
        GlassPanel(
          child: ExpansionTile(
            leading: Icon(Icons.bar_chart, color: theme.colorScheme.primary),
            title: Text(
              'Stochastik',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            children: _buildTopicCheckboxes(context, ref, 'Stochastik', LeitideeGroup(name: 'Stochastik', icon: IconType.barChart, themen: topicCatalog[3].themen)),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTopicCheckboxes(
    BuildContext context,
    WidgetRef ref,
    String leitideeName,
    LeitideeGroup leitideeGroup,
  ) {
    final currentLernplanTopics = ref.watch(lernplanStreamProvider).valueOrNull?.topics ?? [];
    return leitideeGroup.themen.expand((thema) {
      return thema.unterthemen.map((unterthema) {
        final topic = LernplanTopic(
          leitidee: leitideeName,
          thema: thema.name,
          unterthema: unterthema,
          source: 'manual',
          addedAtTimestamp: 0, // Will be set by Firestore service
        );
        final isSelected = currentLernplanTopics.any((t) =>
            t.leitidee == topic.leitidee &&
            t.thema == topic.thema &&
            t.unterthema == topic.unterthema);

        return CheckboxListTile(
          title: Text(unterthema),
          subtitle: Text(thema.name),
          value: isSelected,
          onChanged: (bool? newValue) {
            if (newValue == true) {
              ref.read(lernplanNotifierProvider.notifier).addTopics([topic]);
            } else {
              ref.read(lernplanNotifierProvider.notifier).removeTopic(topic);
            }
          },
          controlAffinity: ListTileControlAffinity.leading,
        );
      });
    }).toList();
  }

  Widget _buildUploadSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Themenliste hochladen (KI-basiert)',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GlassPanel(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(Icons.camera_alt,
                    size: 48, color: theme.colorScheme.secondary),
                const SizedBox(height: 16),
                Text(
                  'Mache ein Foto von deiner Themenliste, und wir helfen dir, deinen Lernplan zu erstellen!',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () {
                    // Placeholder for image upload functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Funktion noch nicht implementiert')),
                    );
                  },
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Themenliste hochladen'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
