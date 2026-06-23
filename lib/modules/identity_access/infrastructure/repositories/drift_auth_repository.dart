import 'package:drift/drift.dart';
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
    if (password != 'password123') {
      return Failure(InvalidCredentialsError());
    }

    final emailStr = email.value;
    UserSession session;

    if (emailStr.contains('buyer')) {
      session = UserSession(
        userId: const UserId('buyer-123'),
        role: UserRole.buyer,
        companyId: const CompanyId('company-abc'),
      );
    } else if (emailStr.contains('rep')) {
      session = UserSession(
        userId: const UserId('rep-456'),
        role: UserRole.representative,
      );
    } else if (emailStr.contains('finance')) {
      session = UserSession(
        userId: const UserId('finance-789'),
        role: UserRole.finance,
      );
    } else {
      return Failure(InvalidCredentialsError());
    }

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
