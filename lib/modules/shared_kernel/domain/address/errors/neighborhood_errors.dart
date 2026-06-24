import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';

class NeighborhoodError extends DomainError {
  const NeighborhoodError(super.message);
}

class NeighborhoodEmptyError extends EmptyError implements NeighborhoodError {
  const NeighborhoodEmptyError() : super('O bairro não pode ser vazio');
}

class NeighborhoodTooLongError extends NeighborhoodError {
  const NeighborhoodTooLongError() : super('O bairro não pode ter mais de 70 caracteres.');
}
