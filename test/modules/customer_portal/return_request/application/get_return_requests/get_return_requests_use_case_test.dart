import 'package:ecommerce_b2b/modules/customer_portal/return_request/application/get_return_requests/get_return_requests_use_case.dart';
import 'package:ecommerce_b2b/modules/customer_portal/return_request/domain/return_request.dart';
import 'package:ecommerce_b2b/modules/customer_portal/return_request/domain/repositories/return_request_repository.dart';
import 'package:ecommerce_b2b/modules/identity_access/domain/user_session.dart';
import 'package:ecommerce_b2b/modules/identity_access/domain/enums/user_role.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/repositories/sales_order_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/rma_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/user_id.dart';
import 'package:ecommerce_b2b/modules/customer_portal/return_request/domain/enums/rma_status.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/auth/errors/auth_errors.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockReturnRequestRepository extends Mock implements ReturnRequestRepository {}
class MockSalesOrderRepository extends Mock implements SalesOrderRepository {}

class CompanyIdFake extends Fake implements CompanyId {}

void main() {
  setUpAll(() {
    registerFallbackValue(CompanyIdFake());
  });

  group('GetReturnRequestsUseCase', () {
    late MockReturnRequestRepository rmaRepo;
    late MockSalesOrderRepository orderRepo;
    late GetReturnRequestsUseCase useCase;

    final companyId = const CompanyId('c1');

    final buyerSession = UserSession(
      userId: const UserId('buyer1'),
      role: UserRole.buyer,
      companyId: const CompanyId('c1'),
    );

    final otherBuyerSession = UserSession(
      userId: const UserId('buyer2'),
      role: UserRole.buyer,
      companyId: const CompanyId('c2'),
    );

    setUp(() {
      rmaRepo = MockReturnRequestRepository();
      orderRepo = MockSalesOrderRepository();
      useCase = GetReturnRequestsUseCase(rmaRepo, orderRepo);
    });

    test('should allow access and return filtered RMAs for the buyer own company', () async {
      final order1 = SalesOrder(
        id: const OrderId('o1'),
        companyId: 'c1',
        status: OrderStatus.delivered,
        creditStatus: CreditStatus.approved,
        items: [],
      );

      final rma1 = ReturnRequest(
        id: const RmaId('r1'),
        orderId: 'o1',
        status: RmaStatus.pending,
        reason: 'Defeito',
      );

      final rma2 = ReturnRequest(
        id: const RmaId('r2'),
        orderId: 'o2', // Pedido de outra empresa
        status: RmaStatus.pending,
        reason: 'Defeito',
      );

      when(() => orderRepo.findByCompanyId(companyId)).thenAnswer((_) async => [order1]);
      when(() => rmaRepo.getAll()).thenAnswer((_) async => [rma1, rma2]);

      final result = await useCase.execute(companyId, buyerSession);

      expect(result.isSuccess, isTrue);
      final rmas = result.getOrThrow();
      expect(rmas.length, 1);
      expect(rmas.first.id.value, 'r1');
    });

    test('should block access if a buyer tries to view RMAs of another company', () async {
      final result = await useCase.execute(companyId, otherBuyerSession);

      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<UnauthorizedError>());
      verifyNever(() => orderRepo.findByCompanyId(any()));
      verifyNever(() => rmaRepo.getAll());
    });
  });
}
