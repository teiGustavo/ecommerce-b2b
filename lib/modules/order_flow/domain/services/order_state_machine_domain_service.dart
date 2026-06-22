import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/sales_order/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';

/// Serviço de Domínio responsável por gerenciar a máquina de estados linear do pedido (RN11).
class OrderStateMachineDomainService {
  /// Transiciona o pedido para o próximo estado válido.
  /// Segue o fluxo: Aguardando Aprovação -> (Bloqueado) -> Em Embalagem -> Em Transporte -> Entregue -> RMA.
  void transitionTo(SalesOrder order, OrderStatus newStatus) {
    if (!_canTransition(order.status, newStatus)) {
      throw StateError(
        'Transição inválida de ${order.status.name} para ${newStatus.name}.',
      );
    }
    order.updateStatus(newStatus);
  }

  bool _canTransition(OrderStatus current, OrderStatus next) {
    if (next == OrderStatus.cancelled) return true; // Cancelamento permitido de quase qualquer estado (simplificação).

    switch (current) {
      case OrderStatus.pendingFinanceApproval:
        return next == OrderStatus.blockedByFinance || next == OrderStatus.pickingPacking;
      
      case OrderStatus.blockedByFinance:
        return next == OrderStatus.pickingPacking;

      case OrderStatus.pickingPacking:
        return next == OrderStatus.inTransit;

      case OrderStatus.inTransit:
        return next == OrderStatus.delivered;

      case OrderStatus.delivered:
        return next == OrderStatus.rma;

      case OrderStatus.rma:
        return false; // RMA é estado terminal ou requer fluxo específico.

      case OrderStatus.cancelled:
        return false;
    }
  }
}
