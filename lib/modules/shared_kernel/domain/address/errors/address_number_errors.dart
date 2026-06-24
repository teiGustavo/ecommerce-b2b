import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';

class AddressNumberError extends DomainError {
  const AddressNumberError(super.message);
}

class AddressNumberEmptyError extends EmptyError implements AddressNumberError {
  const AddressNumberEmptyError() : super('O número não pode ser vazio.');
}

class AddressNumberTooLongError extends AddressNumberError {
  const AddressNumberTooLongError() : super('O número não pode ter mais de 10 caracteres.');
}
