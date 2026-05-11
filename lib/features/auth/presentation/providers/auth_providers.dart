import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';

part 'auth_providers.g.dart';

/// Auth Login Provider
@riverpod
Future<User> authLogin(
    AuthLoginRef ref, Map<String, String> credentials) async {
  final authService = ref.watch(authServiceProvider);
  final firestoreService = ref.watch(firestoreServiceProvider);

  final user = await authService.signIn(
    email: credentials['email']!,
    password: credentials['password']!,
  );

  // Ensure Firestore document exists (handles accounts created before this was wired)
  await firestoreService.initializeUserProfile(
    userId: user.uid,
    displayName: user.displayName ?? user.email ?? '',
    email: user.email ?? '',
  );

  return user;
}

/// Auth Register Provider
@riverpod
Future<User> authRegister(
  AuthRegisterRef ref,
  Map<String, String> credentials,
) async {
  final authService = ref.watch(authServiceProvider);
  final firestoreService = ref.watch(firestoreServiceProvider);

  final user = await authService.signUp(
    email: credentials['email']!,
    password: credentials['password']!,
    displayName: credentials['displayName']!,
  );

  // Create the Firestore document with initial stats/settings
  await firestoreService.initializeUserProfile(
    userId: user.uid,
    displayName: credentials['displayName']!,
    email: credentials['email']!,
  );

  return user;
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
