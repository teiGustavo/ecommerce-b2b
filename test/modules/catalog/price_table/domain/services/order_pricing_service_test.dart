import 'package:ecommerce_b2b/modules/catalog/price_table/domain/price_rule.dart';
import 'package:ecommerce_b2b/modules/catalog/price_table/domain/price_table.dart';
import 'package:ecommerce_b2b/modules/catalog/product/domain/product.dart';
import 'package:ecommerce_b2b/modules/catalog/price_table/domain/enums/price_scope_type.dart';
import 'package:ecommerce_b2b/modules/catalog/price_table/domain/services/order_pricing_domain_service.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/address/enums/state.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/price_table_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late OrderPricingDomainService pricingService;

  setUp(() {
    pricingService = OrderPricingDomainService();
  });

  group('OrderPricingService', () {
    /// deve retornar preço baseado em volume e estado
    test('should return price based on volume and state', () {
      const productId = ProductId('p1');
      final product = Product(
        id: productId,
        sku: 'SKU1',
        name: 'Prod 1',
        description: 'Desc 1',
        active: true,
        basePrice: Money.create(120).getOrThrow(),
      );

      final table = PriceTable(
        id: const PriceTableId('t1'),
        name: 'Tabela Padrão',
        scopeType: PriceScopeType.regional,
        rules: [
          PriceRule(
            productId: productId,
            minQuantity: Quantity.create(1).getOrThrow(),
            maxQuantity: Quantity.create(10).getOrThrow(),
            state: State.saoPaulo,
            unitPrice: Money.create(100).getOrThrow(),
          ),
          PriceRule(
            productId: productId,
            minQuantity: Quantity.create(11).getOrThrow(),
            maxQuantity: Quantity.create(100).getOrThrow(),
            state: State.saoPaulo,
            unitPrice: Money.create(90).getOrThrow(),
          ),
          PriceRule(
            productId: productId,
            minQuantity: Quantity.create(1).getOrThrow(),
            maxQuantity: Quantity.create(100).getOrThrow(),
            state: State.rioDeJaneiro,
            unitPrice: Money.create(110).getOrThrow(),
          ),
        ],
      );

      // Case 1: SP, low volume
      // Caso 1: SP, volume baixo
      final p1 = pricingService.getUnitPrice(
        product: product,
        priceTable: table,
        quantity: Quantity.create(5).getOrThrow(),
        state: State.saoPaulo,
      );
      expect(p1.amount, 100);

      // Case 2: SP, high volume
      // Caso 2: SP, volume alto
      final p2 = pricingService.getUnitPrice(
        product: product,
        priceTable: table,
        quantity: Quantity.create(20).getOrThrow(),
        state: State.saoPaulo,
      );
      expect(p2.amount, 90);

      // Case 3: RJ
      // Caso 3: RJ
      final p3 = pricingService.getUnitPrice(
        product: product,
        priceTable: table,
        quantity: Quantity.create(5).getOrThrow(),
        state: State.rioDeJaneiro,
      );
      expect(p3.amount, 110);
    });
  });
}
