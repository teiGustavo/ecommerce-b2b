import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_error.dart';

sealed class CnpjError extends DomainError {
  CnpjError(super.message);
}

class CnpjEmptyError extends CnpjError {
  CnpjEmptyError() : super('CNPJ cannot be empty.');
}

class CnpjInvalidLengthError extends CnpjError {
  final int currentLength;
  CnpjInvalidLengthError(this.currentLength)
      : super('CNPJ must contain exactly 14 digits (found $currentLength).');
}

class CnpjInvalidVerificationDigitsError extends CnpjError {
  CnpjInvalidVerificationDigitsError()
      : super('The CNPJ number is invalid (verification digits mismatch).');
}

class CnpjInvalidError extends CnpjError {
  CnpjInvalidError()
      : super('The CNPJ number is invalid.');
}