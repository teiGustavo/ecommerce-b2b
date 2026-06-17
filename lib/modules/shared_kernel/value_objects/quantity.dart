import 'package:ecommerce_b2b/modules/shared_kernel/base/base_value_object.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/errors/quantity_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';
import 'package:flutter/foundation.dart';

@immutable
class Quantity extends ValueObject {
  final int value;

  const Quantity._(this.value);

  static Result<Quantity, QuantityError> create(int value) {
    if (value < 0) {
      return Failure(QuantityNegativeError());
    }
    return Success(Quantity._(value));
  }

  Quantity operator +(Quantity other) => Quantity._(value + other.value);
  
  Quantity operator -(Quantity other) {
    final result = value - other.value;
    if (result < 0) {
      throw StateError('Quantity cannot be negative after subtraction');
    }
    return Quantity._(result);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Quantity &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toString();
}
