import 'package:drift/drift.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/authorized_buyer.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/company.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/customer_credit_account.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/repositories/company_repository.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/value_objects/cnpj.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/value_objects/inscricao_estadual.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/address/enums/state.dart' as address_state;
import 'package:ecommerce_b2b/modules/shared_kernel/domain/address/value_objects/address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/buyer_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/email_address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/phone_number.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/infrastructure/database/app_database.dart';

class DriftCompanyRepository implements CompanyRepository {
  final AppDatabase _db;

  DriftCompanyRepository(this._db);

  @override
  Future<void> save(Company company) async {
    await _db.transaction(() async {
      await _db.into(_db.companies).insertOnConflictUpdate(
        CompaniesCompanion.insert(
          id: company.id.value,
          legalName: company.legalName,
          tradeName: company.tradeName,
          cnpj: company.cnpj.value,
          inscricaoEstadual: company.inscricaoEstadual.value,
          email: company.email.value,
          phone: company.phone.value,
          billingStreet: company.billingAddress.street.value,
          billingNumber: company.billingAddress.number.value,
          billingComplement: Value(company.billingAddress.complement?.value),
          billingNeighborhood: company.billingAddress.neighborhood.value,
          billingCity: company.billingAddress.city.value,
          billingState: company.billingAddress.state.code,
          billingZipCode: company.billingAddress.zipCode.value,
          shippingStreet: company.shippingAddress.street.value,
          shippingNumber: company.shippingAddress.number.value,
          shippingComplement: Value(company.shippingAddress.complement?.value),
          shippingNeighborhood: company.shippingAddress.neighborhood.value,
          shippingCity: company.shippingAddress.city.value,
          shippingState: company.shippingAddress.state.code,
          shippingZipCode: company.shippingAddress.zipCode.value,
          stateCode: company.state.code,
          creditLimit: company.creditLimit.amount,
          openBalance: company.creditAccount.openBalance.amount,
          pendingOrdersBalance: company.creditAccount.pendingOrdersBalance.amount,
          representativeId: Value(company.representativeId),
        ),
      );

      // Save authorized buyers
      await (_db.delete(_db.authorizedBuyersTable)
            ..where((t) => t.companyId.equals(company.id.value)))
          .go();

      for (final buyer in company.authorizedBuyers) {
        await _db.into(_db.authorizedBuyersTable).insertOnConflictUpdate(
          AuthorizedBuyersTableCompanion.insert(
            id: buyer.id.value,
            companyId: company.id.value,
            fullName: buyer.fullName,
            email: buyer.email.value,
            phone: buyer.phone.value,
            positionTitle: buyer.positionTitle,
            active: buyer.active,
          ),
        );
      }
    });
  }

  @override
  Future<Company?> findById(CompanyId id) async {
    final companyRow = await (_db.select(_db.companies)
          ..where((t) => t.id.equals(id.value)))
        .getSingleOrNull();

    if (companyRow == null) return null;

    final buyersRows = await (_db.select(_db.authorizedBuyersTable)
          ..where((t) => t.companyId.equals(id.value)))
        .get();

    return _mapToDomain(companyRow, buyersRows);
  }

  @override
  Future<List<Company>> findAll() async {
    final companiesRows = await _db.select(_db.companies).get();
    final List<Company> companies = [];

    for (final row in companiesRows) {
      final buyersRows = await (_db.select(_db.authorizedBuyersTable)
            ..where((t) => t.companyId.equals(row.id)))
          .get();
      companies.add(_mapToDomain(row, buyersRows));
    }

    return companies;
  }

  @override
  Future<List<Company>> findByRepresentativeId(String representativeId) async {
    final companiesRows = await (_db.select(_db.companies)
          ..where((t) => t.representativeId.equals(representativeId)))
        .get();

    final List<Company> companies = [];
    for (final row in companiesRows) {
      final buyersRows = await (_db.select(_db.authorizedBuyersTable)
            ..where((t) => t.companyId.equals(row.id)))
          .get();
      companies.add(_mapToDomain(row, buyersRows));
    }
    return companies;
  }

  Company _mapToDomain(CompanyRow row, List<AuthorizedBuyerRow> buyers) {
    return Company(
      id: CompanyId(row.id),
      legalName: row.legalName,
      tradeName: row.tradeName,
      cnpj: Cnpj.create(row.cnpj).getOrThrow(),
      inscricaoEstadual: InscricaoEstadual.create(row.inscricaoEstadual).getOrThrow(),
      email: EmailAddress.create(row.email).getOrThrow(),
      phone: PhoneNumber.create(row.phone).getOrThrow(),
      billingAddress: Address.create(
        street: row.billingStreet,
        number: row.billingNumber,
        complement: row.billingComplement,
        neighborhood: row.billingNeighborhood,
        city: row.billingCity,
        state: row.billingState,
        zipCode: row.billingZipCode,
      ).getOrThrow(),
      shippingAddress: Address.create(
        street: row.shippingStreet,
        number: row.shippingNumber,
        complement: row.shippingComplement,
        neighborhood: row.shippingNeighborhood,
        city: row.shippingCity,
        state: row.shippingState,
        zipCode: row.shippingZipCode,
      ).getOrThrow(),
      state: address_state.State.fromString(row.stateCode).getOrThrow(),
      creditLimit: Money.create(row.creditLimit).getOrThrow(),
      representativeId: row.representativeId,
      authorizedBuyers: buyers.map((b) => AuthorizedBuyer(
        id: BuyerId(b.id),
        fullName: b.fullName,
        email: EmailAddress.create(b.email).getOrThrow(),
        phone: PhoneNumber.create(b.phone).getOrThrow(),
        positionTitle: b.positionTitle,
        active: b.active,
      )).toList(),
      creditAccount: CustomerCreditAccount(
        preApprovedLimit: Money.create(row.creditLimit).getOrThrow(),
        openBalance: Money.create(row.openBalance).getOrThrow(),
        pendingOrdersBalance: Money.create(row.pendingOrdersBalance).getOrThrow(),
      ),
    );
  }
}
