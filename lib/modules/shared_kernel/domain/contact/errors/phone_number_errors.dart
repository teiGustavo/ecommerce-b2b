import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';

sealed class PhoneNumberError extends DomainError {
  PhoneNumberError(super.message);
}

class PhoneNumberEmptyError extends PhoneNumberError {
  PhoneNumberEmptyError() : super('Phone number cannot be empty.');
}

class PhoneNumberInvalidError extends PhoneNumberError {
  PhoneNumberInvalidError() : super('The phone number is invalid.');
}
