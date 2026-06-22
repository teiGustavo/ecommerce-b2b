import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/company.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/customer_credit_account.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/value_objects/cnpj.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/value_objects/inscricao_estadual.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/sales_order/order_item.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/sales_order/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/services/credit_policy_domain_service.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/address/enums/state.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/address/value_objects/address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/email_address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/phone_number.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CreditPolicyDomainService creditPolicy;

  setUp(() {
    creditPolicy = CreditPolicyDomainService();
  });

  Company createCompany({required Money limit, required Money open, required Money pending}) {
    return Company(
      id: const CompanyId('comp-1'),
      legalName: 'Test Corp',
      tradeName: 'Test',
      cnpj: Cnpj.create('12345678000195').getOrThrow(),
      inscricaoEstadual: InscricaoEstadual.create('123456789').getOrThrow(),
      email: EmailAddress.create('test@test.com').getOrThrow(),
      phone: PhoneNumber.create('11999999999').getOrThrow(),
      billingAddress: Address.create(street: 'Rua A', number: '1', neighborhood: 'Bairro', city: 'São Paulo', state: 'SP', zipCode: '01000-000').getOrThrow(),
      shippingAddress: Address.create(street: 'Rua A', number: '1', neighborhood: 'Bairro', city: 'São Paulo', state: 'SP', zipCode: '01000-000').getOrThrow(),
      state: State.saoPaulo,
      creditLimit: limit,
      authorizedBuyers: [],
      creditAccount: CustomerCreditAccount(
        preApprovedLimit: limit,
        openBalance: open,
        pendingOrdersBalance: pending,
      ),
    );
  }

  SalesOrder createOrder(double totalAmount) {
    return SalesOrder(
      id: const OrderId('order-1'),
      status: OrderStatus.pendingFinanceApproval,
      creditStatus: CreditStatus.pending,
      items: [
        OrderItem(
          productId: const ProductId('p1'),
          quantity: Quantity.create(1).getOrThrow(),
          unitPriceSnapshot: Money.create(totalAmount).getOrThrow(),
        ),
      ],
    );
  }

  group('CreditPolicy', () {
    test('deve aprovar pedido quando há limite disponível', () {
      final company = createCompany(
        limit: Money.create(1000).getOrThrow(),
        open: Money.create(200).getOrThrow(),
        pending: Money.create(100).getOrThrow(),
      );
      // Disponível: 1000 - (200 + 100) = 700
      final order = createOrder(500);

      creditPolicy.evaluate(order, company);

      expect(order.creditStatus, CreditStatus.approved);
      expect(order.status, OrderStatus.pickingPacking);
    });

    test('deve bloquear pedido quando valor excede limite disponível', () {
      final company = createCompany(
        limit: Money.create(1000).getOrThrow(),
        open: Money.create(200).getOrThrow(),
        pending: Money.create(100).getOrThrow(),
      );
      // Disponível: 1000 - (200 + 100) = 700
      final order = createOrder(800);

      creditPolicy.evaluate(order, company);

      expect(order.creditStatus, CreditStatus.blocked);
      expect(order.status, OrderStatus.blockedByFinance);
    });
  });
}
