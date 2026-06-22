import 'package:ecommerce_b2b/modules/inventory/domain/aggregates/warehouse/warehouse.dart';
import 'package:ecommerce_b2b/modules/inventory/domain/aggregates/warehouse/stock_item.dart';
import 'package:ecommerce_b2b/modules/inventory/domain/repositories/warehouse_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/warehouse_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';

class WarehouseRepositoryInMemory implements WarehouseRepository {
  final List<Warehouse> _warehouses = [];

  WarehouseRepositoryInMemory() {
    _populateMocks();
  }

  void _populateMocks() {
    _warehouses.add(
      Warehouse(
        id: const WarehouseId('WH_SP_01'),
        code: 'SP-CEN',
        name: 'Depósito Central São Paulo',
        stockItems: [
          StockItem(
            productId: const ProductId('PROD_001'), // Smart TV
            physicalQuantity: Quantity.create(150).getOrThrow(),
          ),
          StockItem(
            productId: const ProductId('PROD_002'), // Geladeira
            physicalQuantity: Quantity.create(45).getOrThrow(),
          ),
        ],
      ),
    );

    _warehouses.add(
      Warehouse(
        id: const WarehouseId('WH_RJ_01'),
        code: 'RJ-FIL',
        name: 'Filial Rio de Janeiro',
        stockItems: [
          StockItem(
            productId: const ProductId('PROD_001'), // Smart TV
            physicalQuantity: Quantity.create(30).getOrThrow(),
          ),
        ],
      ),
    );
  }

  @override
  Future<List<Warehouse>> getAll() async {
    return List.unmodifiable(_warehouses);
  }

  @override
  Future<void> save(Warehouse warehouse) async {
    final index = _warehouses.indexWhere((w) => w.id == warehouse.id);
    if (index >= 0) {
      _warehouses[index] = warehouse;
    } else {
      _warehouses.add(warehouse);
    }
  }
}
