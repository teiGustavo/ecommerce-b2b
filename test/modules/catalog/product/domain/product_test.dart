import 'package:ecommerce_b2b/modules/catalog/product/domain/product.dart';
import 'package:ecommerce_b2b/modules/catalog/product/domain/product_variant.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_variant_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Product', () {
    // Deve adicionar variantes corretamente.
    test('should add variants', () {
      final product = Product(
        id: const ProductId('p1'),
        sku: 'SKU1',
        name: 'Product 1',
        description: 'Description',
        active: true,
      );

      final variant = ProductVariant(
        id: const ProductVariantId('v1'),
        color: 'Red',
        size: 'L',
        voltage: '110V',
        variantSku: 'SKU1-RED-L',
      );

      product.addVariant(variant);

      expect(product.variants.length, 1);
      expect(product.variants.first, variant);
    });
  });
}
