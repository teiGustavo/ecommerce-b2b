import 'package:formz/formz.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/value_objects/inscricao_estadual.dart';

enum InscricaoEstadualValidationError { invalid }

class InscricaoEstadualInput extends FormzInput<String, InscricaoEstadualValidationError> {
  const InscricaoEstadualInput.pure() : super.pure('');
  const InscricaoEstadualInput.dirty([super.value = '']) : super.dirty();

  @override
  InscricaoEstadualValidationError? validator(String value) {
    if (value.isEmpty) return InscricaoEstadualValidationError.invalid;
    final result = InscricaoEstadual.create(value);
    return result.isSuccess ? null : InscricaoEstadualValidationError.invalid;
  }
}
