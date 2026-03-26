import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/saved_content.dart';
import '../../../../core/presentation/widgets/cross_platform_webview.dart';
import '../../../../core/services/ai_service.dart';
import '../../../../core/services/auth_service.dart';
import '../providers/apps_providers.dart';

/// Builds a standalone HTML page that loads GeoGebra and executes [commands].
///
/// Exposed as a top-level function so both [AppViewerScreen] and
/// [GeogebraScreen] can call it without coupling.
String buildGeoGebraViewerHtml(List<String> commands) {
  final commandsJson = jsonEncode(commands);
  return '''<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="Content-Security-Policy" content="default-src * 'unsafe-inline' 'unsafe-eval' data: blob:;">
  <script src="https://www.geogebra.org/apps/deployggb.js"></script>
  <style>
    body { margin: 0; padding: 0; width: 100vw; height: 100vh; overflow: hidden; background: #f5f5f5; }
    #ggb-element { width: 100%; height: 100%; }
  </style>
</head>
<body>
  <div id="ggb-element"></div>
  <script>
    var pendingCommands = $commandsJson;

    window.ggbOnInit = function() {
      if (typeof ggbApplet !== 'undefined' && ggbApplet.evalCommand) {
        for (var i = 0; i < pendingCommands.length; i++) {
          try { ggbApplet.evalCommand(pendingCommands[i]); } catch(e) { console.error('GGB cmd error:', e); }
        }
      } else {
        // Fallback if ggbApplet is not yet defined
        setTimeout(window.ggbOnInit, 100);
      }
    };

    var params = {
      "appName": "graphing",
      "width": window.innerWidth,
      "height": window.innerHeight,
      "showToolBar": true,
      "showAlgebraInput": true,
      "showMenuBar": false,
      "enableShiftDragZoom": true,
      "enableRightClick": false,
      "allowStyleBar": true,
      "showLogging": false
    };

    var deployer = new GGBApplet(params, true);
    deployer.inject('ggb-element');
  </script>
</body>
</html>''';
}

/// Single chat message in the modification chat
class _ModMessage {
  final String text;
  final bool isUser;
  const _ModMessage({required this.text, required this.isUser});
}

/// Full-screen app viewer with modification chat.
///
/// Used by both KI-Labor (mini-app) and GeoGebra screens.
/// Shows the generated app/visualization and lets the user request
/// modifications through a persistent chat panel.
class AppViewerScreen extends ConsumerStatefulWidget {
  final String title;
  final String htmlContent;
  final String originalPrompt;
  final ContentType contentType; // miniApp or geogebra

  const AppViewerScreen({
    super.key,
    required this.title,
    required this.htmlContent,
    required this.originalPrompt,
    required this.contentType,
  });

  @override
  ConsumerState<AppViewerScreen> createState() => _AppViewerScreenState();
}

class _AppViewerScreenState extends ConsumerState<AppViewerScreen> {
  late String _currentHtml;
  final List<_ModMessage> _messages = [];
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = false;
  bool _chatOpen = false;
  int _htmlVersion = 0; // incremented to force WebView reload

