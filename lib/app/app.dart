import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes.dart';
import 'theme.dart';
import '../features/settings/presentation/providers/settings_providers.dart';

class SLAMApp extends ConsumerWidget {
  const SLAMApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final selectedTheme = ref.watch(selectedThemeProvider);
    final theme = AppTheme.getThemeForPreset(selectedTheme);

    return MaterialApp.router(
      title: 'SLAM Learning',
      theme: theme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
