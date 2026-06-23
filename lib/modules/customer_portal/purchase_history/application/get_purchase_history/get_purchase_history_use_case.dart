import 'package:ecommerce_b2b/modules/identity_access/domain/user_session.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/repositories/sales_order_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/sales_order.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/auth/errors/auth_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';

/// Caso de Uso responsável por recuperar o histórico de compras de uma empresa (RF18).
class GetPurchaseHistoryUseCase {
  final SalesOrderRepository _orderRepository;

  GetPurchaseHistoryUseCase(this._orderRepository);

  /// Executa a consulta do histórico de compras com validação de segurança.
  Future<Result<List<SalesOrder>, AuthError>> execute(
    CompanyId companyId,
    UserSession currentSession,
  ) async {
    // Regra de Autorização: Comprador só pode ver histórico da sua própria empresa.
    if (currentSession.isBuyer && currentSession.companyId != companyId) {
      return Failure(UnauthorizedError('You can only access purchase history for your own company.'));
    }

    // Nota: Representantes e Financeiro podem ter outras regras, 
    // mas para o MVP focamos na restrição do Comprador Autorizado.

    final orders = await _orderRepository.findByCompanyId(companyId);
    return Success(orders);
  }
}
