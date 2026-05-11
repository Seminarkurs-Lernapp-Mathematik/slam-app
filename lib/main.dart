import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/app_initializer.dart';
import 'core/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the app
  final initResult = await AppInitializer().initialize();

  if (!initResult.success) {
    Logger.fatal('Failed to initialize app: ${initResult.error}');
    // In a real app, you might want to show an error screen here
  }

  runApp(
    const ProviderScope(
      child: SLAMApp(),
    ),
  );
}
