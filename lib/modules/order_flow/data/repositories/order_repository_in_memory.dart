import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/sales_order/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/repositories/order_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';

class OrderRepositoryInMemory implements OrderRepository {
  final List<SalesOrder> _orders = [];

  @override
  Future<void> save(SalesOrder order) async {
    _orders.add(order);
  }

  @override
  Future<void> update(SalesOrder order) async {
    final index = _orders.indexWhere((o) => o.id == order.id);
    if (index != -1) {
      _orders[index] = order;
    }
  }

  @override
  Future<SalesOrder?> getById(OrderId id) async {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<SalesOrder>> getAll() async {
    return List.unmodifiable(_orders);
  }
}
