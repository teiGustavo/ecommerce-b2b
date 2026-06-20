import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';

sealed class MoneyError extends DomainError {
  MoneyError(super.message);
}

class MoneyNegativeError extends MoneyError {
  MoneyNegativeError() : super('Money amount cannot be negative.');
}

class MoneyCurrencyMismatchError extends MoneyError {
  MoneyCurrencyMismatchError() : super('Cannot perform operation on different currencies.');
}
