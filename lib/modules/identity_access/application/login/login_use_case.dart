import 'package:ecommerce_b2b/modules/identity_access/domain/repositories/auth_repository.dart';
import 'package:ecommerce_b2b/modules/identity_access/domain/user_session.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/email_address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/auth/errors/auth_errors.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<Result<UserSession, AuthError>> execute(String email, String password) async {
    final emailResult = EmailAddress.create(email);
    
    if (emailResult.isFailure) {
      return Failure(InvalidCredentialsError());
    }

    return await _authRepository.login(emailResult.getOrThrow(), password);
  }
}
