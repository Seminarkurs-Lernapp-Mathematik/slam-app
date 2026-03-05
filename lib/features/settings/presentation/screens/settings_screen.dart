import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/settings_providers.dart';
import '../widgets/theme_selector.dart';
import '../widgets/model_selection_panel.dart';
import '../../../../core/services/auth_service.dart';

/// Modern Settings Screen - Unified, performant, beautiful
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _claudeKeyController = TextEditingController();
  final _geminiKeyController = TextEditingController();
  final _openrouterKeyController = TextEditingController();
  final _backendUrlController = TextEditingController();

  bool _claudeVisible = false;
  bool _geminiVisible = false;
  bool _openrouterVisible = false;
  bool _isDeveloperExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    final appSettings = ref.read(appSettingsNotifierProvider);
    final debugConfig = ref.read(debugConfigNotifierProvider);
    
    _claudeKeyController.text = appSettings.claudeApiKey ?? '';
    _geminiKeyController.text = appSettings.geminiApiKey ?? '';
    _openrouterKeyController.text = appSettings.openrouterApiKey ?? '';
    _backendUrlController.text = debugConfig.backendUrl;
  }

  @override
  void dispose() {
    _claudeKeyController.dispose();
    _geminiKeyController.dispose();
    _openrouterKeyController.dispose();
    _backendUrlController.dispose();
    super.dispose();
  }

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
                // AI Provider Section
                _SectionHeader(
                  icon: Icons.smart_toy,
                  title: 'KI-Anbieter',
                  subtitle: 'Wähle deinen bevorzugten KI-Dienst',
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 12),
                const _AIProviderSelector(),
                const SizedBox(height: 24),
                
                // Model Mode Section
                _SectionHeader(
                  icon: Icons.speed,
                  title: 'Modus',
                  subtitle: 'Geschwindigkeit vs. Qualität',
                  color: colorScheme.secondary,
                ),
                const SizedBox(height: 12),
                const _ModelModeSelector(),
                const SizedBox(height: 24),

                // Per-Task Model Selection
                _SectionHeader(
                  icon: Icons.tune,
                  title: 'Modellauswahl',
                  subtitle: 'Spezifisches Modell pro Aufgabentyp',
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 12),
                const _ModelSelector(),
                const SizedBox(height: 24),

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
                
                // API Keys Section (Collapsible)
                _SectionHeader(
                  icon: Icons.key,
                  title: 'API-Schlüssel',
                  subtitle: 'Verwalte deine API-Zugänge',
                  color: Colors.orange,
                ),
                const SizedBox(height: 12),
                _APIKeysSection(
                  claudeController: _claudeKeyController,
                  geminiController: _geminiKeyController,
                  openrouterController: _openrouterKeyController,
                  claudeVisible: _claudeVisible,
                  geminiVisible: _geminiVisible,
                  openrouterVisible: _openrouterVisible,
                  onClaudeVisibilityChanged: (v) => setState(() => _claudeVisible = v),
                  onGeminiVisibilityChanged: (v) => setState(() => _geminiVisible = v),
                  onOpenrouterVisibilityChanged: (v) => setState(() => _openrouterVisible = v),
                ),
                const SizedBox(height: 24),
                
                // Developer Section (Collapsible)
                _ExpandableSection(
                  title: 'Entwickleroptionen',
                  icon: Icons.developer_mode,
                  isExpanded: _isDeveloperExpanded,
                  onToggle: () => setState(() => _isDeveloperExpanded = !_isDeveloperExpanded),
                  child: _DeveloperSection(
                    backendUrlController: _backendUrlController,
                  ),
                ),
                const SizedBox(height: 32),
                
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
// AI PROVIDER SELECTOR
// ============================================================================

class _AIProviderSelector extends ConsumerWidget {
  const _AIProviderSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;
    
