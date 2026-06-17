import 'package:ecommerce_b2b/modules/shared_kernel/base/base_entity_id.dart';

abstract class Entity<ID extends EntityId> {
  final ID id;

  const Entity(this.id);

  @override
  bool operator ==(Object other) => other is Entity<ID> && other.id == id;

  @override
  int get hashCode => id.hashCode;
}