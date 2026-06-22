import 'package:ecommerce_b2b/modules/catalog/domain/aggregates/product/product.dart';

abstract class ProductRepository {
  Future<void> save(Product product);
  Future<List<Product>> getAll();
  Future<Product?> getById(String id);
}
