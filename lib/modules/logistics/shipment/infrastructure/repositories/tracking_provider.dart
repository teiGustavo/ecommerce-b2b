import 'package:ecommerce_b2b/modules/logistics/shipment/domain/repositories/tracking_repository.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/infrastructure/repositories/adapters/mock/mock_tracking_adapter.dart';

enum TrackingProvider {
  mock;

  TrackingRepository get trackingProvider {
    switch (this) {
      case TrackingProvider.mock: return MockTrackingAdapter();
    }
  }
}