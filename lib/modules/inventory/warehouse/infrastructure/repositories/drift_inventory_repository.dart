import 'package:drift/drift.dart';
import 'package:ecommerce_b2b/modules/inventory/warehouse/domain/repositories/inventory_repository.dart';
import 'package:ecommerce_b2b/modules/inventory/warehouse/domain/warehouse.dart';
import 'package:ecommerce_b2b/modules/inventory/warehouse/domain/stock_item.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/warehouse_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/infrastructure/database/app_database.dart';

class DriftInventoryRepository implements InventoryRepository {
  final AppDatabase _db;

  DriftInventoryRepository(this._db);

  @override
  Future<void> save(Warehouse warehouse) async {
    await _db.transaction(() async {
      await _db.into(_db.warehouses).insertOnConflictUpdate(
        WarehousesCompanion.insert(
          id: warehouse.id.value,
          name: warehouse.name,
        ),
      );

      for (final item in warehouse.stockItems) {
        await _db.into(_db.stocks).insertOnConflictUpdate(
          StocksCompanion.insert(
            warehouseId: warehouse.id.value,
            variantId: item.productId.value, // Using ProductId as variantId for now
            quantity: item.physicalQuantity.value,
          ),
        );
      }
    });
  }

  @override
  Future<Warehouse?> getById(WarehouseId id) async {
    final row = await (_db.select(_db.warehouses)
          ..where((t) => t.id.equals(id.value)))
        .getSingleOrNull();

    if (row == null) return null;

    final stockRows = await (_db.select(_db.stocks)
          ..where((t) => t.warehouseId.equals(id.value)))
        .get();

    return Warehouse(
      id: WarehouseId(row.id),
      code: row.id,
      name: row.name,
      stockItems: stockRows.map((s) => StockItem(
        productId: ProductId(s.variantId),
        physicalQuantity: Quantity.create(s.quantity).getOrThrow(),
      )).toList(),
    );
  }

  @override
  Future<List<Warehouse>> getAll() async {
    final rows = await _db.select(_db.warehouses).get();
    final List<Warehouse> warehouses = [];
    for (final row in rows) {
      final stockRows = await (_db.select(_db.stocks)
            ..where((t) => t.warehouseId.equals(row.id)))
          .get();
      warehouses.add(Warehouse(
        id: WarehouseId(row.id),
        code: row.id,
        name: row.name,
        stockItems: stockRows.map((s) => StockItem(
          productId: ProductId(s.variantId),
          physicalQuantity: Quantity.create(s.quantity).getOrThrow(),
        )).toList(),
      ));
    }
    return warehouses;
  }

  @override
  Future<List<StockItem>> getConsolidatedStock() async {
    final query = _db.selectOnly(_db.stocks)
      ..addColumns([_db.stocks.variantId, _db.stocks.quantity.sum()]);
    
    final results = await query.get();
    
    return results.map((row) {
      final variantId = row.read(_db.stocks.variantId)!;
      final totalQuantity = row.read(_db.stocks.quantity.sum()) ?? 0;
      return StockItem(
        productId: ProductId(variantId),
        physicalQuantity: Quantity.create(totalQuantity.toInt()).getOrThrow(),
      );
    }).toList();
  }

  @override
  Future<StockItem?> getStock(WarehouseId warehouseId, ProductId productId) async {
    final row = await (_db.select(_db.stocks)
      ..where((t) => t.warehouseId.equals(warehouseId.value) & t.variantId.equals(productId.value)))
      .getSingleOrNull();
    
    if (row == null) return null;
    
    return StockItem(
      productId: ProductId(row.variantId),
      physicalQuantity: Quantity.create(row.quantity).getOrThrow(),
    );
  }
}
