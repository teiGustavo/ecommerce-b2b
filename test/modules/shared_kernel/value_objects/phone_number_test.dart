import 'package:ecommerce_b2b/modules/shared_kernel/errors/phone_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/phone_number.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PhoneNumber', () {
    test('should create valid phone number (11 digits)', () {
      final result = PhoneNumber.create('(11) 99999-9999');
      expect(result.isSuccess, isTrue);
      expect(result.getOrThrow().value, '11999999999');
    });

    test('should create valid phone number (10 digits)', () {
      final result = PhoneNumber.create('11 4444-4444');
      expect(result.isSuccess, isTrue);
      expect(result.getOrThrow().value, '1144444444');
    });

    test('should return PhoneEmptyError when input is empty', () {
      final result = PhoneNumber.create('');
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<PhoneEmptyError>());
    });

    test('should return PhoneInvalidError when input has invalid length', () {
      final result = PhoneNumber.create('123');
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<PhoneInvalidError>());
    });
  });
}
