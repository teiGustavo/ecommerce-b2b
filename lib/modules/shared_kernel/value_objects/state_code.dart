import 'package:ecommerce_b2b/modules/shared_kernel/base/base_value_object.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/errors/state_code_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';
import 'package:flutter/foundation.dart';

@immutable
class StateCode extends ValueObject {
  final String value;

  const StateCode._(this.value);

  static Result<StateCode, StateCodeError> create(String input) {
    final code = input.trim().toUpperCase();
    if (code.length != 2) {
      return Failure(StateCodeInvalidError());
    }
    // List of Brazilian states (optional validation)
    const validStates = {
      'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA',
      'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN',
      'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'
    };
    
    if (!validStates.contains(code)) {
      return Failure(StateCodeInvalidError());
    }

    return Success(StateCode._(code));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateCode &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
