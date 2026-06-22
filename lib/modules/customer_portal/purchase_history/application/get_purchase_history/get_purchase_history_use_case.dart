import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/repositories/sales_order_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/sales_order.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';

/// Caso de Uso responsável por recuperar o histórico de compras de uma empresa (RF18).
class GetPurchaseHistoryUseCase {
  final SalesOrderRepository _orderRepository;

  GetPurchaseHistoryUseCase(this._orderRepository);

  /// Executa a consulta do histórico de compras.
  Future<List<SalesOrder>> execute(CompanyId companyId) async {
    return await _orderRepository.findByCompanyId(companyId);
  }
}
