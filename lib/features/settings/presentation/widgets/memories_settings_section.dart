import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/memory.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';
import '../providers/memory_providers.dart';
import '../providers/settings_providers.dart';

/// "KI-Erinnerungen" settings section.
///
/// Two sub-sections:
///  1. Meine Präferenzen — user-written free-text instructions for the AI.
///  2. Lerngedächtnis   — auto-generated spaced-repetition memory entries.
class MemoriesSettingsSection extends ConsumerStatefulWidget {
  const MemoriesSettingsSection({super.key});

  @override
  ConsumerState<MemoriesSettingsSection> createState() =>
      _MemoriesSettingsSectionState();
}

class _MemoriesSettingsSectionState
    extends ConsumerState<MemoriesSettingsSection> {
  final _prefController = TextEditingController();
  bool _addingPref = false;

  @override
  void dispose() {
    _prefController.dispose();
    super.dispose();
  }

  void _submitPreference() {
    final text = _prefController.text.trim();
    if (text.isNotEmpty) {
      ref.read(appSettingsNotifierProvider.notifier).addAiPreference(text);
      _prefController.clear();
    }
    setState(() => _addingPref = false);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final preferences = ref.watch(appSettingsNotifierProvider).aiPreferences;
    final memoriesAsync = ref.watch(userMemoriesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Preferences ────────────────────────────────────────────────────
        _SubHeader(
          icon: Icons.tune,
          label: 'Meine Präferenzen',
          color: colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Diese Anweisungen werden bei jeder Fragengenerierung an die KI weitergegeben.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 12),
              if (preferences.isEmpty && !_addingPref)
                Text(
                  'Noch keine Präferenzen gespeichert.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  for (final pref in preferences)
                    Chip(
                      label: Text(
                        pref,
                        style: const TextStyle(fontSize: 13),
                      ),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => ref
                          .read(appSettingsNotifierProvider.notifier)
                          .removeAiPreference(pref),
                    ),
                ],
              ),
              if (_addingPref) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _prefController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'z. B. Ich bevorzuge kurze, präzise Fragen',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _submitPreference(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      icon: const Icon(Icons.check),
                      onPressed: _submitPreference,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _prefController.clear();
                        setState(() => _addingPref = false);
                      },
                    ),
                  ],
                ),
              ] else ...[
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () => setState(() => _addingPref = true),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Präferenz hinzufügen'),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 20),

        // ── Memories ───────────────────────────────────────────────────────
        _SubHeader(
          icon: Icons.history_edu,
          label: 'Lerngedächtnis',
          color: colorScheme.secondary,
        ),
        const SizedBox(height: 8),
        memoriesAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (e, _) => Text(
            'Fehler beim Laden: $e',
            style: TextStyle(color: colorScheme.error),
          ),
          data: (memories) => _MemoriesContent(memories: memories),
        ),
      ],
    );
  }
}

// ============================================================================
// MEMORIES LIST
// ============================================================================

class _MemoriesContent extends ConsumerWidget {
  final List<Memory> memories;

  const _MemoriesContent({required this.memories});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final userId = ref.watch(currentUserProvider)?.uid;

    if (memories.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              Icons.psychology_outlined,
              size: 40,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'Noch keine Erinnerungen',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Beantworte Fragen im Live-Feed, damit die KI deinen Lernfortschritt merkt.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              for (int i = 0; i < memories.length; i++) ...[
                if (i > 0) const Divider(height: 1, indent: 16, endIndent: 16),
                _MemoryTile(
                  memory: memories[i],
                  userId: userId ?? '',
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (userId != null)
          OutlinedButton.icon(
            onPressed: () => _confirmDeleteAll(context, ref, userId),
            icon: const Icon(Icons.delete_sweep, color: Colors.red),
            label: const Text(
              'Alle Erinnerungen löschen',
              style: TextStyle(color: Colors.red),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
            ),
          ),
      ],
    );
  }

  void _confirmDeleteAll(BuildContext context, WidgetRef ref, String userId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Alle Erinnerungen löschen?'),
        content: const Text(
          'Die KI wird deinen bisherigen Lernfortschritt vergessen. '
          'Neue Erinnerungen werden beim Beantworten von Fragen automatisch angelegt.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref
                  .read(firestoreServiceProvider)
                  .deleteAllMemories(userId);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Alles löschen'),
          ),
        ],
      ),
    );
  }
}

class _MemoryTile extends ConsumerWidget {
  final Memory memory;
  final String userId;

  const _MemoryTile({required this.memory, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final dueLabel = _dueLabel(memory.nextReviewAt);
    final isDue = memory.nextReviewAt.isBefore(DateTime.now());

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        memory.subtopic.isNotEmpty ? memory.subtopic : memory.topic,
        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          Text(
            memory.topic,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
          _QualityDots(quality: memory.lastQuality ?? 0),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isDue
                  ? colorScheme.errorContainer
                  : colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              dueLabel,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isDue
                    ? colorScheme.onErrorContainer
                    : colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: Icon(Icons.delete_outline,
                size: 20, color: colorScheme.onSurfaceVariant),
            onPressed: () => ref.read(firestoreServiceProvider).deleteMemory(
                  userId: userId,
                  memoryId: memory.id,
                ),
          ),
        ],
      ),
    );
  }

  String _dueLabel(DateTime nextReview) {
    final now = DateTime.now();
    final diff = nextReview.difference(now);
    if (diff.isNegative || diff.inHours < 1) return 'Jetzt fällig';
    if (diff.inDays == 0) return 'Heute';
    if (diff.inDays == 1) return 'Morgen';
    return 'In ${diff.inDays} Tagen';
  }
}

// Five small coloured dots showing SM-2 quality 0-5
class _QualityDots extends StatelessWidget {
  final int quality;
  const _QualityDots({required this.quality});

  @override
  Widget build(BuildContext context) {
    const total = 5;
    final filled = quality.clamp(0, total);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        final active = i < filled;
        return Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? _qualityColor(quality)
                : Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withValues(alpha: 0.25),
          ),
        );
      }),
    );
  }

  Color _qualityColor(int q) {
    if (q <= 1) return Colors.red;
    if (q <= 2) return Colors.orange;
    if (q <= 3) return Colors.amber;
    if (q == 4) return Colors.lightGreen;
    return Colors.green;
  }
}

// ============================================================================
// SUB-HEADER
// ============================================================================

class _SubHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SubHeader({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
      ],
    );
  }
}
