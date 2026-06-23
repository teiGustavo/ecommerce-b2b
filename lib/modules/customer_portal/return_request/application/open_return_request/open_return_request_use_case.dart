import 'package:ecommerce_b2b/modules/customer_portal/return_request/domain/return_request.dart';
import 'package:ecommerce_b2b/modules/customer_portal/return_request/domain/return_request_item.dart';
import 'package:ecommerce_b2b/modules/customer_portal/return_request/domain/enums/rma_status.dart';
import 'package:ecommerce_b2b/modules/customer_portal/return_request/domain/repositories/return_request_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/repositories/sales_order_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/services/order_state_machine_domain_service.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/rma_id.dart';

/// Caso de Uso responsável por abrir uma solicitação de troca ou devolução (RMA) (RF20).
class OpenReturnRequestUseCase {
  final OrderStateMachineDomainService _stateMachine;
  final ReturnRequestRepository _returnRequestRepository;
  final SalesOrderRepository _orderRepository;

  OpenReturnRequestUseCase(
    this._stateMachine,
    this._returnRequestRepository,
    this._orderRepository,
  );

  /// Abre um RMA para um pedido entregue.
  Future<ReturnRequest> execute({
    required RmaId rmaId,
    required SalesOrder order,
    required String reason,
    required List<ReturnRequestItem> items,
  }) async {
    if (order.status != OrderStatus.delivered) {
      throw StateError('Só é possível abrir RMA para pedidos que já foram entregues.');
    }

    final rma = ReturnRequest(
      id: rmaId,
      orderId: order.id.value,
      status: RmaStatus.pending,
      reason: reason,
      items: items,
    );

    // Atualiza o estado do pedido para RMA (RN11)
    _stateMachine.transitionTo(order, OrderStatus.rma);

    await _returnRequestRepository.save(rma);
    await _orderRepository.save(order);

    return rma;
  }
}
