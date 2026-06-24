import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';

sealed class PhoneNumberError extends DomainError {
  PhoneNumberError(super.message);
}

class PhoneNumberEmptyError extends PhoneNumberError {
  PhoneNumberEmptyError() : super('O telefone não pode ser vazio.');
}

class PhoneNumberInvalidError extends PhoneNumberError {
  PhoneNumberInvalidError() : super('O número de telefone é inválido.');
}
