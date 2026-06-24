import 'package:drift/drift.dart' show Value;
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/commission.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/customer_assignment.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/enums/commission_status.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/repositories/sales_representative_repository.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/sales_representative.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/sales_hierarchy_link.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/representative_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/email_address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
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
        supervisorId: rep.supervisorLink != null
            ? Value(rep.supervisorLink!.supervisorId.value)
            : const Value.absent(),
      ),
    );
  }

  @override
  Future<SalesRepresentative?> findById(RepresentativeId id) async {
    final row = await (_db.select(_db.salesRepresentativesTable)
          ..where((t) => t.id.equals(id.value)))
        .getSingleOrNull();

    if (row == null) return null;

    final companyRows = await (_db.select(_db.companies)
          ..where((t) => t.representativeId.equals(id.value)))
        .get();

    final commissionRows = await (_db.select(_db.commissionsTable)
          ..where((t) => t.representativeId.equals(id.value)))
        .get();

    final subordinateRows = await (_db.select(_db.salesRepresentativesTable)
          ..where((t) => t.supervisorId.equals(id.value)))
        .get();

    return _mapToDomain(row, companyRows, commissionRows, subordinateRows);
  }

  @override
  Future<List<SalesRepresentative>> findAll() async {
    final rows = await _db.select(_db.salesRepresentativesTable).get();
    final List<SalesRepresentative> representatives = [];
    for (final row in rows) {
      final companyRows = await (_db.select(_db.companies)
            ..where((t) => t.representativeId.equals(row.id)))
          .get();
      final commissionRows = await (_db.select(_db.commissionsTable)
            ..where((t) => t.representativeId.equals(row.id)))
          .get();
      final subordinateRows = await (_db.select(_db.salesRepresentativesTable)
            ..where((t) => t.supervisorId.equals(row.id)))
          .get();
      representatives.add(_mapToDomain(row, companyRows, commissionRows, subordinateRows));
    }
    return representatives;
  }

  SalesRepresentative _mapToDomain(
    SalesRepresentativeRow row,
    List<CompanyRow> companyRows,
    List<CommissionRow> commissionRows,
    List<SalesRepresentativeRow> subordinateRows,
  ) {
    final supervisorLink = row.supervisorId != null
        ? SalesHierarchyLink(
            supervisorId: RepresentativeId(row.supervisorId!),
            subordinateId: RepresentativeId(row.id),
          )
        : null;

    final subordinateLinks = subordinateRows
        .map((sub) => SalesHierarchyLink(
              supervisorId: RepresentativeId(row.id),
              subordinateId: RepresentativeId(sub.id),
            ))
        .toList();

    return SalesRepresentative(
      id: RepresentativeId(row.id),
      fullName: row.fullName,
      email: EmailAddress.create(row.email).getOrThrow(),
      commissionRate: Percentage.create(row.commissionRate).getOrThrow(),
      assignments: companyRows.map((c) => CustomerAssignment(CompanyId(c.id))).toList(),
      commissions: commissionRows.map((c) => Commission(
        baseAmount: Money.create(c.baseAmount).getOrThrow(),
        rate: Percentage.create(c.rate).getOrThrow(),
        amount: Money.create(c.amount).getOrThrow(),
        status: CommissionStatus.values.firstWhere((s) => s.name == c.status),
      )).toList(),
      supervisorLink: supervisorLink,
      subordinateLinks: subordinateLinks,
    );
  }
}
