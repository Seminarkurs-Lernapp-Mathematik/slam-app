import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.g.dart';

/// Authentication Service
///
/// Handles Firebase Authentication with domain restriction (@mvl-gym.de)
/// and email verification flow.
class AuthService {
  final FirebaseAuth _auth;

  AuthService(this._auth);

  // Domain restriction
  static const String allowedDomain = '@mvl-gym.de';

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Validate email domain
  bool isValidEmail(String email) {
    return email.trim().toLowerCase().endsWith(allowedDomain);
  }

  /// Sign up with email and password
  ///
  /// Throws [AuthException] if:
  /// - Invalid email domain
  /// - Email already in use
  /// - Weak password
  Future<User> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // Validate domain
      if (!isValidEmail(email)) {
        throw AuthException(
          code: 'invalid-domain',
          message: 'Nur E-Mail-Adressen mit der Domain $allowedDomain sind erlaubt.',
        );
      }

      // Create user account
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;

      // Update profile with display name
      await user.updateDisplayName(displayName);

      // Send verification email
      await user.sendEmailVerification();

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw AuthException(
        code: 'unknown',
        message: 'Ein unbekannter Fehler ist aufgetreten: $e',
      );
    }
  }

  /// Sign in with email and password
  ///
  /// Throws [AuthException] if:
  /// - User not found
  /// - Wrong password
  /// - Email not verified (returns user but throws exception)
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;

      // Check email verification
      if (!user.emailVerified) {
        throw AuthException(
          code: 'email-not-verified',
          message: 'Bitte verifiziere deine E-Mail-Adresse, bevor du dich anmeldest.',
        );
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(
        code: 'unknown',
        message: 'Ein unbekannter Fehler ist aufgetreten: $e',
      );
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Send email verification
  Future<void> sendEmailVerification() async {
    final user = currentUser;
    if (user == null) {
      throw AuthException(
        code: 'no-user',
        message: 'Kein Benutzer angemeldet.',
      );
    }

    if (user.emailVerified) {
      throw AuthException(
        code: 'already-verified',
        message: 'E-Mail-Adresse ist bereits verifiziert.',
      );
    }

    await user.sendEmailVerification();
  }

  /// Reload user to check email verification status
  Future<bool> reloadAndCheckEmailVerification() async {
    final user = currentUser;
    if (user == null) return false;

    await user.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  /// Update email (requires reauthentication)
  Future<void> updateEmail({
    required String newEmail,
    required String currentPassword,
  }) async {
    final user = currentUser;
    if (user == null) {
      throw AuthException(
        code: 'no-user',
        message: 'Kein Benutzer angemeldet.',
      );
    }

    try {
      // Reauthenticate
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update email
      await user.verifyBeforeUpdateEmail(newEmail);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  /// Update password (requires reauthentication)
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = currentUser;
    if (user == null) {
      throw AuthException(
        code: 'no-user',
        message: 'Kein Benutzer angemeldet.',
      );
    }

    try {
      // Reauthenticate
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  /// Update display name
  Future<void> updateDisplayName(String displayName) async {
    final user = currentUser;
    if (user == null) {
      throw AuthException(
        code: 'no-user',
        message: 'Kein Benutzer angemeldet.',
      );
    }

    await user.updateDisplayName(displayName);
    await user.reload();
  }

  /// Handle Firebase Auth Exceptions
  AuthException _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return AuthException(
          code: e.code,
          message: 'Kein Konto mit dieser E-Mail-Adresse gefunden.',
        );
      case 'wrong-password':
        return AuthException(
          code: e.code,
          message: 'Falsches Passwort.',
        );
      case 'email-already-in-use':
        return AuthException(
          code: e.code,
          message: 'Diese E-Mail-Adresse wird bereits verwendet.',
        );
      case 'weak-password':
        return AuthException(
          code: e.code,
          message: 'Das Passwort ist zu schwach. Bitte wähle ein stärkeres Passwort.',
        );
      case 'invalid-email':
        return AuthException(
          code: e.code,
          message: 'Ungültige E-Mail-Adresse.',
        );
      case 'operation-not-allowed':
        return AuthException(
          code: e.code,
          message: 'Diese Operation ist nicht erlaubt.',
        );
      case 'requires-recent-login':
        return AuthException(
          code: e.code,
          message: 'Bitte melde dich erneut an, um diese Aktion durchzuführen.',
        );
      default:
        return AuthException(
          code: e.code,
          message: e.message ?? 'Ein Authentifizierungsfehler ist aufgetreten.',
        );
    }
  }
}

/// Auth Exception
class AuthException implements Exception {
  final String code;
  final String message;

  AuthException({required this.code, required this.message});

  @override
  String toString() => message;
}

/// Auth Service Provider
@riverpod
AuthService authService(AuthServiceRef ref) {
  return AuthService(FirebaseAuth.instance);
}

/// Current User Provider
@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
}

/// Current User Provider (sync)
@riverpod
User? currentUser(CurrentUserRef ref) {
  final authState = ref.watch(authStateChangesProvider);
  return authState.value;
}
