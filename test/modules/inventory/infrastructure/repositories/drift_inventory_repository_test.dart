import 'package:drift/native.dart';
import 'package:ecommerce_b2b/modules/inventory/warehouse/domain/stock_item.dart';
import 'package:ecommerce_b2b/modules/inventory/warehouse/domain/warehouse.dart';
import 'package:ecommerce_b2b/modules/inventory/warehouse/infrastructure/repositories/drift_inventory_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/warehouse_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/infrastructure/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late DriftInventoryRepository inventoryRepository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    inventoryRepository = DriftInventoryRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('DriftInventoryRepository Integration Tests', () {
    test('should save and retrieve a warehouse with stock items', () async {
      final warehouseId = const WarehouseId('wh-1');
      final warehouse = Warehouse(
        id: warehouseId,
        code: 'WH01',
        name: 'Main Warehouse',
        stockItems: [
          StockItem(
            productId: const ProductId('p1'),
            physicalQuantity: Quantity.create(100).getOrThrow(),
          ),
        ],
      );

      await inventoryRepository.save(warehouse);

      final fetched = await inventoryRepository.getById(warehouseId);
      expect(fetched != null, isTrue);
      expect(fetched!.name, 'Main Warehouse');
      expect(fetched.stockItems.length, 1);
      expect(fetched.stockItems.first.productId, const ProductId('p1'));
      expect(fetched.stockItems.first.physicalQuantity.value, 100);
    });

    test('should get consolidated stock across warehouses', () async {
      final wh1 = Warehouse(
        id: const WarehouseId('wh-1'),
        code: 'WH01',
        name: 'Warehouse 1',
        stockItems: [
          StockItem(productId: const ProductId('p1'), physicalQuantity: Quantity.create(50).getOrThrow()),
        ],
      );
      final wh2 = Warehouse(
        id: const WarehouseId('wh-2'),
        code: 'WH02',
        name: 'Warehouse 2',
        stockItems: [
          StockItem(productId: const ProductId('p1'), physicalQuantity: Quantity.create(30).getOrThrow()),
          StockItem(productId: const ProductId('p2'), physicalQuantity: Quantity.create(20).getOrThrow()),
        ],
      );

      await inventoryRepository.save(wh1);
      await inventoryRepository.save(wh2);

      final consolidated = await inventoryRepository.getConsolidatedStock();
      
      final p1Stock = consolidated.firstWhere((i) => i.productId == const ProductId('p1'));
      final p2Stock = consolidated.firstWhere((i) => i.productId == const ProductId('p2'));

      expect(p1Stock.physicalQuantity.value, 80);
      expect(p2Stock.physicalQuantity.value, 20);
    });
  });
}
