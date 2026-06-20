import 'package:ecommerce_b2b/modules/shared_kernel/errors/address/address_number_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/errors/address/city_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/errors/address/neighborhood_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/errors/address/street_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/errors/address/zip_code_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/address/address_number.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/address/city.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/address/neighborhood.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/address/street.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/address/zip_code.dart';
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
      expect(result.getFailureOrThrow(), isA<StreetEmptyError>());
    });

    test('should return error for too long street', () {
      final result = Street.create('a' * 101);
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<StreetTooLongError>());
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
      expect(result.getFailureOrThrow(), isA<AddressNumberEmptyError>());
    });

    test('should return error for too long number', () {
      final result = AddressNumber.create('a' * 11);
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<AddressNumberTooLongError>());
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
      expect(result.getFailureOrThrow(), isA<CityEmptyError>());
    });

    test('should return error for too long city', () {
      final result = City.create('a' * 101);
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<CityTooLongError>());
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
      expect(result.getFailureOrThrow(), isA<NeighborhoodEmptyError>());
    });

    test('should return error for too long neighborhood', () {
      final result = Neighborhood.create('a' * 71);
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<NeighborhoodTooLongError>());
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
      expect(result.getFailureOrThrow(), isA<ZipCodeLengthError>());
    });

    test('should return error for empty zip code', () {
      final result = ZipCode.create('');
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<ZipCodeEmptyError>());
    });
  });
}
