import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'dart:async';

void main() {
  runApp(const PrototypeApp());
}

class PrototypeApp extends StatelessWidget {
  const PrototypeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SLAM Prototype',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFf97316), // Orange from React app
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const PrototypeHome(),
    );
  }
}

class PrototypeHome extends StatefulWidget {
  const PrototypeHome({super.key});

  @override
  State<PrototypeHome> createState() => _PrototypeHomeState();
}

class _PrototypeHomeState extends State<PrototypeHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const GeoGebraPrototype(),
    const LatexPrototype(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SLAM Flutter Prototype'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.functions),
            label: 'GeoGebra',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate),
            label: 'LaTeX',
          ),
        ],
      ),
    );
  }
}

// GeoGebra Prototype Screen
class GeoGebraPrototype extends StatefulWidget {
  const GeoGebraPrototype({super.key});

  @override
  State<GeoGebraPrototype> createState() => _GeoGebraPrototypeState();
}

class _GeoGebraPrototypeState extends State<GeoGebraPrototype> {
  late WebViewController _controller;
  bool _isLoading = true;
  String _status = 'Initializing...';
  final Stopwatch _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _stopwatch.start();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF1a1a1f))
      ..addJavaScriptChannel(
        'GeoGebraFlutter',
        onMessageReceived: (JavaScriptMessage message) {
          setState(() {
            _status = 'Message from GeoGebra: ${message.message}';
          });
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _status = 'Loading GeoGebra...';
            });
          },
          onPageFinished: (String url) {
            _stopwatch.stop();
            setState(() {
              _isLoading = false;
              _status = 'Loaded in ${_stopwatch.elapsedMilliseconds}ms';
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _status = 'Error: ${error.description}';
              _isLoading = false;
            });
          },
        ),
      )
      ..loadHtmlString(_buildGeoGebraHTML());
  }

  String _buildGeoGebraHTML() {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="https://www.geogebra.org/apps/deployggb.js"></script>
  <style>
    body {
      margin: 0;
      padding: 0;
      background-color: #1a1a1f;
      overflow: hidden;
    }
    #ggb-element {
      width: 100vw;
      height: 100vh;
    }
  </style>
</head>
<body>
  <div id="ggb-element"></div>
  <script>
    var parameters = {
      appName: "classic",
      width: window.innerWidth,
      height: window.innerHeight,
      showToolBar: true,
      showAlgebraInput: false,
      showMenuBar: false,
      enableShiftDragZoom: true,
      enableRightClick: false,
      showResetIcon: true,
      language: "de",
      useBrowserForJS: true,
      appletOnLoad: function(api) {
        // Send ready message to Flutter
        if (window.GeoGebraFlutter) {
          GeoGebraFlutter.postMessage('GeoGebra loaded successfully');
        }

        // Draw a simple function as test
        api.evalCommand("f(x) = x^2");
        api.evalCommand("g(x) = sin(x)");
        api.setColor("f", 249, 115, 22); // Orange
        api.setColor("g", 34, 197, 94); // Green
      }
    };

    var applet = new GGBApplet(parameters, true);
    applet.inject('ggb-element');
  </script>
</body>
</html>
    ''';
  }

  Future<void> _evalCommand(String command) async {
    setState(() {
      _status = 'Executing: $command';
    });

    try {
      await _controller.runJavaScript(
        'window.ggbApplet.evalCommand("$command");'
      );
      setState(() {
        _status = 'Executed: $command';
      });
    } catch (e) {
      setState(() {
        _status = 'Error executing command: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Status bar
        Container(
          padding: const EdgeInsets.all(12),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _status,
                style: const TextStyle(fontSize: 14),
              ),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: LinearProgressIndicator(),
                ),
            ],
          ),
        ),

        // WebView
        Expanded(
          child: _isLoading
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading GeoGebra...'),
                    ],
                  ),
                )
              : WebViewWidget(controller: _controller),
        ),

        // Quick command buttons
        Container(
          padding: const EdgeInsets.all(8),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Wrap(
            spacing: 8,
            children: [
              ElevatedButton(
                onPressed: () => _evalCommand('h(x) = cos(x)'),
                child: const Text('Add cos(x)'),
              ),
              ElevatedButton(
                onPressed: () => _evalCommand('Circle((0,0), 3)'),
                child: const Text('Add Circle'),
              ),
              ElevatedButton(
                onPressed: () => _evalCommand('Delete[f]'),
                child: const Text('Delete f(x)'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// LaTeX Prototype Screen
class LatexPrototype extends StatefulWidget {
  const LatexPrototype({super.key});

  @override
  State<LatexPrototype> createState() => _LatexPrototypeState();
}

class _LatexPrototypeState extends State<LatexPrototype> {
  final List<String> _latexExamples = [
    r'f(x) = x^2 + 2x + 1',
    r'\frac{d}{dx}(x^3) = 3x^2',
    r'\int_0^1 x^2 \, dx = \frac{1}{3}',
    r'\lim_{x \to \infty} \frac{1}{x} = 0',
    r'\sum_{i=1}^{n} i = \frac{n(n+1)}{2}',
    r'\sqrt{a^2 + b^2} = c',
    r'\begin{pmatrix} a & b \\ c & d \end{pmatrix}',
    r'e^{i\pi} + 1 = 0',
    r'\sin^2(x) + \cos^2(x) = 1',
    r'P(A|B) = \frac{P(B|A)P(A)}{P(B)}',
  ];

  final Map<String, int> _renderTimes = {};

  Widget _buildLatexWidget(String latex) {
    final stopwatch = Stopwatch()..start();

    final widget = Math.tex(
      latex,
      textStyle: const TextStyle(fontSize: 20, color: Colors.white),
      mathStyle: MathStyle.display,
    );

    stopwatch.stop();
    _renderTimes[latex] = stopwatch.elapsedMilliseconds;

    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LaTeX Rendering Performance Test',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Using flutter_math_fork package',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Average render time: ${_calculateAverageRenderTime()}ms',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        for (var latex in _latexExamples)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rendered LaTeX
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: _buildLatexWidget(latex),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // LaTeX source
                  Text(
                    latex,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontFamily: 'monospace',
                    ),
                  ),

                  // Render time
                  if (_renderTimes.containsKey(latex))
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Rendered in ${_renderTimes[latex]}ms',
                        style: TextStyle(
                          fontSize: 11,
                          color: _getRenderTimeColor(_renderTimes[latex]!),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  String _calculateAverageRenderTime() {
    if (_renderTimes.isEmpty) return '0';
    final total = _renderTimes.values.reduce((a, b) => a + b);
    return (total / _renderTimes.length).toStringAsFixed(1);
  }

  Color _getRenderTimeColor(int ms) {
    if (ms < 5) return Colors.green;
    if (ms < 10) return Colors.orange;
    return Colors.red;
  }
}
