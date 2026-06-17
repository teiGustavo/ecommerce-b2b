import 'package:ecommerce_b2b/modules/shared_kernel/base/base_value_object.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/errors/phone_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';
import 'package:flutter/foundation.dart';

@immutable
class PhoneNumber extends ValueObject {
  final String value;

  const PhoneNumber._(this.value);

  static Result<PhoneNumber, PhoneError> create(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) {
      return Failure(PhoneEmptyError());
    }

    if (digits.length < 10 || digits.length > 11) {
      return Failure(PhoneInvalidError());
    }

    return Success(PhoneNumber._(digits));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhoneNumber &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
