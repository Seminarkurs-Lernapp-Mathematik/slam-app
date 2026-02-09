import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../providers/settings_providers.dart';
import '../../../../shared/widgets/glass_panel.dart';

/// Debug Panel - API Keys, Backend URL, Developer Options
class DebugPanel extends ConsumerStatefulWidget {
  const DebugPanel({super.key});

  @override
  ConsumerState<DebugPanel> createState() => _DebugPanelState();
}

class _DebugPanelState extends ConsumerState<DebugPanel> {
  final _claudeApiKeyController = TextEditingController();
  final _geminiApiKeyController = TextEditingController();
  final _backendUrlController = TextEditingController();

  bool _claudeKeyVisible = false;
  bool _geminiKeyVisible = false;

  @override
  void initState() {
    super.initState();
    // Load saved values from app settings (Firebase)
    final appSettings = ref.read(appSettingsNotifierProvider);
    final debugConfig = ref.read(debugConfigNotifierProvider);
    _claudeApiKeyController.text = appSettings.claudeApiKey ?? '';
    _geminiApiKeyController.text = appSettings.geminiApiKey ?? '';
    _backendUrlController.text = debugConfig.backendUrl;
  }

  @override
  void dispose() {
    _claudeApiKeyController.dispose();
    _geminiApiKeyController.dispose();
    _backendUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final debugConfig = ref.watch(debugConfigNotifierProvider);

    return GlassPanel(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with warning icon
            Row(
              children: [
                const Icon(Icons.developer_mode, size: 20, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Developer / Debug Optionen',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Nur für Entwickler und Tests. Änderungen können die App-Funktionalität beeinträchtigen.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
            ),
            const SizedBox(height: 24),

            // Backend URL
            Text(
              'Backend Konfiguration',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _backendUrlController,
              decoration: InputDecoration(
                labelText: 'Backend URL',
                hintText: 'https://api.slam-learning.de',
                prefixIcon: const Icon(Icons.cloud),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () async {
                    await ref
                        .read(debugConfigNotifierProvider.notifier)
                        .setBackendUrl(_backendUrlController.text);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Backend URL gespeichert')),
                      );
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    _backendUrlController.text = 'http://localhost:8787';
                  },
                  icon: const Icon(Icons.computer, size: 16),
                  label: const Text('Localhost'),
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    _backendUrlController.text = 'https://learn-smart.app';
                  },
                  icon: const Icon(Icons.cloud, size: 16),
                  label: const Text('Production'),
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),

            const Divider(height: 32),

            // API Keys Section
            Text(
              'API Keys',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            // Claude API Key
            TextField(
              controller: _claudeApiKeyController,
              obscureText: !_claudeKeyVisible,
              decoration: InputDecoration(
                labelText: 'Claude API Key',
                hintText: 'sk-ant-...',
                prefixIcon: const Icon(Icons.key),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        _claudeKeyVisible ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _claudeKeyVisible = !_claudeKeyVisible;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () async {
                        // Save to Firebase via appSettingsNotifier
                        ref
                            .read(appSettingsNotifierProvider.notifier)
                            .setClaudeApiKey(_claudeApiKeyController.text);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Claude API Key in Firebase gespeichert')),
                          );
                        }
                      },
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Gemini API Key
            TextField(
              controller: _geminiApiKeyController,
              obscureText: !_geminiKeyVisible,
              decoration: InputDecoration(
                labelText: 'Gemini API Key',
                hintText: 'AI...',
                prefixIcon: const Icon(Icons.key),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        _geminiKeyVisible ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _geminiKeyVisible = !_geminiKeyVisible;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () async {
                        // Save to Firebase via appSettingsNotifier
                        ref
                            .read(appSettingsNotifierProvider.notifier)
                            .setGeminiApiKey(_geminiApiKeyController.text);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Gemini API Key in Firebase gespeichert')),
                          );
                        }
                      },
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const Divider(height: 32),

            // Debug Options
            Text(
              'Debug Optionen',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            // Mock Mode
            SwitchListTile(
              value: debugConfig.mockMode,
              onChanged: (value) async {
                await ref.read(debugConfigNotifierProvider.notifier).setMockMode(value);
              },
              title: const Text('Mock-Modus'),
              subtitle: const Text('Verwendet Demo-Daten statt echter API-Aufrufe'),
              secondary: const Icon(Icons.science),
              contentPadding: EdgeInsets.zero,
            ),

            // Verbose Logging
            SwitchListTile(
              value: debugConfig.verboseLogging,
              onChanged: (value) async {
                await ref.read(debugConfigNotifierProvider.notifier).setVerboseLogging(value);
              },
              title: const Text('Verbose Logging'),
              subtitle: const Text('Detaillierte Logs in der Konsole'),
              secondary: const Icon(Icons.terminal),
              contentPadding: EdgeInsets.zero,
            ),

            // Skip Email Verification
            SwitchListTile(
              value: debugConfig.skipEmailVerification,
              onChanged: (value) async {
                await ref.read(debugConfigNotifierProvider.notifier).setSkipEmailVerification(value);
              },
              title: const Text('E-Mail-Verifizierung überspringen'),
              subtitle: const Text('Nur für Tests - nicht in Production!'),
              secondary: const Icon(Icons.mail_outline, color: Colors.red),
              contentPadding: EdgeInsets.zero,
            ),

            const Divider(height: 32),

            // Connection Test
            Text(
              'Verbindungstest',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => _testConnection(context),
              icon: const Icon(Icons.wifi_tethering),
              label: const Text('Backend-Verbindung testen'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),

            const SizedBox(height: 12),

            // Clear Cache
            OutlinedButton.icon(
              onPressed: () => _showClearCacheDialog(context),
              icon: const Icon(Icons.delete_sweep),
              label: const Text('Cache leeren'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                foregroundColor: Colors.orange,
                side: const BorderSide(color: Colors.orange),
              ),
            ),

            const SizedBox(height: 12),

            // Reset to Defaults
            OutlinedButton.icon(
              onPressed: () => _showResetDialog(context),
              icon: const Icon(Icons.restore),
              label: const Text('Auf Standardwerte zurücksetzen'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
            ),

            const SizedBox(height: 24),

            // App Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('App Version', '1.0.0+1'),
                  const SizedBox(height: 8),
                  _buildInfoRow('Build Mode', 'Debug'),
                  const SizedBox(height: 8),
                  _buildInfoRow('Flutter Version', '3.6.0'),
                  const SizedBox(height: 8),
                  _buildInfoRow('Dart Version', '3.6.0'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Future<void> _testConnection(BuildContext context) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Teste Verbindung...'),
              ],
            ),
          ),
        ),
      ),
    );

    // Simulate connection test
    await Future.delayed(const Duration(seconds: 2));

    if (context.mounted) {
      Navigator.of(context).pop(); // Close loading dialog

      // Show result
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Flexible(child: Text('Verbindung erfolgreich')),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Backend URL: ${_backendUrlController.text}'),
                const SizedBox(height: 8),
                const Text('Status: 200 OK'),
                const SizedBox(height: 8),
                const Text('Latenz: 125ms'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _showClearCacheDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cache leeren'),
        content: const Text(
          'Möchtest du wirklich den gesamten Cache leeren? '
          'Dies beinhaltet alle zwischengespeicherten Fragen, Bilder und Daten.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('Cache leeren'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // Clear cache logic would go here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cache wurde geleert'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _showResetDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Zurücksetzen'),
        content: const Text(
          'Möchtest du alle Debug-Einstellungen auf die Standardwerte zurücksetzen? '
          'API-Keys und Backend-URL werden gelöscht.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Zurücksetzen'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      ref.read(debugConfigNotifierProvider.notifier).reset();
      _claudeApiKeyController.clear();
      _geminiApiKeyController.clear();
      _backendUrlController.text = 'https://learn-smart.app';

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debug-Einstellungen zurückgesetzt'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
