import 'package:ecommerce_b2b/modules/catalog/price_table/domain/price_table.dart';
import 'package:ecommerce_b2b/modules/catalog/price_table/domain/price_rule.dart';
import 'package:ecommerce_b2b/modules/catalog/product/domain/product.dart';
import 'package:ecommerce_b2b/modules/catalog/product/domain/product_variant.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/address/enums/state.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';

/// Serviço de Domínio responsável por buscar o preço unitário correto baseado em regras e hierarquia.
class OrderPricingDomainService {
  /// Obtém o preço unitário seguindo a hierarquia: Tabela de Preços (Dinâmica) -> Catálogo (Fallback).
  Money getUnitPrice({
    required Product product,
    ProductVariant? variant,
    PriceTable? priceTable,
    required Quantity quantity,
    required State state,
  }) {
    // 1. Tenta encontrar uma regra na Tabela de Preços (Prioridade Máxima)
    if (priceTable != null) {
      final rules = priceTable.rules.where((r) => r.productId == product.id);

      // Ordem de preferência para regras dinâmicas:
      // a) Produto + Variante + Estado + Quantidade
      // b) Produto + Variante + Nacional + Quantidade
      // c) Produto + Estado + Quantidade
      // d) Produto + Nacional + Quantidade

      final matchedRule = _findBestRule(rules, variant, state, quantity);
      if (matchedRule != null) {
        return matchedRule.unitPrice;
      }
    }

    // 2. Fallback para Preço de Catálogo
    if (variant != null && !variant.sameAsParent && variant.price != null) {
      return variant.price!;
    }

    return product.basePrice;
  }

  PriceRule? _findBestRule(
    Iterable<PriceRule> rules,
    ProductVariant? variant,
    State state,
    Quantity quantity,
  ) {
    // Filtrar por quantidade primeiro
    final qtyRules = rules.where((r) =>
        quantity.value >= r.minQuantity.value &&
        quantity.value <= r.maxQuantity.value);

    // a) Variante Específica + Estado Específico
    final v1 = qtyRules.where((r) => r.variantId == variant?.id && r.state == state);
    if (v1.isNotEmpty) return v1.first;

    // b) Variante Específica + Nacional (state null)
    final v2 = qtyRules.where((r) => r.variantId == variant?.id && r.state == null);
    if (v2.isNotEmpty) return v2.first;

    // c) Produto Raiz (variant null) + Estado Específico
    final v3 = qtyRules.where((r) => r.variantId == null && r.state == state);
    if (v3.isNotEmpty) return v3.first;

    // d) Produto Raiz (variant null) + Nacional (state null)
    final v4 = qtyRules.where((r) => r.variantId == null && r.state == null);
    if (v4.isNotEmpty) return v4.first;

    return null;
  }
}

extension on Iterable<PriceRule> {
  // Helper se precisarmos de mais filtros
}
