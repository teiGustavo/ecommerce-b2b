import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_error.dart';

sealed class PercentageError extends DomainError {
  PercentageError(super.message);
}

class PercentageOutOfRangeError extends PercentageError {
  PercentageOutOfRangeError() : super('Percentage must be between 0 and 100.');
}
