import 'package:ecommerce_b2b/modules/shared_kernel/base/base_value_object.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/enums/currency.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/errors/money_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';
import 'package:flutter/foundation.dart';

// TODO: Migrar para utilizar os pacotes decimal/decimal.dart ou money2/money2:

/// Objeto de Valor que representa quantias monetárias.
/// Utiliza inteiros (centavos) internamente para evitar erros de precisão decimal.
@immutable
class Money extends ValueObject {
  /// Valor total em centavos.
  final int amountInCents;
  /// Código da moeda (ex: BRL, USD).
  final Currency currency;

  const Money._(this.amountInCents, {this.currency = Currency.brazil});

  /// Cria uma instância de [Money] a partir de um valor decimal.
  /// Retorna [Failure] se o valor for negativo.
  static Result<Money, MoneyError> create(double amount, {Currency currency = Currency.brazil}) {
    if (amount < 0) {
      return Failure(MoneyNegativeError());
    }

    final cents = (amount * 100).round();
    return Success(Money._(cents, currency: currency));
  }

  /// Retorna o valor convertido para decimal (unidade principal da moeda).
  double get amount => amountInCents / 100;

  /// Soma duas quantias monetárias.
  /// Lança [ArgumentError] se as moedas forem diferentes.
  Money operator +(Money other) {
    if (currency != other.currency) {
      throw ArgumentError('Money currency mismatch: $currency vs ${other.currency}');
    }

    return Money._(amountInCents + other.amountInCents, currency: currency);
  }

  /// Subtrai duas quantias monetárias.
  /// Lança [ArgumentError] se as moedas forem diferentes.
  /// Lança [StateError] se o resultado for negativo.
  Money operator -(Money other) {
    if (currency != other.currency) {
      throw ArgumentError('Money currency mismatch: $currency vs ${other.currency}');
    }

    final result = amountInCents - other.amountInCents;
    if (result < 0) {
      throw StateError('Money amount cannot be negative after subtraction');
    }

    return Money._(result, currency: currency);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Money &&
          runtimeType == other.runtimeType &&
          amountInCents == other.amountInCents &&
          currency == other.currency;

  @override
  int get hashCode => amountInCents.hashCode ^ currency.hashCode;

  @override
  String toString() => '${currency.symbol} ${amount.toStringAsFixed(2)}';
}
