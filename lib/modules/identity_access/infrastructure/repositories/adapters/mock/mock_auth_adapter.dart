import 'package:ecommerce_b2b/modules/identity_access/domain/enums/user_role.dart';
import 'package:ecommerce_b2b/modules/identity_access/domain/repositories/auth_repository.dart';
import 'package:ecommerce_b2b/modules/identity_access/domain/user_session.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/auth/errors/auth_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/representative_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/buyer_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/user_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/email_address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';

class MockAuthAdapter implements AuthRepository {
  UserSession? _currentSession;

  @override
  Future<Result<UserSession, AuthError>> login(EmailAddress email, String password) async {
    // Basic mock logic
    if (password != 'password123') {
      return Failure(InvalidCredentialsError());
    }

    final emailStr = email.value;

    if (emailStr.contains('buyer')) {
      _currentSession = UserSession(
        userId: const BuyerId('buyer-123'),
        role: UserRole.buyer,
        companyId: const CompanyId('company-abc'),
      );
    } else if (emailStr.contains('rep')) {
      _currentSession = UserSession(
        userId: const RepresentativeId('rep-456'),
        role: UserRole.representative,
      );
    } else if (emailStr.contains('finance')) {
      _currentSession = UserSession(
        userId: const UserId('finance-789'),
        role: UserRole.finance,
      );
    } else {
      return Failure(InvalidCredentialsError());
    }

    return Success(_currentSession!);
  }

  @override
  Future<UserSession?> getCurrentSession() async {
    return _currentSession;
  }

  @override
  Future<void> logout() async {
    _currentSession = null;
  }
}
