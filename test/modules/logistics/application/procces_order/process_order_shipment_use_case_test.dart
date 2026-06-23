import 'package:ecommerce_b2b/modules/logistics/application/procces_order/process_order_shipment_use_case.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/shipment.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/repositories/shipment_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/repositories/sales_order_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/services/order_state_machine_domain_service.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/packing_session_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/picking_list_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/shipment_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/logistics/value_objects/tracking_code.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOrderStateMachine extends OrderStateMachineDomainService {
  @override
  void transitionTo(SalesOrder order, OrderStatus newStatus) {
    order.updateStatus(newStatus);
  }
}

class MockShipmentRepository extends Mock implements ShipmentRepository {}
class MockSalesOrderRepository extends Mock implements SalesOrderRepository {}

class ShipmentFake extends Fake implements Shipment {}
class SalesOrderFake extends Fake implements SalesOrder {}

void main() {
  setUpAll(() {
    registerFallbackValue(ShipmentFake());
    registerFallbackValue(SalesOrderFake());
  });

  group('ProcessOrderShipmentUseCase', () {
    late MockShipmentRepository shipmentRepo;
    late MockSalesOrderRepository orderRepo;
    late MockOrderStateMachine stateMachine;
    late ProcessOrderShipmentUseCase useCase;

    setUp(() {
      shipmentRepo = MockShipmentRepository();
      orderRepo = MockSalesOrderRepository();
      stateMachine = MockOrderStateMachine();
      useCase = ProcessOrderShipmentUseCase(stateMachine, shipmentRepo, orderRepo);

      when(() => shipmentRepo.save(any())).thenAnswer((_) async {});
      when(() => orderRepo.save(any())).thenAnswer((_) async {});
    });

    test('should process shipment successfully and transition order status', () async {
      final order = SalesOrder(
        id: const OrderId('o1'),
        status: OrderStatus.pickingPacking,
        creditStatus: CreditStatus.approved,
        items: [],
      );

      final result = await useCase.execute(
        order: order,
        pickingId: const PickingListId('pick-1'),
        packingId: const PackingSessionId('pack-1'),
        shipmentId: const ShipmentId('ship-1'),
        trackingCode: TrackingCode.create('TRK123').getOrThrow(),
        labelNumber: 'LBL-001',
      );

      expect(order.status, OrderStatus.inTransit);
      expect(result.picking.id, const PickingListId('pick-1'));
      expect(result.packing.id, const PackingSessionId('pack-1'));
      expect(result.shipment.id, const ShipmentId('ship-1'));
      expect(result.shipment.trackingCode.value, 'TRK123');
      expect(result.shipment.shippingLabel.labelNumber, 'LBL-001');

      verify(() => shipmentRepo.save(any())).called(1);
      verify(() => orderRepo.save(order)).called(1);
    });

    test('should throw error if order is not in pickingPacking', () async {
      final order = SalesOrder(
        id: const OrderId('o1'),
        status: OrderStatus.pendingFinanceApproval,
        creditStatus: CreditStatus.approved,
        items: [],
      );

      expect(
        () => useCase.execute(
          order: order,
          pickingId: const PickingListId('pick-1'),
          packingId: const PackingSessionId('pack-1'),
          shipmentId: const ShipmentId('ship-1'),
          trackingCode: TrackingCode.create('TRK123').getOrThrow(),
          labelNumber: 'LBL-001',
        ),
        throwsStateError,
      );

      verifyNever(() => shipmentRepo.save(any()));
      verifyNever(() => orderRepo.save(any()));
    });
  });
}
