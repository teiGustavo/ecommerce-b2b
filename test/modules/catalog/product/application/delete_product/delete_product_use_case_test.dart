import 'package:ecommerce_b2b/modules/catalog/product/application/delete_product/delete_product_use_case.dart';
import 'package:ecommerce_b2b/modules/catalog/product/domain/product.dart';
import 'package:ecommerce_b2b/modules/catalog/product/domain/repositories/product_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late MockProductRepository productRepository;
  late DeleteProductUseCase useCase;
  const productId = ProductId('prod-1');

  setUp(() {
    productRepository = MockProductRepository();
    useCase = DeleteProductUseCase(productRepository);
  });

  Product createProduct({String id = 'prod-1'}) {
    return Product(
      id: ProductId(id),
      name: 'Notebook Dell',
      sku: 'SKU-001',
      description: 'Notebook para trabalho',
      active: true,
      basePrice: Money.create(100.0).getOrThrow(),
    );
  }

  group('DeleteProductUseCase', () {
    test('deve excluir o produto com sucesso quando não há vínculos', () async {
      when(() => productRepository.getById(productId))
          .thenAnswer((_) async => createProduct());
      when(() => productRepository.hasActiveLinks(productId))
          .thenAnswer((_) async => false);
      when(() => productRepository.delete(productId))
          .thenAnswer((_) async {});

      final result = await useCase.execute(productId);

      expect(result.isSuccess, isTrue);
      verify(() => productRepository.delete(productId)).called(1);
    });

    test('deve retornar Failure quando o produto não é encontrado', () async {
      when(() => productRepository.getById(productId))
          .thenAnswer((_) async => null);

      final result = await useCase.execute(productId);

      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow().toString(), contains('não encontrado'));
      verifyNever(() => productRepository.delete(productId));
    });

    test('deve retornar Failure quando o produto possui vínculos ativos', () async {
      when(() => productRepository.getById(productId))
          .thenAnswer((_) async => createProduct());
      when(() => productRepository.hasActiveLinks(productId))
          .thenAnswer((_) async => true);

      final result = await useCase.execute(productId);

      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow().toString(), contains('vínculos ativos'));
      verifyNever(() => productRepository.delete(productId));
    });

    test('deve retornar Failure quando o repositório lança exceção', () async {
      when(() => productRepository.getById(productId))
          .thenThrow(Exception('Erro de banco'));

      final result = await useCase.execute(productId);

      expect(result.isFailure, isTrue);
    });
  });
}
