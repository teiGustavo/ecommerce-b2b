import 'package:ecommerce_b2b/modules/customer_management/company/domain/company.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/customer_credit_account.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/value_objects/cnpj.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/value_objects/inscricao_estadual.dart';
import 'package:ecommerce_b2b/modules/inventory/warehouse/domain/stock_item.dart';
import 'package:ecommerce_b2b/modules/inventory/warehouse/domain/warehouse.dart';
import 'package:ecommerce_b2b/modules/inventory/warehouse/domain/services/inventory_allocator_domain_service.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/application/convert_quote/convert_quote_to_order_use_case.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/domain/quote.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/domain/quote_item.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/domain/enums/quote_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/services/credit_policy_domain_service.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/address/enums/state.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/address/value_objects/address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/quote_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/warehouse_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/email_address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/phone_number.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';
import 'package:flutter_test/flutter_test.dart';

class MockCreditPolicy extends CreditPolicyDomainService {
  final OrderStatus targetStatus;
  MockCreditPolicy({required this.targetStatus});

  @override
  void evaluate(SalesOrder order, Company company) {
    order.updateStatus(targetStatus);
  }
}

class MockInventoryAllocator extends InventoryAllocatorDomainService {
  bool allocateCalled = false;
  @override
  void allocateStock(List<Warehouse> warehouses, OrderId orderId, ProductId productId, Quantity requestedQuantity) {
    allocateCalled = true;
  }
}

void main() {
  group('ConvertQuoteToOrderUseCase', () {
    late Company company;
    late Quote quote;
    late Warehouse warehouse;

    setUp(() {
      company = Company(
        id: const CompanyId('c1'),
        legalName: 'L', tradeName: 'T',
        cnpj: Cnpj.create('12345678000195').getOrThrow(),
        inscricaoEstadual: InscricaoEstadual.create('123456789').getOrThrow(),
        email: EmailAddress.create('t@t.com').getOrThrow(),
        phone: PhoneNumber.create('11999999999').getOrThrow(),
        billingAddress: Address.create(street: 'R', number: '1', neighborhood: 'N', city: 'C', state: 'SP', zipCode: '01000-000').getOrThrow(),
        shippingAddress: Address.create(street: 'R', number: '1', neighborhood: 'N', city: 'C', state: 'SP', zipCode: '01000-000').getOrThrow(),
        state: State.saoPaulo,
        creditLimit: Money.create(1000).getOrThrow(),
        authorizedBuyers: [],
        creditAccount: CustomerCreditAccount(preApprovedLimit: Money.create(1000).getOrThrow(), openBalance: Money.create(0).getOrThrow(), pendingOrdersBalance: Money.create(0).getOrThrow()),
      );

      quote = Quote(id: const QuoteId('q1'), status: QuoteStatus.draft);
      quote.addItem(QuoteItem(productId: const ProductId('p1'), quantity: Quantity.create(1).getOrThrow(), unitPrice: Money.create(100).getOrThrow()));
      quote.updateStatus(QuoteStatus.sent);

      warehouse = Warehouse(id: const WarehouseId('w1'), code: 'W1', name: 'N1', stockItems: [
        StockItem(productId: const ProductId('p1'), physicalQuantity: Quantity.create(10).getOrThrow())
      ]);
    });

    /// deve converter orçamento em pedido e alocar estoque se aprovado pelo crédito
    test('should convert quote to order and allocate stock if approved by credit', () {
      final creditPolicy = MockCreditPolicy(targetStatus: OrderStatus.pickingPacking);
      final inventoryAllocator = MockInventoryAllocator();
      final useCase = ConvertQuoteToOrderUseCase(creditPolicy, inventoryAllocator);

      final order = useCase.execute(orderId: const OrderId('o1'), quote: quote, company: company, warehouses: [warehouse]);

      expect(order.status, OrderStatus.pickingPacking);
      expect(quote.status, QuoteStatus.convertedToOrder);
      expect(inventoryAllocator.allocateCalled, isTrue);
    });

    /// deve converter orçamento em pedido mas NÃO alocar estoque se bloqueado pelo crédito
    test('should convert quote to order but NOT allocate stock if blocked by credit', () {
      final creditPolicy = MockCreditPolicy(targetStatus: OrderStatus.blockedByFinance);
      final inventoryAllocator = MockInventoryAllocator();
      final useCase = ConvertQuoteToOrderUseCase(creditPolicy, inventoryAllocator);

      final order = useCase.execute(orderId: const OrderId('o1'), quote: quote, company: company, warehouses: [warehouse]);

      expect(order.status, OrderStatus.blockedByFinance);
      expect(inventoryAllocator.allocateCalled, isFalse);
    });

    /// deve lançar erro se orçamento não estiver enviado
    test('should throw error if quote is not sent', () {
      final creditPolicy = MockCreditPolicy(targetStatus: OrderStatus.pickingPacking);
      final inventoryAllocator = MockInventoryAllocator();
      final useCase = ConvertQuoteToOrderUseCase(creditPolicy, inventoryAllocator);
      
      quote.updateStatus(QuoteStatus.draft);

      expect(() => useCase.execute(orderId: const OrderId('o1'), quote: quote, company: company, warehouses: [warehouse]), throwsStateError);
    });
  });
}
