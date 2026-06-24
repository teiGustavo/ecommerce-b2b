import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';

class StreetError extends DomainError {
  const StreetError(super.message);
}

class StreetEmptyError extends EmptyError implements StreetError {
  const StreetEmptyError() : super('O logradouro não pode ser vazio');
}

class StreetTooLongError extends StreetError {
  const StreetTooLongError() : super('O logradouro não pode ter mais de 100 caracteres.');
}
