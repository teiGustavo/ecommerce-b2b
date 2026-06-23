import 'package:ecommerce_b2b/modules/identity_access/domain/enums/user_role.dart';
import 'package:ecommerce_b2b/modules/identity_access/domain/user_session.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/application/get_customers/get_customer_portfolio_use_case.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/repositories/sales_representative_repository.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/sales_representative.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/services/sales_hierarchy_domain_service.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/auth/errors/auth_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/representative_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/email_address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/percentage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSalesRepresentativeRepository extends Mock implements SalesRepresentativeRepository {}

void main() {
  late MockSalesRepresentativeRepository repRepository;
  late SalesHierarchyDomainService hierarchyService;
  late GetCustomerPortfolioUseCase useCase;

  setUp(() {
    repRepository = MockSalesRepresentativeRepository();
    hierarchyService = SalesHierarchyDomainService();
    useCase = GetCustomerPortfolioUseCase(repRepository, hierarchyService);
  });

  SalesRepresentative createRep(String id) {
    return SalesRepresentative(
      id: RepresentativeId(id),
      fullName: 'Rep $id',
      email: EmailAddress.create('rep$id@test.com').getOrThrow(),
      commissionRate: Percentage.create(5).getOrThrow(),
    );
  }

  group('GetCustomerPortfolioUseCase', () {
    final repId = const RepresentativeId('rep-1');

    // Deve permitir que um representante veja seus próprios clientes.
    test('should allow rep to see their own customers', () async {
      final session = UserSession(
        userId: repId,
        role: UserRole.representative,
      );

      final rep = createRep('rep-1');
      when(() => repRepository.findById(repId)).thenAnswer((_) async => rep);

      final result = await useCase.execute(repId, session);

      expect(result.isSuccess, isTrue);
    });

    // Deve negar o acesso se não for o próprio representante ou supervisor
    test('should deny access if not self or supervisor', () async {
      final otherRepId = const RepresentativeId('rep-2');
      final session = UserSession(
        userId: otherRepId,
        role: UserRole.representative,
      );

      final otherRep = createRep('rep-2');
      final targetRep = createRep('rep-1');

      when(() => repRepository.findById(otherRepId)).thenAnswer((_) async => otherRep);
      when(() => repRepository.findAll()).thenAnswer((_) async => [otherRep, targetRep]);

      final result = await useCase.execute(repId, session);

      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<UnauthorizedError>());
    });
  });
}
