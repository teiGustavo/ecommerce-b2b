import 'package:ecommerce_b2b/modules/catalog/product/domain/product.dart';
import 'package:equatable/equatable.dart';

sealed class CatalogState extends Equatable {
  const CatalogState();

  @override
  List<Object?> get props => [];
}

class CatalogInitial extends CatalogState {}

class CatalogLoading extends CatalogState {}

class CatalogLoaded extends CatalogState {
  final List<Product> products;

  const CatalogLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class CatalogError extends CatalogState {
  final String message;

  const CatalogError(this.message);

  @override
  List<Object?> get props => [message];
}
