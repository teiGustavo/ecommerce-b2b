import 'package:ecommerce_b2b/modules/shared_kernel/base/base_aggregate_root.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/ids/rma_id.dart';
import 'package:ecommerce_b2b/modules/customer_portal/domain/enums/rma_status.dart';
import 'package:ecommerce_b2b/modules/customer_portal/domain/aggregates/return_request/return_request_item.dart';

class ReturnRequest extends AggregateRoot<RmaId> {
  RmaStatus _status;
  final String reason;
  final List<ReturnRequestItem> _items;

  ReturnRequest({
    required RmaId id,
    required RmaStatus status,
    required this.reason,
    List<ReturnRequestItem>? items,
  })  : _status = status,
        _items = items ?? [],
        super(id);

  RmaStatus get status => _status;
  List<ReturnRequestItem> get items => List.unmodifiable(_items);

  void updateStatus(RmaStatus newStatus) {
    _status = newStatus;
  }

  void addItem(ReturnRequestItem item) {
    _items.add(item);
  }
}
