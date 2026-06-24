import 'package:ecommerce_b2b/modules/customer_management/company/domain/authorized_buyer.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/company.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/repositories/company_repository.dart';
import 'package:ecommerce_b2b/modules/identity_access/domain/user_session.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/base/base_domain_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/buyer_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/email_address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/phone_number.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/auth/errors/auth_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';

class CompanyNotFoundError extends DomainError {
  CompanyNotFoundError() : super('Empresa não encontrada.');
}

class AddAuthorizedBuyerUseCase {
  final CompanyRepository _companyRepository;

  AddAuthorizedBuyerUseCase(this._companyRepository);

  Future<Result<Company, DomainError>> execute({
    required UserSession currentSession,
    required CompanyId companyId,
    required String fullName,
    required String email,
    required String phone,
    required String positionTitle,
  }) async {
    if (currentSession.isBuyer) {
      return Failure(UnauthorizedError('Compradores não são autorizados a adicionar outros compradores.'));
    }

    final company = await _companyRepository.findById(companyId);
    if (company == null) {
      return Failure(CompanyNotFoundError());
    }

    final emailResult = EmailAddress.create(email);
    if (emailResult.isFailure) return Failure(emailResult.getFailureOrThrow());

    final phoneResult = PhoneNumber.create(phone);
    if (phoneResult.isFailure) return Failure(phoneResult.getFailureOrThrow());

    final buyer = AuthorizedBuyer(
      id: BuyerId('buyer-${DateTime.now().millisecondsSinceEpoch}'),
      fullName: fullName,
      email: emailResult.getOrThrow(),
      phone: phoneResult.getOrThrow(),
      positionTitle: positionTitle,
      active: true,
    );

    company.addAuthorizedBuyer(buyer);
    await _companyRepository.save(company);

    return Success(company);
  }
}
