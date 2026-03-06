import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// A cross-platform WebView widget that works on Web, Android, and iOS
///
/// Handles platform differences:
/// - Web: Uses data URI with base64 encoding
/// - Mobile: Uses standard loadHtmlString
class CrossPlatformWebView extends StatefulWidget {
  final String htmlContent;
  final String? baseUrl;
  final VoidCallback? onPageFinished;
  final void Function(String message)? onMessage;
  final String? javascriptChannelName;

  const CrossPlatformWebView({
    super.key,
    required this.htmlContent,
    this.baseUrl,
    this.onPageFinished,
    this.onMessage,
    this.javascriptChannelName,
  });

  @override
  State<CrossPlatformWebView> createState() => _CrossPlatformWebViewState();
}

class _CrossPlatformWebViewState extends State<CrossPlatformWebView> {
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent);

    // Add navigation delegate for page finished callback
    controller.setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (url) {
          widget.onPageFinished?.call();
        },
      ),
    );

    // Add JavaScript channel if requested
    if (widget.javascriptChannelName != null && widget.onMessage != null) {
      controller.addJavaScriptChannel(
        widget.javascriptChannelName!,
        onMessageReceived: (message) {
          widget.onMessage!(message.message);
        },
      );
    }

    // Load content based on platform
    _loadContent(controller);

    _controller = controller;
  }

  void _loadContent(WebViewController controller) {
    final html = widget.htmlContent;

    if (kIsWeb) {
      // On web platform, use data URI with base64 encoding
      // This is the only reliable way to load HTML in iframe
      final bytes = utf8.encode(html);
      final base64Str = base64Encode(bytes);
      final dataUri = 'data:text/html;base64,$base64Str';
      controller.loadRequest(Uri.parse(dataUri));
    } else {
      // On mobile, use loadHtmlString directly
      controller.loadHtmlString(html, baseUrl: widget.baseUrl);
    }
  }

  @override
  void didUpdateWidget(CrossPlatformWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.htmlContent != widget.htmlContent) {
      if (_controller != null) {
        _loadContent(_controller!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return WebViewWidget(controller: _controller!);
  }
}

/// Extension to help with WebView operations
extension WebViewControllerExtension on WebViewController {
  /// Execute JavaScript safely across platforms
  Future<void> runJavaScriptSafe(String script) async {
    try {
      await runJavaScript(script);
    } catch (e) {
      debugPrint('JavaScript execution error: $e');
    }
  }
}
