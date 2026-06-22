import 'package:ecommerce_b2b/modules/catalog/product/domain/product.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/base/base_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';

/// Contrato do repositório de produtos.
abstract class ProductRepository implements BaseRepository<Product> {
  /// Salva um produto.
  @override
  Future<void> save(Product product);

  /// Exclui um produto.
  Future<void> delete(ProductId id);

  /// Retorna todos os produtos.
  Future<List<Product>> getAll();

  /// Retorna um produto pelo ID.
  Future<Product?> getById(ProductId id);
}