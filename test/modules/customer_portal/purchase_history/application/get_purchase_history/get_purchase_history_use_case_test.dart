import 'package:ecommerce_b2b/modules/customer_portal/purchase_history/application/get_purchase_history/get_purchase_history_use_case.dart';
import 'package:ecommerce_b2b/modules/identity_access/domain/enums/user_role.dart';
import 'package:ecommerce_b2b/modules/identity_access/domain/user_session.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/repositories/sales_order_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/auth/errors/auth_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/user_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSalesOrderRepository extends Mock implements SalesOrderRepository {}

class CompanyIdFake extends Fake implements CompanyId {}

void main() {
  late MockSalesOrderRepository orderRepository;
  late GetPurchaseHistoryUseCase useCase;

  setUpAll(() {
    registerFallbackValue(CompanyIdFake());
  });

  setUp(() {
    orderRepository = MockSalesOrderRepository();
    useCase = GetPurchaseHistoryUseCase(orderRepository);
  });

  group('GetPurchaseHistoryUseCase', () {
    final companyId = const CompanyId('my-company');
    final otherCompanyId = const CompanyId('other-company');

    // Deve permitir o acesso se o comprador pertencer à empresa
    test('should allow access if buyer belongs to the company', () async {
      final session = UserSession(
        userId: const UserId('user-1'),
        role: UserRole.buyer,
        companyId: companyId,
      );

      when(() => orderRepository.findByCompanyId(companyId))
          .thenAnswer((_) async => []);

      final result = await useCase.execute(companyId, session);

      expect(result.isSuccess, isTrue);
      verify(() => orderRepository.findByCompanyId(companyId)).called(1);
    });

    // Deve negar o acesso se o comprador pertencer a uma empresa diferente
    test('should deny access if buyer belongs to different company', () async {
      final session = UserSession(
        userId: const UserId('user-1'),
        role: UserRole.buyer,
        companyId: otherCompanyId,
      );

      final result = await useCase.execute(companyId, session);

      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<UnauthorizedError>());
      verifyNever(() => orderRepository.findByCompanyId(any()));
    });

    // Deve permitir o acesso para funções financeiras independentemente da empresa
    test('should allow access for finance role regardless of company', () async {
      final session = UserSession(
        userId: const UserId('user-1'),
        role: UserRole.finance,
      );

      when(() => orderRepository.findByCompanyId(companyId))
          .thenAnswer((_) async => []);

      final result = await useCase.execute(companyId, session);

      expect(result.isSuccess, isTrue);
    });
  });
}
