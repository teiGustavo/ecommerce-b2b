import 'package:ecommerce_b2b/modules/customer_portal/domain/aggregates/return_request/return_request_item.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/quantity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReturnRequestItem', () {
    test('should compare equality based on values', () {
      final item1 = ReturnRequestItem(
        productId: ProductId('p1'),
        quantity: Quantity.create(1).getOrThrow(),
        problemDescription: 'Defective',
      );
      final item2 = ReturnRequestItem(
        productId: ProductId('p1'),
        quantity: Quantity.create(1).getOrThrow(),
        problemDescription: 'Defective',
      );

      expect(item1, equals(item2));
    });
  });
}
