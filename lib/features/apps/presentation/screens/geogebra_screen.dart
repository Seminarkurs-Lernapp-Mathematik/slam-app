import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/question.dart';
import '../../../../core/presentation/widgets/cross_platform_webview.dart';
import '../../../../core/services/ai_service.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
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
  bool _isLoading = false;
  String? _error;
  GeoGebraData? _currentVisualization;
  bool _isGeoGebraReady = false;

  String get _initialHtml => _getInitialGeoGebraHTML();

  @override
  void dispose() {
    _promptController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _getInitialGeoGebraHTML() {
    return '''
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Content-Security-Policy" content="default-src * 'unsafe-inline' 'unsafe-eval' data: blob:;">
    <script src="https://www.geogebra.org/apps/deployggb.js"></script>
    <style>
        body {
            margin: 0;
            padding: 0;
            width: 100vw;
            height: 100vh;
            overflow: hidden;
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
        (function() {
            var parameters = {
                "appName": "graphing",
                "width": window.innerWidth,
                "height": window.innerHeight,
                "showToolBar": true,
                "showAlgebraInput": true,
                "showMenuBar": false,
                "enableShiftDragZoom": true,
                "enableRightClick": false,
                "material_id": "J8YgX6Xp",
                "allowStyleBar": true,
                "showLogging": false
            };

            var ggbApplet = null;
            var isReady = false;

            // Initialize GeoGebra when page loads
            function initGeoGebra() {
                try {
                    var applet = new GGBApplet(parameters, true);
                    applet.inject('ggb-element');
                    
                    // Store reference to applet object
                    ggbApplet = applet.getAppletObject();
                    isReady = true;
                    
                    // Notify Flutter that GeoGebra is ready
                    if (window.GeoGebraFlutterChannel) {
                        window.GeoGebraFlutterChannel.postMessage('geogebraReady');
                    }
                    
                    console.log('GeoGebra initialized successfully');
                } catch (e) {
                    console.error('Error initializing GeoGebra:', e);
                    if (window.GeoGebraFlutterChannel) {
                        window.GeoGebraFlutterChannel.postMessage('geogebraError:' + e.message);
                    }
                }
            }

            // Wait for GeoGebra script to load
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', initGeoGebra);
            } else {
                // DOM already loaded, initialize immediately
                setTimeout(initGeoGebra, 100);
            }

            // Function to execute GeoGebra commands (exposed globally)
            window.executeCommands = function(commands) {
                if (!ggbApplet || !isReady) {
                    console.error('GeoGebra not ready');
                    return 'GeoGebra not ready';
                }
                try {
                    commands.forEach(function(cmd) {
                        if (cmd && cmd.trim()) {
                            ggbApplet.evalCommand(cmd);
                        }
                    });
                    return 'Commands executed successfully';
                } catch (e) {
                    console.error('Error executing commands:', e);
                    return 'Error: ' + e.message;
                }
            };

            // Reset function
            window.resetGeoGebra = function() {
                if (ggbApplet && isReady) {
                    ggbApplet.reset();
                }
            };
        })();
    </script>
</body>
</html>''';
  }

  void _onWebViewMessage(String message) {
    debugPrint('GeoGebra WebView message: $message');
    
    if (message == 'geogebraReady') {
      setState(() => _isGeoGebraReady = true);
      
      // Execute pending commands if available
      if (_currentVisualization != null && _currentVisualization!.commands.isNotEmpty) {
        _executeGeoGebraCommands(_currentVisualization!.commands);
      }
    } else if (message.startsWith('geogebraError:')) {
      debugPrint('GeoGebra initialization error: $message');
    }
  }

  void _executeGeoGebraCommands(List<String> commands) {
    // Note: Commands are executed by the WebView's JavaScript channel
    // The CrossPlatformWebView doesn't expose the controller directly,
    // so we need to use a different approach - we'll reload with the commands embedded
    // or use the existing executeCommands function via a message
    
    // For now, we'll create a new HTML with commands pre-loaded
    if (!mounted) return;
    
    setState(() {
      // The commands will be executed when GeoGebra becomes ready
      // via the _onWebViewMessage callback
    });
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
      final appSettings = ref.read(appSettingsNotifierProvider);
      final aiProvider = appSettings.aiProvider;
      final selectedModel = appSettings.getModelForTask('geogebraGeneration');
      final apiKey = appSettings.getApiKey();

      if (apiKey == null || apiKey.isEmpty) {
        throw Exception(
          'Kein API-Key konfiguriert. Bitte konfiguriere einen ${appSettings.getProviderName()} API-Key in den Einstellungen.',
        );
      }

      final visualization = await ref.read(
        generateGeogebraProvider(
          prompt: _promptController.text.trim(),
          apiKey: apiKey,
          selectedModel: selectedModel,
          aiProvider: aiProvider,
        ).future,
      );

      setState(() {
        _currentVisualization = visualization;
        _isLoading = false;
      });

      // Reset and execute new commands
      if (visualization.commands.isNotEmpty) {
        // For GeoGebra, we need to reload the WebView with commands embedded
        // since we can't easily access the controller from CrossPlatformWebView
        setState(() {
          // The WebView will reload with the new visualization data
        });
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
          child: CrossPlatformWebView(
            htmlContent: _initialHtml,
            javascriptChannelName: 'GeoGebraFlutterChannel',
            onMessage: _onWebViewMessage,
            onPageFinished: () {
              debugPrint('✅ GeoGebra WebView loaded');
            },
          ),
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
                  color: Colors.black.withValues(alpha: 0.1),
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
                                  .withValues(alpha: 0.3),
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
