import 'package:ecommerce_b2b/modules/catalog/product/application/get_products/get_products_use_case.dart';
import 'package:ecommerce_b2b/modules/catalog/product/domain/product.dart';
import 'package:ecommerce_b2b/modules/catalog/product/domain/repositories/product_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late MockProductRepository productRepository;
  late GetProductsUseCase useCase;

  setUp(() {
    productRepository = MockProductRepository();
    useCase = GetProductsUseCase(productRepository);
  });

  Product createProduct(String id, String name, String sku) {
    return Product(
      id: ProductId(id),
      name: name,
      sku: sku,
      description: 'Desc $name',
      active: true,
    );
  }

  group('GetProductsUseCase', () {
    test('should return all products when no query is provided', () async {
      final products = [
        createProduct('1', 'Notebook', 'SKU-001'),
        createProduct('2', 'Monitor', 'SKU-002'),
      ];
      when(() => productRepository.getAll()).thenAnswer((_) async => products);

      final result = await useCase.execute();

      expect(result.isSuccess, isTrue);
      expect(result.getOrThrow(), hasLength(2));
    });

    test('should filter products by name', () async {
      final products = [
        createProduct('1', 'Notebook', 'SKU-001'),
        createProduct('2', 'Monitor', 'SKU-002'),
      ];
      when(() => productRepository.getAll()).thenAnswer((_) async => products);

      final result = await useCase.execute(query: 'Note');

      expect(result.isSuccess, isTrue);
      final filtered = result.getOrThrow();
      expect(filtered, hasLength(1));
      expect(filtered.first.name, contains('Notebook'));
    });

    test('should filter products by SKU', () async {
      final products = [
        createProduct('1', 'Notebook', 'SKU-001'),
        createProduct('2', 'Monitor', 'SKU-002'),
      ];
      when(() => productRepository.getAll()).thenAnswer((_) async => products);

      final result = await useCase.execute(query: '002');

      expect(result.isSuccess, isTrue);
      final filtered = result.getOrThrow();
      expect(filtered, hasLength(1));
      expect(filtered.first.sku, contains('002'));
    });
  });
}
