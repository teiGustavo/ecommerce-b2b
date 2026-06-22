import 'package:ecommerce_b2b/modules/shared_kernel/base/base_value_object.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';
import 'package:flutter/foundation.dart';

@immutable
class StockReservation extends ValueObject {
  final OrderId orderId;
  final Quantity quantity;

  const StockReservation({
    required this.orderId,
    required this.quantity,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockReservation &&
          runtimeType == other.runtimeType &&
          orderId == other.orderId &&
          quantity == other.quantity;

  @override
  int get hashCode => orderId.hashCode ^ quantity.hashCode;
}
