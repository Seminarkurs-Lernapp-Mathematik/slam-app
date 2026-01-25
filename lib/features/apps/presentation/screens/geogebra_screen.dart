import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/models/question.dart';
import '../../../../core/services/ai_service.dart';
import '../providers/apps_providers.dart';

/// GeoGebra Visualization Screen
///
/// Allows users to generate GeoGebra visualizations from prompts
class GeogebraScreen extends ConsumerStatefulWidget {
  const GeogebraScreen({super.key});

  @override
  ConsumerState<GeogebraScreen> createState() => _GeogebraScreenState();
}

class _GeogebraScreenState extends ConsumerState<GeogebraScreen> {
  final _promptController = TextEditingController();
  final _scrollController = ScrollController();
  WebViewController? _webViewController;
  bool _isLoading = false;
  String? _error;
  GeoGebraData? _currentVisualization;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            // Inject GeoGebra commands when page loads
            if (_currentVisualization != null &&
                _currentVisualization!.commands.isNotEmpty) {
              _executeGeoGebraCommands(_currentVisualization!.commands);
            }
          },
        ),
      )
      ..loadHtmlString(_getInitialGeoGebraHTML());
  }

  String _getInitialGeoGebraHTML() {
    return '''
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://www.geogebra.org/apps/deployggb.js"></script>
    <style>
        body {
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f5f5f5;
        }
        #ggb-element {
            width: 100%;
            height: 100%;
        }
    </style>
</head>
<body>
    <div id="ggb-element"></div>
    <script>
        var parameters = {
            "appName": "graphing",
            "width": window.innerWidth,
            "height": window.innerHeight,
            "showToolBar": true,
            "showAlgebraInput": true,
            "showMenuBar": false,
            "enableShiftDragZoom": true,
            "enableRightClick": false
        };

        var applet = new GGBApplet(parameters, true);
        window.addEventListener("load", function() {
            applet.inject('ggb-element');
        });

        // Function to execute GeoGebra commands
        window.executeCommands = function(commands) {
            var ggbApp = applet.getAppletObject();
            if (ggbApp) {
                commands.forEach(function(cmd) {
                    ggbApp.evalCommand(cmd);
                });
                return "Commands executed successfully";
            }
            return "GeoGebra not ready";
        };
    </script>
</body>
</html>
    ''';
  }

  Future<void> _executeGeoGebraCommands(List<String> commands) async {
    if (_webViewController == null) return;

    final commandsJson = commands.map((c) => '"$c"').join(',');
    await _webViewController!.runJavaScript(
      'window.executeCommands([$commandsJson]);',
    );
  }

  Future<void> _generateVisualization() async {
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
      final visualization = await ref.read(
        generateGeogebraProvider(
          prompt: _promptController.text.trim(),
        ).future,
      );

      setState(() {
        _currentVisualization = visualization;
        _isLoading = false;
      });

      // Execute commands
      if (visualization.commands.isNotEmpty) {
        await _executeGeoGebraCommands(visualization.commands);
      }
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

  @override
  void dispose() {
    _promptController.dispose();
    _scrollController.dispose();
    super.dispose();
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
                color: Colors.black.withOpacity(0.05),
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
                            setState(() {});
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
              FilledButton.icon(
                onPressed: _isLoading ? null : _generateVisualization,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(_isLoading
                    ? 'Generiere...'
                    : 'Visualisierung generieren'),
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

        // WebView with GeoGebra
        Expanded(
          child: _webViewController == null
              ? const Center(child: CircularProgressIndicator())
              : WebViewWidget(controller: _webViewController!),
        ),

        // Commands display
        if (_currentVisualization != null &&
            _currentVisualization!.commands.isNotEmpty)
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.terminal, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Ausgeführte Befehle',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${_currentVisualization!.commands.length} Befehle',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _currentVisualization!.commands.length,
                    itemBuilder: (context, index) {
                      final command = _currentVisualization!.commands[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .outline
                                  .withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            command,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
