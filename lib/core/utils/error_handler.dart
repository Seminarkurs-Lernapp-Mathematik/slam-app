import 'dart:ui' show PlatformDispatcher;
import 'package:flutter/material.dart';
import '../data/models/result.dart';
import 'logger.dart';

/// Global error handler for the app
///
/// Usage:
/// ```dart
/// void main() {
///   ErrorHandler.initialize();
///   runApp(MyApp());
/// }
/// ```

class ErrorHandler {
  static void initialize() {
    // Catch Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      Logger.fatal(
        'Flutter Framework Error',
        tag: 'Framework',
        error: details.exception,
        stackTrace: details.stack,
      );

      // In debug mode, show the error
      if (Logger.getRecentLogs().isNotEmpty) {
        FlutterError.presentError(details);
      }
    };

    // Catch platform errors (async)
    PlatformDispatcher.instance.onError = (error, stack) {
      Logger.fatal(
        'Platform Error',
        tag: 'Platform',
        error: error,
        stackTrace: stack,
      );
      return true;
    };

    Logger.info('Error handler initialized');
  }

  /// Handle an error with optional context
  static void handleError(
    Object error, {
    StackTrace? stackTrace,
    String? context,
    Map<String, dynamic>? metadata,
  }) {
    final errorMessage =
        context != null ? '$context: $error' : error.toString();

    Logger.error(
      errorMessage,
      tag: 'ErrorHandler',
      data: metadata,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Convert exceptions to AppError
  static AppError convertException(Object error, [StackTrace? stackTrace]) {
    if (error is AppError) return error;

    final errorString = error.toString().toLowerCase();

    // Network errors
    if (errorString.contains('socket') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('network')) {
      return NetworkError(
          'Netzwerkfehler: Bitte überprüfe deine Internetverbindung',
          stackTrace: stackTrace);
    }

    // Auth errors
    if (errorString.contains('permission-denied') ||
        errorString.contains('unauthorized')) {
      return AuthError('Zugriff verweigert',
          type: AuthErrorType.unknown, stackTrace: stackTrace);
    }

    // Database errors
    if (errorString.contains('firestore') || errorString.contains('firebase')) {
      return DatabaseError('Datenbankfehler', stackTrace: stackTrace);
    }

    // Default
    return UnknownError('Ein unerwarteter Fehler ist aufgetreten',
        stackTrace: stackTrace);
  }

  /// Show user-friendly error message
  static String getUserFriendlyMessage(AppError error) {
    return switch (error) {
      NetworkError() =>
        'Keine Internetverbindung. Bitte überprüfe deine Netzwerkeinstellungen.',
      AuthError(:final type) => switch (type) {
          AuthErrorType.invalidCredentials => 'Falsche Anmeldedaten.',
          AuthErrorType.userNotFound => 'Benutzer nicht gefunden.',
          AuthErrorType.emailNotVerified =>
            'Bitte bestätige zuerst deine E-Mail-Adresse.',
          AuthErrorType.weakPassword => 'Das Passwort ist zu schwach.',
          AuthErrorType.emailAlreadyInUse =>
            'Diese E-Mail-Adresse wird bereits verwendet.',
          AuthErrorType.invalidEmail => 'Ungültige E-Mail-Adresse.',
          AuthErrorType.unknown => 'Authentifizierungsfehler.',
        },
      ValidationError(:final fieldErrors) =>
        fieldErrors != null && fieldErrors.isNotEmpty
            ? 'Validierungsfehler: ${fieldErrors.values.first}'
            : 'Ungültige Eingaben.',
      DatabaseError() => 'Datenbankfehler. Bitte versuche es später erneut.',
      CacheError() => 'Cache-Fehler. Die Daten werden neu geladen.',
      UnknownError() => 'Ein unerwarteter Fehler ist aufgetreten.',
    };
  }
}

/// Error boundary widget that catches errors in the widget tree
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(BuildContext context, FlutterErrorDetails error)?
      errorBuilder;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  FlutterErrorDetails? _error;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(context, _error!) ??
          _DefaultErrorWidget(error: _error!);
    }

    return widget.child;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset error when dependencies change (e.g., navigation)
    if (_error != null) {
      setState(() => _error = null);
    }
  }
}

class _DefaultErrorWidget extends StatelessWidget {
  final FlutterErrorDetails error;

  const _DefaultErrorWidget({required this.error});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      child: Container(
        padding: const EdgeInsets.all(24),
        color: theme.colorScheme.errorContainer,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Oops!',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Etwas ist schiefgelaufen',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  // Try to recover
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: const Icon(Icons.home),
                label: const Text('Zur Startseite'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Async error handler wrapper
class AsyncHandler {
  /// Run async operation with automatic error handling
  static Future<T?> run<T>(
    Future<T> Function() operation, {
    String? context,
    void Function(T result)? onSuccess,
    void Function(AppError error)? onError,
  }) async {
    try {
      final result = await operation();
      onSuccess?.call(result);
      return result;
    } catch (e, st) {
      final appError = ErrorHandler.convertException(e, st);

      ErrorHandler.handleError(
        e,
        stackTrace: st,
        context: context,
      );

      onError?.call(appError);
      return null;
    }
  }

  /// Run async operation and return Result type
  static Future<Result<T, AppError>> runWithResult<T>(
    Future<T> Function() operation, {
    String? context,
  }) async {
    try {
      final result = await operation();
      return Success(result);
    } catch (e, st) {
      final appError = ErrorHandler.convertException(e, st);

      ErrorHandler.handleError(
        e,
        stackTrace: st,
        context: context,
      );

      return Failure(appError);
    }
  }
}

/// Snackbar helper for showing errors
class ErrorSnackbar {
  static void show(
    BuildContext context,
    AppError error, {
    VoidCallback? onRetry,
  }) {
    final message = ErrorHandler.getUserFriendlyMessage(error);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline,
                color: Theme.of(context).colorScheme.onErrorContainer),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        behavior: SnackBarBehavior.floating,
        action: onRetry != null
            ? SnackBarAction(
                label: 'WIEDERHOLEN',
                onPressed: onRetry,
              )
            : null,
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle,
                color: Theme.of(context).colorScheme.onPrimaryContainer),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
