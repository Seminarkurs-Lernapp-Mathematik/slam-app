import 'package:flutter/material.dart';

/// Stub function for mobile platforms - returns empty container
Widget buildWebView({
  required String htmlContent,
  VoidCallback? onPageFinished,
  void Function(String message)? onMessage,
  String? javascriptChannelName,
}) {
  return const Center(
    child: Text('WebView not supported on this platform'),
  );
}
