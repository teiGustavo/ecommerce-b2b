import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/services/order_state_machine_domain_service.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late OrderStateMachineDomainService stateMachine;

  setUp(() {
    stateMachine = OrderStateMachineDomainService();
  });

  /// Auxiliar para criar um pedido para testes.
  SalesOrder createOrder(OrderStatus status) {
    return SalesOrder(
      id: const OrderId('order-1'),
      status: status,
      creditStatus: CreditStatus.pending,
      items: [],
    );
  }

  group('OrderStateMachine', () {
    /// deve permitir transição de pendente para bloqueado
    test('should allow transition from pending to blocked', () {
      final order = createOrder(OrderStatus.pendingFinanceApproval);
      stateMachine.transitionTo(order, OrderStatus.blockedByFinance);
      expect(order.status, OrderStatus.blockedByFinance);
    });

    /// deve permitir transição de bloqueado para separação
    test('should allow transition from blocked to picking/packing', () {
      final order = createOrder(OrderStatus.blockedByFinance);
      stateMachine.transitionTo(order, OrderStatus.pickingPacking);
      expect(order.status, OrderStatus.pickingPacking);
    });

    /// deve lançar erro em transição inválida
    test('should throw error on invalid transition', () {
      final order = createOrder(OrderStatus.pendingFinanceApproval);
      expect(
        () => stateMachine.transitionTo(order, OrderStatus.delivered),
        throwsStateError,
      );
    });

    /// deve permitir fluxo completo RN11
    test('should allow full workflow RN11', () {
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
