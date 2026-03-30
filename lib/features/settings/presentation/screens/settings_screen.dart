import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/settings_providers.dart';
import '../widgets/theme_selector.dart';
import '../widgets/memories_settings_section.dart';
import '../../../../core/services/auth_service.dart';

import '../../../live_feed/presentation/providers/live_feed_providers.dart';

/// Production Settings Screen
/// Simplified for production - AI configuration is backend-managed.

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar.large(
            title: const Text('Einstellungen'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/home'),
            ),
          ),
          
          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Theme Section
                _SectionHeader(
                  icon: Icons.palette,
                  title: 'Erscheinungsbild',
                  subtitle: 'Personalisiere dein Erlebnis',
                  color: colorScheme.tertiary,
                ),
                const SizedBox(height: 12),
                const ThemeSelector(),
                const SizedBox(height: 24),
                
                // Education Section
                _SectionHeader(
                  icon: Icons.school,
                  title: 'Bildung',
                  subtitle: 'Klassenstufe und Kursart',
                  color: Colors.green,
                ),
                const SizedBox(height: 12),
                const _EducationSettings(),
                const SizedBox(height: 24),
                
                // Data Section
                _SectionHeader(
                  icon: Icons.storage,
                  title: 'Daten',
                  subtitle: 'Cache und lokale Daten',
                  color: Colors.blueGrey,
                ),
                const SizedBox(height: 12),
                const _DataSettings(),
                const SizedBox(height: 24),

                // KI-Erinnerungen Section
                _SectionHeader(
                  icon: Icons.psychology,
                  title: 'KI-Erinnerungen',
                  subtitle: 'Präferenzen & Lerngedächtnis',
                  color: colorScheme.tertiary,
                ),
                const SizedBox(height: 12),
                const MemoriesSettingsSection(),
                const SizedBox(height: 24),

                // Account Actions
                _SectionHeader(
                  icon: Icons.account_circle,
                  title: 'Account',
                  subtitle: 'Verwalte deinen Account',
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 12),
                const _AccountActions(),
                const SizedBox(height: 48),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SECTION HEADER
// ============================================================================

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// EDUCATION SETTINGS
// ============================================================================

class _EducationSettings extends ConsumerWidget {
  const _EducationSettings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Grade Level
          Row(
            children: [
              Icon(Icons.grade, color: colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: settings.gradeLevel,
                  decoration: const InputDecoration(
                    labelText: 'Klassenstufe',
                    border: InputBorder.none,
                  ),
                  items: ['Klasse_5', 'Klasse_6', 'Klasse_7', 'Klasse_8', 'Klasse_9', 'Klasse_10', 'Klasse_11', 'Klasse_12', 'Klasse_13']
                      .map((g) => DropdownMenuItem(value: g, child: Text(g.replaceFirst('_', ' '))))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(appSettingsNotifierProvider.notifier).setGradeLevel(value);
                    }
                  },
                ),
              ),
            ],
          ),
          
          if (!['Klasse_5', 'Klasse_6', 'Klasse_7', 'Klasse_8', 'Klasse_9', 'Klasse_10'].contains(settings.gradeLevel)) ...[
            const Divider(height: 24),
            // Course Type
            Row(
              children: [
                Icon(Icons.menu_book, color: colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: ['Grundkurs', 'Leistungskurs'].contains(settings.courseType)
                        ? settings.courseType
                        : 'Leistungskurs',
                    decoration: const InputDecoration(
                      labelText: 'Kursart',
                      border: InputBorder.none,
                    ),
                    items: ['Grundkurs', 'Leistungskurs']
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(appSettingsNotifierProvider.notifier).setCourseType(value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// DATA SETTINGS
// ============================================================================

class _DataSettings extends ConsumerWidget {
  const _DataSettings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: const Icon(Icons.delete_sweep, color: Colors.orange),
        title: const Text('Fragen-Cache leeren'),
        subtitle: const Text('Löscht alle zwischengespeicherten Fragen'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          ref.read(liveFeedQueueProvider.notifier).clear();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fragen-Cache wurde geleert')),
          );
        },
      ),
    );
  }
}

// ============================================================================
// ACCOUNT ACTIONS
// ============================================================================

class _AccountActions extends ConsumerWidget {
  const _AccountActions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Abmelden'),
          subtitle: const Text('Von deinem Account abmelden'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => ref.read(authServiceProvider).signOut(),
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.delete_forever, color: colorScheme.error),
          title: Text('Account löschen', style: TextStyle(color: colorScheme.error)),
          subtitle: const Text('Dies kann nicht rückgängig gemacht werden'),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: colorScheme.error),
          onTap: () => _showDeleteAccountDialog(context, ref),
        ),
      ],
    );
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Account löschen?'),
        content: const Text(
          'Diese Aktion kann nicht rückgängig gemacht werden. Alle deine Daten werden permanent gelöscht.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await ref.read(authServiceProvider).deleteAccount();
              } catch (e) {
                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text('Fehler: $e')),
                );
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
  }
}
