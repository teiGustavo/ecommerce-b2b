import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/company.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';

abstract class CompanyRepository {
  Future<void> save(Company company);
  Future<void> update(Company company);
  Future<void> delete(CompanyId id);
  Future<Company?> getById(CompanyId id);
  Future<List<Company>> getAll();
}
