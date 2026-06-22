import 'package:ecommerce_b2b/modules/shared_kernel/domain/logistics/errors/weight_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/logistics/value_objects/weight.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Weight', () {
    /// deve criar um peso válido
    test('should create valid weight', () {
      final result = Weight.create(10.5);
      expect(result.isSuccess, isTrue);
      expect(result.getOrThrow().value, 10.5);
    });

    /// deve retornar erro de peso negativo
    test('should return WeightNegativeError for negative weight', () {
      final result = Weight.create(-1.0);
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<WeightNegativeError>());
    });

    /// toString deve formatar corretamente
    test('toString should format correctly', () {
      final weight = Weight.create(5).getOrThrow();
      expect(weight.toString(), '5.00 kg');
    });
  });
}
