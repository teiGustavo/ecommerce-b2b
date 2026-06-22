import 'package:ecommerce_b2b/modules/customer_portal/purchase_history/application/get_purchase_history/get_purchase_history_use_case.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/sales_order/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/repositories/sales_order_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:flutter_test/flutter_test.dart';

class MockSalesOrderRepository implements SalesOrderRepository {
  @override
  Future<List<SalesOrder>> findByCompanyId(CompanyId companyId) async {
    return [
      SalesOrder(
        id: const OrderId('o1'),
        status: OrderStatus.delivered,
        creditStatus: CreditStatus.approved,
        items: [],
      ),
    ];
  }
}

void main() {
  late GetPurchaseHistoryUseCase useCase;
  late MockSalesOrderRepository repository;

  setUp(() {
    repository = MockSalesOrderRepository();
    useCase = GetPurchaseHistoryUseCase(repository);
  });

  // Deve retornar o histórico de compras para uma empresa específica.
  test('should return purchase history for a given company', () async {
    const companyId = CompanyId('c1');
    final result = await useCase.execute(companyId);

    expect(result, isNotEmpty);
    expect(result.first.id, const OrderId('o1'));
  });
}
