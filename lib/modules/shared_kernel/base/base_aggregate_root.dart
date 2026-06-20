import 'package:ecommerce_b2b/modules/shared_kernel/base/base_entity.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/base/base_entity_id.dart';

/// Classe base para uma Raiz de Agregado (Aggregate Root).
/// Em DDD, um Agregado é um cluster de objetos de domínio que podem ser tratados como uma única unidade.
abstract class AggregateRoot<ID extends EntityId> extends Entity<ID> {
  const AggregateRoot(super.id);
}
