import 'package:ecommerce_b2b/modules/catalog/domain/aggregates/price_table/price_rule.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/aggregates/price_table/price_table.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/aggregates/product/product.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/enums/price_scope_type.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/services/order_pricing_domain_service.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/company.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/customer_credit_account.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/value_objects/cnpj.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/value_objects/inscricao_estadual.dart';
import 'package:ecommerce_b2b/modules/inventory/domain/aggregates/warehouse/stock_item.dart';
import 'package:ecommerce_b2b/modules/inventory/domain/aggregates/warehouse/warehouse.dart';
import 'package:ecommerce_b2b/modules/inventory/domain/services/inventory_allocator_domain_service.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/services/credit_policy_domain_service.dart';
import 'package:ecommerce_b2b/modules/order_flow/application/convert_quote/convert_quote_to_order_use_case.dart';
import 'package:ecommerce_b2b/modules/order_flow/application/create_quote/create_quote_use_case.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/address/enums/state.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/address/value_objects/address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/price_table_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/quote_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/warehouse_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/email_address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/phone_number.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Order Flow Integration', () {
    /// deve realizar fluxo completo de orçamento até pedido com aprovação de crédito
    test('should perform complete flow from quote to order with credit approval', () {
      // 1. Setup
      final pricingService = OrderPricingDomainService();
      final creditPolicy = CreditPolicyDomainService();
      final inventoryAllocator = InventoryAllocatorDomainService();
      final createQuote = CreateQuoteUseCase(pricingService);
      final convertQuote = ConvertQuoteToOrderUseCase(creditPolicy, inventoryAllocator);

      final company = Company(
        id: const CompanyId('c1'),
        legalName: 'B2B Client',
        tradeName: 'Client',
        cnpj: Cnpj.create('12345678000195').getOrThrow(),
        inscricaoEstadual: InscricaoEstadual.create('123456789').getOrThrow(),
        email: EmailAddress.create('client@test.com').getOrThrow(),
        phone: PhoneNumber.create('11999999999').getOrThrow(),
        billingAddress: Address.create(street: 'Rua A', number: '1', neighborhood: 'B', city: 'SP', state: 'SP', zipCode: '01000-000').getOrThrow(),
        shippingAddress: Address.create(street: 'Rua A', number: '1', neighborhood: 'B', city: 'SP', state: 'SP', zipCode: '01000-000').getOrThrow(),
        state: State.saoPaulo,
        creditLimit: Money.create(5000).getOrThrow(),
        authorizedBuyers: [],
        creditAccount: CustomerCreditAccount(
          preApprovedLimit: Money.create(5000).getOrThrow(),
          openBalance: Money.create(0).getOrThrow(),
          pendingOrdersBalance: Money.create(0).getOrThrow(),
        ),
      );

      final product = Product(id: const ProductId('p1'), sku: 'SKU1', name: 'Prod 1', description: 'Desc', active: true);
      final priceTable = PriceTable(
        id: const PriceTableId('t1'),
        name: 'Tabela',
        scopeType: PriceScopeType.regional,
        rules: [
          PriceRule(
            minQuantity: Quantity.create(1).getOrThrow(),
            maxQuantity: Quantity.create(100).getOrThrow(),
            state: State.saoPaulo,
            unitPrice: Money.create(100).getOrThrow(),
          ),
        ],
      );

      final warehouse = Warehouse(
        id: const WarehouseId('w1'),
        code: 'W1',
        name: 'Depósito 1',
        stockItems: [
          StockItem(
            productId: product.id,
            physicalQuantity: Quantity.create(50).getOrThrow(),
          ),
        ],
      );

      // 2. Create Quote
      final quote = createQuote.execute(
        id: const QuoteId('q1'),
        company: company,
        items: [(product: product, quantity: Quantity.create(10).getOrThrow(), priceTable: priceTable)],
      );

      expect(quote.total.amount, 1000);

      // 3. Convert to Order
      final order = convertQuote.execute(
        orderId: const OrderId('o1'),
        quote: quote,
        company: company,
        warehouses: [warehouse],
      );

      // 4. Verify Results
      expect(order.status, OrderStatus.pickingPacking); // Credit approved and stock allocated
      expect(warehouse.getStockItem(product.id)!.reservedQuantity.value, 10);
      expect(warehouse.getStockItem(product.id)!.availableQuantity.value, 40);
    });
  });
}
