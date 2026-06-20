import 'package:ecommerce_b2b/modules/shared_kernel/enums/state.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/errors/address/address_complement_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/errors/address/address_number_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/errors/address/city_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/errors/address/neighborhood_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/errors/address/state_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/errors/address/street_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/errors/address/zip_code_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/address/address.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Address', () {
    test('should create valid address without complement', () {
      final result = Address.create(
        street: 'Rua A',
        number: '123',
        neighborhood: 'Centro',
        city: 'São Paulo',
        state: 'SP',
        zipCode: '01001-000',
      );
      expect(result.isSuccess, isTrue);
      final address = result.getOrThrow();
      expect(address.street.value, 'Rua A');
      expect(address.number.value, '123');
      expect(address.complement, isNull);
      expect(address.neighborhood.value, 'Centro');
      expect(address.city.value, 'São Paulo');
      expect(address.state, State.saoPaulo);
      expect(address.zipCode.value, '01001000');
    });

    test('should create valid address with complement', () {
      final result = Address.create(
        street: 'Rua A',
        number: '123',
        complement: 'Apto 101',
        neighborhood: 'Centro',
        city: 'São Paulo',
        state: 'SP',
        zipCode: '01001-000',
      );
      expect(result.isSuccess, isTrue);
      final address = result.getOrThrow();
      expect(address.complement?.value, 'Apto 101');
    });

    test('should create valid address with empty complement', (){
      final result = Address.create(
        street: 'Rua A',
        number: '123',
        complement: '',
        neighborhood: 'Centro',
        city: 'São Paulo',
        state: 'SP',
        zipCode: '01001-000',
      );

      expect(result.isSuccess, isTrue);
      final address = result.getOrThrow();
      expect(address.complement, isNull);
    });

    test('should return error for invalid state', () {
      final result = Address.create(
        street: 'Rua A',
        number: '123',
        neighborhood: 'Centro',
        city: 'São Paulo',
        state: 'XX',
        zipCode: '01001-000',
      );
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<StateInvalidError>());
    });

    test('should return error for missing street', () {
      final result = Address.create(
        street: '',
        number: '123',
        neighborhood: 'Centro',
        city: 'São Paulo',
        state: 'SP',
        zipCode: '01001-000',
      );
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<StreetEmptyError>());
    });

    test('should return error for invalid zip code', () {
      final result = Address.create(
        street: 'Rua A',
        number: '123',
        neighborhood: 'Centro',
        city: 'São Paulo',
        state: 'SP',
        zipCode: '123',
      );
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<ZipCodeLengthError>());
    });

    test('should return error for empty neighborhood', () {
      final result = Address.create(
        street: 'Rua A',
        number: '123',
        neighborhood: '',
        city: 'São Paulo',
        state: 'SP',
        zipCode: '01001-000',
      );
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<NeighborhoodEmptyError>());
    });

    test('should return error for empty city', () {
      final result = Address.create(
        street: 'Rua A',
        number: '123',
        neighborhood: 'Centro',
        city: '',
        state: 'SP',
        zipCode: '01001-000',
      );
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<CityEmptyError>());
    });

    test('should return error for empty number', () {
      final result = Address.create(
        street: 'Rua A',
        number: '',
        neighborhood: 'Centro',
        city: 'São Paulo',
        state: 'SP',
        zipCode: '01001-000',
      );
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<AddressNumberEmptyError>());
    });

    test('should return error for too long street', () {
      final result = Address.create(
        street: 'a' * 101,
        number: '123',
        neighborhood: 'Centro',
        city: 'São Paulo',
        state: 'SP',
        zipCode: '01001-000',
      );
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<StreetTooLongError>());
    });

    test('should return error for too long complement', () {
      final result = Address.create(
        street: 'Rua A',
        number: '123',
        complement: 'a' * 61,
        neighborhood: 'Centro',
        city: 'São Paulo',
        state: 'SP',
        zipCode: '01001-000',
      );
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<AddressComplementTooLongError>());
    });
  });
}
