import 'package:ecommerce_b2b/modules/shared_kernel/base/base_aggregate_root.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/ids/picking_list_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/ids/order_id.dart';

class PickingList extends AggregateRoot<PickingListId> {
  final OrderId orderId;
  // Other fields like items to pick could be added here

  PickingList({
    required PickingListId id,
    required this.orderId,
  }) : super(id);
}
