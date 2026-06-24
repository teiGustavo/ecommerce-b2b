import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';

class CityError extends DomainError {
  const CityError(super.message);
}

class CityEmptyError extends EmptyError implements CityError {
  const CityEmptyError() : super('A cidade não pode ser vazia.');
}

class CityTooLongError extends CityError {
  const CityTooLongError() : super('A cidade não pode ter mais de 100 caracteres.');
}
