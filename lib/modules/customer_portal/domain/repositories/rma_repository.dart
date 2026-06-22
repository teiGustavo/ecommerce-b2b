import 'package:ecommerce_b2b/modules/customer_portal/domain/aggregates/rma.dart';

abstract class RmaRepository {
  Future<void> save(Rma rma);
  Future<List<Rma>> getAll();
}
