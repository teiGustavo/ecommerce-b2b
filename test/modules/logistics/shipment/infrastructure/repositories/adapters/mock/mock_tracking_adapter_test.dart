import 'package:ecommerce_b2b/modules/logistics/shipment/domain/shipment.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/shipping_label.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/enums/shipment_status.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/enums/tracking_status.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/infrastructure/repositories/adapters/mock/mock_tracking_adapter.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/shipment_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/logistics/value_objects/tracking_code.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MockTrackingAdapter trackingAdapter;

  setUp(() {
    trackingAdapter = MockTrackingAdapter();
  });

  group('MockTrackingAdapter', () {
    /// deve adicionar um novo evento de rastreamento à remessa
    test('should add a new tracking event to the repositories', () async {
      final shipment = Shipment(
        id: const ShipmentId('ship-1'),
        orderId: 'order-1',
        trackingCode: TrackingCode.create('TRK123456').getOrThrow(),
        status: ShipmentStatus.pending,
        shippingLabel: const ShippingLabel('LBL-001'),
      );

      expect(shipment.trackingEvents, isEmpty);

      await trackingAdapter.syncTracking(shipment);

      expect(shipment.trackingEvents, isNotEmpty);
      expect(shipment.trackingEvents.first.status, TrackingStatus.inTransit);
    });
  });
}
