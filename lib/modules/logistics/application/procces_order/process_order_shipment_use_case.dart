import 'package:ecommerce_b2b/modules/logistics/packing/packing_session.dart';
import 'package:ecommerce_b2b/modules/logistics/picking/picking_list.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/shipment.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/shipping_label.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/enums/shipment_status.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/repositories/shipment_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/repositories/sales_order_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/services/order_state_machine_domain_service.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/packing_session_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/picking_list_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/shipment_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/warehouse_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/logistics/value_objects/tracking_code.dart';

/// Caso de Uso responsável por orquestrar a expedição: Picking -> Packing -> Shipment (RF13, RF14, RF15).
class ProcessOrderShipmentUseCase {
  final OrderStateMachineDomainService _stateMachine;
  final ShipmentRepository _shipmentRepository;
  final SalesOrderRepository _orderRepository;

  ProcessOrderShipmentUseCase(
    this._stateMachine,
    this._shipmentRepository,
    this._orderRepository,
  );

  /// Executa o fluxo de expedição do pedido.
  Future<({PickingList picking, PackingSession packing, Shipment shipment})> execute({
    required SalesOrder order,
    required PickingListId pickingId,
    required PackingSessionId packingId,
    required ShipmentId shipmentId,
    required TrackingCode trackingCode,
    required String labelNumber,
    WarehouseId? warehouseId, // Tornar opcional ou remover se for multi-depósito
  }) async {
    if (order.status != OrderStatus.pickingPacking) {
      throw StateError('O pedido deve estar em separação/embalagem para ser enviado.');
    }

    // 1. Gera Lista de Separação (Picking) - RF13
    final picking = PickingList(
      id: pickingId,
      orderId: order.id,
      warehouseId: warehouseId ?? const WarehouseId('unknown'),
    );

    // 2. Inicia Sessão de Embalagem (Packing) - RF14
    final packing = PackingSession(id: packingId);

    // 3. Emite Etiqueta e Cria Remessa (Shipment) - RF15
    final shipment = Shipment(
      id: shipmentId,
      orderId: order.id.value,
      trackingCode: trackingCode,
      status: ShipmentStatus.shipped, // Alterado para shipped para refletir o despacho
      shippingLabel: ShippingLabel(labelNumber),
    );

    // 4. Atualiza estado do pedido para "Em Transporte" (RN11)
    _stateMachine.transitionTo(order, OrderStatus.inTransit);

    await _shipmentRepository.save(shipment);
    await _orderRepository.save(order);

    return (picking: picking, packing: packing, shipment: shipment);
  }
}
