import 'package:ecommerce_b2b/modules/shared_kernel/base/base_aggregate_root.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/catalog/product/domain/product_variant.dart';

/// Raiz do Agregado que representa um Produto no catálogo.
class Product extends AggregateRoot<ProductId> {
  /// Unidade de Manutenção de Estoque (SKU) principal.
  final String sku;
  /// Nome do produto.
  final String name;
  /// Descrição detalhada do produto.
  final String description;
  /// Indica se o produto está ativo para venda.
  final bool active;
  final List<ProductVariant> _variants;

  /// Construtor do Produto.
  Product({
    required ProductId id,
    required this.sku,
    required this.name,
    required this.description,
    required this.active,
    List<ProductVariant>? variants,
  })  : _variants = variants ?? [],
        super(id);

  /// Lista de variantes (cores, tamanhos, voltagens) deste produto.
  List<ProductVariant> get variants => List.unmodifiable(_variants);

  /// Adiciona uma nova variante ao produto.
  void addVariant(ProductVariant variant) {
    _variants.add(variant);
  }
}
