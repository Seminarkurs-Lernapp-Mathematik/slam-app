import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/design_tokens.dart';
import '../../../../core/models/saved_content.dart';
import '../../../../core/presentation/widgets/cross_platform_webview.dart';
import '../providers/apps_providers.dart';
import '../widgets/code_viewer.dart';

class ContentLibraryScreen extends ConsumerStatefulWidget {
  const ContentLibraryScreen({super.key});

  @override
  ConsumerState<ContentLibraryScreen> createState() => _ContentLibraryScreenState();
}

class _ContentLibraryScreenState extends ConsumerState<ContentLibraryScreen> {
  @override
  Widget build(BuildContext context) {
    final contentAsync = ref.watch(filteredSavedContentProvider);
    final currentFilter = ref.watch(contentTypeFilterProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Column(
      children: [
        _buildFilterBar(currentFilter, searchQuery),
        Expanded(
          child: contentAsync.when(
            data: (content) {
              if (content.isEmpty) {
                return _EmptyState(hasFilter: currentFilter != null || searchQuery.isNotEmpty);
              }
              return GridView.builder(
                padding: const EdgeInsets.all(SlamTokens.gutter),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.85,
                ),
                itemCount: content.length,
                itemBuilder: (_, i) => _ContentCard(
                  content: content[i],
                  onTap: () => _openContent(content[i]),
                  onDelete: () => _deleteContent(content[i]),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: SlamTokens.primary)),
            error: (error, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: SlamTokens.danger),
                  const SizedBox(height: 16),
                  Text('Fehler: $error',
                      style: GoogleFonts.dmSans(color: SlamTokens.textDim)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar(ContentType? currentFilter, String searchQuery) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SlamTokens.surface,
        border: Border(bottom: BorderSide(color: SlamTokens.line)),
      ),
      child: Column(
        children: [
          TextField(
            style: GoogleFonts.dmSans(color: SlamTokens.text, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Inhalte durchsuchen...',
              hintStyle: GoogleFonts.dmSans(color: SlamTokens.textDim, fontSize: 14),
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
              prefixIcon: const Icon(Icons.search, color: SlamTokens.textDim, size: 20),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18, color: SlamTokens.textDim),
                      onPressed: () => ref.read(searchQueryProvider.notifier).clear(),
                    )
                  : null,
            ),
            onChanged: (v) => ref.read(searchQueryProvider.notifier).setQuery(v),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterPill('Alle', selected: currentFilter == null,
                    onTap: () => ref.read(contentTypeFilterProvider.notifier).setFilter(null)),
                const SizedBox(width: 8),
                _FilterPill('Simulationen', selected: currentFilter == ContentType.miniApp,
                    onTap: () => ref.read(contentTypeFilterProvider.notifier).setFilter(ContentType.miniApp)),
                const SizedBox(width: 8),
                _FilterPill('GeoGebra', selected: currentFilter == ContentType.geogebra,
                    onTap: () => ref.read(contentTypeFilterProvider.notifier).setFilter(ContentType.geogebra)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openContent(SavedContent content) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => _ContentViewer(content: content),
    ));
  }

  Future<void> _deleteContent(SavedContent content) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: SlamTokens.surface,
        title: Text('Inhalt löschen?',
            style: GoogleFonts.fraunces(fontWeight: FontWeight.w700, color: SlamTokens.text)),
        content: Text(
          'Möchtest du "${content.title}" wirklich löschen?',
          style: GoogleFonts.dmSans(color: SlamTokens.textDim),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Abbrechen', style: GoogleFonts.dmSans(color: SlamTokens.textDim)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Löschen', style: GoogleFonts.dmSans(color: SlamTokens.danger, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(deleteContentProvider(content.id).future);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gelöscht', style: GoogleFonts.dmSans(color: SlamTokens.primaryOn)),
            backgroundColor: SlamTokens.surface,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler: $e', style: GoogleFonts.dmSans(color: SlamTokens.primaryOn)),
            backgroundColor: SlamTokens.danger,
          ),
        );
      }
    }
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill(this.label, {required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: SlamTokens.dState,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? SlamTokens.primary : SlamTokens.bgElev,
          borderRadius: BorderRadius.circular(SlamTokens.rCircle),
          border: Border.all(color: selected ? SlamTokens.primary : SlamTokens.line),
        ),
        child: Text(label, style: GoogleFonts.dmSans(
            fontSize: 13, fontWeight: FontWeight.w600,
            color: selected ? SlamTokens.primaryOn : SlamTokens.textDim)),
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({required this.content, required this.onTap, required this.onDelete});
  final SavedContent content;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(content.type);
    return GestureDetector(
      onTap: onTap,
      onLongPress: onDelete,
      child: Container(
        decoration: BoxDecoration(
          color: SlamTokens.surface,
          borderRadius: BorderRadius.circular(SlamTokens.rCardMd),
          border: Border.all(color: SlamTokens.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: color.withValues(alpha: 0.12),
                alignment: Alignment.center,
                child: Icon(_typeIcon(content.type), size: 40, color: color),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(content.title,
                      style: GoogleFonts.fraunces(
                          fontSize: 13, fontWeight: FontWeight.w700, color: SlamTokens.text),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.label_outline, size: 11, color: SlamTokens.textDim),
                    const SizedBox(width: 4),
                    Expanded(child: Text(content.type.displayName,
                        style: GoogleFonts.dmSans(fontSize: 11, color: SlamTokens.textDim))),
                  ]),
                  const SizedBox(height: 2),
                  Row(children: [
                    Icon(Icons.access_time, size: 11, color: SlamTokens.textDim),
                    const SizedBox(width: 4),
                    Expanded(child: Text(_formatDate(content.createdAt),
                        style: GoogleFonts.dmSans(fontSize: 11, color: SlamTokens.textDim))),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _typeIcon(ContentType type) {
    switch (type) {
      case ContentType.miniApp: return Icons.auto_awesome;
      case ContentType.geogebra: return Icons.functions;
      case ContentType.simulation: return Icons.science;
      case ContentType.chat: return Icons.chat_bubble_outline;
    }
  }

  Color _typeColor(ContentType type) {
    switch (type) {
      case ContentType.miniApp: return const Color(0xFFC88CFF);
      case ContentType.geogebra: return const Color(0xFF60A5FA);
      case ContentType.simulation: return const Color(0xFF4ADE80);
      case ContentType.chat: return const Color(0xFF2DD4BF);
    }
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'Heute';
    if (diff.inDays == 1) return 'Gestern';
    if (diff.inDays < 7) return 'vor ${diff.inDays} Tagen';
    return '${date.day}.${date.month}.${date.year}';
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasFilter});
  final bool hasFilter;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: SlamTokens.bgElev,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Icon(hasFilter ? Icons.search_off : Icons.folder_open,
                  size: 36, color: SlamTokens.textDim),
            ),
            const SizedBox(height: 20),
            Text(hasFilter ? 'Keine Inhalte gefunden' : 'Noch keine Inhalte',
                style: GoogleFonts.fraunces(
                    fontSize: 20, fontWeight: FontWeight.w700, color: SlamTokens.text)),
            const SizedBox(height: 8),
            Text(
              hasFilter
                  ? 'Versuche einen anderen Filter'
                  : 'Erstelle deine ersten Apps im KI-Labor',
              style: GoogleFonts.dmSans(fontSize: 13, color: SlamTokens.textDim),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentViewer extends StatefulWidget {
  const _ContentViewer({required this.content});
  final SavedContent content;

  @override
  State<_ContentViewer> createState() => _ContentViewerState();
}

class _ContentViewerState extends State<_ContentViewer> {
  String _buildFullHTML() {
    return '''<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>* { box-sizing: border-box; } body { margin: 0; padding: 16px; font-family: -apple-system, sans-serif; } ${widget.content.cssContent ?? ''}</style>
</head>
<body>
    ${widget.content.htmlContent}
    <script>${widget.content.javascriptContent ?? ''}</script>
</body>
</html>''';
  }

  void _showCodeViewer() {
    showCodeViewerBottomSheet(
      context,
      html: widget.content.htmlContent,
      css: widget.content.cssContent,
      javascript: widget.content.javascriptContent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SlamTokens.bg,
      appBar: AppBar(
        backgroundColor: SlamTokens.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: SlamTokens.text),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.content.title,
            style: GoogleFonts.fraunces(fontSize: 18, fontWeight: FontWeight.w700, color: SlamTokens.text)),
        actions: [
          IconButton(
            icon: const Icon(Icons.code, color: SlamTokens.textDim),
            onPressed: _showCodeViewer,
            tooltip: 'Code ansehen',
          ),
        ],
      ),
      body: CrossPlatformWebView(
        htmlContent: _buildFullHTML(),
        onPageFinished: () => debugPrint('✅ Content loaded: ${widget.content.title}'),
      ),
    );
  }
}
