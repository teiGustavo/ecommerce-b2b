import 'package:ecommerce_b2b/modules/shared_kernel/base/base_value_object.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/enums/finance_decision.dart';
import 'package:flutter/foundation.dart';

@immutable
class FinanceReview extends ValueObject {
  final FinanceDecision decision;
  final String reason;

  const FinanceReview({
    required this.decision,
    required this.reason,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinanceReview &&
          runtimeType == other.runtimeType &&
          decision == other.decision &&
          reason == other.reason;

  @override
  int get hashCode => decision.hashCode ^ reason.hashCode;
}
