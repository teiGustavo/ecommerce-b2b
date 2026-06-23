import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';

sealed class AuthError extends DomainError {
  AuthError(super.message);
}

class UnauthorizedError extends AuthError {
  UnauthorizedError([super.message = 'Access denied. You do not have permission to perform this action.']);
}

class InvalidCredentialsError extends AuthError {
  InvalidCredentialsError() : super('Invalid email or password.');
}

class SessionExpiredError extends AuthError {
  SessionExpiredError() : super('Session has expired. Please login again.');
}
