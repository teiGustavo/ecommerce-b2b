import 'package:ecommerce_b2b/modules/logistics/application/procces_order/process_order_shipment_use_case.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/sales_order/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/services/order_state_machine_domain_service.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/buyer_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/representative_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/packing_session_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/picking_list_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/shipment_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/logistics/value_objects/tracking_code.dart';
import 'package:flutter_test/flutter_test.dart';

class MockOrderStateMachine extends OrderStateMachineDomainService {
  @override
  void transitionTo(SalesOrder order, OrderStatus newStatus) {
    order.updateStatus(newStatus);
  }
}

void main() {
  group('ProcessOrderShipmentUseCase', () {
    /// deve processar expedição com sucesso e transicionar status do pedido
    test('should process shipment successfully and transition order status', () {
      final stateMachine = MockOrderStateMachine();
      final useCase = ProcessOrderShipmentUseCase(stateMachine);
      final order = SalesOrder(
        id: const OrderId('ORD_1'),
        status: OrderStatus.pickingPacking,
        companyId: const CompanyId('COMP_1'),
        buyerId: const BuyerId('BUYER_1'),
        representativeId: const RepresentativeId('REP_1'),
        createdAt: DateTime.now(),
        creditStatus: CreditStatus.approved,
        items: [],
      );

      final result = useCase.execute(
        order: order,
        pickingId: const PickingListId('pick-1'),
        packingId: const PackingSessionId('pack-1'),
        shipmentId: const ShipmentId('ship-1'),
        trackingCode: const TrackingCode('TRK123'),
        labelNumber: 'LBL-001',
      );

      expect(order.status, OrderStatus.inTransit);
      expect(result.picking.id, const PickingListId('pick-1'));
      expect(result.packing.id, const PackingSessionId('pack-1'));
      expect(result.shipment.id, const ShipmentId('ship-1'));
      expect(result.shipment.trackingCode.value, 'TRK123');
      expect(result.shipment.shippingLabel.labelNumber, 'LBL-001');
    });

    /// deve lançar erro se pedido não estiver em pickingPacking
    test('should throw error if order is not in pickingPacking', () {
      final stateMachine = MockOrderStateMachine();
      final useCase = ProcessOrderShipmentUseCase(stateMachine);
      final order = SalesOrder(
        id: const OrderId('o1'),
        status: OrderStatus.pendingFinanceApproval,
        companyId: const CompanyId('COMP_1'),
        buyerId: const BuyerId('BUYER_1'),
        representativeId: const RepresentativeId('REP_1'),
        createdAt: DateTime.now(),
        creditStatus: CreditStatus.approved,
        items: [],
      );

      expect(
        () => useCase.execute(
          order: order,
          pickingId: const PickingListId('pick-1'),
          packingId: const PackingSessionId('pack-1'),
          shipmentId: const ShipmentId('ship-1'),
          trackingCode: const TrackingCode('TRK123'),
          labelNumber: 'LBL-001',
        ),
        throwsStateError,
      );
    });
  });
}
