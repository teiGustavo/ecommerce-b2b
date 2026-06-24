import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';

sealed class MoneyError extends DomainError {
  MoneyError(super.message);
}

class MoneyNegativeError extends MoneyError {
  MoneyNegativeError() : super('O valor monetário não pode ser negativo.');
}

class MoneyCurrencyMismatchError extends MoneyError {
  MoneyCurrencyMismatchError() : super('Não é possível realizar operações em moedas diferentes.');
}
