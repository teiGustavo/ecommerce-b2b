import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';

sealed class PercentageError extends DomainError {
  PercentageError(super.message);
}

class PercentageOutOfRangeError extends PercentageError {
  PercentageOutOfRangeError() : super('A porcentagem deve estar entre 0 e 100.');
}
