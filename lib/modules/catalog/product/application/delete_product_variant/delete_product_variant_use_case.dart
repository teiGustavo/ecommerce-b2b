import 'package:ecommerce_b2b/modules/catalog/product/domain/repositories/product_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_variant_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';

/// Caso de uso para excluir uma variante de um produto.
class DeleteProductVariantUseCase {
  final ProductRepository _productRepository;

  DeleteProductVariantUseCase(this._productRepository);

  /// Executa a exclusão de uma variante específica de um produto.
  Future<Result<void, Exception>> execute(ProductId productId, ProductVariantId variantId) async {
    try {
      // Verificar se o produto existe
      final product = await _productRepository.getById(productId);
      if (product == null) {
        return Failure(Exception('Produto não encontrado.'));
      }

      // Verificar se a variante existe no produto
      final hasVariant = product.variants.any((v) => v.id == variantId);
      if (!hasVariant) {
        return Failure(Exception('Variante não encontrada neste produto.'));
      }

      await _productRepository.deleteVariant(productId, variantId);
      return Success(null);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
