import 'package:ecommerce_b2b/modules/customer_portal/domain/aggregates/rma.dart';
import 'package:ecommerce_b2b/modules/customer_portal/domain/repositories/rma_repository.dart';

class RmaRepositoryInMemory implements RmaRepository {
  final List<Rma> _rmas = [];

  @override
  Future<List<Rma>> getAll() async {
    return List.unmodifiable(_rmas);
  }

  @override
  Future<void> save(Rma rma) async {
    final index = _rmas.indexWhere((r) => r.id == rma.id);
    if (index >= 0) {
      _rmas[index] = rma;
    } else {
      _rmas.add(rma);
    }
  }
}
