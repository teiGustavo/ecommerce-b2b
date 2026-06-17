import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_error.dart';

sealed class PhoneError extends DomainError {
  PhoneError(super.message);
}

class PhoneEmptyError extends PhoneError {
  PhoneEmptyError() : super('Phone number cannot be empty.');
}

class PhoneInvalidError extends PhoneError {
  PhoneInvalidError() : super('The phone number is invalid.');
}
