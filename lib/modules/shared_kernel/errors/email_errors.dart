import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';

sealed class EmailError extends DomainError {
  EmailError(super.message);
}

class EmailEmptyError extends EmailError {
  EmailEmptyError() : super('Email cannot be empty.');
}

class EmailInvalidError extends EmailError {
  EmailInvalidError() : super('The email address is invalid.');
}