  @override
  void initState() {
    super.initState();
    _currentHtml = widget.htmlContent;
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Modification
  // ---------------------------------------------------------------------------

  Future<void> _sendModification() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(_ModMessage(text: text, isUser: true));
      _isLoading = true;
    });
    _inputController.clear();
    _scrollToBottom();

    try {
      final aiService = ref.read(aiServiceProvider);
      String newHtml;

      if (widget.contentType == ContentType.miniApp) {
        // Rebuild the app incorporating all modifications
        final allMods = _messages
            .where((m) => m.isUser)
            .map((m) => m.text)
            .join('\n- ');
        final app = await aiService.generateMiniApp(
          description:
              '${widget.originalPrompt}\n\nGewünschte Änderungen:\n- $allMods',
        );
        newHtml = _buildMiniAppHtml(app);
        if (mounted) {
          setState(() {
            _messages.add(
              _ModMessage(
                text: 'App wurde aktualisiert: "${app.title}"',
                isUser: false,
              ),
            );
          });
        }
      } else {
        // GeoGebra: re-generate with modification context
        final geo = await aiService.generateGeoGebra(
          questionText: widget.originalPrompt,
          topic: 'general',
          userPrompt: text,
        );
        newHtml = buildGeoGebraViewerHtml(geo.commands);
        if (mounted) {
          setState(() {
            _messages.add(
              _ModMessage(
                text:
                    'Visualisierung aktualisiert: "${geo.title}"',
                isUser: false,
              ),
            );
          });
        }
      }

      if (mounted) {
        setState(() {
          _currentHtml = newHtml;
          _htmlVersion++;
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(
            _ModMessage(text: 'Fehler: ${e.toString()}', isUser: false),
          );
          _isLoading = false;
        });
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ---------------------------------------------------------------------------
  // HTML helpers
  // ---------------------------------------------------------------------------

  String _buildMiniAppHtml(GeneratedApp app) {
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
  $html
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

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              _chatOpen ? Icons.close : Icons.chat_bubble_outline,
              color: Colors.white,
            ),
            tooltip: _chatOpen ? 'Chat schließen' : 'Änderungen besprechen',
            onPressed: () => setState(() => _chatOpen = !_chatOpen),
          ),
        ],
      ),
      body: Column(
        children: [
          // WebView
          Expanded(
            flex: _chatOpen ? 1 : 1,
            child: CrossPlatformWebView(
              key: ValueKey('webview_$_htmlVersion'),
              htmlContent: _currentHtml,
              onPageFinished: () => debugPrint('✅ AppViewer: page loaded'),
            ),
          ),

          // Chat panel
          if (_chatOpen)
            Container(
              height: MediaQuery.of(context).size.height * 0.38,
              decoration: BoxDecoration(
                color: cs.surface,
                border: Border(top: BorderSide(color: cs.outline.withValues(alpha: 0.3))),
              ),
              child: Column(
                children: [
                  // Chat header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                    child: Row(
                      children: [
                        Icon(Icons.auto_fix_high, size: 18, color: cs.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Änderungen anfragen',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Messages
                  Expanded(
                    child: _messages.isEmpty && !_isLoading
                        ? Center(
                            child: Text(
                              'Beschreibe eine Änderung, z.B. "Füge einen Reset-Button hinzu"',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            itemCount: _messages.length + (_isLoading ? 1 : 0),
                            itemBuilder: (_, i) {
                              if (i == _messages.length) {
                                return _buildTypingIndicator(cs);
                              }
                              return _buildBubble(_messages[i], theme, cs);
                            },
                          ),
                  ),

                  // Input bar
                  Container(
                    padding: EdgeInsets.only(
                      left: 12,
                      right: 8,
                      top: 8,
                      bottom: 8 + MediaQuery.of(context).viewInsets.bottom,
                    ),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      border: Border(
                        top: BorderSide(
                            color: cs.outlineVariant.withValues(alpha: 0.4)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _inputController,
                            maxLines: 2,
                            minLines: 1,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _sendModification(),
                            decoration: InputDecoration(
                              hintText: 'z.B. "Mache den Button größer…"',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: cs.outlineVariant),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              filled: true,
                              fillColor: cs.surfaceContainerHighest
                                  .withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: _isLoading ? null : _sendModification,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.all(10),
                            minimumSize: const Size(44, 44),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.send, size: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBubble(_ModMessage msg, ThemeData theme, ColorScheme cs) {
    final isUser = msg.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isUser ? cs.primary : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isUser ? 12 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 12),
          ),
        ),
        child: Text(
          msg.text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isUser ? cs.onPrimary : cs.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(ColorScheme cs) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: cs.primary),
            ),
            const SizedBox(width: 8),
            Text('Generiere…',
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

