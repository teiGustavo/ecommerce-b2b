import 'package:ecommerce_b2b/modules/catalog/product/domain/product.dart';
import 'package:ecommerce_b2b/modules/catalog/product/domain/repositories/product_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';

class GetProductsUseCase {
  final ProductRepository _productRepository;

  GetProductsUseCase(this._productRepository);

  Future<Result<List<Product>, Exception>> execute({String? query}) async {
    try {
      final products = await _productRepository.getAll();
      
      if (query != null && query.isNotEmpty) {
        final filtered = products.where((p) {
          final q = query.toLowerCase();
          return p.name.toLowerCase().contains(q) || 
                 p.sku.toLowerCase().contains(q);
        }).toList();
        return Success(filtered);
      }
      
      return Success(products);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
