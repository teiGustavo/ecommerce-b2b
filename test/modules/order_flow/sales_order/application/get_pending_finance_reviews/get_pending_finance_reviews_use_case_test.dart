import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/application/get_pending_finance_reviews/get_pending_finance_reviews_use_case.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/repositories/sales_order_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSalesOrderRepository extends Mock implements SalesOrderRepository {}

void main() {
  group('GetPendingFinanceReviewsUseCase', () {
    late MockSalesOrderRepository orderRepository;
    late GetPendingFinanceReviewsUseCase useCase;

    setUp(() {
      orderRepository = MockSalesOrderRepository();
      useCase = GetPendingFinanceReviewsUseCase(orderRepository);
    });

    test('should fetch pending approval and blocked orders and return combined list', () async {
      final pendingOrder = SalesOrder(
        id: const OrderId('o1'),
        status: OrderStatus.pendingFinanceApproval,
        creditStatus: CreditStatus.pending,
        items: [],
      );

      final blockedOrder = SalesOrder(
        id: const OrderId('o2'),
        status: OrderStatus.blockedByFinance,
        creditStatus: CreditStatus.blocked,
        items: [],
      );

      when(() => orderRepository.findByStatus(OrderStatus.pendingFinanceApproval.name))
          .thenAnswer((_) async => [pendingOrder]);
      when(() => orderRepository.findByStatus(OrderStatus.blockedByFinance.name))
          .thenAnswer((_) async => [blockedOrder]);

      final result = await useCase.execute();

      expect(result.length, 2);
      expect(result, containsAll([pendingOrder, blockedOrder]));

      verify(() => orderRepository.findByStatus(OrderStatus.pendingFinanceApproval.name)).called(1);
      verify(() => orderRepository.findByStatus(OrderStatus.blockedByFinance.name)).called(1);
    });
  });
}
