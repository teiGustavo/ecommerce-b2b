import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/value_objects/cnpj.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/value_objects/inscricao_estadual.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/base/base_aggregate_root.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/email_address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/phone_number.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/state_code.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/authorized_buyer.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/customer_credit_account.dart';

class Company extends AggregateRoot<CompanyId> {
  final String legalName;
  final String tradeName;
  final Cnpj cnpj;
  final InscricaoEstadual inscricaoEstadual;
  final EmailAddress email;
  final PhoneNumber phone;
  final Address billingAddress;
  final Address shippingAddress;
  final StateCode stateCode;
  final Money creditLimit;
  
  final List<AuthorizedBuyer> _authorizedBuyers;
  CustomerCreditAccount _creditAccount;

  Company({
    required CompanyId id,
    required this.legalName,
    required this.tradeName,
    required this.cnpj,
    required this.inscricaoEstadual,
    required this.email,
    required this.phone,
    required this.billingAddress,
    required this.shippingAddress,
    required this.stateCode,
    required this.creditLimit,
    required this._authorizedBuyers,
    required this._creditAccount,
  }) : super(id);

  List<AuthorizedBuyer> get authorizedBuyers => List.unmodifiable(_authorizedBuyers);
  CustomerCreditAccount get creditAccount => _creditAccount;

  void updateCreditAccount(CustomerCreditAccount newAccount) {
    _creditAccount = newAccount;
  }

  void addAuthorizedBuyer(AuthorizedBuyer buyer) {
    _authorizedBuyers.add(buyer);
  }

  void removeAuthorizedBuyer(AuthorizedBuyer buyer) {
    _authorizedBuyers.removeWhere((b) => b.id == buyer.id);
  }
}
