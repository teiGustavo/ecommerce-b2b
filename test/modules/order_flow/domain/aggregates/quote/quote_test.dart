import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/quote/quote.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/quote/quote_item.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/quote_status.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/ids/quote_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/quantity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Quote', () {
    test('should calculate total correctly', () {
      final quote = Quote(id: QuoteId('q1'), status: QuoteStatus.draft);
      
      quote.addItem(QuoteItem(
        productId: ProductId('p1'),
        quantity: Quantity.create(2).getOrThrow(),
        unitPrice: Money.create(10.0).getOrThrow(),
      ));
      
      quote.addItem(QuoteItem(
        productId: ProductId('p2'),
        quantity: Quantity.create(1).getOrThrow(),
        unitPrice: Money.create(5.0).getOrThrow(),
      ));

      expect(quote.total.amount, 25.0);
    });

    test('should throw StateError when adding item to non-draft quote', () {
      final quote = Quote(id: QuoteId('q1'), status: QuoteStatus.sent);
      
      expect(
        () => quote.addItem(QuoteItem(
          productId: ProductId('p1'),
          quantity: Quantity.create(1).getOrThrow(),
          unitPrice: Money.create(10.0).getOrThrow(),
        )),
        throwsStateError,
      );
    });
  });
}
