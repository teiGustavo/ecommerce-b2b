import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';

sealed class CnpjError extends DomainError {
  CnpjError(super.message);
}

class CnpjEmptyError extends CnpjError {
  CnpjEmptyError() : super('O CNPJ não pode ser vazio.');
}

class CnpjInvalidLengthError extends CnpjError {
  final int currentLength;
  CnpjInvalidLengthError(this.currentLength)
      : super('O CNPJ deve conter exatamente 14 dígitos (encontrados $currentLength).');
}

class CnpjInvalidVerificationDigitsError extends CnpjError {
  CnpjInvalidVerificationDigitsError()
      : super('O número do CNPJ é inválido (dígitos verificadores não coincidem).');
}

class CnpjInvalidError extends CnpjError {
  CnpjInvalidError()
      : super('O número do CNPJ é inválido.');
}
