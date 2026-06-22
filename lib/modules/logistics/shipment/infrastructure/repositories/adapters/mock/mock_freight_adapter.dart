import 'package:ecommerce_b2b/modules/logistics/shipment/domain/repositories/freight_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/address/value_objects/zip_code.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/logistics/value_objects/weight.dart';

/// Mock para cálculo de frete, simulando chamada em API externa.
class MockFreightAdapter implements FreightRepository {
  @override
  Future<Money> calculateFreight({
    required ZipCode origin,
    required ZipCode destination,
    required Weight totalWeight,
  }) async {
    // Simulação de delay de rede
    await Future.delayed(const Duration(milliseconds: 700));

    // Regra simulada: R$ 10,00 base + R$ 2,00 por kg
    final base = 10.0;
    final perKg = 2.0;
    final total = base + (perKg * totalWeight.value);

    return Money.create(total).getOrThrow();
  }
}