import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/errors/inscricao_estadual_errors.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/value_objects/inscricao_estadual.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InscricaoEstadual', () {
    test('should create valid IE', () {
      final result = InscricaoEstadual.create('123.456.789-01');
      expect(result.isSuccess, isTrue);
      expect(result.getOrThrow().value, '12345678901');
    });

    test('should return InscricaoEstadualEmptyError for empty input', () {
      final result = InscricaoEstadual.create('');
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<InscricaoEstadualEmptyError>());
    });

    test('should return InscricaoEstadualEmptyError for whitespace-only input', () {
      final result = InscricaoEstadual.create('  ');
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<InscricaoEstadualEmptyError>());
    });

    test('should return InscricaoEstadualInvalidError for too short input', () {
      final result = InscricaoEstadual.create('123');
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<InscricaoEstadualInvalidError>());
    });

    test('should equal other with same value', () {
      final ie1 = InscricaoEstadual.create('123.456.789-01').getOrThrow();
      final ie2 = InscricaoEstadual.create('123.456.789-01').getOrThrow();
      expect(ie1, equals(ie2));
    });
  });
}
