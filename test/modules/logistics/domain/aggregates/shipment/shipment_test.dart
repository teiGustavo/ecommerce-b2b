import 'package:ecommerce_b2b/modules/logistics/domain/aggregates/shipment/shipment.dart';
import 'package:ecommerce_b2b/modules/logistics/domain/aggregates/shipment/shipping_label.dart';
import 'package:ecommerce_b2b/modules/logistics/domain/enums/shipment_status.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/shipment_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/logistics/value_objects/tracking_code.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Shipment', () {
    test('should create shipment and update status', () {
      const id = ShipmentId('s1');
      const trackingCode = TrackingCode('ABC123XYZ');
      final label = ShippingLabel('LABEL123');
      
      final shipment = Shipment(
        id: id,
        trackingCode: trackingCode,
        status: ShipmentStatus.pending,
        shippingLabel: label,
      );

      expect(shipment.id, id);
      expect(shipment.status, ShipmentStatus.pending);

      shipment.updateStatus(ShipmentStatus.shipped);
      expect(shipment.status, ShipmentStatus.shipped);
    });
  });
}
