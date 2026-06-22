import 'package:ecommerce_b2b/modules/catalog/domain/aggregates/product/product.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/aggregates/product/product_variant.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/repositories/product_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_variant_id.dart';

class ProductRepositoryInMemory implements ProductRepository {
  final List<Product> _products = [];

  ProductRepositoryInMemory() {
    _populateMocks();
  }

  void _populateMocks() {
    _products.add(
      Product(
        id: const ProductId('PROD_001'),
        sku: 'SKU-TV-001',
        name: 'Smart TV 55" 4K',
        description: 'Televisor inteligente com resolução 4K e painel OLED.',
        active: true,
        variants: [
          ProductVariant(
            id: const ProductVariantId('VAR_001'),
            color: 'Preto',
            size: '55"',
            voltage: 'Bivolt',
            variantSku: 'SKU-TV-001-B',
          ),
        ],
      ),
    );
    _products.add(
      Product(
        id: const ProductId('PROD_002'),
        sku: 'SKU-GEL-002',
        name: 'Geladeira Frost Free',
        description: 'Geladeira espaçosa com tecnologia frost free.',
        active: true,
        variants: [
          ProductVariant(
            id: const ProductVariantId('VAR_002'),
            color: 'Branco',
            size: '400L',
            voltage: '110v',
            variantSku: 'SKU-GEL-002-W-110',
          ),
          ProductVariant(
            id: const ProductVariantId('VAR_003'),
            color: 'Inox',
            size: '400L',
            voltage: '220v',
            variantSku: 'SKU-GEL-002-I-220',
          ),
        ],
      ),
    );
  }

  @override
  Future<List<Product>> getAll() async {
    return List.unmodifiable(_products);
  }

  @override
  Future<Product?> getById(String id) async {
    try {
      return _products.firstWhere((p) => p.id.value == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> save(Product product) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _products[index] = product;
    } else {
      _products.add(product);
    }
  }
}
