import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/saved_content.dart';
import '../../../../core/services/ai_service.dart';
import '../../../../core/services/auth_service.dart';
import '../providers/apps_providers.dart';
import 'app_viewer_screen.dart';

/// Generative Apps Screen (KI-Labor)
///
/// Lets users describe a mini-app, generates it, then shows an "Öffnen"
/// button. Opening the app launches a full-screen viewer that supports
/// multi-turn chat-based modifications.
class GenerativeAppsScreen extends ConsumerStatefulWidget {
  const GenerativeAppsScreen({super.key});

  @override
  ConsumerState<GenerativeAppsScreen> createState() =>
      _GenerativeAppsScreenState();
}

class _GenerativeAppsScreenState extends ConsumerState<GenerativeAppsScreen> {
  final _promptController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  GeneratedApp? _currentApp;

  final List<String> _examplePrompts = [
    'Binomialverteilung Simulator',
    'Ableitungen visualisieren',
    'Vektoraddition',
    'Würfelsimulator',
    'Funktionsplotter',
    'Primzahlenfinder',
    'Bruchrechner',
    'Geometrie-Tool',
  ];

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Generation + auto-save
  // ---------------------------------------------------------------------------

  Future<void> _generateApp() async {
    if (_promptController.text.trim().isEmpty) {
      setState(() => _error = 'Bitte gib eine Beschreibung ein');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _currentApp = null;
    });

    try {
      final app = await ref.read(
        generateMiniAppProvider(
          description: _promptController.text.trim(),
        ).future,
      );

      setState(() {
        _isLoading = false;
        _currentApp = app;
      });

      // Auto-save in background (fire-and-forget, don't block UI)
      _autoSave(app);
    } on AIException catch (e) {
      setState(() {
        _error = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Fehler beim Generieren der App: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _autoSave(GeneratedApp app) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    try {
      final content = SavedContent(
        id: 'app-${DateTime.now().millisecondsSinceEpoch}',
        userId: user.uid,
        title: app.title,
        type: ContentType.miniApp,
        htmlContent: app.html,
        cssContent: app.css,
        javascriptContent: app.javascript,
        description: _promptController.text.trim(),
        createdAt: DateTime.now(),
        tags: ['ki-labor'],
      );
      await ref.read(saveContentProvider(content).future);
      debugPrint('✅ KI-Labor: auto-saved "${app.title}"');
    } catch (e) {
      debugPrint('⚠️ KI-Labor: auto-save failed: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Open fullscreen viewer
  // ---------------------------------------------------------------------------

  void _openApp() {
    if (_currentApp == null) return;

    final html = _buildHtml(_currentApp!);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => AppViewerScreen(
          title: _currentApp!.title,
          htmlContent: html,
          originalPrompt: _promptController.text.trim(),
          contentType: ContentType.miniApp,
        ),
      ),
    );
  }

  String _buildHtml(GeneratedApp app) {
    final html = app.html.trim();
    if (html.toLowerCase().startsWith('<!doctype') ||
        html.toLowerCase().startsWith('<html')) {
      return html;
    }
    return '''<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>* { box-sizing: border-box; } body { margin: 0; padding: 16px; font-family: -apple-system, sans-serif; } ${app.css ?? ''}</style>
</head>
<body>
  ${app.html}
  <script>${app.javascript ?? ''}</script>
</body>
</html>''';
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      children: [
        // Prompt input section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _promptController,
                decoration: InputDecoration(
                  hintText: 'z.B. "Erstelle einen Funktionsplotter"',
                  labelText: 'Was soll die App können?',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.auto_awesome),
                  suffixIcon: _promptController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _promptController.clear();
                            setState(() => _currentApp = null);
                          },
                        )
                      : null,
                ),
                maxLines: 3,
                textInputAction: TextInputAction.done,
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) => _generateApp(),
              ),
              const SizedBox(height: 12),

              // Example prompts
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _examplePrompts.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return ActionChip(
                      label: Text(_examplePrompts[index]),
                      onPressed: () {
                        _promptController.text = _examplePrompts[index];
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              FilledButton.icon(
                onPressed: _isLoading ? null : _generateApp,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome),
                label:
                    Text(_isLoading ? 'Generiere App...' : 'App generieren'),
              ),

              if (_error != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: cs.error),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(_error!,
                            style: TextStyle(color: cs.error)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _generateApp,
                        tooltip: 'Erneut versuchen',
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),

        // Result area
        Expanded(
          child: _buildResultArea(theme, cs),
        ),
      ],
    );
  }

  Widget _buildResultArea(ThemeData theme, ColorScheme cs) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('App wird generiert…',
                style: theme.textTheme.titleMedium?.copyWith(
                    color: cs.onSurfaceVariant)),
            const SizedBox(height: 8),
            Text('Das dauert etwa 10–20 Sekunden',
                style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant)),
          ],
        ),
      );
    }

    if (_currentApp == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome, size: 64, color: cs.primary),
            const SizedBox(height: 16),
            Text('Generiere deine erste Mini-App',
                style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Beschreibe, was die App können soll',
                style: TextStyle(color: cs.secondary)),
          ],
        ),
      );
    }

    // Generation complete — show result card with Öffnen button
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: cs.primary.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Icon(Icons.check_circle,
                      size: 48, color: cs.primary),
                  const SizedBox(height: 12),
                  Text(
                    _currentApp!.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'App erfolgreich generiert und gespeichert',
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _openApp,
              icon: const Icon(Icons.open_in_new),
              label: const Text('Öffnen'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 16),
                textStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _generateApp,
              icon: const Icon(Icons.refresh),
              label: const Text('Neu generieren'),
            ),
          ],
        ),
      ),
    );
  }
}
