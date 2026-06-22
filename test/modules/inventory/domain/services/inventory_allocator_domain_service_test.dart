import 'package:ecommerce_b2b/modules/inventory/domain/aggregates/warehouse/stock_item.dart';
import 'package:ecommerce_b2b/modules/inventory/domain/aggregates/warehouse/warehouse.dart';
import 'package:ecommerce_b2b/modules/inventory/domain/aggregates/warehouse/stock_reservation.dart';
import 'package:ecommerce_b2b/modules/inventory/domain/services/inventory_allocator_domain_service.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/warehouse_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InventoryAllocatorDomainService', () {
    late InventoryAllocatorDomainService service;
    late ProductId productId;
    late List<Warehouse> warehouses;

    setUp(() {
      service = InventoryAllocatorDomainService();
      productId = const ProductId('p1');
      warehouses = [
        Warehouse(
          id: const WarehouseId('w1'),
          code: 'W1',
          name: 'Warehouse 1',
          stockItems: [
            StockItem(
              productId: productId,
              physicalQuantity: Quantity.create(100).getOrThrow(),
            ),
          ],
        ),
        Warehouse(
          id: const WarehouseId('w2'),
          code: 'W2',
          name: 'Warehouse 2',
          stockItems: [
            StockItem(
              productId: productId,
              physicalQuantity: Quantity.create(50).getOrThrow(),
            ),
          ],
        ),
      ];
    });

    test('getConsolidatedPhysicalStock should sum all warehouses', () {
      final total = service.getConsolidatedPhysicalStock(warehouses, productId);
      expect(total.value, 150);
    });

    test('getConsolidatedAvailableStock should sum available quantity in all warehouses', () {
      // Adding some reservations
      warehouses[0].getStockItem(productId)!.addReservation(
        StockReservation(
          orderId: const OrderId('any'), 
          quantity: Quantity.create(10).getOrThrow(),
        ),
      );
      
      final total = service.getConsolidatedAvailableStock(warehouses, productId);
      expect(total.value, 140);
    });

    test('allocateStock should distribute reservations across warehouses', () {
      final orderId = const OrderId('o1');
      final requested = Quantity.create(120).getOrThrow();

      service.allocateStock(warehouses, orderId, productId, requested);

      expect(warehouses[0].getStockItem(productId)!.reservedQuantity.value, 100);
      expect(warehouses[1].getStockItem(productId)!.reservedQuantity.value, 20);
    });

    test('allocateStock should throw if insufficient stock', () {
      final orderId = const OrderId('o1');
      final requested = Quantity.create(200).getOrThrow();

      expect(
        () => service.allocateStock(warehouses, orderId, productId, requested),
        throwsA(isA<StateError>()),
      );
    });
  });
}
