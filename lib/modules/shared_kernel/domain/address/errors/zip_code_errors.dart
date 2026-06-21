import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';

class ZipCodeError extends DomainError {
  const ZipCodeError(super.message);
}

class ZipCodeEmptyError extends EmptyError implements ZipCodeError {
  const ZipCodeEmptyError() : super('Zip code');
}

class ZipCodeLengthError extends ZipCodeError {
  const ZipCodeLengthError() : super('Zip code must have 8 digits.');
}