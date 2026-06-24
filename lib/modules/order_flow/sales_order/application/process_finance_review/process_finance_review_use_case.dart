import 'package:ecommerce_b2b/modules/inventory/warehouse/domain/warehouse.dart';
import 'package:ecommerce_b2b/modules/inventory/warehouse/domain/services/inventory_allocator_domain_service.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/finance_review.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/enums/finance_decision.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/services/order_state_machine_domain_service.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/repositories/sales_order_repository.dart';

/// Caso de Uso responsável por processar a análise manual do departamento financeiro (RF12).
class ProcessFinanceReviewUseCase {
  final OrderStateMachineDomainService _stateMachine;
  final InventoryAllocatorDomainService _inventoryAllocator;
  final SalesOrderRepository _orderRepository;

  ProcessFinanceReviewUseCase(
    this._stateMachine,
    this._inventoryAllocator,
    this._orderRepository,
  );

  /// Aplica a decisão financeira ao pedido bloqueado e persiste no banco.
  Future<void> execute({
    required SalesOrder order,
    required FinanceReview review,
    required List<Warehouse> warehouses,
  }) async {
    if (order.status != OrderStatus.blockedByFinance &&
        order.status != OrderStatus.pendingFinanceApproval) {
      throw StateError(
          'Apenas pedidos em análise ou bloqueados podem passar por análise financeira.');
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

    await _orderRepository.save(order);
  }
}
