import 'package:ecommerce_b2b/modules/logistics/shipment/domain/repositories/freight_repository.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/infrastructure/repositories/adapters/mock/mock_freight_adapter.dart';

enum FreightProvider {
  mock;

  FreightRepository get freightProvider {
    switch (this) {
      case FreightProvider.mock: return MockFreightAdapter();
    }
  }
}