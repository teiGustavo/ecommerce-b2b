import 'package:ecommerce_b2b/modules/customer_portal/return_request/application/open_return_request/open_return_request_use_case.dart';
import 'package:ecommerce_b2b/modules/customer_portal/return_request/domain/enums/rma_status.dart';
import 'package:ecommerce_b2b/modules/customer_portal/return_request/domain/return_request_item.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/services/order_state_machine_domain_service.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/rma_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';
import 'package:flutter_test/flutter_test.dart';

class MockOrderStateMachine extends OrderStateMachineDomainService {
  @override
  void transitionTo(SalesOrder order, OrderStatus newStatus) {
    order.updateStatus(newStatus);
  }
}

void main() {
  group('OpenReturnRequestUseCase', () {
    /// deve abrir RMA com sucesso para pedido entregue
    test('should open RMA successfully for delivered order', () {
      final stateMachine = MockOrderStateMachine();
      final useCase = OpenReturnRequestUseCase(stateMachine);
      final order = SalesOrder(
        id: const OrderId('o1'),
        status: OrderStatus.delivered,
        creditStatus: CreditStatus.approved,
        items: [],
      );

      final rma = useCase.execute(
        rmaId: const RmaId('rma-1'),
        order: order,
        reason: 'Defeito',
        items: [
          ReturnRequestItem(
            productId: const ProductId('p1'),
            quantity: Quantity.create(1).getOrThrow(),
            problemDescription: 'Não liga',
          ),
        ],
      );

      expect(rma.status, RmaStatus.pending);
      expect(order.status, OrderStatus.rma);
      expect(rma.items.length, 1);
    });

    /// deve lançar erro se pedido não estiver entregue
    test('should throw error if order is not delivered', () {
      final stateMachine = MockOrderStateMachine();
      final useCase = OpenReturnRequestUseCase(stateMachine);
      final order = SalesOrder(
        id: const OrderId('o1'),
        status: OrderStatus.inTransit,
        creditStatus: CreditStatus.approved,
        items: [],
      );

      expect(
        () => useCase.execute(
          rmaId: const RmaId('rma-1'),
          order: order,
          reason: 'Defeito',
          items: [],
        ),
        throwsStateError,
      );
    });
  });
}
