import 'package:drift/drift.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:ecommerce_b2b/modules/identity_access/domain/enums/user_role.dart';
import 'package:ecommerce_b2b/modules/identity_access/domain/repositories/auth_repository.dart';
import 'package:ecommerce_b2b/modules/identity_access/domain/user_session.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/auth/errors/auth_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/user_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/email_address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/infrastructure/database/app_database.dart';

class DriftAuthRepository implements AuthRepository {
  final AppDatabase _db;

  DriftAuthRepository(this._db);

  @override
  Future<Result<UserSession, AuthError>> login(EmailAddress email, String password) async {
    final queryResult = await _db.customSelect(
      'SELECT id, role, company_id, password_hash FROM users WHERE email = ? AND active = 1 LIMIT 1',
      variables: [Variable(email.value)],
    ).getSingleOrNull();

    if (queryResult == null) {
      return Failure(InvalidCredentialsError());
    }

    final userId = queryResult.read<String>('id');
    final role = queryResult.read<String>('role');
    final companyId = queryResult.data['company_id'] as String?;
    final passwordHash = queryResult.read<String>('password_hash');

    if (!BCrypt.checkpw(password, passwordHash)) {
      return Failure(InvalidCredentialsError());
    }

    final session = UserSession(
      userId: UserId(userId),
      role: UserRole.values.firstWhere((r) => r.name == role),
      companyId: companyId != null ? CompanyId(companyId) : null,
    );

    await _db.transaction(() async {
      // Deactivate any active sessions
      await (_db.update(_db.userSessions)..where((t) => t.isActive.equals(true)))
          .write(const UserSessionsCompanion(isActive: Value(false)));

      // Insert/update session as active
      await _db.into(_db.userSessions).insertOnConflictUpdate(
        UserSessionsCompanion.insert(
          userId: session.userId.value,
          role: session.role.name,
          companyId: Value(session.companyId?.value),
          isActive: true,
        ),
      );
    });

    return Success(session);
  }

  @override
  Future<UserSession?> getCurrentSession() async {
    final row = await (_db.select(_db.userSessions)
          ..where((t) => t.isActive.equals(true)))
        .getSingleOrNull();

    if (row == null) return null;

    return UserSession(
      userId: UserId(row.userId),
      role: UserRole.values.firstWhere((r) => r.name == row.role),
      companyId: row.companyId != null ? CompanyId(row.companyId!) : null,
    );
  }

  @override
  Future<void> logout() async {
    await (_db.update(_db.userSessions)..where((t) => t.isActive.equals(true)))
        .write(const UserSessionsCompanion(isActive: Value(false)));
  }
}
