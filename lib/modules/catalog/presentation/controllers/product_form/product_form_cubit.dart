import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ecommerce_b2b/app/config/service_locator.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/repositories/product_repository.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/aggregates/product/product.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/aggregates/product/product_variant.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_variant_id.dart';
import 'package:ecommerce_b2b/modules/catalog/presentation/controllers/product_form/models/product_inputs.dart';

class ProductFormState extends Equatable {
  final ProductName name;
  final ProductSku sku;
  final String description;
  final List<ProductVariant> variants;
  final FormzSubmissionStatus status;

  const ProductFormState({
    this.name = const ProductName.pure(),
    this.sku = const ProductSku.pure(),
    this.description = '',
    this.variants = const [],
    this.status = FormzSubmissionStatus.initial,
  });

  ProductFormState copyWith({
    ProductName? name,
    ProductSku? sku,
    String? description,
    List<ProductVariant>? variants,
    FormzSubmissionStatus? status,
  }) {
    return ProductFormState(
      name: name ?? this.name,
      sku: sku ?? this.sku,
      description: description ?? this.description,
      variants: variants ?? this.variants,
      status: status ?? this.status,
    );
  }

  bool get isValid => Formz.validate([name, sku]) && variants.isNotEmpty;

  @override
  List<Object?> get props => [name, sku, description, variants, status];
}

class ProductFormCubit extends Cubit<ProductFormState> {
  final ProductRepository _productRepository;

  ProductFormCubit() 
      : _productRepository = getIt<ProductRepository>(),
        super(const ProductFormState());

  void nameChanged(String value) {
    final name = ProductName.dirty(value);
    emit(state.copyWith(name: name, status: FormzSubmissionStatus.initial));
  }

  void skuChanged(String value) {
    final sku = ProductSku.dirty(value);
    emit(state.copyWith(sku: sku, status: FormzSubmissionStatus.initial));
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(description: value, status: FormzSubmissionStatus.initial));
  }

  void addVariant({required String color, required String size, required String voltage}) {
    final variant = ProductVariant(
      id: ProductVariantId('VAR_${DateTime.now().millisecondsSinceEpoch}'),
      color: color,
      size: size,
      voltage: voltage,
      variantSku: '${state.sku.value}-$color-$size-$voltage'.toUpperCase(),
    );
    final updatedVariants = List<ProductVariant>.from(state.variants)..add(variant);
    emit(state.copyWith(variants: updatedVariants, status: FormzSubmissionStatus.initial));
  }

  void removeVariant(ProductVariant variant) {
    final updatedVariants = List<ProductVariant>.from(state.variants)..remove(variant);
    emit(state.copyWith(variants: updatedVariants, status: FormzSubmissionStatus.initial));
  }

  Future<void> submit() async {
    if (!state.isValid) return;
    
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final product = Product(
        id: ProductId('PROD_${DateTime.now().millisecondsSinceEpoch}'),
        sku: state.sku.value,
        name: state.name.value,
        description: state.description,
        active: true,
        variants: state.variants,
      );

      await _productRepository.save(product);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
