import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/repositories/sales_representative_repository.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/sales_representative.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/representative_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/email_address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/percentage.dart';

class MockRepresentativeAdapter implements SalesRepresentativeRepository {
  final List<SalesRepresentative> _reps = [
    SalesRepresentative(
      id: const RepresentativeId('rep-456'),
      fullName: 'Representante Mock',
      email: EmailAddress.create('rep@test.com').getOrThrow(),
      commissionRate: Percentage.create(5).getOrThrow(),
    ),
  ];

  @override
  Future<List<SalesRepresentative>> findAll() async {
    return _reps;
  }

  @override
  Future<SalesRepresentative?> findById(RepresentativeId id) async {
    try {
      return _reps.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }
}
