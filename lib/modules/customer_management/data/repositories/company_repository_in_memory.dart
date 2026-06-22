import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/company.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/repositories/company_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';

class CompanyRepositoryInMemory implements CompanyRepository {
  final List<Company> _companies = [];

  @override
  Future<void> save(Company company) async {
    _companies.add(company);
  }

  @override
  Future<void> update(Company company) async {
    final index = _companies.indexWhere((c) => c.id == company.id);
    if (index != -1) {
      _companies[index] = company;
    }
  }

  @override
  Future<void> delete(CompanyId id) async {
    _companies.removeWhere((c) => c.id == id);
  }

  @override
  Future<Company?> getById(CompanyId id) async {
    try {
      return _companies.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Company>> getAll() async {
    return List.unmodifiable(_companies);
  }
}
