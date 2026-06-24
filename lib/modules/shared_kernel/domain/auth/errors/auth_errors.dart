import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';

sealed class AuthError extends DomainError {
  AuthError(super.message);
}

class InvalidCredentialsError extends AuthError {
  InvalidCredentialsError() : super('E-mail ou senha inválidos.');
}

class SessionExpiredError extends AuthError {
  SessionExpiredError() : super('A sessão expirou. Por favor, faça login novamente.');
}

class UnauthorizedError extends AuthError {
  UnauthorizedError(super.message);
}
