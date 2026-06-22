import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/presentation/formz/not_empty_input.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/presentation/formz/email_input.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/presentation/formz/phone_input.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/presentation/formz/zip_code_input.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/presentation/formz/money_input.dart';
import 'package:ecommerce_b2b/modules/customer_management/presentation/formz/cnpj_input.dart';
import 'package:ecommerce_b2b/modules/customer_management/presentation/formz/ie_input.dart';

class CompanyFormState extends Equatable {
  final NotEmptyInput legalName;
  final NotEmptyInput tradeName;
  final CnpjInput cnpj;
  final InscricaoEstadualInput ie;
  final EmailInput email;
  final PhoneInput phone;
  final ZipCodeInput billingZipCode;
  final ZipCodeInput shippingZipCode;
  final MoneyInput creditLimit;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  const CompanyFormState({
    this.legalName = const NotEmptyInput.pure(),
    this.tradeName = const NotEmptyInput.pure(),
    this.cnpj = const CnpjInput.pure(),
    this.ie = const InscricaoEstadualInput.pure(),
    this.email = const EmailInput.pure(),
    this.phone = const PhoneInput.pure(),
    this.billingZipCode = const ZipCodeInput.pure(),
    this.shippingZipCode = const ZipCodeInput.pure(),
    this.creditLimit = const MoneyInput.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  CompanyFormState copyWith({
    NotEmptyInput? legalName,
    NotEmptyInput? tradeName,
    CnpjInput? cnpj,
    InscricaoEstadualInput? ie,
    EmailInput? email,
    PhoneInput? phone,
    ZipCodeInput? billingZipCode,
    ZipCodeInput? shippingZipCode,
    MoneyInput? creditLimit,
    FormzSubmissionStatus? status,
    String? errorMessage,
  }) {
    return CompanyFormState(
      legalName: legalName ?? this.legalName,
      tradeName: tradeName ?? this.tradeName,
      cnpj: cnpj ?? this.cnpj,
      ie: ie ?? this.ie,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      billingZipCode: billingZipCode ?? this.billingZipCode,
      shippingZipCode: shippingZipCode ?? this.shippingZipCode,
      creditLimit: creditLimit ?? this.creditLimit,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  bool get isValid => Formz.validate([
        legalName,
        tradeName,
        cnpj,
        ie,
        email,
        phone,
        billingZipCode,
        shippingZipCode,
        creditLimit,
      ]);

  @override
  List<Object?> get props => [
        legalName,
        tradeName,
        cnpj,
        ie,
        email,
        phone,
        billingZipCode,
        shippingZipCode,
        creditLimit,
        status,
        errorMessage,
      ];
}
