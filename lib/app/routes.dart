import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/email_verification_screen.dart';
import '../features/gamification/presentation/screens/progress_screen.dart';
import '../features/home/presentation/widgets/main_navigation.dart';
import '../features/learning_plan/presentation/screens/learning_plan_screen.dart';

part 'routes.g.dart';

/// App Routes Provider
@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    routes: [
      // Auth Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/email-verification',
        name: 'email-verification',
        builder: (context, state) => const EmailVerificationScreen(),
      ),

      // Main App Routes (after authentication)
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const MainNavigation(),
      ),

      // Learning Plan
      GoRoute(
        path: '/learning-plan',
        name: 'learning-plan',
        builder: (context, state) => const LearningPlanScreen(),
      ),

      // Question Session
      GoRoute(
        path: '/question-session/:sessionId',
        name: 'question-session',
        builder: (context, state) {
          final sessionId = state.pathParameters['sessionId']!;
          return Scaffold(
            body: Center(
              child: Text('Question Session: $sessionId - Coming Soon'),
            ),
          );
        },
      ),

      // Settings
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Settings - Coming Soon'),
          ),
        ),
      ),

      // Progress/Gamification
      GoRoute(
        path: '/progress',
        name: 'progress',
        builder: (context, state) => const ProgressScreen(),
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
