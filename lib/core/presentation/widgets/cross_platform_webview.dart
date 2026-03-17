import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Platform-specific implementations
import 'cross_platform_webview_stub.dart'
    if (dart.library.html) 'cross_platform_webview_web.dart';

/// A cross-platform WebView widget that works on Web, Android, and iOS
///
/// Handles platform differences:
/// - Web: Uses HtmlElementView with iframe
/// - Mobile: Uses webview_flutter package
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
  WebViewController? _mobileController;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _initMobileWebView();
    }
  }

  void _initMobileWebView() {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent);

    controller.setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (url) {
          widget.onPageFinished?.call();
        },
      ),
    );

    if (widget.javascriptChannelName != null && widget.onMessage != null) {
      controller.addJavaScriptChannel(
        widget.javascriptChannelName!,
        onMessageReceived: (message) {
          widget.onMessage!(message.message);
        },
      );
    }

    controller.loadHtmlString(widget.htmlContent, baseUrl: widget.baseUrl);
    _mobileController = controller;
  }

  @override
  void didUpdateWidget(CrossPlatformWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.htmlContent != widget.htmlContent) {
      if (!kIsWeb && _mobileController != null) {
        _mobileController!.loadHtmlString(widget.htmlContent, baseUrl: widget.baseUrl);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return buildWebView(
        htmlContent: widget.htmlContent,
        onPageFinished: widget.onPageFinished,
        onMessage: widget.onMessage,
        javascriptChannelName: widget.javascriptChannelName,
      );
    } else {
      if (_mobileController == null) {
        return const Center(child: CircularProgressIndicator());
      }
      return WebViewWidget(controller: _mobileController!);
    }
  }
}

/// Extension to help with WebView operations
extension WebViewControllerExtension on WebViewController {
  Future<void> runJavaScriptSafe(String script) async {
    try {
      await runJavaScript(script);
    } catch (e) {
      debugPrint('JavaScript execution error: $e');
    }
  }
}
