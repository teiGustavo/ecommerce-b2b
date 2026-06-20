import 'package:ecommerce_b2b/modules/shared_kernel/base/base_value_object.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/enums/state.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/quantity.dart';
import 'package:flutter/foundation.dart';

@immutable
class PriceRule extends ValueObject {
  final Quantity minQuantity;
  final Quantity maxQuantity;
  final State state;
  final Money unitPrice;

  const PriceRule({
    required this.minQuantity,
    required this.maxQuantity,
    required this.state,
    required this.unitPrice,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriceRule &&
          runtimeType == other.runtimeType &&
          minQuantity == other.minQuantity &&
          maxQuantity == other.maxQuantity &&
          state == other.state &&
          unitPrice == other.unitPrice;

  @override
  int get hashCode =>
      minQuantity.hashCode ^
      maxQuantity.hashCode ^
      state.hashCode ^
      unitPrice.hashCode;
}
