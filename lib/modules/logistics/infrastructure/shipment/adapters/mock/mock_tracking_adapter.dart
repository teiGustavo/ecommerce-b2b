import 'package:ecommerce_b2b/modules/logistics/domain/aggregates/shipment/repositories/tracking_repository.dart';
import 'package:ecommerce_b2b/modules/logistics/domain/aggregates/shipment/shipment.dart';
import 'package:ecommerce_b2b/modules/logistics/domain/aggregates/shipment/tracking_event.dart';
import 'package:ecommerce_b2b/modules/logistics/domain/enums/tracking_status.dart';

/// Mock para rastreamento de transportadora, simulando chamada em API externa.
class MockTrackingAdapter implements TrackingRepository {
  @override
  Future<void> syncTracking(Shipment shipment) async {
    // Simulação de delay de rede
    await Future.delayed(const Duration(milliseconds: 300));

    // Simula a obtenção de um novo evento da transportadora
    final newEvent = TrackingEvent(
      status: TrackingStatus.inTransit,
      occurredAt: DateTime.now(),
    );

    shipment.addTrackingEvent(newEvent);
  }
}