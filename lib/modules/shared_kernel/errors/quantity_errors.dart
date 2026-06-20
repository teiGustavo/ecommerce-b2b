import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';

sealed class QuantityError extends DomainError {
  QuantityError(super.message);
}

class QuantityNegativeError extends QuantityError {
  QuantityNegativeError() : super('Quantity cannot be negative.');
}
