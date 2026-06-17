import 'package:ecommerce_b2b/modules/shared_kernel/base/base_entity.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/base/base_entity_id.dart';

abstract class AggregateRoot<ID extends EntityId> extends Entity<ID> {
  const AggregateRoot(super.id);
}
