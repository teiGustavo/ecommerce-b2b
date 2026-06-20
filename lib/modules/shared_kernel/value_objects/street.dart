import 'package:ecommerce_b2b/modules/shared_kernel/base/base_value_object.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/errors/address_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';
import 'package:flutter/foundation.dart';

@immutable
class Street extends ValueObject {
  final String value;

  const Street._(this.value);

  static Result<Street, AddressError> create(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return Failure(AddressRequiredFieldError('Street'));
    }
    return Success(Street._(trimmed));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Street &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
