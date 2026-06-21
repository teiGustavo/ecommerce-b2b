import 'package:ecommerce_b2b/modules/shared_kernel/base/base_value_object.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/percentage.dart';
import 'package:ecommerce_b2b/modules/sales_team/domain/enums/commission_status.dart';
import 'package:flutter/foundation.dart';

@immutable
class Commission extends ValueObject {
  final Money baseAmount;
  final Percentage rate;
  final Money amount;
  final CommissionStatus status;

  const Commission({
    required this.baseAmount,
    required this.rate,
    required this.amount,
    required this.status,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Commission &&
          runtimeType == other.runtimeType &&
          baseAmount == other.baseAmount &&
          rate == other.rate &&
          amount == other.amount &&
          status == other.status;

  @override
  int get hashCode =>
      baseAmount.hashCode ^ rate.hashCode ^ amount.hashCode ^ status.hashCode;
}
