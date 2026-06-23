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

@DataClassName('UserSessionRow')
class UserSessions extends Table {
  TextColumn get userId => text()();
  TextColumn get role => text()();
  TextColumn get companyId => text().nullable()();
  BoolColumn get isActive => boolean()();

  @override
  Set<Column> get primaryKey => {userId};
}

@DataClassName('ProductRow')
class Products extends Table {
  TextColumn get id => text()();
  TextColumn get sku => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  RealColumn get basePrice => real().withDefault(const Constant(0.0))();
  BoolColumn get active => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ProductVariantRow')
class ProductVariants extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text()();
  TextColumn get variantSku => text()();
  TextColumn get color => text()();
  TextColumn get size => text()();
  TextColumn get voltage => text()();
  RealColumn get price => real().nullable()();
  BoolColumn get sameAsParent => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PriceTableRow')
class PriceTables extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get scopeType => text()(); // national, regional, customerSpecific

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PriceRuleRow')
class PriceRules extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get priceTableId => text()();
  TextColumn get productId => text()();
  TextColumn get variantId => text().nullable()();
  IntColumn get minQuantity => integer()();
  IntColumn get maxQuantity => integer()();
  TextColumn get stateCode => text().nullable()();
  RealColumn get unitPrice => real()();
}

@DataClassName('WarehouseRow')
class Warehouses extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('StockRow')
class Stocks extends Table {
  TextColumn get warehouseId => text()();
  TextColumn get variantId => text()();
  IntColumn get quantity => integer()();

  @override
  Set<Column> get primaryKey => {warehouseId, variantId};
}

@DataClassName('ShipmentRow')
class Shipments extends Table {
  TextColumn get id => text()();
  TextColumn get orderId => text()();
  TextColumn get trackingCode => text().nullable()();
  TextColumn get carrierName => text().nullable()();
  TextColumn get status => text()();
  DateTimeColumn get estimatedDelivery => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ReturnRequestRow')
class ReturnRequests extends Table {
  TextColumn get id => text()();
  TextColumn get orderId => text()();
  TextColumn get reason => text()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('QuoteRow')
class QuotesTable extends Table {
  TextColumn get id => text()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('QuoteItemRow')
class QuoteItemsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get quoteId => text()();
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
  UserSessions,
  Products,
  ProductVariants,
  PriceTables,
  PriceRules,
  Warehouses,
  Stocks,
  Shipments,
  ReturnRequests,
  QuotesTable,
  QuoteItemsTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(userSessions);
          }
          if (from < 3) {
            await m.createTable(products);
            await m.createTable(productVariants);
          }
          if (from < 4) {
            await m.addColumn(products, products.basePrice);
            await m.addColumn(productVariants, productVariants.price);
            await m.addColumn(productVariants, productVariants.sameAsParent);
          }
          if (from < 5) {
            await m.createTable(priceTables);
            await m.createTable(priceRules);
          }
          if (from < 6) {
            await m.createTable(warehouses);
            await m.createTable(stocks);
            await m.createTable(shipments);
            await m.createTable(returnRequests);
          }
          if (from < 7) {
            await m.createTable(quotesTable);
            await m.createTable(quoteItemsTable);
          }
        },
      );
}

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
