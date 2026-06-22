import 'package:ecommerce_b2b/modules/logistics/domain/aggregates/shipment/repositories/tracking_repository.dart';
import 'package:ecommerce_b2b/modules/logistics/infrastructure/shipment/adapters/mock/mock_tracking_adapter.dart';

enum TrackingProvider {
  mock;

  TrackingRepository get trackingProvider {
    switch (this) {
      case TrackingProvider.mock: return MockTrackingAdapter();
    }
  }
}