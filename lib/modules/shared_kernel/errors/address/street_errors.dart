import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';

class StreetError extends DomainError {
  const StreetError(super.message);
}

class StreetEmptyError extends EmptyError implements StreetError {
  const StreetEmptyError() : super('Street');
}

class StreetTooLongError extends StreetError {
  const StreetTooLongError() : super('Street cannot be longer than 100 characters.');
}