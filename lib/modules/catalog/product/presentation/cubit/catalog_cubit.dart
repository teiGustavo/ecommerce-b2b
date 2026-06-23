import 'package:ecommerce_b2b/modules/catalog/product/application/get_products/get_products_use_case.dart';
import 'package:ecommerce_b2b/modules/catalog/product/application/save_product/save_product_use_case.dart';
import 'package:ecommerce_b2b/modules/catalog/product/domain/product.dart';
import 'package:ecommerce_b2b/modules/catalog/product/presentation/cubit/catalog_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatalogCubit extends Cubit<CatalogState> {
  final GetProductsUseCase _getProductsUseCase;
  final SaveProductUseCase _saveProductUseCase;

  CatalogCubit(
    this._getProductsUseCase,
    this._saveProductUseCase,
  ) : super(CatalogInitial());

  Future<void> loadProducts({String? query}) async {
    emit(CatalogLoading());
    final result = await _getProductsUseCase.execute(query: query);
    
    result.fold(
      (error) => emit(CatalogError(error.toString())),
      (products) => emit(CatalogLoaded(products)),
    );
  }

  Future<void> saveProduct(Product product) async {
    final result = await _saveProductUseCase.execute(product);
    
    result.fold(
      (error) => emit(CatalogError(error.toString())),
      (_) => loadProducts(),
    );
  }
}
