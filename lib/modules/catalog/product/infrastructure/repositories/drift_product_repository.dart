import 'package:ecommerce_b2b/modules/catalog/product/domain/product.dart';
import 'package:ecommerce_b2b/modules/catalog/product/domain/product_variant.dart';
import 'package:ecommerce_b2b/modules/catalog/product/domain/repositories/product_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_variant_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/infrastructure/database/app_database.dart';

class DriftProductRepository implements ProductRepository {
  final AppDatabase _db;

  DriftProductRepository(this._db);

  @override
  Future<void> save(Product product) async {
    await _db.transaction(() async {
      await _db.into(_db.products).insertOnConflictUpdate(
        ProductsCompanion.insert(
          id: product.id.value,
          sku: product.sku,
          name: product.name,
          description: product.description,
          active: product.active,
        ),
      );

      // Deletar variantes antigas e reinserir (simplificação)
      await (_db.delete(_db.productVariants)
            ..where((t) => t.productId.equals(product.id.value)))
          .go();

      for (final variant in product.variants) {
        await _db.into(_db.productVariants).insertOnConflictUpdate(
          ProductVariantsCompanion.insert(
            id: variant.id.value,
            productId: product.id.value,
            variantSku: variant.variantSku,
            color: variant.color,
            size: variant.size,
            voltage: variant.voltage,
          ),
        );
      }
    });
  }

  @override
  Future<void> delete(ProductId id) async {
    await _db.transaction(() async {
      await (_db.delete(_db.productVariants)
            ..where((t) => t.productId.equals(id.value)))
          .go();
      await (_db.delete(_db.products)
            ..where((t) => t.id.equals(id.value)))
          .go();
    });
  }

  @override
  Future<List<Product>> getAll() async {
    final productRows = await _db.select(_db.products).get();
    final List<Product> products = [];

    for (final row in productRows) {
      final variantRows = await (_db.select(_db.productVariants)
            ..where((t) => t.productId.equals(row.id)))
          .get();
      products.add(_mapToDomain(row, variantRows));
    }

    return products;
  }

  @override
  Future<Product?> getById(ProductId id) async {
    final row = await (_db.select(_db.products)
          ..where((t) => t.id.equals(id.value)))
        .getSingleOrNull();

    if (row == null) return null;

    final variantRows = await (_db.select(_db.productVariants)
          ..where((t) => t.productId.equals(id.value)))
        .get();

    return _mapToDomain(row, variantRows);
  }

  Product _mapToDomain(ProductRow row, List<ProductVariantRow> variantRows) {
    return Product(
      id: ProductId(row.id),
      sku: row.sku,
      name: row.name,
      description: row.description,
      active: row.active,
      variants: variantRows
          .map((v) => ProductVariant(
                id: ProductVariantId(v.id),
                color: v.color,
                size: v.size,
                voltage: v.voltage,
                variantSku: v.variantSku,
              ))
          .toList(),
    );
  }
}
