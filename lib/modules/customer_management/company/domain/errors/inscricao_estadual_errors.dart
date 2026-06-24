import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';

sealed class InscricaoEstadualError extends DomainError {
  InscricaoEstadualError(super.message);
}

class InscricaoEstadualEmptyError extends InscricaoEstadualError {
  InscricaoEstadualEmptyError() : super('A inscrição estadual não pode ser vazia.');
}

class InscricaoEstadualInvalidError extends InscricaoEstadualError {
  InscricaoEstadualInvalidError() : super('A inscrição estadual é inválida.');
}
