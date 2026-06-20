import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';

class AddressComplementError extends DomainError {
  const AddressComplementError(super.message);
}

class AddressComplementEmptyError extends EmptyError implements AddressComplementError {
  const AddressComplementEmptyError() : super('Complement');
}

class AddressComplementTooLongError extends AddressComplementError {
  const AddressComplementTooLongError() : super('Complement cannot be longer than 60 characters.');
}
