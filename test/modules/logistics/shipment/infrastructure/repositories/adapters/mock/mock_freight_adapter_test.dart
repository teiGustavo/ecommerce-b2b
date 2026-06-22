import 'package:ecommerce_b2b/modules/logistics/shipment/infrastructure/repositories/adapters/mock/mock_freight_adapter.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/address/value_objects/zip_code.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/logistics/value_objects/weight.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MockFreightAdapter freightAdapter;

  setUp(() {
    freightAdapter = MockFreightAdapter();
  });

  group('MockFreightAdapter', () {
    /// deve calcular o frete corretamente seguindo a regra simulada (10 + 2*peso)
    test('should calculate freight correctly following simulated rule (10 + 2*weight)', () async {
      final origin = ZipCode.create('01000-000').getOrThrow();
      final destination = ZipCode.create('20000-000').getOrThrow();
      final weight = Weight.create(5.0).getOrThrow();

      final result = await freightAdapter.calculateFreight(
        origin: origin,
        destination: destination,
        totalWeight: weight,
      );

      // 10 + (2 * 5) = 20
      expect(result.amount, 20.0);
    });

    /// deve calcular frete com peso zero
    test('should calculate freight with zero weight', () async {
      final origin = ZipCode.create('01000-000').getOrThrow();
      final destination = ZipCode.create('20000-000').getOrThrow();
      final weight = Weight.create(0.0).getOrThrow();

      final result = await freightAdapter.calculateFreight(
        origin: origin,
        destination: destination,
        totalWeight: weight,
      );

      // 10 + (2 * 0) = 10
      expect(result.amount, 10.0);
    });
  });
}
