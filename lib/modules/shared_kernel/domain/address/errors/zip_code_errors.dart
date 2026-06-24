import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';

class ZipCodeError extends DomainError {
  const ZipCodeError(super.message);
}

class ZipCodeEmptyError extends EmptyError implements ZipCodeError {
  const ZipCodeEmptyError() : super('O CEP não pode ser vazio');
}

class ZipCodeLengthError extends ZipCodeError {
  const ZipCodeLengthError() : super('O CEP deve ter 8 dígitos.');
}
