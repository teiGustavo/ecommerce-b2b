import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_error.dart';

sealed class AddressError extends DomainError {
  AddressError(super.message);
}

class AddressRequiredFieldError extends AddressError {
  final String fieldName;
  AddressRequiredFieldError(this.fieldName) : super('$fieldName is required.');
}

class AddressInvalidFieldError extends AddressError {
  final String fieldName;
  AddressInvalidFieldError(this.fieldName) : super('$fieldName is invalid.');
}

class AddressInvalidZipCodeError extends AddressError {
  AddressInvalidZipCodeError() : super('Invalid ZIP code format.');
}

class AddressInvalidStateError extends AddressError {
  AddressInvalidStateError() : super('Invalid state.');
}
