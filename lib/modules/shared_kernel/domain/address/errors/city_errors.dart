import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';

class CityError extends DomainError {
  const CityError(super.message);
}

class CityEmptyError extends EmptyError implements CityError {
  const CityEmptyError() : super('City');
}

class CityTooLongError extends CityError {
  const CityTooLongError() : super('City cannot be longer than 100 characters.');
}