import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/sales_representative.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/representative_id.dart';

abstract class SalesRepresentativeRepository {
  Future<SalesRepresentative?> findById(RepresentativeId id);
  Future<List<SalesRepresentative>> findAll();
}
