/// Result type for handling success/failure operations.
///
/// Similar to Either in functional programming.
///
/// Usage:
/// ```dart
/// Result<User, AuthError> result = await authRepository.signIn();
///
/// result.when(
///   success: (user) => print('Welcome ${user.name}'),
///   failure: (error) => print('Error: $error'),
/// );
/// ```
library;

sealed class Result<S, F> {
  const Result();

  bool get isSuccess => this is Success<S, F>;
  bool get isFailure => this is Failure<S, F>;

  S? get successOrNull => isSuccess ? (this as Success<S, F>).value : null;
  F? get failureOrNull => isFailure ? (this as Failure<S, F>).error : null;

  T when<T>({
    required T Function(S value) success,
    required T Function(F error) failure,
  }) {
    return switch (this) {
      Success<S, F>(value: final v) => success(v),
      Failure<S, F>(error: final e) => failure(e),
    };
  }

  T map<T>({
    required T Function(S value) success,
    required T Function(F error) failure,
  }) => when(success: success, failure: failure);

  Result<T, F> mapSuccess<T>(T Function(S value) transform) {
    return when(
      success: (v) => Success(transform(v)),
      failure: (e) => Failure(e),
    );
  }

  Result<S, T> mapFailure<T>(T Function(F error) transform) {
    return when(
      success: (v) => Success(v),
      failure: (e) => Failure(transform(e)),
    );
  }

  S getOrElse(S defaultValue) => successOrNull ?? defaultValue;
  S getOrThrow() => successOrNull ?? (throw StateError('Result is failure'));
}

class Success<S, F> extends Result<S, F> {
  final S value;
  const Success(this.value);

  @override
  String toString() => 'Success($value)';
}

class Failure<S, F> extends Result<S, F> {
  final F error;
  const Failure(this.error);

  @override
  String toString() => 'Failure($error)';
}

/// Common error types for the app
sealed class AppError {
  final String message;
  final StackTrace? stackTrace;
  
  const AppError(this.message, {this.stackTrace});

  @override
  String toString() => message;
}

class NetworkError extends AppError {
  final int? statusCode;
  const NetworkError(super.message, {this.statusCode, super.stackTrace});
}

class AuthError extends AppError {
  final AuthErrorType type;
  const AuthError(super.message, {required this.type, super.stackTrace});
}

enum AuthErrorType {
  invalidCredentials,
  userNotFound,
  emailNotVerified,
  weakPassword,
  emailAlreadyInUse,
  invalidEmail,
  unknown,
}

class ValidationError extends AppError {
  final Map<String, String>? fieldErrors;
  const ValidationError(super.message, {this.fieldErrors, super.stackTrace});
}

class DatabaseError extends AppError {
  final String? code;
  const DatabaseError(super.message, {this.code, super.stackTrace});
}

class CacheError extends AppError {
  const CacheError(super.message, {super.stackTrace});
}

class UnknownError extends AppError {
  const UnknownError(super.message, {super.stackTrace});
}
