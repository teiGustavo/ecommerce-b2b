import 'package:ecommerce_b2b/modules/customer_management/company/domain/company.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';

abstract class CompanyRepository {
  Future<void> save(Company company);
  Future<Company?> findById(CompanyId id);
  Future<List<Company>> findAll();
  Future<List<Company>> findByRepresentativeId(String representativeId);
}
