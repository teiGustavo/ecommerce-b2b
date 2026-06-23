import 'package:ecommerce_b2b/modules/catalog/price_table/domain/price_rule.dart';
import 'package:ecommerce_b2b/modules/catalog/price_table/domain/price_table.dart';
import 'package:ecommerce_b2b/modules/catalog/price_table/domain/enums/price_scope_type.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/address/enums/state.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/price_table_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PriceTable', () {
    // Deve adicionar regras de preço corretamente.
    test('should add price rules', () {
      final priceTable = PriceTable(
        id: const PriceTableId('t1'),
        name: 'Price Table 1',
        scopeType: PriceScopeType.regional,
      );

      final rule = PriceRule(
        productId: const ProductId('p1'),
        minQuantity: Quantity.create(1).getOrThrow(),
        maxQuantity: Quantity.create(10).getOrThrow(),
        state: State.saoPaulo,
        unitPrice: Money.create(100).getOrThrow(),
      );

      priceTable.addRule(rule);

      expect(priceTable.rules.length, 1);
      expect(priceTable.rules.first, rule);
    });
  });
}
