import 'package:ecommerce_b2b/modules/shared_kernel/base/base_entity.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/ids/product_variant_id.dart';

class ProductVariant extends Entity<ProductVariantId> {
  final String color;
  final String size;
  final String voltage;
  final String variantSku;

  ProductVariant({
    required ProductVariantId id,
    required this.color,
    required this.size,
    required this.voltage,
    required this.variantSku,
  }) : super(id);
}
