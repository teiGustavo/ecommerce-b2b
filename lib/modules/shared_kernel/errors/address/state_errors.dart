import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';

sealed class StateError extends DomainError {
  StateError(super.message);
}

class StateInvalidError extends StateError {
  StateInvalidError() : super('Invalid state.');
}
