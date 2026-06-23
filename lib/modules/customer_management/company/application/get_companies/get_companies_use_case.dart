import 'package:ecommerce_b2b/modules/customer_management/company/domain/company.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/repositories/company_repository.dart';
import 'package:ecommerce_b2b/modules/identity_access/domain/user_session.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/auth/errors/auth_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';

class GetCompaniesUseCase {
  final CompanyRepository _companyRepository;

  GetCompaniesUseCase(this._companyRepository);

  Future<Result<List<Company>, AuthError>> execute(UserSession currentSession) async {
    if (currentSession.isBuyer) {
      if (currentSession.companyId == null) {
        return Failure(UnauthorizedError('Buyer user session has no company associated.'));
      }
      final company = await _companyRepository.findById(currentSession.companyId!);
      if (company != null) {
        return Success([company]);
      }
      return Success([]);
    }

    if (currentSession.isRepresentative) {
      final companies = await _companyRepository.findByRepresentativeId(currentSession.userId.value);
      return Success(companies);
    }

    if (currentSession.isFinance) {
      final companies = await _companyRepository.findAll();
      return Success(companies);
    }

    return Failure(UnauthorizedError('You do not have permission to view companies.'));
  }
}
