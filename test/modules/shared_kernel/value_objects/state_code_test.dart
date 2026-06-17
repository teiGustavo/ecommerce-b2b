import 'package:ecommerce_b2b/modules/shared_kernel/errors/state_code_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/state_code.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StateCode', () {
    test('should create valid state code', () {
      final result = StateCode.create('sp');
      expect(result.isSuccess, isTrue);
      expect(result.getOrThrow().value, 'SP');
    });

    test('should return StateCodeInvalidError for non-existent state', () {
      final result = StateCode.create('XX');
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<StateCodeInvalidError>());
    });

    test('should return StateCodeInvalidError for invalid length', () {
      final result = StateCode.create('S');
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<StateCodeInvalidError>());
    });
  });
}
