import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/sales_order/order_item.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/sales_order/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/sales_team/domain/aggregates/sales_representative/sales_representative.dart';
import 'package:ecommerce_b2b/modules/sales_team/domain/enums/commission_status.dart';
import 'package:ecommerce_b2b/modules/sales_team/domain/services/commission_calculator_domain_service.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/representative_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/email_address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/percentage.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CommissionCalculatorDomainService calculator;

  setUp(() {
    calculator = CommissionCalculatorDomainService();
  });

  group('CommissionCalculatorDomainService', () {
    test('deve calcular a comissão corretamente baseada no total do pedido e taxa do representante', () {
      final order = SalesOrder(
        id: const OrderId('o1'),
        status: OrderStatus.pickingPacking,
        creditStatus: CreditStatus.approved,
        items: [
          OrderItem(
            productId: const ProductId('p1'),
            quantity: Quantity.create(10).getOrThrow(),
            unitPriceSnapshot: Money.create(100.0).getOrThrow(),
          ),
        ],
      ); // Total = 1000

      final representative = SalesRepresentative(
        id: const RepresentativeId('r1'),
        fullName: 'John Doe',
        email: EmailAddress.create('john@test.com').getOrThrow(),
        commissionRate: Percentage.create(5.0).getOrThrow(), // 5%
      );

      final commission = calculator.calculate(order, representative);

      expect(commission.amount.amount, 50.0);
      expect(commission.status, CommissionStatus.pending);
      expect(commission.rate.value, 5.0);
      expect(commission.baseAmount, order.total);
    });
  });
}
