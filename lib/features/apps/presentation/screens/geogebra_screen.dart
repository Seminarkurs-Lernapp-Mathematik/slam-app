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

// GeoGebra accent colors
const _ggbA = SlamTokens.accentBlue;
const _ggbB = SlamTokens.accentIndigo;

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

  final List<String> _examples = [
    'Quadratische Funktion',
    'Kreistangente',
    'Sinusfunktion',
    'Parabel & Gerade',
    'Dreieck Mittelsenkrechte',
    'Vektoren addieren',
  ];

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    if (_promptController.text.trim().isEmpty) return;
    setState(() {
      _isLoading = true;
      _error = null;
      _currentVisualization = null;
    });
    try {
      final vis = await ref.read(
        generateGeogebraProvider(prompt: _promptController.text.trim()).future,
      );
      setState(() {
        _currentVisualization = vis;
        _isLoading = false;
      });
      _autoSave(vis);
    } on AIException catch (e) {
      setState(() {
        _error = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Fehler: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _autoSave(GeoGebraData data) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    try {
      final html = buildGeoGebraViewerHtml(data.commands);
      await ref.read(saveContentProvider(SavedContent(
        id: 'ggb-${DateTime.now().millisecondsSinceEpoch}',
        userId: user.uid,
        title: data.title,
        type: ContentType.geogebra,
        htmlContent: html,
        description: _promptController.text.trim(),
        createdAt: DateTime.now(),
        tags: ['geogebra'],
      )).future);
    } catch (_) {}
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
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_ggbA, _ggbB],
        ),
        borderRadius: BorderRadius.circular(SlamTokens.rCardMd),
        boxShadow: [
          BoxShadow(
            color: _ggbA.withValues(alpha: 0.3),
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
            child: const Icon(Icons.functions, size: 22, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('GeoGebra-Visualisierung',
                    style: GoogleFonts.fraunces(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3)),
                Text('Funktionen, Geometrie, Vektoren',
                    style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.75))),
              ],
            ),
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
                hintText: 'z.B. "Zeige eine quadratische Funktion"',
                hintStyle: GoogleFonts.dmSans(
                    color: SlamTokens.textDim, fontSize: 14),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.fromLTRB(16, 14, 48, 14),
                suffixIcon: _promptController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear,
                            size: 16, color: SlamTokens.textDim),
                        onPressed: () {
                          _promptController.clear();
                          setState(() => _currentVisualization = null);
                        },
                      )
                    : null,
              ),
              maxLines: 2,
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
                    color: _ggbA.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(SlamTokens.rCircle),
                    border: Border.all(
                        color: _ggbA.withValues(alpha: 0.25)),
                  ),
                  child: Text(_examples[i],
                      style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: _ggbA,
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
                          _ggbA.withValues(alpha: 0.4),
                          _ggbB.withValues(alpha: 0.4)
                        ]
                      : [_ggbA, _ggbB],
                ),
                borderRadius: BorderRadius.circular(SlamTokens.rCircle),
                boxShadow: _isLoading
                    ? null
                    : [
                        BoxShadow(
                          color: _ggbA.withValues(alpha: 0.35),
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
                    _isLoading
                        ? 'Generiere…'
                        : 'Visualisierung erstellen',
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
                color: _ggbA,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 20),
            Text('Visualisierung wird erstellt…',
                style: GoogleFonts.fraunces(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: SlamTokens.text)),
            const SizedBox(height: 6),
            Text('GeoGebra-Befehle werden generiert',
                style: GoogleFonts.dmSans(
                    fontSize: 13, color: SlamTokens.textDim)),
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
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_ggbA, _ggbB],
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: _ggbA.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: -6,
                    )
                  ],
                ),
                alignment: Alignment.center,
                child:
                    const Icon(Icons.functions, size: 38, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text('Was willst du sehen?',
                  style: GoogleFonts.fraunces(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: SlamTokens.text)),
              const SizedBox(height: 8),
              Text('Beschreibe eine Funktion, Konstruktion oder Visualisierung.',
                  style: GoogleFonts.dmSans(
                      fontSize: 13, color: SlamTokens.textDim),
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
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _ggbA.withValues(alpha: 0.12),
                    _ggbB.withValues(alpha: 0.08)
                  ],
                ),
                borderRadius: BorderRadius.circular(SlamTokens.rCardLg),
                border: Border.all(color: _ggbA.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [_ggbA, _ggbB]),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.check,
                        size: 26, color: Colors.white),
                  ),
                  const SizedBox(height: 14),
                  Text(vis.title,
                      style: GoogleFonts.fraunces(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: SlamTokens.text),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  if (vis.description.isNotEmpty) ...[
                    Text(vis.description,
                        style: GoogleFonts.dmSans(
                            fontSize: 12, color: SlamTokens.textDim),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                  ],
                  Text('${vis.commands.length} Befehle · gespeichert',
                      style: GoogleFonts.dmSans(
                          fontSize: 11, color: _ggbA)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _openVisualization,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [_ggbA, _ggbB]),
                  borderRadius:
                      BorderRadius.circular(SlamTokens.rCircle),
                  boxShadow: [
                    BoxShadow(
                      color: _ggbA.withValues(alpha: 0.4),
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
                    Text('Öffnen',
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
