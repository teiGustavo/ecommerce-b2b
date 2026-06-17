import 'package:ecommerce_b2b/modules/shared_kernel/base/base_aggregate_root.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/ids/company_id.dart';

class Company extends AggregateRoot<CompanyId> {
  Company(super.id);
}
