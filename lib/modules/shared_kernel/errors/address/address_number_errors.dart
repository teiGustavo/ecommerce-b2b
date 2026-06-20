import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';

class AddressNumberError extends DomainError {
  const AddressNumberError(super.message);
}

class AddressNumberEmptyError extends EmptyError implements AddressNumberError {
  const AddressNumberEmptyError() : super('Number');
}

class AddressNumberTooLongError extends AddressNumberError {
  const AddressNumberTooLongError() : super('Number cannot be longer than 10 characters.');
}
