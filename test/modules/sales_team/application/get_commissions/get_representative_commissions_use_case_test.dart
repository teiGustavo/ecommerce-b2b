import 'package:ecommerce_b2b/modules/identity_access/domain/enums/user_role.dart';
import 'package:ecommerce_b2b/modules/identity_access/domain/user_session.dart';
import 'package:ecommerce_b2b/modules/sales_team/application/get_commissions/get_representative_commissions_use_case.dart';
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
  late GetRepresentativeCommissionsUseCase useCase;

  setUp(() {
    repRepository = MockSalesRepresentativeRepository();
    hierarchyService = SalesHierarchyDomainService();
    useCase = GetRepresentativeCommissionsUseCase(repRepository, hierarchyService);
  });

  SalesRepresentative createRep(String id) {
    return SalesRepresentative(
      id: RepresentativeId(id),
      fullName: 'Rep $id',
      email: EmailAddress.create('rep$id@test.com').getOrThrow(),
      commissionRate: Percentage.create(5).getOrThrow(),
    );
  }

  group('GetRepresentativeCommissionsUseCase', () {
    final repId = const RepresentativeId('rep-1');
    final otherRepId = const RepresentativeId('rep-2');

    // Deve permitir que os representantes vejam suas próprias comissões
    test('should allow rep to see their own commissions', () async {
      final session = UserSession(
        userId: repId,
        role: UserRole.representative,
      );

      final rep = createRep('rep-1');
      when(() => repRepository.findById(repId)).thenAnswer((_) async => rep);

      final result = await useCase.execute(repId, session);

      expect(result.isSuccess, isTrue);
    });

    // Deve permitir que o supervisor veja as comissões dos subordinados
    test('should allow supervisor to see subordinate commissions', () async {
      final supervisorId = const RepresentativeId('sup-1');
      final session = UserSession(
        userId: supervisorId,
        role: UserRole.representative,
      );

      final supervisor = createRep('sup-1');
      supervisor.addSubordinate(repId);
      final subordinate = createRep('rep-1');

      when(() => repRepository.findById(supervisorId)).thenAnswer((_) async => supervisor);
      when(() => repRepository.findById(repId)).thenAnswer((_) async => subordinate);
      when(() => repRepository.findAll()).thenAnswer((_) async => [supervisor, subordinate]);

      final result = await useCase.execute(repId, session);

      expect(result.isSuccess, isTrue);
    });

    // Deve negar o acesso a comissões representativas não relacionadas
    test('should deny access to non-related representative commissions', () async {
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
