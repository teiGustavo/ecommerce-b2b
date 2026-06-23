import 'package:ecommerce_b2b/modules/identity_access/domain/enums/user_role.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/user_id.dart';

class UserSession {
  final UserId userId;
  final UserRole role;
  final CompanyId? companyId; // Relevante apenas para UserRole.buyer

  UserSession({
    required this.userId,
    required this.role,
    this.companyId,
  }) {
    if (role == UserRole.buyer && companyId == null) {
      throw ArgumentError('CompanyId is required for buyer role.');
    }
  }

  bool get isBuyer => role == UserRole.buyer;
  bool get isRepresentative => role == UserRole.representative;
  bool get isFinance => role == UserRole.finance;
}
