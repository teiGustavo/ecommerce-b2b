import 'package:ecommerce_b2b/modules/inventory/domain/aggregates/warehouse/warehouse.dart';

abstract class WarehouseRepository {
  Future<List<Warehouse>> getAll();
  Future<void> save(Warehouse warehouse);
}
