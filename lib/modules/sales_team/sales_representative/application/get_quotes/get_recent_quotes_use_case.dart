import 'package:ecommerce_b2b/modules/identity_access/domain/user_session.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/domain/quote.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/domain/repositories/quote_repository.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/repositories/sales_representative_repository.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/services/sales_hierarchy_domain_service.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/auth/errors/auth_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/representative_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';

class GetRecentQuotesUseCase {
  final QuoteRepository _quoteRepository;
  final SalesRepresentativeRepository _representativeRepository;
  final SalesHierarchyDomainService _hierarchyService;

  GetRecentQuotesUseCase(
    this._quoteRepository,
    this._representativeRepository,
    this._hierarchyService,
  );

  Future<Result<List<Quote>, AuthError>> execute(
    RepresentativeId targetRepId,
    UserSession currentSession,
  ) async {
    final isSelf = currentSession.userId.value == targetRepId.value;

    if (isSelf) {
      final quotes = await _quoteRepository.findByRepresentativeId(targetRepId.value);
      return Success(quotes);
    }

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
          final quotes = await _quoteRepository.findByRepresentativeId(targetRepId.value);
          return Success(quotes);
        }
      }
    }

    return Failure(UnauthorizedError('Você não tem permissão para visualizar estes orçamentos.'));
  }
}
