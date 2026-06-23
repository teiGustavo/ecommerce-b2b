import 'package:ecommerce_b2b/modules/inventory/warehouse/domain/stock_item.dart';
import 'package:ecommerce_b2b/modules/inventory/warehouse/domain/warehouse.dart';
import 'package:ecommerce_b2b/modules/inventory/warehouse/domain/services/inventory_allocator_domain_service.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/application/process_finance_review/process_finance_review_use_case.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/finance_review.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/order_item.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/enums/finance_decision.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/services/order_state_machine_domain_service.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/warehouse_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';
import 'package:flutter_test/flutter_test.dart';

class MockOrderStateMachine extends OrderStateMachineDomainService {
  @override
  void transitionTo(SalesOrder order, OrderStatus newStatus) {
    order.updateStatus(newStatus);
  }
}

class MockInventoryAllocator extends InventoryAllocatorDomainService {
  bool allocateCalled = false;
  @override
  void allocateStock(List<Warehouse> warehouses, OrderId orderId, ProductId productId, Quantity requestedQuantity) {
    allocateCalled = true;
  }
}

void main() {
  group('ProcessFinanceReviewUseCase', () {
    late SalesOrder order;
    late Warehouse warehouse;

    setUp(() {
      order = SalesOrder(
        id: const OrderId('o1'),
        status: OrderStatus.blockedByFinance,
        creditStatus: CreditStatus.blocked,
        items: [
          OrderItem(productId: const ProductId('p1'), quantity: Quantity.create(1).getOrThrow(), unitPriceSnapshot: Money.create(100).getOrThrow())
        ],
      );

      warehouse = Warehouse(id: const WarehouseId('w1'), code: 'W1', name: 'N1', stockItems: [
        StockItem(productId: const ProductId('p1'), physicalQuantity: Quantity.create(10).getOrThrow())
      ]);
    });

    /// deve aprovar pedido, transicionar status e alocar estoque
    test('should approve order, transition status and allocate stock', () {
      final stateMachine = MockOrderStateMachine();
      final inventoryAllocator = MockInventoryAllocator();
      final useCase = ProcessFinanceReviewUseCase(stateMachine, inventoryAllocator);
      final review = FinanceReview(
        decision: FinanceDecision.approved,
        reviewerId: 'admin',
        reviewedAt: DateTime.now(),
        justification: 'OK',
      );

      useCase.execute(order: order, review: review, warehouses: [warehouse]);

      expect(order.status, OrderStatus.pickingPacking);
      expect(order.financeReview, review);
      expect(inventoryAllocator.allocateCalled, isTrue);
    });

    /// deve cancelar pedido se reprovado pelo financeiro
    test('should cancel order if rejected by finance', () {
      final stateMachine = MockOrderStateMachine();
      final inventoryAllocator = MockInventoryAllocator();
      final useCase = ProcessFinanceReviewUseCase(stateMachine, inventoryAllocator);
      final review = FinanceReview(
        decision: FinanceDecision.rejected,
        reviewerId: 'admin',
        reviewedAt: DateTime.now(),
        justification: 'No credit',
      );

      useCase.execute(order: order, review: review, warehouses: [warehouse]);

      expect(order.status, OrderStatus.cancelled);
      expect(inventoryAllocator.allocateCalled, isFalse);
    });

    /// deve lançar erro se pedido não estiver bloqueado
    test('should throw error if order is not blocked', () {
      final stateMachine = MockOrderStateMachine();
      final inventoryAllocator = MockInventoryAllocator();
      final useCase = ProcessFinanceReviewUseCase(stateMachine, inventoryAllocator);
      final review = FinanceReview(
        decision: FinanceDecision.approved,
        reviewerId: 'admin',
        reviewedAt: DateTime.now(),
        justification: 'OK',
      );

      order.updateStatus(OrderStatus.pendingFinanceApproval);

      expect(() => useCase.execute(order: order, review: review, warehouses: [warehouse]), throwsStateError);
    });
  });
}
