import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/sales_order/sales_order.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';

abstract class OrderRepository {
  Future<void> save(SalesOrder order);
  Future<void> update(SalesOrder order);
  Future<SalesOrder?> getById(OrderId id);
  Future<List<SalesOrder>> getAll();
}
