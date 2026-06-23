import 'package:ecommerce_b2b/modules/customer_portal/return_request/application/open_return_request/open_return_request_use_case.dart';
import 'package:ecommerce_b2b/modules/customer_portal/return_request/domain/enums/rma_status.dart';
import 'package:ecommerce_b2b/modules/customer_portal/return_request/domain/return_request_item.dart';
import 'package:ecommerce_b2b/modules/customer_portal/return_request/domain/return_request.dart';
import 'package:ecommerce_b2b/modules/customer_portal/return_request/domain/repositories/return_request_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/repositories/sales_order_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/services/order_state_machine_domain_service.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/rma_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOrderStateMachine extends OrderStateMachineDomainService {
  @override
  void transitionTo(SalesOrder order, OrderStatus newStatus) {
    order.updateStatus(newStatus);
  }
}

class MockReturnRequestRepository extends Mock implements ReturnRequestRepository {}
class MockSalesOrderRepository extends Mock implements SalesOrderRepository {}

class ReturnRequestFake extends Fake implements ReturnRequest {}
class SalesOrderFake extends Fake implements SalesOrder {}

void main() {
  setUpAll(() {
    registerFallbackValue(ReturnRequestFake());
    registerFallbackValue(SalesOrderFake());
  });

  group('OpenReturnRequestUseCase', () {
    late MockReturnRequestRepository rmaRepo;
    late MockSalesOrderRepository orderRepo;
    late MockOrderStateMachine stateMachine;
    late OpenReturnRequestUseCase useCase;

    setUp(() {
      rmaRepo = MockReturnRequestRepository();
      orderRepo = MockSalesOrderRepository();
      stateMachine = MockOrderStateMachine();
      useCase = OpenReturnRequestUseCase(stateMachine, rmaRepo, orderRepo);

      when(() => rmaRepo.save(any())).thenAnswer((_) async {});
      when(() => orderRepo.save(any())).thenAnswer((_) async {});
    });

    test('should open RMA successfully for delivered order and save to repos', () async {
      final order = SalesOrder(
        id: const OrderId('o1'),
        status: OrderStatus.delivered,
        creditStatus: CreditStatus.approved,
        items: [],
      );

      final rma = await useCase.execute(
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

      verify(() => rmaRepo.save(any())).called(1);
      verify(() => orderRepo.save(order)).called(1);
    });

    test('should throw error if order is not delivered', () async {
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

      verifyNever(() => rmaRepo.save(any()));
      verifyNever(() => orderRepo.save(any()));
    });
  });
}
