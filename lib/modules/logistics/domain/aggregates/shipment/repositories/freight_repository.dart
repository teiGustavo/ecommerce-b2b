import 'package:ecommerce_b2b/modules/shared_kernel/domain/address/value_objects/zip_code.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/logistics/value_objects/weight.dart';

/// Contrato usado para cálculo de frete (RF16), permitindo múltiplas implementações (ou fontes de dados).
abstract class FreightRepository {
  /// Calcula o frete com base nos parâmetros fornecidos.
  Future<Money> calculateFreight({
    required ZipCode origin,
    required ZipCode destination,
    required Weight totalWeight,
  });
}