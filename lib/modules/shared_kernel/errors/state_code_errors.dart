import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_error.dart';

sealed class StateCodeError extends DomainError {
  StateCodeError(super.message);
}

class StateCodeInvalidError extends StateCodeError {
  StateCodeInvalidError() : super('Invalid state code. Must be 2 characters.');
}
