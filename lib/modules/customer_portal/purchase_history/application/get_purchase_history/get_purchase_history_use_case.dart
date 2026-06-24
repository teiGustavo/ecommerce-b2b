import 'package:ecommerce_b2b/modules/identity_access/domain/user_session.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/repositories/sales_order_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/sales_order.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/repositories/sales_representative_repository.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/services/sales_hierarchy_domain_service.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/auth/errors/auth_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/representative_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';

/// Caso de Uso responsável por recuperar o histórico de compras de uma empresa (RF18).
class GetPurchaseHistoryUseCase {
  final SalesOrderRepository _orderRepository;
  final SalesRepresentativeRepository _representativeRepository;
  final SalesHierarchyDomainService _hierarchyService;

  GetPurchaseHistoryUseCase(
    this._orderRepository,
    this._representativeRepository,
    this._hierarchyService,
  );

  /// Executa a consulta do histórico de compras com validação de segurança.
  Future<Result<List<SalesOrder>, AuthError>> execute(
    CompanyId companyId,
    UserSession currentSession,
  ) async {
    // Regra de Autorização: Comprador só pode ver histórico da sua própria empresa.
    if (currentSession.isBuyer && currentSession.companyId != companyId) {
      return Failure(UnauthorizedError('Você só pode acessar o histórico de compras da sua própria empresa.'));
    }

    // Regra de Autorização: Representante só pode ver histórico de empresas em sua carteira ou de seus subordinados.
    if (currentSession.isRepresentative) {
      final repId = RepresentativeId(currentSession.userId.value);
      final representative = await _representativeRepository.findById(repId);
      if (representative == null) {
        return Failure(UnauthorizedError('Representante não encontrado.'));
      }

      // Verifica se a empresa está diretamente associada ao representante
      final hasDirectAssignment = representative.assignments.any((a) => a.companyId == companyId);
      
      if (!hasDirectAssignment) {
        // Verifica se a empresa está associada a algum subordinado hierárquico
        final allReps = await _representativeRepository.findAll();
        bool hasSubordinateAccess = false;
        
        for (final otherRep in allReps) {
          if (_hierarchyService.canSupervisorAccessSubordinate(
            supervisor: representative,
            subordinateId: otherRep.id,
            allSubordinatesInContext: allReps,
          )) {
            if (otherRep.assignments.any((a) => a.companyId == companyId)) {
              hasSubordinateAccess = true;
              break;
            }
          }
        }
        
        if (!hasSubordinateAccess) {
          return Failure(UnauthorizedError('Você só pode acessar o histórico de compras de empresas em sua carteira ou de seus subordinados.'));
        }
      }
    }

    final orders = await _orderRepository.findByCompanyId(companyId);
    return Success(orders);
  }
}
