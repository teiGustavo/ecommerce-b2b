import 'package:ecommerce_b2b/modules/sales_team/domain/aggregates/sales_representative/sales_representative.dart';
import 'package:ecommerce_b2b/modules/sales_team/domain/services/sales_hierarchy_domain_service.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/representative_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/email_address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/percentage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SalesHierarchyServiceDomainService hierarchyService;

  setUp(() {
    hierarchyService = SalesHierarchyServiceDomainService();
  });

  SalesRepresentative createRep(String id, {List<String> subordinates = const []}) {
    final rep = SalesRepresentative(
      id: RepresentativeId(id),
      fullName: 'Rep $id',
      email: EmailAddress.create('rep$id@test.com').getOrThrow(),
      commissionRate: Percentage.create(5).getOrThrow(),
    );
    for (final subId in subordinates) {
      rep.addSubordinate(RepresentativeId(subId));
    }
    return rep;
  }

  group('SalesHierarchyService', () {
    test('deve permitir acesso a subordinado direto', () {
      final supervisor = createRep('S1', subordinates: ['Sub1']);
      final subordinate = createRep('Sub1');

      final hasAccess = hierarchyService.canSupervisorAccessSubordinate(
        supervisor: supervisor,
        subordinateId: subordinate.id,
        allSubordinatesInContext: [subordinate],
      );

      expect(hasAccess, isTrue);
    });

    test('deve permitir acesso a subordinado indireto (recursivo)', () {
      final supervisor = createRep('S1', subordinates: ['M1']);
      final manager = createRep('M1', subordinates: ['Sub1']);
      final subordinate = createRep('Sub1');

      final hasAccess = hierarchyService.canSupervisorAccessSubordinate(
        supervisor: supervisor,
        subordinateId: subordinate.id,
        allSubordinatesInContext: [manager, subordinate],
      );

      expect(hasAccess, isTrue);
    });

    test('deve negar acesso a quem não é subordinado', () {
      final supervisor = createRep('S1', subordinates: ['Sub1']);
      final otherRep = createRep('Other');

      final hasAccess = hierarchyService.canSupervisorAccessSubordinate(
        supervisor: supervisor,
        subordinateId: otherRep.id,
        allSubordinatesInContext: [otherRep],
      );

      expect(hasAccess, isFalse);
    });
  });
}
