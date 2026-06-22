import 'package:ecommerce_b2b/modules/inventory/domain/aggregates/warehouse/warehouse.dart';
import 'package:ecommerce_b2b/modules/inventory/domain/services/inventory_allocator_domain_service.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/sales_order/finance_review.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/sales_order/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/finance_decision.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/services/order_state_machine_domain_service.dart';

/// Caso de Uso responsável por processar a análise manual do departamento financeiro (RF12).
class ProcessFinanceReviewUseCase {
  final OrderStateMachineDomainService _stateMachine;
  final InventoryAllocatorDomainService _inventoryAllocator;

  ProcessFinanceReviewUseCase(this._stateMachine, this._inventoryAllocator);

  /// Aplica a decisão financeira ao pedido bloqueado.
  void execute({
    required SalesOrder order,
    required FinanceReview review,
    required List<Warehouse> warehouses,
  }) {
    if (order.status != OrderStatus.blockedByFinance) {
      throw StateError('Apenas pedidos bloqueados podem passar por análise financeira.');
    }

    order.applyFinanceReview(review);

    if (review.decision == FinanceDecision.approved) {
      // Se aprovado manualmente, avança para Picking/Packing (RN11).
      _stateMachine.transitionTo(order, OrderStatus.pickingPacking);
      
      // Tenta alocar estoque agora que foi aprovado.
      for (final item in order.items) {
        _inventoryAllocator.allocateStock(warehouses, order.id, item.productId, item.quantity);
      }
    } else {
      // Se reprovado, o pedido pode ser cancelado ou mantido como bloqueado (aqui vamos cancelar).
      _stateMachine.transitionTo(order, OrderStatus.cancelled);
    }
  }
}
