import 'package:ecommerce_b2b/modules/shared_kernel/errors/email_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/email_address.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EmailAddress', () {
    test('should create a valid email address', () {
      final result = EmailAddress.create('test@example.com');
      expect(result.isSuccess, isTrue);
      expect(result.getOrThrow().value, 'test@example.com');
    });

    test('should normalize email to lowercase', () {
      final result = EmailAddress.create('TEST@EXAMPLE.COM');
      expect(result.getOrThrow().value, 'test@example.com');
    });

    test('should return EmailEmptyError when input is empty', () {
      final result = EmailAddress.create('');
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<EmailEmptyError>());
    });

    test('should return EmailInvalidError when input is invalid', () {
      final result = EmailAddress.create('invalid-email');
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<EmailInvalidError>());
    });
  });
}
