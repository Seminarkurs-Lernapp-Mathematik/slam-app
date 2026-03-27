import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/topic_catalog.dart';
import '../../../../core/models/lernplan.dart';
import '../../../../core/services/ai_service.dart';
import '../../../../shared/widgets/glass_panel.dart';
import '../providers/lernplan_providers.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (GoRouter.of(context).canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
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
                      const _UploadSection(),
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

    // Filter out corrupted topics (with all empty fields) and auto-delete them
    final validTopics = topics.where((topic) {
      final isValid = topic.leitidee.isNotEmpty || 
                      topic.thema.isNotEmpty || 
                      topic.unterthema.isNotEmpty;
      if (!isValid) {
        // Auto-delete corrupted topic
        ref.read(lernplanNotifierProvider.notifier).removeTopic(topic);
        debugPrint('Auto-deleted corrupted topic with empty fields');
      }
      return isValid;
    }).toList();

    if (validTopics.isEmpty && topics.isNotEmpty) {
      // All topics were corrupted and deleted
      return GlassPanel(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.cleaning_services,
                size: 48, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Korrupte Daten bereinigt',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Ungültige Themen wurden automatisch entfernt.',
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
        children: validTopics.map((topic) {
          // Use unique key based on all topic fields plus timestamp
          final uniqueKey = 'topic_${topic.uniqueKey}_${topic.hashCode}';
          return Dismissible(
            key: ValueKey(uniqueKey),
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
          addedAt: DateTime.now(), // Will be set by Firestore service
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

}

/// Image upload section — picks a photo of a topic list and uses the AI
/// to extract topics and add them to the Lernplan automatically.
class _UploadSection extends ConsumerStatefulWidget {
  const _UploadSection();

  @override
  ConsumerState<_UploadSection> createState() => _UploadSectionState();
}

class _UploadSectionState extends ConsumerState<_UploadSection> {
  bool _isLoading = false;

  Future<void> _pickAndAnalyze(ImageSource source) async {
    final picker = ImagePicker();
    XFile? file;
    try {
      file = await picker.pickImage(source: source, imageQuality: 85);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kamera/Galerie-Zugriff fehlgeschlagen: $e')),
        );
      }
      return;
    }
    if (file == null) return;

    setState(() => _isLoading = true);
    try {
      final bytes = await file.readAsBytes();
      final aiService = ref.read(aiServiceProvider);
      final result = await aiService.analyzeImage(
        imageBytes: bytes,
        analysisType: 'learning_plan',
      );

      if (!mounted) return;

      if (result.topics.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Keine Themen erkannt. Versuche ein klareres Foto.')),
        );
        return;
      }

      // Map returned topic strings to LernplanTopic objects by searching catalog
      final matched = <LernplanTopic>[];
      for (final topicName in result.topics) {
        final lower = topicName.toLowerCase();
        for (final leitidee in topicCatalog) {
          for (final thema in leitidee.themen) {
            for (final unterthema in thema.unterthemen) {
              if (unterthema.toLowerCase().contains(lower) ||
                  lower.contains(unterthema.toLowerCase())) {
                matched.add(LernplanTopic(
                  leitidee: leitidee.name,
                  thema: thema.name,
                  unterthema: unterthema,
                  source: 'image_upload',
                  addedAt: DateTime.now(),
                ));
              }
            }
          }
        }
      }

      if (matched.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'KI hat folgende Themen erkannt, aber konnte sie nicht zuordnen: ${result.topics.join(', ')}',
            ),
            duration: const Duration(seconds: 6),
          ),
        );
        return;
      }

      await ref.read(lernplanNotifierProvider.notifier).addTopics(matched);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${matched.length} Themen zum Lernplan hinzugefügt!'),
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler bei der Analyse: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Themenliste hochladen (KI-basiert)',
          style: theme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
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
                  'Mache ein Foto von deiner Themenliste – die KI erkennt die Themen und fügt sie deinem Lernplan hinzu.',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton.icon(
                        onPressed: () => _pickAndAnalyze(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt, size: 18),
                        label: const Text('Foto aufnehmen'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () => _pickAndAnalyze(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library, size: 18),
                        label: const Text('Galerie'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
