import 'package:ecommerce_b2b/modules/shared_kernel/base/base_aggregate_root.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/sales_order/order_item.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/sales_order/finance_review.dart';

/// Raiz do Agregado que representa um Pedido de Venda.
class SalesOrder extends AggregateRoot<OrderId> {
  OrderStatus _status;
  CreditStatus _creditStatus;
  final List<OrderItem> _items;
  FinanceReview? _financeReview;

  /// Construtor do Pedido de Venda.
  SalesOrder({
    required OrderId id,
    required this._status,
    required this._creditStatus,
    required this._items,
    this._financeReview,
  })  : super(id);

  /// Status atual do pedido (ex: pendente aprovação, em trânsito).
  OrderStatus get status => _status;
  
  /// Status de crédito do pedido.
  CreditStatus get creditStatus => _creditStatus;
  
  /// Itens que compõem o pedido.
  List<OrderItem> get items => List.unmodifiable(_items);
  
  /// Revisão financeira associada ao pedido, se houver.
  FinanceReview? get financeReview => _financeReview;

  /// Calcula o valor total do pedido somando os subtotais de cada item.
  Money get total {
    if (_items.isEmpty) return Money.create(0).getOrThrow();
    
    Money sum = Money.create(0, currency: _items.first.unitPriceSnapshot.currency).getOrThrow();
    for (var item in _items) {
      sum = sum + item.subtotal;
    }
    return sum;
  }

  /// Atualiza o status do pedido.
  void updateStatus(OrderStatus newStatus) {
    _status = newStatus;
  }

  /// Atualiza o status de crédito do pedido.
  void updateCreditStatus(CreditStatus newStatus) {
    _creditStatus = newStatus;
  }

  /// Aplica uma decisão de revisão financeira ao pedido.
  void applyFinanceReview(FinanceReview review) {
    _financeReview = review;
  }
}
