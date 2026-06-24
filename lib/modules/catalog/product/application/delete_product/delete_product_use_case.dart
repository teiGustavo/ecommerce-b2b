import 'package:ecommerce_b2b/modules/catalog/product/domain/repositories/product_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';

/// Caso de uso para excluir um produto do catálogo.
/// Verifica vínculos ativos antes de permitir a exclusão.
class DeleteProductUseCase {
  final ProductRepository _productRepository;

  DeleteProductUseCase(this._productRepository);

  /// Executa a exclusão do produto.
  /// Retorna [Failure] se o produto possuir vínculos ativos (pedidos, cotações, estoque).
  Future<Result<void, Exception>> execute(ProductId productId) async {
    try {
      // Verificar se o produto existe
      final product = await _productRepository.getById(productId);
      if (product == null) {
        return Failure(Exception('Produto não encontrado.'));
      }

      // Verificar se existem vínculos ativos
      final hasLinks = await _productRepository.hasActiveLinks(productId);
      if (hasLinks) {
        return Failure(Exception(
          'Não é possível excluir o produto "${product.name}" pois ele possui '
          'vínculos ativos (pedidos, cotações ou estoque).',
        ));
      }

      await _productRepository.delete(productId);
      return Success(null);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
