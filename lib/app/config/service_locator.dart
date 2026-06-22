import 'package:get_it/get_it.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/repositories/company_repository.dart';
import 'package:ecommerce_b2b/modules/customer_management/data/repositories/company_repository_in_memory.dart';

import 'package:ecommerce_b2b/modules/order_flow/domain/repositories/order_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/data/repositories/order_repository_in_memory.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/repositories/product_repository.dart';
import 'package:ecommerce_b2b/modules/catalog/data/repositories/product_repository_in_memory.dart';
import 'package:ecommerce_b2b/modules/customer_portal/domain/repositories/rma_repository.dart';
import 'package:ecommerce_b2b/modules/customer_portal/data/repositories/rma_repository_in_memory.dart';
import 'package:ecommerce_b2b/modules/inventory/domain/repositories/warehouse_repository.dart';
import 'package:ecommerce_b2b/modules/inventory/data/repositories/warehouse_repository_in_memory.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  // Repositories
  getIt.registerLazySingleton<CompanyRepository>(() => CompanyRepositoryInMemory());
  getIt.registerLazySingleton<OrderRepository>(() => OrderRepositoryInMemory());
  getIt.registerLazySingleton<ProductRepository>(() => ProductRepositoryInMemory());
  getIt.registerLazySingleton<RmaRepository>(() => RmaRepositoryInMemory());
  getIt.registerLazySingleton<WarehouseRepository>(() => WarehouseRepositoryInMemory());
  
  // Aqui também serão registrados UseCases, Blocs/Cubits se necessário (por enquanto os Cubits são criados nas rotas)
}
