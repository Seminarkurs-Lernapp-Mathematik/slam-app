import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/design_tokens.dart';
import '../../../../core/models/question.dart';
import '../../../../core/models/saved_content.dart';
import '../../../../core/services/ai_service.dart';
import '../../../../core/services/auth_service.dart';
import '../providers/apps_providers.dart';
import 'app_viewer_screen.dart';

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

  Future<void> _generateVisualization() async {
    if (_promptController.text.trim().isEmpty) {
      setState(() => _error = 'Bitte gib eine Beschreibung ein');
      return;
    }
    setState(() { _isLoading = true; _error = null; _currentVisualization = null; });
    try {
      final visualization = await ref.read(
        generateGeogebraProvider(prompt: _promptController.text.trim()).future,
      );
      setState(() { _currentVisualization = visualization; _isLoading = false; });
      _autoSave(visualization);
    } on AIException catch (e) {
      setState(() { _error = e.message; _isLoading = false; });
    } catch (e) {
      setState(() { _error = 'Fehler beim Generieren: $e'; _isLoading = false; });
    }
  }

  Future<void> _autoSave(GeoGebraData data) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    try {
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
    } catch (e) {
      debugPrint('⚠️ GeoGebra: auto-save failed: $e');
    }
  }

  void _openVisualization() {
    if (_currentVisualization == null) return;
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => AppViewerScreen(
        title: _currentVisualization!.title,
        htmlContent: buildGeoGebraViewerHtml(_currentVisualization!.commands),
        originalPrompt: _promptController.text.trim(),
        contentType: ContentType.geogebra,
      ),
    ));
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
              hintText: 'z.B. "Zeige eine quadratische Funktion"',
              hintStyle: GoogleFonts.dmSans(color: SlamTokens.textDim, fontSize: 14),
              labelText: 'Was möchtest du visualisieren?',
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
              prefixIcon: const Icon(Icons.functions, color: SlamTokens.primary, size: 20),
              suffixIcon: _promptController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18, color: SlamTokens.textDim),
                      onPressed: () { _promptController.clear(); setState(() => _currentVisualization = null); },
                    )
                  : null,
            ),
            maxLines: 2,
            textInputAction: TextInputAction.done,
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _generateVisualization(),
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
            onTap: _isLoading ? null : _generateVisualization,
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
                  Text(_isLoading ? 'Generiere...' : 'Visualisierung generieren',
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
                    onTap: _generateVisualization,
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
            Text('Visualisierung wird erstellt…',
                style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600, color: SlamTokens.text)),
            const SizedBox(height: 6),
            Text('GeoGebra-Befehle werden generiert',
                style: GoogleFonts.dmSans(fontSize: 13, color: SlamTokens.textDim)),
          ],
        ),
      );
    }

    if (_currentVisualization == null) {
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
                child: const Icon(Icons.functions, size: 36, color: SlamTokens.primary),
              ),
              const SizedBox(height: 20),
              Text('GeoGebra-Visualisierung',
                  style: GoogleFonts.fraunces(fontSize: 20, fontWeight: FontWeight.w700, color: SlamTokens.text)),
              const SizedBox(height: 8),
              Text('Beschreibe, was du visualisieren möchtest',
                  style: GoogleFonts.dmSans(fontSize: 13, color: SlamTokens.textDim),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

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
                color: SlamTokens.primarySoft,
                borderRadius: BorderRadius.circular(SlamTokens.rCardLg),
                border: Border.all(color: SlamTokens.primary.withValues(alpha: 0.25)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.check_circle, size: 48, color: SlamTokens.primary),
                  const SizedBox(height: 12),
                  Text(vis.title,
                      style: GoogleFonts.fraunces(fontSize: 18, fontWeight: FontWeight.w700, color: SlamTokens.text),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  if (vis.description.isNotEmpty) ...[
                    Text(vis.description,
                        style: GoogleFonts.dmSans(fontSize: 12, color: SlamTokens.textDim),
                        textAlign: TextAlign.center,
                        maxLines: 3, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                  ],
                  Text('${vis.commands.length} Befehle • automatisch gespeichert',
                      style: GoogleFonts.dmSans(fontSize: 11, color: SlamTokens.textDim)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _openVisualization,
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
              onTap: _generateVisualization,
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
