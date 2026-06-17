import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/errors/cnpj_errors.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/value_objects/cnpj.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';

void main() {
  group('Cnpj Value Object Tests', () {

    test('valid CNPJ is accepted and normalized into Success', () {
      final result = Cnpj.create('04.252.011/0001-10');

      expect(result, isA<Success<Cnpj, CnpjError>>());

      result.fold(
        (error) => fail('Should not return an error'),
        (cnpj) {
          expect(cnpj.value, equals('04252011000110'));
        },
      );
    });

    test('empty CNPJ returns CnpjEmptyError', () {
      final result = Cnpj.create('   ');

      expect(result, isA<Failure<Cnpj, CnpjError>>());

      result.fold(
        (error) {
          expect(error, isA<CnpjEmptyError>());
        },
        (cnpj) => fail('Should not return a value'),
      );
    });

    test('CNPJ with invalid length returns CnpjInvalidLengthError', () {
      final result = Cnpj.create('123');

      expect(result, isA<Failure<Cnpj, CnpjError>>());

      final error = (result as Failure).error;
      expect(error, isA<CnpjInvalidLengthError>());

      // Você pode até testar propriedades internas do erro semântico!
      expect((error as CnpjInvalidLengthError).currentLength, equals(3));
    });

    test('CNPJ with sequential numbers returns CnpjInvalidError', () {
      final result = Cnpj.create('11.111.111/1111-11');

      expect(result, isA<Failure<Cnpj, CnpjError>>());
      expect((result as Failure).error, isA<CnpjInvalidError>());
    });

    test('CNPJ with invalid check digits returns CnpjInvalidVerificationDigitsError', () {
      final result = Cnpj.create('04.252.011/0001-99');

      expect(result, isA<Failure<Cnpj, CnpjError>>());
      expect((result as Failure).error, isA<CnpjInvalidVerificationDigitsError>());
    });

  });
}