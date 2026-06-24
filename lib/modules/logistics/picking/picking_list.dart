import 'package:ecommerce_b2b/modules/shared_kernel/base/base_aggregate_root.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/picking_list_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/warehouse_id.dart';

class PickingList extends AggregateRoot<PickingListId> {
  final OrderId orderId;
  final WarehouseId warehouseId;

  PickingList({
    required PickingListId id,
    required this.orderId,
    required this.warehouseId,
  }) : super(id);
}
