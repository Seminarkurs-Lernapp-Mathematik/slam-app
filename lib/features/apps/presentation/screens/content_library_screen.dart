import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/models/saved_content.dart';
import '../providers/apps_providers.dart';
import '../widgets/code_viewer.dart';

/// Content Library Screen
///
/// Displays all saved user-generated content
class ContentLibraryScreen extends ConsumerStatefulWidget {
  const ContentLibraryScreen({super.key});

  @override
  ConsumerState<ContentLibraryScreen> createState() =>
      _ContentLibraryScreenState();
}

class _ContentLibraryScreenState extends ConsumerState<ContentLibraryScreen> {
  @override
  Widget build(BuildContext context) {
    final contentAsync = ref.watch(filteredSavedContentProvider);
    final currentFilter = ref.watch(contentTypeFilterProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Column(
      children: [
        // Search and Filter section
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
            children: [
              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Inhalte durchsuchen...',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            ref.read(searchQueryProvider.notifier).clear();
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).setQuery(value);
                },
              ),
              const SizedBox(height: 12),

              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('Alle'),
                      selected: currentFilter == null,
                      onSelected: (_) {
                        ref
                            .read(contentTypeFilterProvider.notifier)
                            .setFilter(null);
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Simulationen'),
                      selected: currentFilter == ContentType.miniApp,
                      onSelected: (_) {
                        ref
                            .read(contentTypeFilterProvider.notifier)
                            .setFilter(ContentType.miniApp);
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('GeoGebra'),
                      selected: currentFilter == ContentType.geogebra,
                      onSelected: (_) {
                        ref
                            .read(contentTypeFilterProvider.notifier)
                            .setFilter(ContentType.geogebra);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Content grid
        Expanded(
          child: contentAsync.when(
            data: (content) {
              if (content.isEmpty) {
                return _EmptyState(
                  hasFilter: currentFilter != null || searchQuery.isNotEmpty,
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: content.length,
                itemBuilder: (context, index) {
                  return _ContentCard(
                    content: content[index],
                    onTap: () => _openContent(context, content[index]),
                    onDelete: () => _deleteContent(content[index]),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Fehler: $error'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openContent(BuildContext context, SavedContent content) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _ContentViewer(content: content),
      ),
    );
  }

  Future<void> _deleteContent(SavedContent content) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Inhalt löschen?'),
        content: Text(
          'Möchtest du "${content.title}" wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(deleteContentProvider(content.id).future);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inhalt erfolgreich gelöscht'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Löschen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _ContentCard extends StatelessWidget {
  final SavedContent content;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ContentCard({
    required this.content,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onDelete,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Icon/Thumbnail
            Expanded(
              child: Container(
                color: _getTypeColor(content.type).withValues(alpha: 0.1),
                child: Center(
                  child: Icon(
                    _getTypeIcon(content.type),
                    size: 48,
                    color: _getTypeColor(content.type),
                  ),
                ),
              ),
            ),

            // Content info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.label_outline,
                        size: 12,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          content.type.displayName,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _formatDate(content.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(ContentType type) {
    switch (type) {
      case ContentType.miniApp:
        return Icons.auto_awesome;
      case ContentType.geogebra:
        return Icons.functions;
      case ContentType.simulation:
        return Icons.science;
    }
  }

  Color _getTypeColor(ContentType type) {
    switch (type) {
      case ContentType.miniApp:
        return Colors.purple;
      case ContentType.geogebra:
        return Colors.blue;
      case ContentType.simulation:
        return Colors.green;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Heute';
    } else if (diff.inDays == 1) {
      return 'Gestern';
    } else if (diff.inDays < 7) {
      return 'vor ${diff.inDays} Tagen';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasFilter;

  const _EmptyState({required this.hasFilter});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasFilter ? Icons.search_off : Icons.folder_open,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            hasFilter ? 'Keine Inhalte gefunden' : 'Noch keine Inhalte',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasFilter
                ? 'Versuche es mit einem anderen Filter'
                : 'Erstelle deine ersten Apps im KI-Labor',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _ContentViewer extends StatefulWidget {
  final SavedContent content;

  const _ContentViewer({required this.content});

  @override
  State<_ContentViewer> createState() => _ContentViewerState();
}

class _ContentViewerState extends State<_ContentViewer> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    final html = _buildFullHTML();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(html);
  }

  String _buildFullHTML() {
    return '''
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * {
            box-sizing: border-box;
        }
        body {
            margin: 0;
            padding: 16px;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        ${widget.content.cssContent ?? ''}
    </style>
</head>
<body>
    ${widget.content.htmlContent}
    <script>
        ${widget.content.javascriptContent ?? ''}
    </script>
</body>
</html>
    ''';
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
      appBar: AppBar(
        title: Text(widget.content.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.code),
            onPressed: _showCodeViewer,
            tooltip: 'Code ansehen',
          ),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
