import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/errors/quantity_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Quantity', () {
    test('should create valid quantity', () {
      final result = Quantity.create(10);
      expect(result.isSuccess, isTrue);
      expect(result.getOrThrow().value, 10);
    });

    test('should return QuantityNegativeError for negative values', () {
      final result = Quantity.create(-1);
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<QuantityNegativeError>());
    });

    test('should add quantities', () {
      final q1 = Quantity.create(10).getOrThrow();
      final q2 = Quantity.create(5).getOrThrow();
      expect((q1 + q2).value, 15);
    });

    test('should subtract quantities', () {
      final q1 = Quantity.create(10).getOrThrow();
      final q2 = Quantity.create(3).getOrThrow();
      expect((q1 - q2).value, 7);
    });

    test('should throw StateError if subtraction results in negative', () {
      final q1 = Quantity.create(5).getOrThrow();
      final q2 = Quantity.create(10).getOrThrow();
      expect(() => q1 - q2, throwsStateError);
    });
  });
}
