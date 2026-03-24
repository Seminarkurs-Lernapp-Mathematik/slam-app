// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

/// Counter for generating unique view IDs
int _viewIdCounter = 0;

/// Build web view using HtmlElementView
Widget buildWebView({
  required String htmlContent,
  VoidCallback? onPageFinished,
  void Function(String message)? onMessage,
  String? javascriptChannelName,
}) {
  final viewId = 'webview-${_viewIdCounter++}-${DateTime.now().millisecondsSinceEpoch}';

  ui_web.platformViewRegistry.registerViewFactory(viewId, (int viewId) {
    final iframe = html.IFrameElement()
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.border = 'none'
      ..style.overflow = 'hidden'
      ..setAttribute(
        'sandbox',
        'allow-scripts allow-same-origin allow-forms allow-popups allow-downloads allow-pointer-lock allow-modals',
      )
      ..allowFullscreen = true;

    // Create blob URL from HTML content
    final blob = html.Blob([htmlContent], 'text/html');
    final url = html.Url.createObjectUrlFromBlob(blob);
    iframe.src = url;

    // Listen for load events
    iframe.onLoad.listen((_) {
      onPageFinished?.call();
      html.Url.revokeObjectUrl(url);
    });

    // Set up message listener if channel name is provided
    if (javascriptChannelName != null && onMessage != null) {
      void messageListener(html.Event event) {
        if (event is html.MessageEvent) {
          final data = event.data;
          if (data is String) {
            onMessage(data);
          }
        }
      }
      html.window.addEventListener('message', messageListener);
    }

    return iframe;
  });

  // Trigger onPageFinished after a short delay as fallback
  Future.delayed(const Duration(milliseconds: 800), () {
    onPageFinished?.call();
  });

  return HtmlElementView(viewType: viewId);
}
