import 'package:ecommerce_b2b/modules/catalog/price_table/domain/price_table.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/address/enums/state.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';

/// Serviço de Domínio responsável por buscar o preço unitário correto baseado em regras.
class OrderPricingDomainService {
  /// Obtém o preço unitário de uma tabela de preços com base na quantidade e UF (RF6).
  /// Caso não encontre uma regra específica, retorna o preço da primeira regra compatível
  /// ou lança um erro se a tabela estiver vazia.
  Money getUnitPrice({
    required PriceTable priceTable,
    required Quantity quantity,
    required State state,
  }) {
    if (priceTable.rules.isEmpty) {
      throw StateError('A tabela de preços "${priceTable.name}" não possui regras cadastradas.');
    }

    // Tenta encontrar uma regra que atenda tanto o Estado quanto a faixa de quantidade.
    final match = priceTable.rules.where((rule) {
      final stateMatch = rule.state == state;
      final quantityMatch = quantity.value >= rule.minQuantity.value &&
          quantity.value <= rule.maxQuantity.value;
      return stateMatch && quantityMatch;
    });

    if (match.isNotEmpty) {
      return match.first.unitPrice;
    }

    // Fallback: Tenta encontrar apenas por Estado se não houver faixa de quantidade compatível.
    final stateOnlyMatch = priceTable.rules.where((rule) => rule.state == state);
    if (stateOnlyMatch.isNotEmpty) {
      return stateOnlyMatch.first.unitPrice;
    }

    // Caso não encontre nada para o Estado, retorna a primeira regra disponível (como padrão).
    return priceTable.rules.first.unitPrice;
  }
}
