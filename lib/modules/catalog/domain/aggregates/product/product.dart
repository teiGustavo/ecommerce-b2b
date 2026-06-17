import 'package:ecommerce_b2b/modules/shared_kernel/base/base_aggregate_root.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/aggregates/product/product_variant.dart';

class Product extends AggregateRoot<ProductId> {
  final String sku;
  final String name;
  final String description;
  final bool active;
  final List<ProductVariant> _variants;

  Product({
    required ProductId id,
    required this.sku,
    required this.name,
    required this.description,
    required this.active,
    List<ProductVariant>? variants,
  })  : _variants = variants ?? [],
        super(id);

  List<ProductVariant> get variants => List.unmodifiable(_variants);

  void addVariant(ProductVariant variant) {
    _variants.add(variant);
  }
}
