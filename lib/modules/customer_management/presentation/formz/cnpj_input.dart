import 'package:formz/formz.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/value_objects/cnpj.dart';

enum CnpjValidationError { invalid }

class CnpjInput extends FormzInput<String, CnpjValidationError> {
  const CnpjInput.pure() : super.pure('');
  const CnpjInput.dirty([super.value = '']) : super.dirty();

  @override
  CnpjValidationError? validator(String value) {
    if (value.isEmpty) return CnpjValidationError.invalid;
    final result = Cnpj.create(value);
    return result.isSuccess ? null : CnpjValidationError.invalid;
  }
}
