import 'package:ecommerce_b2b/modules/catalog/domain/aggregates/price_table/price_table.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/aggregates/product/product.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/services/order_pricing_domain_service.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/company.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/quote/quote.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/quote/quote_item.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/quote_status.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/quote_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';

/// Caso de Uso responsável por criar um novo orçamento (RF9).
class CreateQuoteUseCase {
  final OrderPricingDomainService _pricingService;

  CreateQuoteUseCase(this._pricingService);

  /// Executa a criação do orçamento aplicando as regras de precificação dinâmica.
  Quote execute({
    required QuoteId id,
    required Company company,
    required List<({Product product, Quantity quantity, PriceTable priceTable})> items,
  }) {
    final quote = Quote(id: id, status: QuoteStatus.draft);

    for (final item in items) {
      final unitPrice = _pricingService.getUnitPrice(
        priceTable: item.priceTable,
        quantity: item.quantity,
        state: company.state,
      );

      quote.addItem(QuoteItem(
        productId: item.product.id,
        quantity: item.quantity,
        unitPrice: unitPrice,
      ));
    }

    quote.updateStatus(QuoteStatus.sent);
    return quote;
  }
}
