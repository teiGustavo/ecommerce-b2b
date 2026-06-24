import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';

class AddressComplementError extends DomainError {
  const AddressComplementError(super.message);
}

class AddressComplementEmptyError extends EmptyError implements AddressComplementError {
  const AddressComplementEmptyError() : super('O complemento não pode ser vazio.');
}

class AddressComplementTooLongError extends AddressComplementError {
  const AddressComplementTooLongError() : super('O complemento não pode ter mais de 60 caracteres.');
}
