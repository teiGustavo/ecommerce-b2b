import 'package:ecommerce_b2b/modules/shared_kernel/base/base_aggregate_root.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/rma_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:ecommerce_b2b/modules/customer_portal/domain/enums/rma_status.dart';

class Rma extends AggregateRoot<RmaId> {
  final OrderId orderId;
  final String reason;
  RmaStatus _status;

  Rma({
    required RmaId id,
    required this.orderId,
    required this.reason,
    required RmaStatus status,
  })  : _status = status,
        super(id);

  RmaStatus get status => _status;

  void updateStatus(RmaStatus newStatus) {
    _status = newStatus;
  }
}
