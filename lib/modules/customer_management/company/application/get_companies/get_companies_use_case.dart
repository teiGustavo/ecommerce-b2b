import 'package:ecommerce_b2b/modules/customer_management/company/domain/company.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/repositories/company_repository.dart';
import 'package:ecommerce_b2b/modules/identity_access/domain/user_session.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/repositories/sales_representative_repository.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/services/sales_hierarchy_domain_service.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/representative_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/auth/errors/auth_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';

class GetCompaniesUseCase {
  final CompanyRepository _companyRepository;
  final SalesRepresentativeRepository _representativeRepository;
  final SalesHierarchyDomainService _hierarchyService;

  GetCompaniesUseCase(
    this._companyRepository,
    this._representativeRepository,
    this._hierarchyService,
  );

  Future<Result<List<Company>, AuthError>> execute(
    UserSession currentSession, {
    String? targetRepresentativeId,
  }) async {
    if (currentSession.isBuyer) {
      if (currentSession.companyId == null) {
        return Failure(UnauthorizedError('Buyer user session has no company associated.'));
      }
      final company = await _companyRepository.findById(currentSession.companyId!);
      if (company != null) {
        return Success([company]);
      }
      return Success([]);
    }

    if (currentSession.isFinance) {
      final companies = await _companyRepository.findAll();
      return Success(companies);
    }

    if (currentSession.isRepresentative) {
      final effectiveRepId = targetRepresentativeId ?? currentSession.userId.value;
      
      if (effectiveRepId != currentSession.userId.value) {
        final supervisorId = RepresentativeId(currentSession.userId.value);
        final supervisor = await _representativeRepository.findById(supervisorId);
        
        if (supervisor != null) {
          final allReps = await _representativeRepository.findAll();
          final hasAccess = _hierarchyService.canSupervisorAccessSubordinate(
            supervisor: supervisor,
            subordinateId: RepresentativeId(effectiveRepId),
            allSubordinatesInContext: allReps,
          );

          if (!hasAccess) {
            return Failure(UnauthorizedError('You do not have permission to view this customer portfolio.'));
          }
        } else {
          return Failure(UnauthorizedError('Supervisor not found.'));
        }
      }

      final companies = await _companyRepository.findByRepresentativeId(effectiveRepId);
      return Success(companies);
    }

    return Failure(UnauthorizedError('You do not have permission to view companies.'));
  }
}
