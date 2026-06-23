import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/repositories/sales_representative_repository.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/sales_representative.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/representative_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/email_address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/percentage.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/infrastructure/database/app_database.dart';

class DriftSalesRepresentativeRepository implements SalesRepresentativeRepository {
  final AppDatabase _db;

  DriftSalesRepresentativeRepository(this._db);

  Future<void> save(SalesRepresentative rep) async {
    await _db.into(_db.salesRepresentativesTable).insertOnConflictUpdate(
      SalesRepresentativesTableCompanion.insert(
        id: rep.id.value,
        fullName: rep.fullName,
        email: rep.email.value,
        commissionRate: rep.commissionRate.value,
      ),
    );
  }

  @override
  Future<SalesRepresentative?> findById(RepresentativeId id) async {
    final row = await (_db.select(_db.salesRepresentativesTable)
          ..where((t) => t.id.equals(id.value)))
        .getSingleOrNull();

    if (row == null) return null;
    return _mapToDomain(row);
  }

  @override
  Future<List<SalesRepresentative>> findAll() async {
    final rows = await _db.select(_db.salesRepresentativesTable).get();
    return rows.map(_mapToDomain).toList();
  }

  SalesRepresentative _mapToDomain(SalesRepresentativeRow row) {
    return SalesRepresentative(
      id: RepresentativeId(row.id),
      fullName: row.fullName,
      email: EmailAddress.create(row.email).getOrThrow(),
      commissionRate: Percentage.create(row.commissionRate).getOrThrow(),
    );
  }
}
