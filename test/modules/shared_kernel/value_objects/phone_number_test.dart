import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/errors/phone_number_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/phone_number.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PhoneNumber (E.164)', () {
    test('should create valid Brazilian mobile number with country code', () {
      final result = PhoneNumber.create('+55 (11) 99999-9999');
      expect(result.isSuccess, isTrue);
      expect(result.getOrThrow().value, '+5511999999999');
    });

    test('should create valid international number', () {
      final result = PhoneNumber.create('+1 555 123 4567');
      expect(result.isSuccess, isTrue);
      expect(result.getOrThrow().value, '+15551234567');
    });

    test('should add "+" prefix if missing but digits are provided', () {
      final result = PhoneNumber.create('5511999998888');
      expect(result.isSuccess, isTrue);
      expect(result.getOrThrow().value, '+5511999998888');
    });

    test('should return PhoneNumberEmptyError when input is empty', () {
      final result = PhoneNumber.create('');
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<PhoneNumberEmptyError>());
    });

    test('should return PhoneNumberInvalidError when number is too short (E.164 min 7 digits)', () {
      final result = PhoneNumber.create('+123456');
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<PhoneNumberInvalidError>());
    });

    test('should return PhoneNumberInvalidError when number is too long (E.164 max 15 digits)', () {
      final result = PhoneNumber.create('+1234567890123456');
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<PhoneNumberInvalidError>());
    });

    test('should normalize by removing brackets, dashes and spaces', () {
      final result = PhoneNumber.create(' +55-11-98888-7777 ');
      expect(result.isSuccess, isTrue);
      expect(result.getOrThrow().value, '+5511988887777');
    });
  });
}
