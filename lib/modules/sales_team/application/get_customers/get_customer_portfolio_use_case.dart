import 'package:ecommerce_b2b/modules/identity_access/domain/user_session.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/customer_assignment.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/repositories/sales_representative_repository.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/services/sales_hierarchy_domain_service.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/auth/errors/auth_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/representative_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';

class GetCustomerPortfolioUseCase {
  final SalesRepresentativeRepository _representativeRepository;
  final SalesHierarchyDomainService _hierarchyService;

  GetCustomerPortfolioUseCase(
    this._representativeRepository,
    this._hierarchyService,
  );

  Future<Result<List<CustomerAssignment>, AuthError>> execute(
    RepresentativeId targetRepId,
    UserSession currentSession,
  ) async {
    // 1. Verificação de Identidade (RN1)
    final isSelf = currentSession.userId == targetRepId;

    if (isSelf) {
      final rep = await _representativeRepository.findById(targetRepId);
      return Success(rep?.assignments ?? []);
    }

    // 2. Verificação de Hierarquia (RN9)
    if (currentSession.isRepresentative) {
      final supervisorId = RepresentativeId(currentSession.userId.value);
      final supervisor = await _representativeRepository.findById(supervisorId);
      
      if (supervisor != null) {
        final allReps = await _representativeRepository.findAll();
        
        final hasAccess = _hierarchyService.canSupervisorAccessSubordinate(
          supervisor: supervisor,
          subordinateId: targetRepId,
          allSubordinatesInContext: allReps,
        );

        if (hasAccess) {
          final targetRep = await _representativeRepository.findById(targetRepId);
          return Success(targetRep?.assignments ?? []);
        }
      }
    }

    return Failure(UnauthorizedError('You do not have permission to view this customer portfolio.'));
  }
}
