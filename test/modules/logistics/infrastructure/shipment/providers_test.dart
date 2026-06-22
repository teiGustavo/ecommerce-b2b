import 'package:ecommerce_b2b/modules/logistics/infrastructure/shipment/adapters/mock/mock_freight_adapter.dart';
import 'package:ecommerce_b2b/modules/logistics/infrastructure/shipment/adapters/mock/mock_tracking_adapter.dart';
import 'package:ecommerce_b2b/modules/logistics/infrastructure/shipment/freight_provider.dart';
import 'package:ecommerce_b2b/modules/logistics/infrastructure/shipment/tracking_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Shipment Providers', () {
    /// FreightProvider.mock deve retornar uma instância de MockFreightAdapter
    test('FreightProvider.mock should return an instance of MockFreightAdapter', () {
      final repository = FreightProvider.mock.freightProvider;
      expect(repository, isA<MockFreightAdapter>());
    });

    /// TrackingProvider.mock deve retornar uma instância de MockTrackingAdapter
    test('TrackingProvider.mock should return an instance of MockTrackingAdapter', () {
      final repository = TrackingProvider.mock.trackingProvider;
      expect(repository, isA<MockTrackingAdapter>());
    });
  });
}
