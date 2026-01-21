import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/services/auth_service.dart';

part 'auth_providers.g.dart';

/// Auth Login Provider
///
/// Handles login with email and password
@riverpod
Future<User> authLogin(AuthLoginRef ref, Map<String, String> credentials) async {
  final authService = ref.watch(authServiceProvider);

  return await authService.signIn(
    email: credentials['email']!,
    password: credentials['password']!,
  );
}

/// Auth Register Provider
///
/// Handles registration with email, password, and display name
@riverpod
Future<User> authRegister(
  AuthRegisterRef ref,
  Map<String, String> credentials,
) async {
  final authService = ref.watch(authServiceProvider);

  return await authService.signUp(
    email: credentials['email']!,
    password: credentials['password']!,
    displayName: credentials['displayName']!,
  );
}

/// Auth Logout Provider
@riverpod
Future<void> authLogout(AuthLogoutRef ref) async {
  final authService = ref.watch(authServiceProvider);
  await authService.signOut();
}

/// Is Authenticated Provider
///
/// Returns true if user is authenticated and email is verified
@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  final user = ref.watch(currentUserProvider);
  return user != null && user.emailVerified;
}
