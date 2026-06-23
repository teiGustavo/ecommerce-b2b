import 'package:drift/drift.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/enums/shipment_status.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/repositories/shipment_repository.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/shipment.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/shipping_label.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/shipment_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/logistics/value_objects/tracking_code.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/infrastructure/database/app_database.dart';

class DriftShipmentRepository implements ShipmentRepository {
  final AppDatabase _db;

  DriftShipmentRepository(this._db);

  @override
  Future<void> save(Shipment shipment) async {
    await _db.into(_db.shipments).insertOnConflictUpdate(
      ShipmentsCompanion.insert(
        id: shipment.id.value,
        orderId: shipment.orderId,
        trackingCode: Value(shipment.trackingCode.value),
        status: shipment.status.name,
      ),
    );
  }

  @override
  Future<Shipment?> getById(ShipmentId id) async {
    final row = await (_db.select(_db.shipments)
          ..where((t) => t.id.equals(id.value)))
        .getSingleOrNull();

    if (row == null) return null;

    return _mapToDomain(row);
  }

  @override
  Future<Shipment?> getByOrderId(String orderId) async {
    final row = await (_db.select(_db.shipments)
          ..where((t) => t.orderId.equals(orderId)))
        .getSingleOrNull();

    if (row == null) return null;

    return _mapToDomain(row);
  }

  Shipment _mapToDomain(ShipmentRow row) {
    return Shipment(
      id: ShipmentId(row.id),
      orderId: row.orderId,
      trackingCode: TrackingCode.create(row.trackingCode ?? '').getOrThrow(),
      status: ShipmentStatus.values.firstWhere((e) => e.name == row.status),
      shippingLabel: ShippingLabel(row.id), // Using ID as label for simplicity
    );
  }
}
