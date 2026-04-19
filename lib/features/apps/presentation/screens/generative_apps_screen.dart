import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/design_tokens.dart';
import '../../../../core/models/saved_content.dart';
import '../../../../core/services/ai_service.dart';
import '../../../../core/services/auth_service.dart';
import '../providers/apps_providers.dart';
import 'app_viewer_screen.dart';

class GenerativeAppsScreen extends ConsumerStatefulWidget {
  const GenerativeAppsScreen({super.key});

  @override
  ConsumerState<GenerativeAppsScreen> createState() => _GenerativeAppsScreenState();
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
      setState(() => _error = 'Bitte gib eine Beschreibung ein');
      return;
    }
    setState(() { _isLoading = true; _error = null; _currentApp = null; });
    try {
      final app = await ref.read(
        generateMiniAppProvider(description: _promptController.text.trim()).future,
      );
      setState(() { _isLoading = false; _currentApp = app; });
      _autoSave(app);
    } on AIException catch (e) {
      setState(() { _error = e.message; _isLoading = false; });
    } catch (e) {
      setState(() { _error = 'Fehler beim Generieren: $e'; _isLoading = false; });
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
    } catch (e) {
      debugPrint('⚠️ KI-Labor: auto-save failed: $e');
    }
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
    if (html.toLowerCase().startsWith('<!doctype') || html.toLowerCase().startsWith('<html')) {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildInputSection(),
        Expanded(child: _buildResultArea()),
      ],
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SlamTokens.surface,
        border: Border(bottom: BorderSide(color: SlamTokens.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _promptController,
            style: GoogleFonts.dmSans(color: SlamTokens.text, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'z.B. "Erstelle einen Funktionsplotter"',
              hintStyle: GoogleFonts.dmSans(color: SlamTokens.textDim, fontSize: 14),
              labelText: 'Was soll die App können?',
              labelStyle: GoogleFonts.dmSans(color: SlamTokens.textDim, fontSize: 13),
              filled: true,
              fillColor: SlamTokens.bgElev,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SlamTokens.rCardMd),
                borderSide: BorderSide(color: SlamTokens.line),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SlamTokens.rCardMd),
                borderSide: BorderSide(color: SlamTokens.line),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SlamTokens.rCardMd),
                borderSide: const BorderSide(color: SlamTokens.primary, width: 1.5),
              ),
              prefixIcon: const Icon(Icons.auto_awesome, color: SlamTokens.primary, size: 20),
              suffixIcon: _promptController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18, color: SlamTokens.textDim),
                      onPressed: () { _promptController.clear(); setState(() => _currentApp = null); },
                    )
                  : null,
            ),
            maxLines: 3,
            textInputAction: TextInputAction.done,
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _generateApp(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _examplePrompts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => GestureDetector(
                onTap: () { _promptController.text = _examplePrompts[i]; setState(() {}); },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: SlamTokens.bgElev,
                    borderRadius: BorderRadius.circular(SlamTokens.rCircle),
                    border: Border.all(color: SlamTokens.line),
                  ),
                  child: Text(_examplePrompts[i],
                      style: GoogleFonts.dmSans(fontSize: 12, color: SlamTokens.textDim)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _isLoading ? null : _generateApp,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: _isLoading ? SlamTokens.primary.withValues(alpha: 0.5) : SlamTokens.primary,
                borderRadius: BorderRadius.circular(SlamTokens.rCircle),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isLoading)
                    const SizedBox(width: 18, height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: SlamTokens.primaryOn))
                  else
                    const Icon(Icons.auto_awesome, size: 18, color: SlamTokens.primaryOn),
                  const SizedBox(width: 8),
                  Text(_isLoading ? 'Generiere App...' : 'App generieren',
                      style: GoogleFonts.dmSans(
                          fontSize: 14, fontWeight: FontWeight.w700,
                          color: SlamTokens.primaryOn)),
                ],
              ),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: SlamTokens.dangerSoft,
                borderRadius: BorderRadius.circular(SlamTokens.rCardMd),
                border: Border.all(color: SlamTokens.danger.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: SlamTokens.danger, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_error!,
                      style: GoogleFonts.dmSans(fontSize: 13, color: SlamTokens.danger))),
                  GestureDetector(
                    onTap: _generateApp,
                    child: const Icon(Icons.refresh, color: SlamTokens.danger, size: 18),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultArea() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: SlamTokens.primary),
            const SizedBox(height: 16),
            Text('App wird generiert…',
                style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600, color: SlamTokens.text)),
            const SizedBox(height: 6),
            Text('Das dauert etwa 10–20 Sekunden',
                style: GoogleFonts.dmSans(fontSize: 13, color: SlamTokens.textDim)),
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
                width: 72, height: 72,
                decoration: BoxDecoration(
                  color: SlamTokens.primarySoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.auto_awesome, size: 36, color: SlamTokens.primary),
              ),
              const SizedBox(height: 20),
              Text('KI-Labor',
                  style: GoogleFonts.fraunces(fontSize: 20, fontWeight: FontWeight.w700, color: SlamTokens.text)),
              const SizedBox(height: 8),
              Text('Beschreibe, was die App können soll',
                  style: GoogleFonts.dmSans(fontSize: 13, color: SlamTokens.textDim),
                  textAlign: TextAlign.center),
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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: SlamTokens.primarySoft,
                borderRadius: BorderRadius.circular(SlamTokens.rCardLg),
                border: Border.all(color: SlamTokens.primary.withValues(alpha: 0.25)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.check_circle, size: 48, color: SlamTokens.primary),
                  const SizedBox(height: 12),
                  Text(_currentApp!.title,
                      style: GoogleFonts.fraunces(fontSize: 18, fontWeight: FontWeight.w700, color: SlamTokens.text),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text('App erfolgreich generiert und gespeichert',
                      style: GoogleFonts.dmSans(fontSize: 12, color: SlamTokens.textDim),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _openApp,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                decoration: BoxDecoration(
                  color: SlamTokens.primary,
                  borderRadius: BorderRadius.circular(SlamTokens.rCircle),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.open_in_new, size: 18, color: SlamTokens.primaryOn),
                    const SizedBox(width: 8),
                    Text('Öffnen', style: GoogleFonts.dmSans(
                        fontSize: 15, fontWeight: FontWeight.w800, color: SlamTokens.primaryOn)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _generateApp,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: SlamTokens.line),
                  borderRadius: BorderRadius.circular(SlamTokens.rCircle),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.refresh, size: 16, color: SlamTokens.textDim),
                    const SizedBox(width: 6),
                    Text('Neu generieren',
                        style: GoogleFonts.dmSans(fontSize: 13, color: SlamTokens.textDim)),
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
