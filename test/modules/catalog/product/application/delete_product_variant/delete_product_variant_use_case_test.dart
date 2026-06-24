import 'package:ecommerce_b2b/modules/catalog/product/application/delete_product_variant/delete_product_variant_use_case.dart';
import 'package:ecommerce_b2b/modules/catalog/product/domain/product.dart';
import 'package:ecommerce_b2b/modules/catalog/product/domain/product_variant.dart';
import 'package:ecommerce_b2b/modules/catalog/product/domain/repositories/product_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_variant_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late MockProductRepository productRepository;
  late DeleteProductVariantUseCase useCase;
  const productId = ProductId('prod-1');
  const variantId = ProductVariantId('var-1');
  const nonExistentVariantId = ProductVariantId('var-999');

  setUp(() {
    productRepository = MockProductRepository();
    useCase = DeleteProductVariantUseCase(productRepository);
  });

  Product createProductWithVariant() {
    return Product(
      id: productId,
      name: 'Notebook Dell',
      sku: 'SKU-001',
      description: 'Notebook para trabalho',
      active: true,
      basePrice: Money.create(100.0).getOrThrow(),
      variants: [
        ProductVariant(
          id: variantId,
          variantSku: 'SKU-001-RED',
          color: 'Red',
          size: 'G',
          voltage: 'N/A',
          sameAsParent: true,
        ),
      ],
    );
  }

  group('DeleteProductVariantUseCase', () {
    test('deve excluir a variante com sucesso quando ela existe', () async {
      when(() => productRepository.getById(productId))
          .thenAnswer((_) async => createProductWithVariant());
      when(() => productRepository.deleteVariant(productId, variantId))
          .thenAnswer((_) async {});

      final result = await useCase.execute(productId, variantId);

      expect(result.isSuccess, isTrue);
      verify(() => productRepository.deleteVariant(productId, variantId)).called(1);
    });

    test('deve retornar Failure quando o produto não é encontrado', () async {
      when(() => productRepository.getById(productId))
          .thenAnswer((_) async => null);

      final result = await useCase.execute(productId, variantId);

      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow().toString(), contains('Produto não encontrado'));
      verifyNever(() => productRepository.deleteVariant(any(), any()));
    });

    test('deve retornar Failure quando a variante não existe no produto', () async {
      when(() => productRepository.getById(productId))
          .thenAnswer((_) async => createProductWithVariant());

      final result = await useCase.execute(productId, nonExistentVariantId);

      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow().toString(), contains('Variante não encontrada'));
      verifyNever(() => productRepository.deleteVariant(any(), any()));
    });

    test('deve retornar Failure quando o repositório lança exceção', () async {
      when(() => productRepository.getById(productId))
          .thenThrow(Exception('Erro de banco'));

      final result = await useCase.execute(productId, variantId);

      expect(result.isFailure, isTrue);
    });
  });
}
