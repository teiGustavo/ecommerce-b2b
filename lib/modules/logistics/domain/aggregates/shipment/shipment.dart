import 'package:ecommerce_b2b/modules/shared_kernel/base/base_aggregate_root.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/ids/shipment_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/tracking_code.dart';
import 'package:ecommerce_b2b/modules/logistics/domain/enums/shipment_status.dart';
import 'package:ecommerce_b2b/modules/logistics/domain/aggregates/shipment/shipping_label.dart';
import 'package:ecommerce_b2b/modules/logistics/domain/aggregates/shipment/tracking_event.dart';

class Shipment extends AggregateRoot<ShipmentId> {
  final TrackingCode trackingCode;
  ShipmentStatus _status;
  final ShippingLabel shippingLabel;
  final List<TrackingEvent> _trackingEvents;

  Shipment({
    required ShipmentId id,
    required this.trackingCode,
    required this._status,
    required this.shippingLabel,
    List<TrackingEvent>? trackingEvents,
  })  : _trackingEvents = trackingEvents ?? [],
        super(id);

  ShipmentStatus get status => _status;
  List<TrackingEvent> get trackingEvents => List.unmodifiable(_trackingEvents);

  void addTrackingEvent(TrackingEvent event) {
    _trackingEvents.add(event);
  }

  void updateStatus(ShipmentStatus newStatus) {
    _status = newStatus;
  }
}
