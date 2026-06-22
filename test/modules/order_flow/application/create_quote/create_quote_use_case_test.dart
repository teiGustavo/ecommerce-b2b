import 'package:ecommerce_b2b/modules/catalog/domain/aggregates/price_table/price_rule.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/aggregates/price_table/price_table.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/aggregates/product/product.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/enums/price_scope_type.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/services/order_pricing_domain_service.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/company.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/customer_credit_account.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/value_objects/cnpj.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/value_objects/inscricao_estadual.dart';
import 'package:ecommerce_b2b/modules/order_flow/application/create_quote/create_quote_use_case.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/quote_status.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/address/enums/state.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/address/value_objects/address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/price_table_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/quote_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/email_address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/phone_number.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock simple service for pricing
class MockOrderPricingService extends OrderPricingDomainService {
  @override
  Money getUnitPrice({
    required PriceTable priceTable,
    required Quantity quantity,
    required State state,
  }) {
    return priceTable.rules.first.unitPrice;
  }
}

void main() {
  late CreateQuoteUseCase useCase;
  late MockOrderPricingService pricingService;

  setUp(() {
    pricingService = MockOrderPricingService();
    useCase = CreateQuoteUseCase(pricingService);
  });

  /// deve criar um orçamento com sucesso aplicando precificação
  test('should create a quote successfully applying pricing', () {
    final company = Company(
      id: const CompanyId('c1'),
      legalName: 'Legal',
      tradeName: 'Trade',
      cnpj: Cnpj.create('12345678000195').getOrThrow(),
      inscricaoEstadual: InscricaoEstadual.create('123456789').getOrThrow(),
      email: EmailAddress.create('test@test.com').getOrThrow(),
      phone: PhoneNumber.create('11999999999').getOrThrow(),
      billingAddress: Address.create(street: 'R', number: '1', neighborhood: 'N', city: 'C', state: 'SP', zipCode: '01000-000').getOrThrow(),
      shippingAddress: Address.create(street: 'R', number: '1', neighborhood: 'N', city: 'C', state: 'SP', zipCode: '01000-000').getOrThrow(),
      state: State.saoPaulo,
      creditLimit: Money.create(1000).getOrThrow(),
      authorizedBuyers: [],
      creditAccount: CustomerCreditAccount(
        preApprovedLimit: Money.create(1000).getOrThrow(),
        openBalance: Money.create(0).getOrThrow(),
        pendingOrdersBalance: Money.create(0).getOrThrow(),
      ),
    );

    final product = Product(id: const ProductId('p1'), sku: 'S1', name: 'N1', description: 'D1', active: true);
    final priceTable = PriceTable(
      id: const PriceTableId('t1'),
      name: 'T1',
      scopeType: PriceScopeType.regional,
      rules: [
        PriceRule(
          minQuantity: Quantity.create(1).getOrThrow(),
          maxQuantity: Quantity.create(100).getOrThrow(),
          state: State.saoPaulo,
          unitPrice: Money.create(50.0).getOrThrow(),
        ),
      ],
    );

    final quote = useCase.execute(
      id: const QuoteId('q1'),
      company: company,
      items: [
        (product: product, quantity: Quantity.create(2).getOrThrow(), priceTable: priceTable),
      ],
    );

    expect(quote.status, QuoteStatus.sent);
    expect(quote.items.length, 1);
    expect(quote.items.first.unitPrice.amount, 50.0);
    expect(quote.total.amount, 100.0);
  });
}
