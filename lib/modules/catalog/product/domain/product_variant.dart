import 'package:ecommerce_b2b/modules/shared_kernel/base/base_entity.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_variant_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';

class ProductVariant extends Entity<ProductVariantId> {
  final String color;
  final String size;
  final String voltage;
  final String variantSku;
  final Money? price;
  final bool sameAsParent;

  ProductVariant({
    required ProductVariantId id,
    required this.color,
    required this.size,
    required this.voltage,
    required this.variantSku,
    this.price,
    this.sameAsParent = true,
  }) : super(id);
}
