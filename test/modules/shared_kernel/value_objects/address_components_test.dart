import 'package:ecommerce_b2b/modules/shared_kernel/errors/address_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/address_number.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/city.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/neighborhood.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/street.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/zip_code.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Street', () {
    test('should create valid street', () {
      final result = Street.create('Rua das Flores');
      expect(result.isSuccess, isTrue);
      expect(result.getOrThrow().value, 'Rua das Flores');
    });

    test('should return error for empty street', () {
      final result = Street.create('  ');
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<AddressRequiredFieldError>());
    });
  });

  group('AddressNumber', () {
    test('should create valid number', () {
      final result = AddressNumber.create('123 A');
      expect(result.isSuccess, isTrue);
      expect(result.getOrThrow().value, '123 A');
    });

    test('should return error for empty number', () {
      final result = AddressNumber.create('');
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<AddressRequiredFieldError>());
    });
  });

  group('City', () {
    test('should create valid city', () {
      final result = City.create('São Paulo');
      expect(result.isSuccess, isTrue);
      expect(result.getOrThrow().value, 'São Paulo');
    });

    test('should return error for empty city', () {
      final result = City.create('');
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<AddressRequiredFieldError>());
    });
  });

  group('Neighborhood', () {
    test('should create valid neighborhood', () {
      final result = Neighborhood.create('Centro');
      expect(result.isSuccess, isTrue);
      expect(result.getOrThrow().value, 'Centro');
    });

    test('should return error for empty neighborhood', () {
      final result = Neighborhood.create('');
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<AddressRequiredFieldError>());
    });
  });

  group('ZipCode', () {
    test('should create valid zip code', () {
      final result = ZipCode.create('01234-567');
      expect(result.isSuccess, isTrue);
      expect(result.getOrThrow().value, '01234567');
      expect(result.getOrThrow().formatted, '01234-567');
    });

    test('should return error for invalid zip code length', () {
      final result = ZipCode.create('12345');
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<AddressInvalidZipCodeError>());
    });

    test('should return error for empty zip code', () {
      final result = ZipCode.create('');
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<AddressRequiredFieldError>());
    });
  });
}
