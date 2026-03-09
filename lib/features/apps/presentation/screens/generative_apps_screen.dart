import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/saved_content.dart';
import '../../../../core/presentation/widgets/cross_platform_webview.dart';
import '../../../../core/services/ai_service.dart';
import '../../../../core/services/auth_service.dart';
import '../providers/apps_providers.dart';
import '../widgets/code_viewer.dart';

/// Generative Apps Screen (KI-Labor)
///
/// Allows users to generate mini-apps from text descriptions
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

  Future<void> _generateApp() async {
    if (_promptController.text.trim().isEmpty) {
      setState(() {
        _error = 'Bitte gib eine Beschreibung ein';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
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

  String? _getCurrentHtml() {
    if (_currentApp == null) return null;
    return _getHtml(_currentApp!);
  }

  String _getHtml(GeneratedApp app) {
    final html = app.html.trim();
    // If the backend returned a full document, use it as-is
    if (html.toLowerCase().startsWith('<!doctype') ||
        html.toLowerCase().startsWith('<html')) {
      return html;
    }
    // Otherwise wrap the snippet
    return '''<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    * { box-sizing: border-box; }
    body { margin: 0; padding: 16px; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; }
    ${app.css ?? ''}
  </style>
</head>
<body>
  $html
  <script>${app.javascript ?? ''}</script>
</body>
</html>''';
  }

  Future<void> _saveApp() async {
    if (_currentApp == null) return;

    final user = ref.read(currentUserProvider);
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte melde dich an, um Apps zu speichern'),
        ),
      );
      return;
    }

    // Show dialog to get title
    final title = await _showSaveTitleDialog();
    if (title == null || title.isEmpty) return;

    final content = SavedContent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: user.uid,
      title: title,
      type: ContentType.miniApp,
      htmlContent: _currentApp!.html,
      cssContent: _currentApp!.css,
      javascriptContent: _currentApp!.javascript,
      description: _promptController.text.trim(),
      createdAt: DateTime.now(),
      tags: [],
    );

    try {
      await ref.read(saveContentProvider(content).future);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('App erfolgreich gespeichert!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Speichern: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<String?> _showSaveTitleDialog() async {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('App speichern'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Titel',
            hintText: 'z.B. Mein Funktionsplotter',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.of(context).pop(controller.text.trim());
              }
            },
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
  }

  void _showCodeViewer() {
    if (_currentApp == null) return;

    showCodeViewerBottomSheet(
      context,
      html: _currentApp!.html,
      css: _currentApp!.css,
      javascript: _currentApp!.javascript,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Prompt input section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
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
                            setState(() {});
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
                label: Text(_isLoading ? 'Generiere App...' : 'App generieren'),
              ),

              if (_error != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
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

        // WebView with generated app
        Expanded(
          child: _currentApp == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Generiere deine erste Mini-App',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Beschreibe, was die App können soll',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                )
              : CrossPlatformWebView(
                  htmlContent: _getCurrentHtml()!,
                  onPageFinished: () {
                    debugPrint('✅ Mini-App loaded successfully');
                  },
                ),
        ),

        // Action buttons
        if (_currentApp != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _showCodeViewer,
                    icon: const Icon(Icons.code),
                    label: const Text('Code ansehen'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _saveApp,
                    icon: const Icon(Icons.save),
                    label: const Text('Speichern'),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
