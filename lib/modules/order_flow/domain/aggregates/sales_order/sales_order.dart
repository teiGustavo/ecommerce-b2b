import 'package:ecommerce_b2b/modules/shared_kernel/base/base_aggregate_root.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/ids/order_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/sales_order/order_item.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/sales_order/finance_review.dart';

class SalesOrder extends AggregateRoot<OrderId> {
  OrderStatus _status;
  CreditStatus _creditStatus;
  final List<OrderItem> _items;
  FinanceReview? _financeReview;

  SalesOrder({
    required OrderId id,
    required this._status,
    required this._creditStatus,
    required this._items,
    this._financeReview,
  })  : super(id);

  OrderStatus get status => _status;
  CreditStatus get creditStatus => _creditStatus;
  List<OrderItem> get items => List.unmodifiable(_items);
  FinanceReview? get financeReview => _financeReview;

  Money get total {
    if (_items.isEmpty) return Money.create(0).getOrThrow();
    
    Money sum = Money.create(0, currency: _items.first.unitPriceSnapshot.currency).getOrThrow();
    for (var item in _items) {
      sum = sum + item.subtotal;
    }
    return sum;
  }

  void updateStatus(OrderStatus newStatus) {
    _status = newStatus;
  }

  void updateCreditStatus(CreditStatus newStatus) {
    _creditStatus = newStatus;
  }

  void applyFinanceReview(FinanceReview review) {
    _financeReview = review;
  }
}
