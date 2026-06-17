import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/errors/cnpj_errors.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/value_objects/cnpj.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Cnpj', () {
    test('should create valid CNPJ', () {
      // Valid CNPJ generated for testing
      final result = Cnpj.create('11.222.333/0001-81');
      expect(result.isSuccess, isTrue);
      expect(result.getOrThrow().value, '11222333000181');
    });

    test('should return CnpjEmptyError for empty input', () {
      final result = Cnpj.create('');
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<CnpjEmptyError>());
    });

    test('should return CnpjInvalidLengthError for incorrect length', () {
      final result = Cnpj.create('123');
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<CnpjInvalidLengthError>());
    });

    test('should return CnpjInvalidError for with sequential numbers', () {
      final result = Cnpj.create('11.111.111/1111-11');
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<CnpjInvalidError>());
    });

    test('should return CnpjInvalidVerificationDigitsError for wrong digits', () {
      final result = Cnpj.create('11.222.333/0001-00');
      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<CnpjInvalidVerificationDigitsError>());
    });
  });
}
