import 'package:ecommerce_b2b/modules/inventory/domain/aggregates/warehouse/stock_item.dart';
import 'package:ecommerce_b2b/modules/inventory/domain/aggregates/warehouse/stock_reservation.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/ids/order_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/quantity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StockItem', () {
    final productId = ProductId('p1');
    final qty10 = Quantity.create(10).getOrThrow();
    final qty2 = Quantity.create(2).getOrThrow();

    test('should calculate available quantity correctly', () {
      final stockItem = StockItem(
        productId: productId,
        physicalQuantity: qty10,
        reservations: [
          StockReservation(orderId: OrderId('o1'), quantity: qty2),
        ],
      );

      expect(stockItem.reservedQuantity.value, 2);
      expect(stockItem.availableQuantity.value, 8);
    });

    test('should add reservation if stock is available', () {
      final stockItem = StockItem(productId: productId, physicalQuantity: qty10);
      stockItem.addReservation(StockReservation(orderId: OrderId('o1'), quantity: qty2));
      
      expect(stockItem.reservedQuantity.value, 2);
    });

    test('should throw StateError when adding reservation exceeding available stock', () {
      final stockItem = StockItem(productId: productId, physicalQuantity: qty2);
      final qty5 = Quantity.create(5).getOrThrow();
      
      expect(
        () => stockItem.addReservation(StockReservation(orderId: OrderId('o1'), quantity: qty5)),
        throwsStateError,
      );
    });
  });
}
