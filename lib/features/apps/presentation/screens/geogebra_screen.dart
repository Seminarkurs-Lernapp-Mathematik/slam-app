import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/question.dart';
import '../../../../core/models/saved_content.dart';
import '../../../../core/services/ai_service.dart';
import '../../../../core/services/auth_service.dart';
import '../providers/apps_providers.dart';
import 'app_viewer_screen.dart';

/// GeoGebra Visualization Screen
///
/// Generates GeoGebra commands from a prompt, then shows an "Öffnen" button.
/// Opening the visualization launches a full-screen GeoGebra WebView that
/// supports multi-turn chat-based modifications.
class GeogebraScreen extends ConsumerStatefulWidget {
  const GeogebraScreen({super.key});

  @override
  ConsumerState<GeogebraScreen> createState() => _GeogebraScreenState();
}

class _GeogebraScreenState extends ConsumerState<GeogebraScreen> {
  final _promptController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  GeoGebraData? _currentVisualization;

  final List<String> _examplePrompts = [
    'Quadratische Funktion mit Verschiebung',
    'Kreistangente und Normale',
    'Sinusfunktion',
    'Parabel und Gerade (Schnittpunkte)',
    'Dreieck Mittelsenkrechte',
    'Vektoren addieren',
  ];

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Generation + auto-save
  // ---------------------------------------------------------------------------

  Future<void> _generateVisualization() async {
    if (_promptController.text.trim().isEmpty) {
      setState(() => _error = 'Bitte gib eine Beschreibung ein');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _currentVisualization = null;
    });

    try {
      final visualization = await ref.read(
        generateGeogebraProvider(
          prompt: _promptController.text.trim(),
        ).future,
      );

      setState(() {
        _currentVisualization = visualization;
        _isLoading = false;
      });

      // Auto-save in background
      _autoSave(visualization);
    } on AIException catch (e) {
      setState(() {
        _error = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Fehler beim Generieren der Visualisierung: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _autoSave(GeoGebraData data) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    try {
      // Save as an HTML page that embeds the GeoGebra viewer
      final html = buildGeoGebraViewerHtml(data.commands);
      final content = SavedContent(
        id: 'ggb-${DateTime.now().millisecondsSinceEpoch}',
        userId: user.uid,
        title: data.title,
        type: ContentType.geogebra,
        htmlContent: html,
        description: _promptController.text.trim(),
        createdAt: DateTime.now(),
        tags: ['geogebra'],
      );
      await ref.read(saveContentProvider(content).future);
      debugPrint('✅ GeoGebra: auto-saved "${data.title}"');
    } catch (e) {
      debugPrint('⚠️ GeoGebra: auto-save failed: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Open fullscreen viewer
  // ---------------------------------------------------------------------------

  void _openVisualization() {
    if (_currentVisualization == null) return;

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => AppViewerScreen(
          title: _currentVisualization!.title,
          htmlContent:
              buildGeoGebraViewerHtml(_currentVisualization!.commands),
          originalPrompt: _promptController.text.trim(),
          contentType: ContentType.geogebra,
        ),
      ),
    );
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
                  hintText: 'z.B. "Zeige eine quadratische Funktion"',
                  labelText: 'Was möchtest du visualisieren?',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.functions),
                  suffixIcon: _promptController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _promptController.clear();
                            setState(() => _currentVisualization = null);
                          },
                        )
                      : null,
                ),
                maxLines: 2,
                textInputAction: TextInputAction.done,
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) => _generateVisualization(),
              ),
              const SizedBox(height: 12),

              // Example prompts
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _examplePrompts.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) => ActionChip(
                    label: Text(_examplePrompts[index]),
                    onPressed: () {
                      _promptController.text = _examplePrompts[index];
                      setState(() {});
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),

              FilledButton.icon(
                onPressed: _isLoading ? null : _generateVisualization,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(
                    _isLoading ? 'Generiere...' : 'Visualisierung generieren'),
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
                              style: TextStyle(color: cs.error))),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _generateVisualization,
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
        Expanded(child: _buildResultArea(theme, cs)),
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
            Text('Visualisierung wird erstellt…',
                style: theme.textTheme.titleMedium?.copyWith(
                    color: cs.onSurfaceVariant)),
            const SizedBox(height: 8),
            Text('GeoGebra-Befehle werden generiert',
                style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant)),
          ],
        ),
      );
    }

    if (_currentVisualization == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.functions, size: 64, color: cs.primary),
            const SizedBox(height: 16),
            Text('Erstelle eine GeoGebra-Visualisierung',
                style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Beschreibe, was du visualisieren möchtest',
                style: TextStyle(color: cs.secondary)),
          ],
        ),
      );
    }

    // Generation complete — show result card
    final vis = _currentVisualization!;
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
                border: Border.all(color: cs.primary.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Icon(Icons.check_circle, size: 48, color: cs.primary),
                  const SizedBox(height: 12),
                  Text(
                    vis.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  if (vis.description.isNotEmpty) ...[
                    Text(
                      vis.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    '${vis.commands.length} GeoGebra-Befehle • automatisch gespeichert',
                    style: theme.textTheme.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _openVisualization,
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
              onPressed: _generateVisualization,
              icon: const Icon(Icons.refresh),
              label: const Text('Neu generieren'),
            ),
          ],
        ),
      ),
    );
  }
}
