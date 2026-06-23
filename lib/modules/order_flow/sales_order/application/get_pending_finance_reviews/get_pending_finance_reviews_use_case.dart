import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/repositories/sales_order_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/sales_order.dart';

class GetPendingFinanceReviewsUseCase {
  final SalesOrderRepository _orderRepository;

  GetPendingFinanceReviewsUseCase(this._orderRepository);

  Future<List<SalesOrder>> execute() async {
    // Busca tanto pedidos pendentes de aprovação quanto bloqueados que requerem ação manual (RF12).
    final pending = await _orderRepository.findByStatus(OrderStatus.pendingFinanceApproval);
    final blocked = await _orderRepository.findByStatus(OrderStatus.blockedByFinance);
    
    return [...pending, ...blocked];
  }
}
