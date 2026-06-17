import 'package:ecommerce_b2b/modules/shared_kernel/base/base_value_object.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/money.dart';

class CustomerCreditAccount extends ValueObject {
  final Money preApprovedLimit;
  final Money openBalance;

  const CustomerCreditAccount({
    required this.preApprovedLimit,
    required this.openBalance,
  });

  Money get availableLimit => preApprovedLimit - openBalance;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerCreditAccount &&
          runtimeType == other.runtimeType &&
          preApprovedLimit == other.preApprovedLimit &&
          openBalance == other.openBalance;

  @override
  int get hashCode => preApprovedLimit.hashCode ^ openBalance.hashCode;
}
