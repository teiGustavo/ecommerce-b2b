import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'company_form_state.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/presentation/formz/not_empty_input.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/presentation/formz/email_input.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/presentation/formz/phone_input.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/presentation/formz/zip_code_input.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/presentation/formz/money_input.dart';
import 'package:ecommerce_b2b/modules/customer_management/presentation/formz/cnpj_input.dart';
import 'package:ecommerce_b2b/modules/customer_management/presentation/formz/ie_input.dart';
import 'package:ecommerce_b2b/app/config/service_locator.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/repositories/company_repository.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/company.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/customer_credit_account.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/value_objects/cnpj.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/value_objects/inscricao_estadual.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/email_address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/phone_number.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/address/value_objects/address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/representative_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/address/enums/state.dart' as addr_state;

class CompanyFormCubit extends Cubit<CompanyFormState> {
  final CompanyRepository _repository;

  CompanyFormCubit() 
      : _repository = getIt<CompanyRepository>(),
        super(const CompanyFormState());

  void legalNameChanged(String value) {
    final legalName = NotEmptyInput.dirty(value);
    emit(state.copyWith(legalName: legalName));
  }

  void tradeNameChanged(String value) {
    final tradeName = NotEmptyInput.dirty(value);
    emit(state.copyWith(tradeName: tradeName));
  }

  void cnpjChanged(String value) {
    final cnpj = CnpjInput.dirty(value);
    emit(state.copyWith(cnpj: cnpj));
  }

  void ieChanged(String value) {
    final ie = InscricaoEstadualInput.dirty(value);
    emit(state.copyWith(ie: ie));
  }

  void emailChanged(String value) {
    final email = EmailInput.dirty(value);
    emit(state.copyWith(email: email));
  }

  void phoneChanged(String value) {
    final phone = PhoneInput.dirty(value);
    emit(state.copyWith(phone: phone));
  }

  void billingZipCodeChanged(String value) {
    final zipCode = ZipCodeInput.dirty(value);
    emit(state.copyWith(billingZipCode: zipCode));
  }

  void shippingZipCodeChanged(String value) {
    final zipCode = ZipCodeInput.dirty(value);
    emit(state.copyWith(shippingZipCode: zipCode));
  }

  void creditLimitChanged(String value) {
    final limit = MoneyInput.dirty(value);
    emit(state.copyWith(creditLimit: limit));
  }

  Future<void> submit() async {
    if (!state.isValid) {
      emit(state.copyWith(
        legalName: NotEmptyInput.dirty(state.legalName.value),
        tradeName: NotEmptyInput.dirty(state.tradeName.value),
        cnpj: CnpjInput.dirty(state.cnpj.value),
        ie: InscricaoEstadualInput.dirty(state.ie.value),
        email: EmailInput.dirty(state.email.value),
        phone: PhoneInput.dirty(state.phone.value),
        billingZipCode: ZipCodeInput.dirty(state.billingZipCode.value),
        shippingZipCode: ZipCodeInput.dirty(state.shippingZipCode.value),
        creditLimit: MoneyInput.dirty(state.creditLimit.value),
      ));
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final id = CompanyId(DateTime.now().millisecondsSinceEpoch.toString());
      final creditMoney = Money.create(double.tryParse(state.creditLimit.value.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0).getOrThrow();

      final company = Company(
        id: id,
        legalName: state.legalName.value,
        tradeName: state.tradeName.value,
        cnpj: Cnpj.create(state.cnpj.value).getOrThrow(),
        inscricaoEstadual: InscricaoEstadual.create(state.ie.value).getOrThrow(),
        email: EmailAddress.create(state.email.value).getOrThrow(),
        phone: PhoneNumber.create(state.phone.value).getOrThrow(),
        billingAddress: Address.create(
          street: 'Rua de Faturamento',
          number: '123',
          neighborhood: 'Centro',
          city: 'São Paulo',
          state: 'SP',
          zipCode: state.billingZipCode.value,
        ).getOrThrow(),
        shippingAddress: Address.create(
          street: 'Rua de Entrega',
          number: '456',
          neighborhood: 'Bairro Industrial',
          city: 'São Paulo',
          state: 'SP',
          zipCode: state.shippingZipCode.value,
        ).getOrThrow(),
        state: addr_state.State.saoPaulo, 
        creditLimit: creditMoney,
        representativeId: const RepresentativeId('REP_ALPHA_001'), // Mock do rep logado
        authorizedBuyers: const [],
        creditAccount: CustomerCreditAccount(
          preApprovedLimit: creditMoney,
          openBalance: Money.create(0).getOrThrow(),
          pendingOrdersBalance: Money.create(0).getOrThrow(),
        ),
      );

      await _repository.save(company);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
