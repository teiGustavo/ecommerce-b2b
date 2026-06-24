import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';

sealed class EmailError extends DomainError {
  EmailError(super.message);
}

class EmailEmptyError extends EmailError {
  EmailEmptyError() : super('O e-mail não pode ser vazio.');
}

class EmailInvalidError extends EmailError {
  EmailInvalidError() : super('O endereço de e-mail é inválido.');
}
