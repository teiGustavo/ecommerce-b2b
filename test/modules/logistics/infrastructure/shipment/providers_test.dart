import 'package:ecommerce_b2b/modules/logistics/infrastructure/shipment/adapters/mock/mock_freight_adapter.dart';
import 'package:ecommerce_b2b/modules/logistics/infrastructure/shipment/adapters/mock/mock_tracking_adapter.dart';
import 'package:ecommerce_b2b/modules/logistics/infrastructure/shipment/freight_provider.dart';
import 'package:ecommerce_b2b/modules/logistics/infrastructure/shipment/tracking_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Shipment Providers', () {
    test('FreightProvider.mock deve retornar uma instância de MockFreightAdapter', () {
      final repository = FreightProvider.mock.freightProvider;
      expect(repository, isA<MockFreightAdapter>());
    });

    test('TrackingProvider.mock deve retornar uma instância de MockTrackingAdapter', () {
      final repository = TrackingProvider.mock.trackingProvider;
      expect(repository, isA<MockTrackingAdapter>());
    });
  });
}
