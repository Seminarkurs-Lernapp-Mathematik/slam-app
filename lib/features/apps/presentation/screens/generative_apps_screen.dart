import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/design_tokens.dart';
import '../../../../core/models/saved_content.dart';
import '../../../../core/services/ai_service.dart';
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

class _GenerativeAppsScreenState extends ConsumerState<GenerativeAppsScreen> {
  final _promptController = TextEditingController();
  bool _isFastMode = false;
  String? _error;
  GeneratedApp? _currentApp;

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
    super.dispose();
  }

  Future<void> _generate() async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    // Show initial notification
    final durationText = _isFastMode ? '15-25' : '30-90';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Das dauert ca. $durationText Sekunden. Du kannst die App weiter nutzen, wir benachrichtigen dich!',
          style: GoogleFonts.dmSans(fontSize: 13),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
      ),
    );

    // Start background generation
    ref.read(miniAppGeneratorProvider.notifier).generateInBackground(
          description: prompt,
          isFastMode: _isFastMode,
        );

    // Clear and reset UI immediately
    setState(() {
      _promptController.clear();
      _error = null;
      _currentApp = null;
    });
    HapticFeedback.lightImpact();
  }

  void _openApp() {
    final latestApp = ref.read(generatedAppStateProvider);
    final app = _currentApp ?? latestApp;
    if (app == null) return;
    
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => AppViewerScreen(
        title: app.title,
        htmlContent: _buildHtml(app),
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(SlamTokens.rCircle),
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
              style: GoogleFonts.dmSans(color: SlamTokens.text, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'z.B. "Erstelle einen Funktionsplotter"',
                hintStyle:
                    GoogleFonts.dmSans(color: SlamTokens.textDim, fontSize: 14),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.fromLTRB(16, 14, 48, 14),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                  decoration: BoxDecoration(
                    color: _kiA.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(SlamTokens.rCircle),
                    border: Border.all(color: _kiA.withValues(alpha: 0.25)),
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
          Row(
            children: [
              Switch(
                value: _isFastMode,
                onChanged: (val) => setState(() => _isFastMode = val),
                activeColor: _kiA,
                inactiveThumbColor: SlamTokens.textDim,
                inactiveTrackColor: SlamTokens.surfaceHi,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isFastMode ? 'Fast-Modus (Haiku)' : 'Smart-Modus (Sonnet)',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: SlamTokens.text,
                      ),
                    ),
                    Text(
                      _isFastMode ? 'Schneller, ideal für einfache UI-Apps' : 'Höchste Qualität für komplexe Logik',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: SlamTokens.textDim,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _generate,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_kiA, _kiB],
                ),
                borderRadius: BorderRadius.circular(SlamTokens.rCircle),
                boxShadow: [
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
                  const Icon(Icons.auto_awesome, size: 16, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'App generieren',
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
        border: Border.all(color: SlamTokens.danger.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: SlamTokens.danger, size: 16),
          const SizedBox(width: 8),
          Expanded(
              child: Text(_error!,
                  style: GoogleFonts.dmSans(
                      fontSize: 13, color: SlamTokens.danger))),
          GestureDetector(
            onTap: _generate,
            child:
                const Icon(Icons.refresh, color: SlamTokens.danger, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final latestApp = ref.watch(generatedAppStateProvider);
    final displayApp = _currentApp ?? latestApp;

    if (displayApp == null) {
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
                style:
                    GoogleFonts.dmSans(fontSize: 13, color: SlamTokens.textDim),
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
                borderRadius: BorderRadius.circular(SlamTokens.rCardLg),
                border: Border.all(color: _kiA.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [_kiA, _kiB]),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child:
                        const Icon(Icons.check, size: 26, color: Colors.white),
                  ),
                  const SizedBox(height: 14),
                  Text(displayApp.title,
                      style: GoogleFonts.fraunces(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: SlamTokens.text),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text('App generiert & gespeichert',
                      style: GoogleFonts.dmSans(fontSize: 12, color: _kiA)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _openApp,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [_kiA, _kiB]),
                  borderRadius: BorderRadius.circular(SlamTokens.rCircle),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.refresh,
                        size: 14, color: SlamTokens.textDim),
                    const SizedBox(width: 6),
                    Text('Neu generieren',
                        style: GoogleFonts.dmSans(
                            fontSize: 13, color: SlamTokens.textDim)),
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
