import 'package:ecommerce_b2b/modules/shared_kernel/base/base_aggregate_root.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/packing_session_id.dart';

class PackingSession extends AggregateRoot<PackingSessionId> {
  // Fields related to packing process
  
  PackingSession({
    required PackingSessionId id,
  }) : super(id);
}
