import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/enums/currency.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/errors/money_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Money', () {
    test('should create valid money', () {
      final result = Money.create(100.50);
      expect(result.isSuccess, isTrue);
      expect(result.getOrThrow().amount, 100.50);
      expect(result.getOrThrow().amountInCents, 10050);
    });

    test('should return MoneyNegativeError for negative amount during creation', () {
      final result = Money.create(-1.0);
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<MoneyNegativeError>());
    });

    test('should add money with same currency', () {
      final m1 = Money.create(50.0).getOrThrow();
      final m2 = Money.create(30.0).getOrThrow();
      final sum = m1 + m2;
      expect(sum.amount, 80.0);
    });

    test('should throw ArgumentError when adding different currencies', () {
      final m1 = Money.create(50.0, currency: Currency.brazil).getOrThrow();
      final m2 = Money.create(30.0, currency: Currency.unitedStates).getOrThrow();
      expect(() => m1 + m2, throwsArgumentError);
    });

    test('should subtract money', () {
      final m1 = Money.create(100.0).getOrThrow();
      final m2 = Money.create(30.0).getOrThrow();
      final diff = m1 - m2;
      expect(diff.amount, 70.0);
    });

    test('should throw StateError if subtraction result is negative', () {
      final m1 = Money.create(30.0).getOrThrow();
      final m2 = Money.create(100.0).getOrThrow();
      expect(() => m1 - m2, throwsStateError);
    });

    test('should handle floating point precision correctly using cents', () {
      final m1 = Money.create(0.1).getOrThrow();
      final m2 = Money.create(0.2).getOrThrow();
      final sum = m1 + m2;
      expect(sum.amount, 0.3);
      expect(sum.amountInCents, 30);
    });
  });
}
