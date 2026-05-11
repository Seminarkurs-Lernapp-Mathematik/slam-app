import 'package:flutter_test/flutter_test.dart';
import 'package:slam_app_flutter/core/data/models/result.dart';

void main() {
  group('Result<T, E>', () {
    test('should create a Success result', () {
      const result = Success<int, String>(42);

      expect(result.isSuccess, true);
      expect(result.isFailure, false);
      expect(result.successOrNull, 42);
      expect(result.failureOrNull, null);
    });

    test('should create a Failure result', () {
      const result = Failure<int, String>('error');

      expect(result.isSuccess, false);
      expect(result.isFailure, true);
      expect(result.successOrNull, null);
      expect(result.failureOrNull, 'error');
    });

    test('should use pattern matching with when()', () {
      const success = Success<int, String>(42);
      const failure = Failure<int, String>('error');

      final successValue = success.when(
        success: (value) => value * 2,
        failure: (error) => 0,
      );

      final failureValue = failure.when(
        success: (value) => value * 2,
        failure: (error) => error.length,
      );

      expect(successValue, 84);
      expect(failureValue, 5);
    });

    test('should map success values', () {
      const result = Success<int, String>(42);
      final mapped = result.mapSuccess((value) => value.toString());

      expect(mapped.isSuccess, true);
      expect(mapped.successOrNull, '42');
    });

    test('should pass through failure on map', () {
      const result = Failure<int, String>('error');
      final mapped = result.mapSuccess((value) => value.toString());

      expect(mapped.isFailure, true);
      expect(mapped.failureOrNull, 'error');
    });

    test('should getOrElse return value for success', () {
      const result = Success<int, String>(42);
      final value = result.getOrElse(0);

      expect(value, 42);
    });

    test('should getOrElse return default for failure', () {
      const result = Failure<int, String>('error');
      final value = result.getOrElse(0);

      expect(value, 0);
    });

    test('should getOrThrow for success', () {
      const result = Success<int, String>(42);
      expect(result.getOrThrow(), 42);
    });

    test('should throw for failure with getOrThrow', () {
      const result = Failure<int, String>('error');
      expect(() => result.getOrThrow(), throwsStateError);
    });

    test('should chain successful operations with mapSuccess', () {
      const result = Success<int, String>(10);
      final chained = result.mapSuccess((value) => value * 2);

      expect(chained.successOrNull, 20);
    });

    test('should map failure with mapFailure', () {
      const result = Failure<int, String>('first');
      final mapped = result.mapFailure((error) => error.toUpperCase());

      expect(mapped.failureOrNull, 'FIRST');
    });

    test('should pass through success on mapFailure', () {
      const result = Success<int, String>(42);
      final mapped = result.mapFailure((error) => error.toUpperCase());

      expect(mapped.isSuccess, true);
      expect(mapped.successOrNull, 42);
    });
  });

  group('AppError', () {
    test('NetworkError should have status code', () {
      const error = NetworkError('Connection failed', statusCode: 404);
      expect(error.message, 'Connection failed');
      expect(error.statusCode, 404);
    });

    test('AuthError should have type', () {
      const error = AuthError('Invalid credentials',
          type: AuthErrorType.invalidCredentials);
      expect(error.message, 'Invalid credentials');
      expect(error.type, AuthErrorType.invalidCredentials);
    });

    test('ValidationError should have field errors', () {
      const error = ValidationError('Validation failed',
          fieldErrors: {'email': 'Invalid'});
      expect(error.message, 'Validation failed');
      expect(error.fieldErrors?['email'], 'Invalid');
    });

    test('DatabaseError should have code', () {
      const error = DatabaseError('Write failed', code: 'PERMISSION_DENIED');
      expect(error.message, 'Write failed');
      expect(error.code, 'PERMISSION_DENIED');
    });

    test('toString should return message', () {
      const error = UnknownError('Something went wrong');
      expect(error.toString(), 'Something went wrong');
    });
  });
}
