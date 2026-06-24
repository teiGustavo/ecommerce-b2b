import 'package:ecommerce_b2b/modules/catalog/product/domain/product.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/base/base_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_variant_id.dart';

/// Contrato do repositório de produtos.
abstract class ProductRepository implements BaseRepository<Product> {
  /// Salva um produto.
  @override
  Future<void> save(Product product);

  /// Exclui um produto.
  Future<void> delete(ProductId id);

  /// Exclui uma variante específica de um produto.
  Future<void> deleteVariant(ProductId productId, ProductVariantId variantId);

  /// Retorna todos os produtos.
  Future<List<Product>> getAll();

  /// Retorna um produto pelo ID.
  Future<Product?> getById(ProductId id);

  /// Verifica se o produto possui vínculos ativos (pedidos, cotações, estoque, tabelas de preço).
  /// Retorna true se houver vínculos que impeçam a exclusão.
  Future<bool> hasActiveLinks(ProductId id);
}