    final providers = [
      (
        id: 'gemini',
        name: 'Gemini',
        icon: Icons.auto_awesome,
        color: Colors.blue,
        description: 'Google\'s KI-Modelle',
      ),
      (
        id: 'claude',
        name: 'Claude',
        icon: Icons.psychology,
        color: Colors.orange,
        description: 'Anthropic\'s KI-Modelle',
      ),
      (
        id: 'openrouter',
        name: 'OpenRouter',
        icon: Icons.router,
        color: Colors.purple,
        description: 'Kostenlose Modelle',
      ),
    ];
    
    return Column(
      children: providers.map((provider) {
        final isSelected = settings.aiProvider == provider.id;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _SelectCard(
            isSelected: isSelected,
            onTap: () => ref.read(aIConfigNotifierProvider.notifier)
                .setProvider(AIProvider.values.firstWhere((p) => p.name == provider.id)),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: provider.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(provider.icon, color: provider.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? colorScheme.primary : null,
                        ),
                      ),
                      Text(
                        provider.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle, color: colorScheme.primary),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ============================================================================
// MODEL MODE SELECTOR
// ============================================================================

class _ModelModeSelector extends ConsumerWidget {
  const _ModelModeSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;
    
    final modes = [
      (id: 'fast', name: 'Schnell', icon: Icons.bolt, desc: 'Schnelle Antworten'),
      (id: 'standard', name: 'Standard', icon: Icons.balance, desc: 'Ausgewogen'),
      (id: 'smart', name: 'Intelligent', icon: Icons.lightbulb, desc: 'Beste Qualität'),
    ];
    
    return Row(
      children: modes.map((mode) {
        final isSelected = settings.modelMode == mode.id;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _SelectCard(
              isSelected: isSelected,
              onTap: () => ref.read(appSettingsNotifierProvider.notifier)
                  .setModelMode(mode.id),
              child: Column(
                children: [
                  Icon(
                    mode.icon,
                    color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mode.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: isSelected ? colorScheme.primary : null,
                    ),
                  ),
                  Text(
                    mode.desc,
                    style: TextStyle(
                      fontSize: 10,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ============================================================================
// MODEL SELECTOR (per task)
// ============================================================================

class _ModelSelector extends ConsumerWidget {
  const _ModelSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsNotifierProvider);
    final apiKey = settings.getApiKey();
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (apiKey == null || apiKey.isEmpty)
            _NoKeyHint(provider: settings.getProviderName())
          else
            const ModelSelectionPanel(),
        ],
      ),
    );
  }
}

class _NoKeyHint extends StatelessWidget {
  final String provider;
  const _NoKeyHint({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Icon(Icons.info_outline,
              size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Kein $provider API-Key konfiguriert. '
              'Trage deinen Key im Abschnitt "API-Schlüssel" ein, '
              'um verfügbare Modelle zu laden.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
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
                  items: ['Klasse_9', 'Klasse_10', 'Klasse_11', 'Klasse_12', 'Klasse_13']
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
          const Divider(height: 24),
          // Course Type
          Row(
            children: [
              Icon(Icons.menu_book, color: colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: settings.courseType,
                  decoration: const InputDecoration(
                    labelText: 'Kursart',
                    border: InputBorder.none,
                  ),
                  items: ['Grundkurs', 'Leistungsfach', 'Leistungskurs']
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
      ),
    );
  }
}

// ============================================================================
// API KEYS SECTION
// ============================================================================

class _APIKeysSection extends ConsumerWidget {
  final TextEditingController claudeController;
  final TextEditingController geminiController;
  final TextEditingController openrouterController;
  final bool claudeVisible;
  final bool geminiVisible;
  final bool openrouterVisible;
  final ValueChanged<bool> onClaudeVisibilityChanged;
  final ValueChanged<bool> onGeminiVisibilityChanged;
  final ValueChanged<bool> onOpenrouterVisibilityChanged;

  const _APIKeysSection({
    required this.claudeController,
    required this.geminiController,
    required this.openrouterController,
    required this.claudeVisible,
    required this.geminiVisible,
    required this.openrouterVisible,
    required this.onClaudeVisibilityChanged,
    required this.onGeminiVisibilityChanged,
    required this.onOpenrouterVisibilityChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Claude API Key
          _APIKeyField(
            label: 'Claude API Key',
            controller: claudeController,
            isVisible: claudeVisible,
            onVisibilityChanged: onClaudeVisibilityChanged,
            onSave: () => ref.read(appSettingsNotifierProvider.notifier)
                .setClaudeApiKey(claudeController.text),
            icon: Icons.psychology,
            color: Colors.orange,
          ),
          const SizedBox(height: 16),
          // Gemini API Key
          _APIKeyField(
            label: 'Gemini API Key',
            controller: geminiController,
            isVisible: geminiVisible,
            onVisibilityChanged: onGeminiVisibilityChanged,
            onSave: () => ref.read(appSettingsNotifierProvider.notifier)
                .setGeminiApiKey(geminiController.text),
            icon: Icons.auto_awesome,
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          // OpenRouter API Key
          _APIKeyField(
            label: 'OpenRouter API Key',
            controller: openrouterController,
            isVisible: openrouterVisible,
            onVisibilityChanged: onOpenrouterVisibilityChanged,
            onSave: () => ref.read(appSettingsNotifierProvider.notifier)
                .setOpenrouterApiKey(openrouterController.text),
            icon: Icons.router,
            color: Colors.purple,
            hintText: 'sk-or-v1-...',
          ),
        ],
      ),
    );
  }
}

class _APIKeyField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isVisible;
  final ValueChanged<bool> onVisibilityChanged;
  final VoidCallback onSave;
  final IconData icon;
  final Color color;
  final String? hintText;

  const _APIKeyField({
    required this.label,
    required this.controller,
    required this.isVisible,
    required this.onVisibilityChanged,
    required this.onSave,
    required this.icon,
    required this.color,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: controller,
            obscureText: !isVisible,
            decoration: InputDecoration(
              labelText: label,
              hintText: hintText,
              border: const OutlineInputBorder(),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => onVisibilityChanged(!isVisible),
                  ),
                  IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: onSave,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// DEVELOPER SECTION
// ============================================================================

class _DeveloperSection extends ConsumerWidget {
  final TextEditingController backendUrlController;

  const _DeveloperSection({required this.backendUrlController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debugConfig = ref.watch(debugConfigNotifierProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Backend URL',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: backendUrlController,
            decoration: InputDecoration(
              hintText: 'https://api.learn-smart.app',
              prefixIcon: const Icon(Icons.cloud),
              suffixIcon: IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  ref.read(debugConfigNotifierProvider.notifier)
                      .setBackendUrl(backendUrlController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Backend URL gespeichert')),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Verbose Logging
          SwitchListTile(
            title: const Text('Ausführliche Logs'),
            subtitle: const Text('Detaillierte Konsolenausgabe'),
            value: debugConfig.verboseLogging,
            onChanged: (v) => ref.read(debugConfigNotifierProvider.notifier)
                .setVerboseLogging(v),
          ),
          // Skip Email Verification
          SwitchListTile(
            title: const Text('E-Mail-Verifizierung überspringen'),
            subtitle: const Text('Nur für Entwicklung'),
            value: debugConfig.skipEmailVerification,
            onChanged: (v) => ref.read(debugConfigNotifierProvider.notifier)
                .setSkipEmailVerification(v),
          ),
        ],
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Account löschen?'),
        content: const Text(
          'Diese Aktion kann nicht rückgängig gemacht werden. Alle deine Daten werden permanent gelöscht.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(authServiceProvider).deleteAccount();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
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

// ============================================================================
// EXPANDABLE SECTION
// ============================================================================

class _ExpandableSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Widget child;

  const _ExpandableSection({
    required this.title,
    required this.icon,
    required this.isExpanded,
    required this.onToggle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: Colors.orange),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(Icons.expand_more),
            ),
            onTap: onToggle,
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: child,
            ),
            crossFadeState: isExpanded 
                ? CrossFadeState.showSecond 
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SELECT CARD
// ============================================================================

class _SelectCard extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;

  const _SelectCard({
    required this.isSelected,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Material(
      color: isSelected 
          ? colorScheme.primaryContainer 
          : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? colorScheme.primary : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: child,
        ),
      ),
    );
  }
}
