import 'package:ecommerce_b2b/modules/shared_kernel/base/base_aggregate_root.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/quote_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/quote_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/quote/quote_item.dart';

class Quote extends AggregateRoot<QuoteId> {
  QuoteStatus _status;
  final List<QuoteItem> _items;

  Quote({
    required QuoteId id,
    required this._status,
    List<QuoteItem>? items,
  })  : _items = items ?? [],
        super(id);

  QuoteStatus get status => _status;
  List<QuoteItem> get items => List.unmodifiable(_items);

  Money get total {
    if (_items.isEmpty) return Money.create(0).getOrThrow();
    
    Money sum = Money.create(0, currency: _items.first.unitPrice.currency).getOrThrow();
    for (var item in _items) {
      sum = sum + item.subtotal;
    }
    return sum;
  }

  void addItem(QuoteItem item) {
    if (_status != QuoteStatus.draft) {
      throw StateError('Cannot add items to a non-draft quote');
    }
    _items.add(item);
  }

  void updateStatus(QuoteStatus newStatus) {
    _status = newStatus;
  }
}
