import 'package:ecommerce_b2b/modules/shared_kernel/base/base_aggregate_root.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/ids/warehouse_id.dart';
import 'package:ecommerce_b2b/modules/inventory/domain/aggregates/warehouse/stock_item.dart';

class Warehouse extends AggregateRoot<WarehouseId> {
  final String code;
  final String name;
  final List<StockItem> _stockItems;

  Warehouse({
    required WarehouseId id,
    required this.code,
    required this.name,
    List<StockItem>? stockItems,
  })  : _stockItems = stockItems ?? [],
        super(id);

  List<StockItem> get stockItems => List.unmodifiable(_stockItems);

  void updateStock(StockItem item) {
    final index = _stockItems.indexWhere((i) => i.productId == item.productId);
    if (index >= 0) {
      _stockItems[index] = item;
    } else {
      _stockItems.add(item);
    }
  }

  StockItem? getStockItem(dynamic productId) {
    try {
      return _stockItems.firstWhere((i) => i.productId == productId);
    } catch (_) {
      return null;
    }
  }
}
