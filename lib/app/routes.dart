import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/presentation/screens/onboarding_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/email_verification_screen.dart';
import '../features/auth/presentation/screens/password_reset_screen.dart';
import '../features/gamification/presentation/screens/progress_screen.dart';
import '../features/home/presentation/widgets/main_navigation.dart';
import '../features/home/presentation/providers/main_nav_notifier.dart';
import '../features/question_session/presentation/screens/question_session_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../core/services/auth_service.dart';

part 'routes.g.dart';

/// A [ChangeNotifier] that listens to a [Stream] and notifies GoRouter
/// to re-evaluate its redirect whenever the stream emits a new value.
///
/// Used so GoRouter automatically re-checks the auth guard when Firebase
/// Auth finishes restoring a persisted session (important on web).
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// Material 3 Expressive Page Transition
/// Uses emphasized easing curves for smooth, physics-based motion
NoTransitionPage<void> buildPageWithExpressiveTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return NoTransitionPage<void>(key: state.pageKey, child: child);
}

/// App Routes Provider
@riverpod
GoRouter router(Ref ref) {
  final authService = ref.watch(authServiceProvider);

  // Notify GoRouter to re-run its redirect whenever Firebase Auth emits a
  // new auth state.  Without this, the router would keep showing the login
  // page on web even after Firebase asynchronously restores a persisted session.
  final refreshNotifier = GoRouterRefreshStream(authService.authStateChanges);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    refreshListenable: refreshNotifier,
    redirect: (BuildContext context, GoRouterState state) {
      final user = authService.currentUser;
      final isAuthenticated = user != null && user.emailVerified;
      final isOnAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/password-reset' ||
          state.matchedLocation == '/verify-email';
      final isOnSplash = state.matchedLocation == '/';
      final isOnOnboarding = state.matchedLocation == '/onboarding';

      // Allow splash screen
      if (isOnSplash) return null;

      // If authenticated and trying to access auth routes, redirect to home
      if (isAuthenticated && isOnAuthRoute) {
        return '/home';
      }

      // Allow onboarding for authenticated users
      if (isOnOnboarding) return null;

      // If not authenticated and trying to access protected routes, redirect to login
      if (!isAuthenticated && !isOnAuthRoute && !isOnSplash) {
        return '/login';
      }

      // ── Liquid UI tab/overlay shortcuts ───────────────────────────────────
      // /lernplan  → MainNavigation tab 1 (Plan)
      // /shop      → MainNavigation tab 3 (Shop)
      // /profil    → MainNavigation + profile swoosh-overlay
      // Routes are kept so deep-links / external calls still resolve.
      if (isAuthenticated) {
        if (state.matchedLocation == '/lernplan') {
          Future.microtask(
            () => ref.read(mainNavNotifierProvider.notifier).switchToTab(1),
          );
          return '/home';
        }
        if (state.matchedLocation == '/shop') {
          Future.microtask(
            () => ref.read(mainNavNotifierProvider.notifier).switchToTab(3),
          );
          return '/home';
        }
        if (state.matchedLocation == '/profil') {
          Future.microtask(
            () => ref.read(mainNavNotifierProvider.notifier).openProfile(),
          );
          return '/home';
        }
      }

      // No redirect needed
      return null;
    },
    routes: [
      // Splash Screen (initial route)
      GoRoute(
        path: '/',
        name: 'splash',
        pageBuilder: (context, state) => buildPageWithExpressiveTransition(
          context: context,
          state: state,
          child: const SplashScreen(),
        ),
      ),
      // Onboarding (shown once after first login)
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        pageBuilder: (context, state) => buildPageWithExpressiveTransition(
          context: context,
          state: state,
          child: const OnboardingScreen(),
        ),
      ),
      // Auth Routes
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => buildPageWithExpressiveTransition(
          context: context,
          state: state,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        pageBuilder: (context, state) => buildPageWithExpressiveTransition(
          context: context,
          state: state,
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: '/verify-email',
        name: 'verify-email',
        pageBuilder: (context, state) => buildPageWithExpressiveTransition(
          context: context,
          state: state,
          child: const EmailVerificationScreen(),
        ),
      ),
      GoRoute(
        path: '/password-reset',
        name: 'password-reset',
        pageBuilder: (context, state) => buildPageWithExpressiveTransition(
          context: context,
          state: state,
          child: const PasswordResetScreen(),
        ),
      ),

      // Main App Routes (after authentication)
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder: (context, state) => buildPageWithExpressiveTransition(
          context: context,
          state: state,
          child: const MainNavigation(),
        ),
      ),



      // /lernplan → handled by redirect above (switches to Plan tab in MainNavigation).
      // Route stub kept so named navigation (goNamed('lernplan')) resolves.
      GoRoute(
        path: '/lernplan',
        name: 'lernplan',
        pageBuilder: (context, state) => buildPageWithExpressiveTransition(
          context: context,
          state: state,
          child: const MainNavigation(),
        ),
      ),

      // /profil → handled by redirect above (opens swoosh-overlay in MainNavigation).
      GoRoute(
        path: '/profil',
        name: 'profil',
        pageBuilder: (context, state) => buildPageWithExpressiveTransition(
          context: context,
          state: state,
          child: const MainNavigation(),
        ),
      ),

      // Question Session
      GoRoute(
        path: '/question-session/:sessionId',
        name: 'question-session',
        pageBuilder: (context, state) {
          final sessionId = state.pathParameters['sessionId']!;
          return buildPageWithExpressiveTransition(
            context: context,
            state: state,
            child: QuestionSessionScreen(sessionId: sessionId),
          );
        },
      ),

      // Settings
      GoRoute(
        path: '/settings',
        name: 'settings',
        pageBuilder: (context, state) => buildPageWithExpressiveTransition(
          context: context,
          state: state,
          child: const SettingsScreen(),
        ),
      ),

      // Progress/Gamification
      GoRoute(
        path: '/progress',
        name: 'progress',
        builder: (context, state) => const ProgressScreen(),
      ),

      // /shop → handled by redirect above (switches to Shop tab in MainNavigation).
      GoRoute(
        path: '/shop',
        name: 'shop',
        pageBuilder: (context, state) => buildPageWithExpressiveTransition(
          context: context,
          state: state,
          child: const MainNavigation(),
        ),
      ),
    ],

    // Error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.error?.toString() ?? 'Unknown error',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    ),
  );
}
