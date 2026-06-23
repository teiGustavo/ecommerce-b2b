import 'package:drift/native.dart';
import 'package:ecommerce_b2b/app/core/di/service_locator.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/infrastructure/database/app_database.dart';
import 'package:ecommerce_b2b/modules/catalog/product/application/get_products/get_products_use_case.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/repositories/sales_order_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  group('Service Locator Tests', () {
    setUp(() async {
      await GetIt.instance.reset();
    });

    tearDown(() async {
      await GetIt.instance.reset();
    });

    test('should register all dependencies successfully', () async {
      // Setup the service locator using an in-memory database
      await setupServiceLocator(connection: NativeDatabase.memory());

      // Verify that registrations are resolved without throwing exceptions
      expect(GetIt.instance.isRegistered<AppDatabase>(), isTrue);
      expect(GetIt.instance.isRegistered<SalesOrderRepository>(), isTrue);
      expect(GetIt.instance.isRegistered<GetProductsUseCase>(), isTrue);

      final db = GetIt.instance<AppDatabase>();
      expect(db, isNotNull);

      final getProducts = GetIt.instance<GetProductsUseCase>();
      expect(getProducts, isNotNull);
    });
  });
}
