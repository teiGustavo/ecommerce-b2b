import 'package:ecommerce_b2b/modules/catalog/price_table/domain/enums/price_scope_type.dart';
import 'package:ecommerce_b2b/modules/catalog/price_table/domain/price_rule.dart';
import 'package:ecommerce_b2b/modules/catalog/price_table/domain/price_table.dart';
import 'package:ecommerce_b2b/modules/catalog/price_table/domain/services/order_pricing_domain_service.dart';
import 'package:ecommerce_b2b/modules/catalog/product/domain/product.dart';
import 'package:ecommerce_b2b/modules/catalog/product/domain/product_variant.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/address/enums/state.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/price_table_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_variant_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late OrderPricingDomainService pricingService;

  setUp(() {
    pricingService = OrderPricingDomainService();
  });

  final productId = const ProductId('p1');
  final variantId = const ProductVariantId('v1');
  final product = Product(
    id: productId,
    sku: 'SKU',
    name: 'Product',
    description: '',
    basePrice: Money.create(100).getOrThrow(),
    active: true,
  );

  final variant = ProductVariant(
    id: variantId,
    color: 'Blue',
    size: 'G',
    voltage: '',
    variantSku: 'SKU-BLUE',
    price: Money.create(110).getOrThrow(),
    sameAsParent: false,
  );

  group('OrderPricingDomainService Hierarchy', () {
    test('should return catalog base price when no table or variant price exists', () {
      final price = pricingService.getUnitPrice(
        product: product,
        quantity: Quantity.create(1).getOrThrow(),
        state: State.saoPaulo,
      );
      expect(price.amount, 100);
    });

    test('should return variant catalog price when sameAsParent is false', () {
      final price = pricingService.getUnitPrice(
        product: product,
        variant: variant,
        quantity: Quantity.create(1).getOrThrow(),
        state: State.saoPaulo,
      );
      expect(price.amount, 110);
    });

    test('should return price table rule price (higher priority)', () {
      final table = PriceTable(
        id: const PriceTableId('pt1'),
        name: 'Promo',
        scopeType: PriceScopeType.national,
        rules: [
          PriceRule(
            productId: productId,
            minQuantity: Quantity.create(10).getOrThrow(),
            maxQuantity: Quantity.create(100).getOrThrow(),
            unitPrice: Money.create(80).getOrThrow(),
          ),
        ],
      );

      final price = pricingService.getUnitPrice(
        product: product,
        priceTable: table,
        quantity: Quantity.create(15).getOrThrow(),
        state: State.saoPaulo,
      );
      expect(price.amount, 80);
    });

    test('should respect UF specificity in price table', () {
      final table = PriceTable(
        id: const PriceTableId('pt1'),
        name: 'Promo',
        scopeType: PriceScopeType.regional,
        rules: [
          PriceRule(
            productId: productId,
            minQuantity: Quantity.create(1).getOrThrow(),
            maxQuantity: Quantity.create(100).getOrThrow(),
            state: State.rioDeJaneiro,
            unitPrice: Money.create(95).getOrThrow(),
          ),
          PriceRule(
            productId: productId,
            minQuantity: Quantity.create(1).getOrThrow(),
            maxQuantity: Quantity.create(100).getOrThrow(),
            unitPrice: Money.create(90).getOrThrow(), // National fallback in table
          ),
        ],
      );

      final priceRJ = pricingService.getUnitPrice(
        product: product,
        priceTable: table,
        quantity: Quantity.create(5).getOrThrow(),
        state: State.rioDeJaneiro,
      );
      expect(priceRJ.amount, 95);

      final priceSP = pricingService.getUnitPrice(
        product: product,
        priceTable: table,
        quantity: Quantity.create(5).getOrThrow(),
        state: State.saoPaulo,
      );
      expect(priceSP.amount, 90);
    });
  });
}
