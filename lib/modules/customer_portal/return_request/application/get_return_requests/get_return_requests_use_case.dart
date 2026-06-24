import 'package:ecommerce_b2b/modules/customer_portal/return_request/domain/return_request.dart';
import 'package:ecommerce_b2b/modules/customer_portal/return_request/domain/repositories/return_request_repository.dart';
import 'package:ecommerce_b2b/modules/identity_access/domain/user_session.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/repositories/sales_order_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/auth/errors/auth_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';

/// Caso de Uso responsável por recuperar as solicitações de RMA de uma empresa (RF21).
class GetReturnRequestsUseCase {
  final ReturnRequestRepository _returnRequestRepository;
  final SalesOrderRepository _orderRepository;

  GetReturnRequestsUseCase(
    this._returnRequestRepository,
    this._orderRepository,
  );

  /// Executa a consulta das solicitações de RMA com validação de segurança.
  Future<Result<List<ReturnRequest>, AuthError>> execute(
    CompanyId companyId,
    UserSession currentSession,
  ) async {
    // Regra de Autorização: Comprador só pode ver RMAs da sua própria empresa.
    if (currentSession.isBuyer && currentSession.companyId != companyId) {
      return Failure(UnauthorizedError('You can only access return requests for your own company.'));
    }

    // Busca todos os pedidos da empresa
    final orders = await _orderRepository.findByCompanyId(companyId);
    final orderIds = orders.map((o) => o.id.value).toSet();

    // Busca todos os RMAs e filtra os que pertencem aos pedidos da empresa
    final allRma = await _returnRequestRepository.getAll();
    final companyRma = allRma.where((rma) => orderIds.contains(rma.orderId)).toList();

    return Success(companyRma);
  }
}
