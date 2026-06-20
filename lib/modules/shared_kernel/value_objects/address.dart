import 'package:ecommerce_b2b/modules/shared_kernel/base/base_value_object.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/enums/state.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/errors/address_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';
import 'package:flutter/foundation.dart';

/// Objeto de Valor que representa um endereço válido.
@immutable
class Address extends ValueObject {
  final String street;
  final String number;
  final String complement;
  final String neighborhood;
  final String city;
  final State state;
  final String zipCode;

  const Address._({
    required this.street,
    required this.number,
    required this.complement,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  static Result<Address, AddressError> create({
    required String street,
    required String number,
    String complement = '',
    required String neighborhood,
    required String city,
    required String state,
    required String zipCode,
  }) {
    if (street.trim().isEmpty) return Failure(AddressRequiredFieldError('Street'));
    if (number.trim().isEmpty) return Failure(AddressRequiredFieldError('Number'));
    if (neighborhood.trim().isEmpty) return Failure(AddressRequiredFieldError('Neighborhood'));
    if (city.trim().isEmpty) return Failure(AddressRequiredFieldError('City'));
    if (state.trim().isEmpty) return Failure(AddressRequiredFieldError('State'));
    
    final stateResult = State.fromString(state);
    if (stateResult.isFailure) {
      return Failure(AddressInvalidFieldError('State'));
    }
    
    final cleanZip = zipCode.replaceAll(RegExp(r'\D'), '');
    if (cleanZip.length != 8) return Failure(AddressInvalidZipCodeError());

    return Success(Address._(
      street: street.trim(),
      number: number.trim(),
      complement: complement.trim(),
      neighborhood: neighborhood.trim(),
      city: city.trim(),
      state: stateResult.getOrThrow(),
      zipCode: cleanZip,
    ));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Address &&
          runtimeType == other.runtimeType &&
          street == other.street &&
          number == other.number &&
          complement == other.complement &&
          neighborhood == other.neighborhood &&
          city == other.city &&
          state == other.state &&
          zipCode == other.zipCode;

  @override
  int get hashCode =>
      street.hashCode ^
      number.hashCode ^
      complement.hashCode ^
      neighborhood.hashCode ^
      city.hashCode ^
      state.hashCode ^
      zipCode.hashCode;
}
