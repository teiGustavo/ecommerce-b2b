import 'package:formz/formz.dart';

enum ProductNameValidationError { empty }

class ProductName extends FormzInput<String, ProductNameValidationError> {
  const ProductName.pure() : super.pure('');
  const ProductName.dirty([super.value = '']) : super.dirty();

  @override
  ProductNameValidationError? validator(String value) {
    if (value.trim().isEmpty) return ProductNameValidationError.empty;
    return null;
  }
}

enum ProductSkuValidationError { empty, invalid }

class ProductSku extends FormzInput<String, ProductSkuValidationError> {
  const ProductSku.pure() : super.pure('');
  const ProductSku.dirty([super.value = '']) : super.dirty();

  @override
  ProductSkuValidationError? validator(String value) {
    if (value.trim().isEmpty) return ProductSkuValidationError.empty;
    if (value.length < 3) return ProductSkuValidationError.invalid;
    return null;
  }
}
