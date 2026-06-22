import 'package:ecommerce_b2b/modules/shared_kernel/base/base_value_object.dart';
import 'package:flutter/foundation.dart';

@immutable
class ShippingLabel extends ValueObject {
  final String labelNumber;

  const ShippingLabel(this.labelNumber);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShippingLabel &&
          runtimeType == other.runtimeType &&
          labelNumber == other.labelNumber;

  @override
  int get hashCode => labelNumber.hashCode;
}
