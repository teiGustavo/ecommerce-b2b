import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

@DataClassName('CompanyRow')
class Companies extends Table {
  TextColumn get id => text()();
  TextColumn get legalName => text()();
  TextColumn get tradeName => text()();
  TextColumn get cnpj => text()();
  TextColumn get inscricaoEstadual => text()();
  TextColumn get email => text()();
  TextColumn get phone => text()();
  
  // Billing Address
  TextColumn get billingStreet => text()();
  TextColumn get billingNumber => text()();
  TextColumn get billingComplement => text().nullable()();
  TextColumn get billingNeighborhood => text()();
  TextColumn get billingCity => text()();
  TextColumn get billingState => text()();
  TextColumn get billingZipCode => text()();

  // Shipping Address
  TextColumn get shippingStreet => text()();
  TextColumn get shippingNumber => text()();
  TextColumn get shippingComplement => text().nullable()();
  TextColumn get shippingNeighborhood => text()();
  TextColumn get shippingCity => text()();
  TextColumn get shippingState => text()();
  TextColumn get shippingZipCode => text()();

  TextColumn get stateCode => text()();
  
  RealColumn get creditLimit => real()();
  RealColumn get openBalance => real()();
  RealColumn get pendingOrdersBalance => real()();
  TextColumn get representativeId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AuthorizedBuyerRow')
class AuthorizedBuyersTable extends Table {
  TextColumn get id => text()();
  TextColumn get companyId => text()();
  TextColumn get fullName => text()();
  TextColumn get email => text()();
  TextColumn get phone => text()();
  TextColumn get positionTitle => text()();
  BoolColumn get active => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SalesRepresentativeRow')
class SalesRepresentativesTable extends Table {
  TextColumn get id => text()();
  TextColumn get fullName => text()();
  TextColumn get email => text()();
  RealColumn get commissionRate => real()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SalesOrderRow')
class SalesOrdersTable extends Table {
  TextColumn get id => text()();
  TextColumn get companyId => text().nullable()();
  TextColumn get status => text()();
  TextColumn get creditStatus => text()();
  
  // Finance Review
  TextColumn get financeDecision => text().nullable()();
  TextColumn get financeReviewerId => text().nullable()();
  DateTimeColumn get financeReviewedAt => dateTime().nullable()();
  TextColumn get financeJustification => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('OrderItemRow')
class OrderItemsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get orderId => text()();
  TextColumn get productId => text()();
  IntColumn get quantity => integer()();
  RealColumn get unitPrice => real()();
  TextColumn get currency => text()();
}

@DriftDatabase(tables: [
  Companies,
  AuthorizedBuyersTable,
  SalesRepresentativesTable,
  SalesOrdersTable,
  OrderItemsTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
