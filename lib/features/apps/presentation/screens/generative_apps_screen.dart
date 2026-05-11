import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/design_tokens.dart';
import '../../../../core/models/saved_content.dart';
import '../../../../core/services/ai_service.dart';
import '../../../../core/services/auth_service.dart';
import '../providers/apps_providers.dart';
import 'app_viewer_screen.dart';

// KI-Labor accent colors
final _kiA = SlamTokens.primary;
final _kiB = SlamTokens.accentPink;

class GenerativeAppsScreen extends ConsumerStatefulWidget {
  const GenerativeAppsScreen({super.key});

  @override
  ConsumerState<GenerativeAppsScreen> createState() =>
      _GenerativeAppsScreenState();
}

class _GenerativeAppsScreenState
    extends ConsumerState<GenerativeAppsScreen> {
  final _promptController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  GeneratedApp? _currentApp;
  String _loadingMessage = 'App wird generiert…';
  Timer? _loadingTimer;

  static const _loadingStages = [
    (4,  'Idee wird analysiert…'),
    (10, 'Konzept wird entworfen…'),
    (20, 'Code wird geschrieben…'),
    (35, 'Interface wird gebaut…'),
    (55, 'Details werden verfeinert…'),
    (80, 'Fast fertig…'),
  ];

  final List<String> _examples = [
    'Binomialverteilung',
    'Ableitungen',
    'Vektoraddition',
    'Würfelsimulator',
    'Funktionsplotter',
    'Primzahlen',
    'Bruchrechner',
    'Geometrie-Tool',
  ];

  @override
  void dispose() {
    _promptController.dispose();
    _loadingTimer?.cancel();
    super.dispose();
  }

  void _startLoadingTimer() {
    _loadingTimer?.cancel();
    final startTime = DateTime.now();
    _loadingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final elapsed = DateTime.now().difference(startTime).inSeconds;
      for (final (seconds, message) in _loadingStages.reversed) {
        if (elapsed >= seconds) {
          if (_loadingMessage != message) {
            setState(() => _loadingMessage = message);
          }
          break;
        }
      }
    });
  }

  Future<void> _generate() async {
    if (_promptController.text.trim().isEmpty) return;
    setState(() {
      _isLoading = true;
      _error = null;
      _currentApp = null;
      _loadingMessage = 'App wird generiert…';
    });
    _startLoadingTimer();
    try {
      final app = await ref.read(
        generateMiniAppProvider(
                description: _promptController.text.trim())
            .future,
      ).timeout(
        const Duration(seconds: 90),
        onTimeout: () => throw TimeoutException('timeout'),
      );
      _loadingTimer?.cancel();
      setState(() {
        _currentApp = app;
        _isLoading = false;
      });
      _autoSave(app);
    } on TimeoutException {
      _loadingTimer?.cancel();
      setState(() {
        _error = 'Die Generierung hat zu lange gedauert. Versuche es mit einer einfacheren Beschreibung oder später erneut.';
        _isLoading = false;
      });
    } on AIException catch (e) {
      _loadingTimer?.cancel();
      setState(() {
        _error = e.statusCode == 408
            ? 'Zeitüberschreitung — das Netzwerk ist langsam. Bitte erneut versuchen.'
            : e.message;
        _isLoading = false;
      });
    } catch (e) {
      _loadingTimer?.cancel();
      setState(() {
        _error = 'Fehler: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _autoSave(GeneratedApp app) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    try {
      await ref.read(saveContentProvider(SavedContent(
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
      )).future);
    } catch (_) {}
  }

  void _openApp() {
    if (_currentApp == null) return;
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => AppViewerScreen(
        title: _currentApp!.title,
        htmlContent: _buildHtml(_currentApp!),
        originalPrompt: _promptController.text.trim(),
        contentType: ContentType.miniApp,
      ),
    ));
  }

  String _buildHtml(GeneratedApp app) {
    final html = app.html.trim();
    if (html.toLowerCase().startsWith('<!doctype') ||
        html.toLowerCase().startsWith('<html')) {
      return html;
    }
    return '''<!DOCTYPE html><html><head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>* { box-sizing: border-box; } body { margin: 0; padding: 16px; font-family: -apple-system, sans-serif; } ${app.css ?? ''}</style>
</head><body>${app.html}<script>${app.javascript ?? ''}</script></body></html>''';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHero(),
        _buildInput(),
        if (_error != null) _buildError(),
        Expanded(child: _buildResult()),
      ],
    );
  }

  Widget _buildHero() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
          SlamTokens.gutter, 12, SlamTokens.gutter, 0),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_kiA, _kiB],
        ),
        borderRadius: BorderRadius.circular(SlamTokens.rCardMd),
        boxShadow: [
          BoxShadow(
            color: _kiA.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -6,
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child:
                const Icon(Icons.auto_awesome, size: 22, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('KI-Labor',
                    style: GoogleFonts.fraunces(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3)),
                Text('Beschreibe — die KI baut es.',
                    style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.75))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius:
                  BorderRadius.circular(SlamTokens.rCircle),
            ),
            child: Text('NEU',
                style: GoogleFonts.dmSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          SlamTokens.gutter, 16, SlamTokens.gutter, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: SlamTokens.surface,
              borderRadius: BorderRadius.circular(SlamTokens.rInput),
              border: Border.all(color: SlamTokens.line),
            ),
            child: TextField(
              controller: _promptController,
              style: GoogleFonts.dmSans(
                  color: SlamTokens.text, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'z.B. "Erstelle einen Funktionsplotter"',
                hintStyle: GoogleFonts.dmSans(
                    color: SlamTokens.textDim, fontSize: 14),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.fromLTRB(16, 14, 48, 14),
                suffixIcon: _promptController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear,
                            size: 16, color: SlamTokens.textDim),
                        onPressed: () {
                          _promptController.clear();
                          setState(() => _currentApp = null);
                        },
                      )
                    : null,
              ),
              maxLines: 3,
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _generate(),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 32,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _examples.length,
              separatorBuilder: (_, __) => const SizedBox(width: 7),
              itemBuilder: (_, i) => GestureDetector(
                onTap: () {
                  _promptController.text = _examples[i];
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 11, vertical: 5),
                  decoration: BoxDecoration(
                    color: _kiA.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(SlamTokens.rCircle),
                    border: Border.all(
                        color: _kiA.withValues(alpha: 0.25)),
                  ),
                  child: Text(_examples[i],
                      style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: _kiA,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _isLoading ? null : _generate,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isLoading
                      ? [
                          _kiA.withValues(alpha: 0.4),
                          _kiB.withValues(alpha: 0.4)
                        ]
                      : [_kiA, _kiB],
                ),
                borderRadius:
                    BorderRadius.circular(SlamTokens.rCircle),
                boxShadow: _isLoading
                    ? null
                    : [
                        BoxShadow(
                          color: _kiA.withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                          spreadRadius: -4,
                        )
                      ],
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isLoading)
                    const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white))
                  else
                    const Icon(Icons.auto_awesome,
                        size: 16, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    _isLoading ? 'Generiere App…' : 'App generieren',
                    style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
          SlamTokens.gutter, 10, SlamTokens.gutter, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: SlamTokens.dangerSoft,
        borderRadius: BorderRadius.circular(SlamTokens.rCardMd),
        border:
            Border.all(color: SlamTokens.danger.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline,
              color: SlamTokens.danger, size: 16),
          const SizedBox(width: 8),
          Expanded(
              child: Text(_error!,
                  style: GoogleFonts.dmSans(
                      fontSize: 13, color: SlamTokens.danger))),
          GestureDetector(
            onTap: _generate,
            child: const Icon(Icons.refresh,
                color: SlamTokens.danger, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                  color: _kiA, strokeWidth: 3),
            ),
            const SizedBox(height: 20),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Text(
                _loadingMessage,
                key: ValueKey(_loadingMessage),
                style: GoogleFonts.fraunces(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: SlamTokens.text),
              ),
            ),
            const SizedBox(height: 6),
            Text('Das dauert etwa 15–30 Sekunden',
                style: GoogleFonts.dmSans(
                    fontSize: 13, color: SlamTokens.textDim)),
          ],
        ),
      );
    }

    if (_currentApp == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_kiA, _kiB],
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: _kiA.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: -6,
                    )
                  ],
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.auto_awesome,
                    size: 38, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text('Was soll die App können?',
                  style: GoogleFonts.fraunces(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: SlamTokens.text)),
              const SizedBox(height: 8),
              Text(
                'Beschreibe deine Idee — die KI generiert Rechner, Graphen und Simulatoren.',
                style: GoogleFonts.dmSans(
                    fontSize: 13, color: SlamTokens.textDim),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _kiA.withValues(alpha: 0.12),
                    _kiB.withValues(alpha: 0.08)
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(SlamTokens.rCardLg),
                border: Border.all(
                    color: _kiA.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [_kiA, _kiB]),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.check,
                        size: 26, color: Colors.white),
                  ),
                  const SizedBox(height: 14),
                  Text(_currentApp!.title,
                      style: GoogleFonts.fraunces(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: SlamTokens.text),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text('App generiert & gespeichert',
                      style: GoogleFonts.dmSans(
                          fontSize: 12, color: _kiA)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _openApp,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [_kiA, _kiB]),
                  borderRadius:
                      BorderRadius.circular(SlamTokens.rCircle),
                  boxShadow: [
                    BoxShadow(
                      color: _kiA.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                      spreadRadius: -4,
                    )
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.open_in_new,
                        size: 16, color: Colors.white),
                    const SizedBox(width: 8),
                    Text('App öffnen',
                        style: GoogleFonts.dmSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _generate,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.refresh,
                        size: 14, color: SlamTokens.textDim),
                    const SizedBox(width: 6),
                    Text('Neu generieren',
                        style: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: SlamTokens.textDim)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
