import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/repositories/sales_order_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/sales_order.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';

class MockSalesOrderAdapter implements SalesOrderRepository {
  final List<SalesOrder> _orders = [
    SalesOrder(
      id: const OrderId('order-101'),
      status: OrderStatus.blockedByFinance,
      creditStatus: CreditStatus.blocked,
      items: [],
    ),
    SalesOrder(
      id: const OrderId('order-102'),
      status: OrderStatus.pendingFinanceApproval,
      creditStatus: CreditStatus.approved,
      items: [],
    ),
  ];

  @override
  Future<List<SalesOrder>> findByCompanyId(CompanyId companyId) async {
    return _orders;
  }

  @override
  Future<List<SalesOrder>> findByStatus(OrderStatus status) async {
    return _orders.where((o) => o.status == status).toList();
  }
}
