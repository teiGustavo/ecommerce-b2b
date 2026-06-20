import 'package:ecommerce_b2b/modules/shared_kernel/base/base_value_object.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/errors/address_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';
import 'package:flutter/foundation.dart';

@immutable
class City extends ValueObject {
  final String value;

  const City._(this.value);

  static Result<City, AddressError> create(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return Failure(AddressRequiredFieldError('City'));
    }
    return Success(City._(trimmed));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is City &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
