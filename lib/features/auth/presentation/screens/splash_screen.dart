import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/auth_service.dart';

/// Splash Screen
///
/// Checks authentication status and navigates accordingly:
/// - If authenticated: Navigate to /home
/// - If not authenticated: Navigate to /login
/// - If email not verified: Navigate to /verify-email
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Show the splash screen for a minimum of 500 ms.
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    final authService = ref.read(authServiceProvider);

    // On web, Firebase Auth restores a persisted session asynchronously.
    // Waiting for the first event of authStateChanges guarantees we get the
    // real auth state instead of the initial `null` that currentUser returns
    // before the session is restored.
    try {
      final user = await authService.authStateChanges
          .timeout(const Duration(seconds: 10))
          .first;

      if (!mounted) return;

      if (user != null && user.emailVerified) {
        context.go('/home');
      } else if (user != null) {
        context.go('/verify-email');
      } else {
        context.go('/login');
      }
    } on TimeoutException {
      // Firebase took too long — fall back to the synchronous value (may be null).
      if (!mounted) return;
      final user = authService.currentUser;
      if (user != null && user.emailVerified) {
        context.go('/home');
      } else if (user != null) {
        context.go('/verify-email');
      } else {
        context.go('/login');
      }
    } catch (_) {
      if (mounted) context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo/Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.auto_awesome,
                size: 64,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),

            // App Name
            Text(
              'SLAM',
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),

            // Tagline
            Text(
              'Smarte Lern-App für Mathematik',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 48),

            // Loading Indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
