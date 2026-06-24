import 'package:drift/native.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/enums/shipment_status.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/shipment.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/shipping_label.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/infrastructure/repositories/drift_shipment_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/shipment_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/logistics/value_objects/tracking_code.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/infrastructure/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late DriftShipmentRepository shipmentRepository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    shipmentRepository = DriftShipmentRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('DriftShipmentRepository Integration Tests', () {
    test('should save and retrieve a shipment by id', () async {
      final shipmentId = const ShipmentId('sh-123');
      final shipment = Shipment(
        id: shipmentId,
        orderId: 'order-101',
        trackingCode: TrackingCode.create('TRK789').getOrThrow(),
        status: ShipmentStatus.pending,
        shippingLabel: const ShippingLabel('LABEL-123'),
      );

      await shipmentRepository.save(shipment);

      final fetched = await shipmentRepository.getById(shipmentId);
      expect(fetched != null, isTrue);
      expect(fetched!.orderId, 'order-101');
      expect(fetched.trackingCode.value, 'TRK789');
      expect(fetched.status, ShipmentStatus.pending);
    });

    test('should find shipment by order id', () async {
      final shipment = Shipment(
        id: const ShipmentId('sh-1'),
        orderId: 'order-999',
        trackingCode: TrackingCode.create('XYZ123').getOrThrow(),
        status: ShipmentStatus.shipped,
        shippingLabel: const ShippingLabel('LBL1'),
      );

      await shipmentRepository.save(shipment);

      final fetched = await shipmentRepository.getByOrderId('order-999');
      expect(fetched != null, isTrue);
      expect(fetched!.id, const ShipmentId('sh-1'));
    });
  });
}
