import 'package:ecommerce_b2b/modules/logistics/shipment/domain/repositories/tracking_repository.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/shipment.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/tracking_event.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/enums/tracking_status.dart';

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