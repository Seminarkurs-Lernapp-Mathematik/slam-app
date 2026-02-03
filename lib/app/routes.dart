import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/email_verification_screen.dart';
import '../features/auth/presentation/screens/password_reset_screen.dart';
import '../features/gamification/presentation/screens/progress_screen.dart';
import '../features/gamification/presentation/screens/shop_screen.dart';
import '../features/home/presentation/widgets/main_navigation.dart';
import '../features/learning_plan/presentation/screens/learning_plan_screen.dart';
import '../features/question_session/presentation/screens/question_session_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../core/services/auth_service.dart';

part 'routes.g.dart';

/// Material 3 Expressive Page Transition
/// Uses emphasized easing curves for smooth, physics-based motion
CustomTransitionPage<void> buildPageWithExpressiveTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Material 3 Expressive easing: Emphasized curve for motion
      const curve = Curves.easeInOutCubicEmphasized;

      // Fade + Scale animation (subtle, smooth)
      final fadeAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );

      final scaleAnimation = Tween<double>(
        begin: 0.95,
        end: 1.0,
      ).animate(fadeAnimation);

      return FadeTransition(
        opacity: fadeAnimation,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 350),
  );
}

/// App Routes Provider
@riverpod
GoRouter router(Ref ref) {
  final authService = ref.watch(authServiceProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (BuildContext context, GoRouterState state) {
      final user = authService.currentUser;
      final isAuthenticated = user != null && user.emailVerified;
      final isOnAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/password-reset' ||
          state.matchedLocation == '/verify-email';
      final isOnSplash = state.matchedLocation == '/';

      // Allow splash screen
      if (isOnSplash) return null;

      // If authenticated and trying to access auth routes, redirect to home
      if (isAuthenticated && isOnAuthRoute) {
        return '/home';
      }

      // If not authenticated and trying to access protected routes, redirect to login
      if (!isAuthenticated && !isOnAuthRoute && !isOnSplash) {
        return '/login';
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

      // Learning Plan
      GoRoute(
        path: '/learning-plan',
        name: 'learning-plan',
        pageBuilder: (context, state) => buildPageWithExpressiveTransition(
          context: context,
          state: state,
          child: const LearningPlanScreen(),
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

      // Shop
      GoRoute(
        path: '/shop',
        name: 'shop',
        pageBuilder: (context, state) => buildPageWithExpressiveTransition(
          context: context,
          state: state,
          child: const ShopScreen(),
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
