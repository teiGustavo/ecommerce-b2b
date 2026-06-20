import 'package:ecommerce_b2b/modules/shared_kernel/enums/state.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/errors/state_errors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('State Enum', () {
    test('should return Success for valid state code', () {
      final result = State.fromString('SP');
      expect(result.isSuccess, isTrue);
      expect(result.getOrThrow(), State.saoPaulo);
    });

    test('should return Success for valid state name', () {
      final result = State.fromString('São Paulo');
      expect(result.isSuccess, isTrue);
      expect(result.getOrThrow(), State.saoPaulo);
    });

    test('should be case insensitive', () {
      final result = State.fromString('sp');
      expect(result.isSuccess, isTrue);
      expect(result.getOrThrow(), State.saoPaulo);
    });

    test('should return Failure for invalid state', () {
      final result = State.fromString('XX');
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<StateInvalidError>());
    });

    test('should return Failure for empty input', () {
      final result = State.fromString('');
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<StateInvalidError>());
    });
  });
}
