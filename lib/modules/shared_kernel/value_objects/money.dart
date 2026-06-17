import 'package:ecommerce_b2b/modules/shared_kernel/base/base_value_object.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/errors/money_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';
import 'package:flutter/foundation.dart';

// TODO: Migrar para utilizar os pacotes decimal/decimal.dart ou money2/money2:

@immutable
class Money extends ValueObject {
  final int amountInCents;
  final String currency;

  const Money._(this.amountInCents, {this.currency = 'BRL'});

  static Result<Money, MoneyError> create(double amount, {String currency = 'BRL'}) {
    if (amount < 0) {
      return Failure(MoneyNegativeError());
    }

    final cents = (amount * 100).round();
    return Success(Money._(cents, currency: currency));
  }

  double get amount => amountInCents / 100;

  Money operator +(Money other) {
    if (currency != other.currency) {
      throw ArgumentError('Money currency mismatch: $currency vs ${other.currency}');
    }

    return Money._(amountInCents + other.amountInCents, currency: currency);
  }

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
  String toString() => '$currency ${amount.toStringAsFixed(2)}';
}
