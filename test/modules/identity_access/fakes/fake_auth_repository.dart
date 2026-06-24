import 'package:ecommerce_b2b/modules/identity_access/domain/enums/user_role.dart';
import 'package:ecommerce_b2b/modules/identity_access/domain/repositories/auth_repository.dart';
import 'package:ecommerce_b2b/modules/identity_access/domain/user_session.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/auth/errors/auth_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/user_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/email_address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/id_generator.dart';
import 'package:bcrypt/bcrypt.dart';

class FakeAuthRepository implements AuthRepository {
  UserSession? _currentSession;
  late final Map<String, _FakeUserRecord> _users = {
    'buyer@test.com': _FakeUserRecord(
      userId: UserId(generateId()),
      role: UserRole.buyer,
      companyId: CompanyId('c1'),
      passwordHash: BCrypt.hashpw('password123', BCrypt.gensalt()),
    ),
    'rep@test.com': _FakeUserRecord(
      userId: UserId('rep-456'),
      role: UserRole.representative,
      passwordHash: BCrypt.hashpw('password123', BCrypt.gensalt()),
    ),
    'supervisor@test.com': _FakeUserRecord(
      userId: UserId('rep-supervisor'),
      role: UserRole.supervisor,
      passwordHash: BCrypt.hashpw('password123', BCrypt.gensalt()),
    ),
    'finance@test.com': _FakeUserRecord(
      userId: UserId(generateId()),
      role: UserRole.finance,
      passwordHash: BCrypt.hashpw('password123', BCrypt.gensalt()),
    ),
  };

  @override
  Future<Result<UserSession, AuthError>> login(EmailAddress email, String password) async {
    final user = _users[email.value];
    if (user == null || !BCrypt.checkpw(password, user.passwordHash)) {
      return Failure(InvalidCredentialsError());
    }

    _currentSession = UserSession(
      userId: user.userId,
      role: user.role,
      companyId: user.companyId,
    );

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

class _FakeUserRecord {
  final UserId userId;
  final UserRole role;
  final CompanyId? companyId;
  final String passwordHash;

  _FakeUserRecord({
    required this.userId,
    required this.role,
    this.companyId,
    required this.passwordHash,
  });
}

