import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/errors/inscricao_estadual_errors.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/value_objects/inscricao_estadual.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';

void main() {
  group('InscricaoEstadual Value Object Tests', () {
    test('valid numeric IE is accepted and normalized into Success', () {
      final result = InscricaoEstadual.create('110.042.490.114');

      expect(result, isA<Success<InscricaoEstadual, InscricaoEstadualError>>());

      result.fold(
        (error) => fail('Should not return an error'),
        (ie) {
          expect(ie.value, equals('110042490114'));
        },
      );
    });

    test('string "ISENTO" should now return an error (logic moved to entity)', () {
      final result = InscricaoEstadual.create('ISENTO');

      expect(result, isA<Failure<InscricaoEstadual, InscricaoEstadualError>>());
      expect((result as Failure).error, isA<InscricaoEstadualEmptyError>());
    });

    test('empty or whitespace-only IE returns InscricaoEstadualEmptyError', () {
      final result = InscricaoEstadual.create('   ');

      expect(result, isA<Failure<InscricaoEstadual, InscricaoEstadualError>>());
      expect((result as Failure).error, isA<InscricaoEstadualEmptyError>());
    });

    test('IE with invalid length (too short) returns InscricaoEstadualInvalidError', () {
      final result = InscricaoEstadual.create('1234567');

      expect(result, isA<Failure<InscricaoEstadual, InscricaoEstadualError>>());
      expect((result as Failure).error, isA<InscricaoEstadualInvalidError>());
    });

    test('two IEs with same digits should be equal', () {
      final ie1 = InscricaoEstadual.create('12345678').fold((f) => null, (s) => s);
      final ie2 = InscricaoEstadual.create('12.345.678').fold((f) => null, (s) => s);

      expect(ie1, equals(ie2));
    });
  });
}
