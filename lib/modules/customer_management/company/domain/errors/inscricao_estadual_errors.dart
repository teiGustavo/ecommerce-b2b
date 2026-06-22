import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';

sealed class InscricaoEstadualError extends DomainError {
  InscricaoEstadualError(super.message);
}

class InscricaoEstadualEmptyError extends InscricaoEstadualError {
  InscricaoEstadualEmptyError() : super('Inscrição Estadual cannot be empty.');
}

class InscricaoEstadualInvalidError extends InscricaoEstadualError {
  InscricaoEstadualInvalidError() : super('The Inscrição Estadual is invalid.');
}
