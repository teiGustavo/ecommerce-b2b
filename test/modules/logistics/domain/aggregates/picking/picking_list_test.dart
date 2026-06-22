import 'package:ecommerce_b2b/modules/logistics/domain/aggregates/picking/picking_list.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/picking_list_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PickingList', () {
    test('should create picking list', () {
      const id = PickingListId('pl1');
      const orderId = OrderId('o1');
      final pickingList = PickingList(id: id, orderId: orderId);

      expect(pickingList.id, id);
      expect(pickingList.orderId, orderId);
    });
  });
}
