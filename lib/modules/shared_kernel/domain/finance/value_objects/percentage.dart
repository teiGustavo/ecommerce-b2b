import 'package:ecommerce_b2b/modules/shared_kernel/base/base_value_object.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/errors/percentage_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';
import 'package:flutter/foundation.dart';

/// Objeto de Valor que representa uma porcentagem válida.
@immutable
class Percentage extends ValueObject {
  final double value;

  const Percentage._(this.value);

  /// Cria uma instância de [Percentage] a partir de um valor decimal.
  /// Retorna [Failure] se o valor estiver fora do intervalo [0, 100].
  static Result<Percentage, PercentageError> create(double value) {
    if (value < 0 || value > 100) {
      return Failure(PercentageOutOfRangeError());
    }
    return Success(Percentage._(value));
  }

  double get decimal => value / 100;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Percentage &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => '${value.toStringAsFixed(2)}%';
}
