import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Code Viewer Widget
///
/// Displays HTML, CSS, and JavaScript code with syntax highlighting
class CodeViewer extends StatefulWidget {
  final String? html;
  final String? css;
  final String? javascript;

  const CodeViewer({
    super.key,
    this.html,
    this.css,
    this.javascript,
  });

  @override
  State<CodeViewer> createState() => _CodeViewerState();
}

class _CodeViewerState extends State<CodeViewer>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _activeTabIndex = 0;

  @override
  void initState() {
    super.initState();
    final tabs = _getAvailableTabs();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _activeTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<_CodeTab> _getAvailableTabs() {
    final tabs = <_CodeTab>[];
    if (widget.html != null && widget.html!.isNotEmpty) {
      tabs.add(_CodeTab('HTML', widget.html!, Icons.code));
    }
    if (widget.css != null && widget.css!.isNotEmpty) {
      tabs.add(_CodeTab('CSS', widget.css!, Icons.style));
    }
    if (widget.javascript != null && widget.javascript!.isNotEmpty) {
      tabs.add(_CodeTab('JavaScript', widget.javascript!, Icons.javascript));
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = _getAvailableTabs();

    if (tabs.isEmpty) {
      return const Center(
        child: Text('Kein Code verfügbar'),
      );
    }

    return Column(
      children: [
        Container(
          color: Theme.of(context).colorScheme.surfaceContainer,
          child: Row(
            children: [
              Expanded(
                child: TabBar(
                  controller: _tabController,
                  tabs: tabs
                      .map((tab) => Tab(
                            icon: Icon(tab.icon),
                            text: tab.title,
                          ))
                      .toList(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                tooltip: 'Code kopieren',
                onPressed: () => _copyCurrentCode(context, tabs),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: tabs
                .map((tab) => _CodeDisplay(
                      code: tab.code,
                      language: tab.title.toLowerCase(),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  void _copyCurrentCode(BuildContext context, List<_CodeTab> tabs) {
    final currentCode = tabs[_activeTabIndex].code;
    Clipboard.setData(ClipboardData(text: currentCode));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${tabs[_activeTabIndex].title} Code kopiert'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _CodeTab {
  final String title;
  final String code;
  final IconData icon;

  _CodeTab(this.title, this.code, this.icon);
}

class _CodeDisplay extends StatelessWidget {
  final String code;
  final String language;

  const _CodeDisplay({
    required this.code,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1E1E1E), // Dark background like VS Code
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SelectableText(
          code,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            color: Color(0xFFD4D4D4), // Light gray text
            height: 1.5,
          ),
          // Simple syntax highlighting with TextSpan would go here
          // For production, consider using flutter_highlight package
        ),
      ),
    );
  }
}

/// Show code viewer in bottom sheet
void showCodeViewerBottomSheet(
  BuildContext context, {
  required String? html,
  required String? css,
  required String? javascript,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.code),
                  const SizedBox(width: 12),
                  const Text(
                    'Code ansehen',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CodeViewer(
                html: html,
                css: css,
                javascript: javascript,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
