import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/sales_order/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/services/order_state_machine_domain_service.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late OrderStateMachineDomainService stateMachine;

  setUp(() {
    stateMachine = OrderStateMachineDomainService();
  });

  SalesOrder createOrder(OrderStatus status) {
    return SalesOrder(
      id: const OrderId('order-1'),
      status: status,
      creditStatus: CreditStatus.pending,
      items: [],
    );
  }

  group('OrderStateMachine', () {
    test('deve permitir transição de pendente para bloqueado', () {
      final order = createOrder(OrderStatus.pendingFinanceApproval);
      stateMachine.transitionTo(order, OrderStatus.blockedByFinance);
      expect(order.status, OrderStatus.blockedByFinance);
    });

    test('deve permitir transição de bloqueado para separação', () {
      final order = createOrder(OrderStatus.blockedByFinance);
      stateMachine.transitionTo(order, OrderStatus.pickingPacking);
      expect(order.status, OrderStatus.pickingPacking);
    });

    test('deve lançar erro em transição inválida', () {
      final order = createOrder(OrderStatus.pendingFinanceApproval);
      expect(
        () => stateMachine.transitionTo(order, OrderStatus.delivered),
        throwsStateError,
      );
    });

    test('deve permitir fluxo completo BR11', () {
      final order = createOrder(OrderStatus.pendingFinanceApproval);
      
      stateMachine.transitionTo(order, OrderStatus.pickingPacking);
      expect(order.status, OrderStatus.pickingPacking);
      
      stateMachine.transitionTo(order, OrderStatus.inTransit);
      expect(order.status, OrderStatus.inTransit);
      
      stateMachine.transitionTo(order, OrderStatus.delivered);
      expect(order.status, OrderStatus.delivered);
      
      stateMachine.transitionTo(order, OrderStatus.rma);
      expect(order.status, OrderStatus.rma);
    });
  });
}
