import 'package:ecommerce_b2b/modules/shared_kernel/enums/state.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/errors/address_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/address.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Address', () {
    test('should create valid address', () {
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
      expect(address.street, 'Rua A');
      expect(address.state, State.saoPaulo);
      expect(address.zipCode, '01001000');
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
      expect(result.getFailureOrThrow(), isA<AddressRequiredFieldError>());
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
      expect(result.getFailureOrThrow(), isA<AddressRequiredFieldError>());
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
      expect(result.getFailureOrThrow(), isA<AddressInvalidZipCodeError>());
    });
  });
}
