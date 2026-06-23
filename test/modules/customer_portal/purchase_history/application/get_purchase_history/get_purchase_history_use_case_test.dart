import 'package:ecommerce_b2b/modules/customer_portal/purchase_history/application/get_purchase_history/get_purchase_history_use_case.dart';
import 'package:ecommerce_b2b/modules/identity_access/domain/enums/user_role.dart';
import 'package:ecommerce_b2b/modules/identity_access/domain/user_session.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/repositories/sales_order_repository.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/repositories/sales_representative_repository.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/services/sales_hierarchy_domain_service.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/sales_representative.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/customer_assignment.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/auth/errors/auth_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/user_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/representative_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/email_address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/percentage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSalesOrderRepository extends Mock implements SalesOrderRepository {}
class MockSalesRepresentativeRepository extends Mock implements SalesRepresentativeRepository {}

class CompanyIdFake extends Fake implements CompanyId {}

void main() {
  late MockSalesOrderRepository orderRepository;
  late MockSalesRepresentativeRepository representativeRepository;
  late SalesHierarchyDomainService hierarchyService;
  late GetPurchaseHistoryUseCase useCase;

  setUpAll(() {
    registerFallbackValue(CompanyIdFake());
  });

  setUp(() {
    orderRepository = MockSalesOrderRepository();
    representativeRepository = MockSalesRepresentativeRepository();
    hierarchyService = SalesHierarchyDomainService();
    useCase = GetPurchaseHistoryUseCase(orderRepository, representativeRepository, hierarchyService);
  });

  group('GetPurchaseHistoryUseCase', () {
    final companyId = const CompanyId('my-company');
    final otherCompanyId = const CompanyId('other-company');

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

    test('should allow access for representative if company is directly assigned', () async {
      final session = UserSession(
        userId: const UserId('rep-1'),
        role: UserRole.representative,
      );

      final rep = SalesRepresentative(
        id: const RepresentativeId('rep-1'),
        fullName: 'Jane Rep',
        email: EmailAddress.create('rep@company.com').getOrThrow(),
        commissionRate: Percentage.create(5).getOrThrow(),
        assignments: [CustomerAssignment(companyId)],
      );

      when(() => representativeRepository.findById(const RepresentativeId('rep-1')))
          .thenAnswer((_) async => rep);
      when(() => orderRepository.findByCompanyId(companyId))
          .thenAnswer((_) async => []);

      final result = await useCase.execute(companyId, session);

      expect(result.isSuccess, isTrue);
      verify(() => orderRepository.findByCompanyId(companyId)).called(1);
    });

    test('should allow access for supervisor if company is assigned to a subordinate', () async {
      final session = UserSession(
        userId: const UserId('supervisor-1'),
        role: UserRole.representative,
      );

      final supervisor = SalesRepresentative(
        id: const RepresentativeId('supervisor-1'),
        fullName: 'John Boss',
        email: EmailAddress.create('boss@company.com').getOrThrow(),
        commissionRate: Percentage.create(5).getOrThrow(),
        assignments: [],
      );
      supervisor.addSubordinate(const RepresentativeId('rep-1'));

      final subordinate = SalesRepresentative(
        id: const RepresentativeId('rep-1'),
        fullName: 'Jane Rep',
        email: EmailAddress.create('rep@company.com').getOrThrow(),
        commissionRate: Percentage.create(5).getOrThrow(),
        assignments: [CustomerAssignment(companyId)],
      );

      when(() => representativeRepository.findById(const RepresentativeId('supervisor-1')))
          .thenAnswer((_) async => supervisor);
      when(() => representativeRepository.findAll())
          .thenAnswer((_) async => [supervisor, subordinate]);
      when(() => orderRepository.findByCompanyId(companyId))
          .thenAnswer((_) async => []);

      final result = await useCase.execute(companyId, session);

      expect(result.isSuccess, isTrue);
      verify(() => orderRepository.findByCompanyId(companyId)).called(1);
    });

    test('should deny access for representative if company is not in portfolio or subordinate portfolio', () async {
      final session = UserSession(
        userId: const UserId('rep-1'),
        role: UserRole.representative,
      );

      final rep = SalesRepresentative(
        id: const RepresentativeId('rep-1'),
        fullName: 'Jane Rep',
        email: EmailAddress.create('rep@company.com').getOrThrow(),
        commissionRate: Percentage.create(5).getOrThrow(),
        assignments: [CustomerAssignment(otherCompanyId)],
      );

      when(() => representativeRepository.findById(const RepresentativeId('rep-1')))
          .thenAnswer((_) async => rep);
      when(() => representativeRepository.findAll())
          .thenAnswer((_) async => [rep]);

      final result = await useCase.execute(companyId, session);

      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<UnauthorizedError>());
      verifyNever(() => orderRepository.findByCompanyId(companyId));
    });
  });
}
