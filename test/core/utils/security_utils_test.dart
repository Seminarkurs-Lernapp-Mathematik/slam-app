import 'package:flutter_test/flutter_test.dart';
import 'package:slam_app_flutter/core/utils/security_utils.dart';

void main() {
  group('SecurityUtils', () {
    group('hash', () {
      test('should generate consistent hashes', () {
        final hash1 = SecurityUtils.hash('test');
        final hash2 = SecurityUtils.hash('test');
        
        expect(hash1, hash2);
      });

      test('should generate different hashes for different inputs', () {
        final hash1 = SecurityUtils.hash('test1');
        final hash2 = SecurityUtils.hash('test2');
        
        expect(hash1, isNot(hash2));
      });
    });

    group('obfuscate/deobfuscate', () {
      test('should correctly obfuscate and deobfuscate', () {
        const original = 'secret data';
        const key = 'mykey';
        
        final obfuscated = SecurityUtils.obfuscate(original, key);
        final deobfuscated = SecurityUtils.deobfuscate(obfuscated, key);
        
        expect(obfuscated, isNot(original));
        expect(deobfuscated, original);
      });

      test('should fail with wrong key', () {
        const original = 'secret data';
        const key = 'mykey';
        const wrongKey = 'wrongkey';
        
        final obfuscated = SecurityUtils.obfuscate(original, key);
        
        // With wrong key, deobfuscation will produce garbage
        final deobfuscated = SecurityUtils.deobfuscate(obfuscated, wrongKey);
        expect(deobfuscated, isNot(original));
      });
    });

    group('isValidEmail', () {
      test('should validate correct emails', () {
        expect(SecurityUtils.isValidEmail('test@example.com'), true);
        expect(SecurityUtils.isValidEmail('user.name@domain.co.uk'), true);
        expect(SecurityUtils.isValidEmail('user+tag@example.com'), true);
      });

      test('should reject invalid emails', () {
        expect(SecurityUtils.isValidEmail('not-an-email'), false);
        expect(SecurityUtils.isValidEmail('@example.com'), false);
        expect(SecurityUtils.isValidEmail('test@'), false);
        expect(SecurityUtils.isValidEmail(''), false);
      });
    });

    group('checkPasswordStrength', () {
      test('should score weak passwords', () {
        final result = SecurityUtils.checkPasswordStrength('123');
        expect(result.score, lessThanOrEqualTo(1));
        expect(result.isWeak, true);
      });

      test('should score strong passwords', () {
        final result = SecurityUtils.checkPasswordStrength('MyStr0ng!Pass');
        expect(result.score, greaterThanOrEqualTo(3));
        expect(result.isStrong, true);
      });

      test('should provide feedback for weak passwords', () {
        final result = SecurityUtils.checkPasswordStrength('abc');
        expect(result.feedback, isNotEmpty);
      });
    });

    group('sanitizeInput', () {
      test('should remove HTML tags', () {
        final sanitized = SecurityUtils.sanitizeInput('<script>alert("xss")</script>');
        expect(sanitized.contains('<'), false);
        expect(sanitized.contains('>'), false);
      });

      test('should trim whitespace', () {
        final sanitized = SecurityUtils.sanitizeInput('  hello  ');
        expect(sanitized, 'hello');
      });

      test('should enforce max length', () {
        final sanitized = SecurityUtils.sanitizeInput('a' * 2000, maxLength: 100);
        expect(sanitized.length, 100);
      });
    });

    group('rate limiting', () {
      tearDown(() {
        SecurityUtils.clearRateLimit('test_key');
      });

      test('should allow first attempts', () {
        expect(SecurityUtils.isRateLimited('test_key', maxAttempts: 3), false);
        expect(SecurityUtils.isRateLimited('test_key', maxAttempts: 3), false);
        expect(SecurityUtils.isRateLimited('test_key', maxAttempts: 3), false);
      });

      test('should block after max attempts', () {
        for (var i = 0; i < 5; i++) {
          SecurityUtils.isRateLimited('test_key', maxAttempts: 3);
        }
        expect(SecurityUtils.isRateLimited('test_key', maxAttempts: 3), true);
      });

      test('should track remaining attempts', () {
        SecurityUtils.isRateLimited('test_key', maxAttempts: 5);
        SecurityUtils.isRateLimited('test_key', maxAttempts: 5);
        
        expect(SecurityUtils.getRemainingAttempts('test_key', maxAttempts: 5), 3);
      });
    });
  });

  group('InputValidators', () {
    test('required should validate non-empty', () {
      expect(InputValidators.required(null), isNotNull);
      expect(InputValidators.required(''), isNotNull);
      expect(InputValidators.required('  '), isNotNull);
      expect(InputValidators.required('value'), isNull);
    });

    test('minLength should validate length', () {
      expect(InputValidators.minLength('ab', 3), isNotNull);
      expect(InputValidators.minLength('abc', 3), isNull);
      expect(InputValidators.minLength('abcd', 3), isNull);
    });

    test('maxLength should validate length', () {
      expect(InputValidators.maxLength('abcd', 3), isNotNull);
      expect(InputValidators.maxLength('abc', 3), isNull);
      expect(InputValidators.maxLength('ab', 3), isNull);
    });

    test('range should validate numeric range', () {
      expect(InputValidators.range(5, 10, 20), isNotNull);
      expect(InputValidators.range(15, 10, 20), isNull);
      expect(InputValidators.range(25, 10, 20), isNotNull);
    });

    test('compose should run all validators', () {
      final validator = (String? v) => InputValidators.compose(v, [
        (v) => InputValidators.required(v),
        (v) => InputValidators.minLength(v, 5),
      ]);

      expect(validator(null), isNotNull);
      expect(validator('ab'), isNotNull);
      expect(validator('valid'), isNull);
    });
  });
}
