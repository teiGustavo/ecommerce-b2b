import 'package:drift/drift.dart';
import 'package:ecommerce_b2b/modules/catalog/product/domain/product.dart';
import 'package:ecommerce_b2b/modules/catalog/product/domain/product_variant.dart';
import 'package:ecommerce_b2b/modules/catalog/product/domain/repositories/product_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_variant_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
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
          basePrice: Value(product.basePrice.amount),
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
            price: Value(variant.price?.amount),
            sameAsParent: Value(variant.sameAsParent),
          ),
        );
      }
    });
  }

  @override
  Future<void> delete(ProductId id) async {
    await _db.transaction(() async {
      // Deletar regras de preço vinculadas ao produto
      await (_db.delete(_db.priceRules)
            ..where((t) => t.productId.equals(id.value)))
          .go();

      // Deletar variantes do produto
      await (_db.delete(_db.productVariants)
            ..where((t) => t.productId.equals(id.value)))
          .go();

      // Deletar o produto
      await (_db.delete(_db.products)
            ..where((t) => t.id.equals(id.value)))
          .go();
    });
  }

  @override
  Future<void> deleteVariant(ProductId productId, ProductVariantId variantId) async {
    await (_db.delete(_db.productVariants)
          ..where((t) => t.id.equals(variantId.value) & t.productId.equals(productId.value)))
        .go();
  }

  @override
  Future<bool> hasActiveLinks(ProductId id) async {
    // Verifica vínculos em itens de pedido (order_items)
    final orderItemCount = await (_db.selectOnly(_db.orderItemsTable)
          ..addColumns([_db.orderItemsTable.id])
          ..where(_db.orderItemsTable.productId.equals(id.value))
          ..limit(1))
        .get();
    if (orderItemCount.isNotEmpty) return true;

    // Verifica vínculos em itens de cotação (quote_items)
    final quoteItemCount = await (_db.selectOnly(_db.quoteItemsTable)
          ..addColumns([_db.quoteItemsTable.id])
          ..where(_db.quoteItemsTable.productId.equals(id.value))
          ..limit(1))
        .get();
    if (quoteItemCount.isNotEmpty) return true;

    // Verifica vínculos em estoque (stocks) — usando variantes do produto
    final variantRows = await (_db.select(_db.productVariants)
          ..where((t) => t.productId.equals(id.value)))
        .get();

    for (final variant in variantRows) {
      final stockCount = await (_db.selectOnly(_db.stocks)
            ..addColumns([_db.stocks.warehouseId])
            ..where(_db.stocks.variantId.equals(variant.id))
            ..limit(1))
          .get();
      if (stockCount.isNotEmpty) return true;
    }

    return false;
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
      basePrice: Money.create(row.basePrice).getOrThrow(),
      active: row.active,
      variants: variantRows
          .map((v) => ProductVariant(
                id: ProductVariantId(v.id),
                color: v.color,
                size: v.size,
                voltage: v.voltage,
                variantSku: v.variantSku,
                price: v.price != null ? Money.create(v.price!).getOrThrow() : null,
                sameAsParent: v.sameAsParent,
              ))
          .toList(),
    );
  }
}
