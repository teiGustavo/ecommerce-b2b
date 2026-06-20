import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';

class NeighborhoodError extends DomainError {
  const NeighborhoodError(super.message);
}

class NeighborhoodEmptyError extends EmptyError implements NeighborhoodError {
  const NeighborhoodEmptyError() : super('Neighborhood');
}

class NeighborhoodTooLongError extends NeighborhoodError {
  const NeighborhoodTooLongError() : super('Neighborhood cannot be longer than 70 characters.');
}
