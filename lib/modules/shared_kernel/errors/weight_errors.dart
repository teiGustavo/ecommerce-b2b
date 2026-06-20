import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_error.dart';

sealed class WeightError extends DomainError {
  WeightError(super.message);
}

class WeightNegativeError extends WeightError {
  WeightNegativeError() : super('Weight cannot be negative.');
}
