import 'package:drift/drift.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/enums/finance_decision.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/finance_review.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/order_item.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/repositories/sales_order_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/sales_order.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/enums/currency.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/infrastructure/database/app_database.dart';

class DriftSalesOrderRepository implements SalesOrderRepository {
  final AppDatabase _db;

  DriftSalesOrderRepository(this._db);

  @override
  Future<void> save(SalesOrder order) async {
    await _db.transaction(() async {
      await _db.into(_db.salesOrdersTable).insertOnConflictUpdate(
        SalesOrdersTableCompanion.insert(
          id: order.id.value,
          companyId: Value(order.companyId),
          status: order.status.name,
          creditStatus: order.creditStatus.name,
          financeDecision: Value(order.financeReview?.decision.name),
          financeReviewerId: Value(order.financeReview?.reviewerId),
          financeReviewedAt: Value(order.financeReview?.reviewedAt),
          financeJustification: Value(order.financeReview?.justification),
        ),
      );

      // Delete old items and re-insert
      await (_db.delete(_db.orderItemsTable)
            ..where((t) => t.orderId.equals(order.id.value)))
          .go();

      for (final item in order.items) {
        await _db.into(_db.orderItemsTable).insert(
          OrderItemsTableCompanion.insert(
            orderId: order.id.value,
            productId: item.productId.value,
            quantity: item.quantity.value,
            unitPrice: item.unitPriceSnapshot.amount,
            currency: item.unitPriceSnapshot.currency.code,
          ),
        );
      }
    });
  }

  @override
  Future<SalesOrder?> getById(OrderId id) async {
    final row = await (_db.select(_db.salesOrdersTable)
          ..where((t) => t.id.equals(id.value)))
        .getSingleOrNull();

    if (row == null) return null;

    final itemRows = await (_db.select(_db.orderItemsTable)
          ..where((t) => t.orderId.equals(id.value)))
        .get();

    return _mapToDomain(row, itemRows);
  }

  @override
  Future<List<SalesOrder>> getAll() async {
    final rows = await _db.select(_db.salesOrdersTable).get();
    final List<SalesOrder> orders = [];
    for (final row in rows) {
      final itemRows = await (_db.select(_db.orderItemsTable)
            ..where((t) => t.orderId.equals(row.id)))
          .get();
      orders.add(_mapToDomain(row, itemRows));
    }
    return orders;
  }

  @override
  Future<List<SalesOrder>> findByCompanyId(CompanyId companyId) async {
    final rows = await (_db.select(_db.salesOrdersTable)
          ..where((t) => t.companyId.equals(companyId.value)))
        .get();
    
    final List<SalesOrder> orders = [];
    for (final row in rows) {
      final itemRows = await (_db.select(_db.orderItemsTable)
            ..where((t) => t.orderId.equals(row.id)))
          .get();
      orders.add(_mapToDomain(row, itemRows));
    }
    return orders;
  }

  @override
  Future<List<SalesOrder>> findByStatus(String status) async {
    final rows = await (_db.select(_db.salesOrdersTable)
          ..where((t) => t.status.equals(status)))
        .get();

    final List<SalesOrder> orders = [];
    for (final row in rows) {
      final itemRows = await (_db.select(_db.orderItemsTable)
            ..where((t) => t.orderId.equals(row.id)))
          .get();
      orders.add(_mapToDomain(row, itemRows));
    }
    return orders;
  }

  SalesOrder _mapToDomain(SalesOrderRow row, List<OrderItemRow> itemRows) {
    FinanceReview? review;
    if (row.financeDecision != null) {
      review = FinanceReview(
        decision: FinanceDecision.values.firstWhere((e) => e.name == row.financeDecision),
        reviewerId: row.financeReviewerId ?? '',
        reviewedAt: row.financeReviewedAt ?? DateTime.now(),
        justification: row.financeJustification ?? '',
      );
    }

    return SalesOrder(
      id: OrderId(row.id),
      companyId: row.companyId,
      status: OrderStatus.values.firstWhere((e) => e.name == row.status),
      creditStatus: CreditStatus.values.firstWhere((e) => e.name == row.creditStatus),
      items: itemRows.map((i) => OrderItem(
        productId: ProductId(i.productId),
        quantity: Quantity.create(i.quantity).getOrThrow(),
        unitPriceSnapshot: Money.create(
          i.unitPrice,
          currency: Currency.values.firstWhere((c) => c.code == i.currency),
        ).getOrThrow(),
      )).toList(),
      financeReview: review,
    );
  }
}
