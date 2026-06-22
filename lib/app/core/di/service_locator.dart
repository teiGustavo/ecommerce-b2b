import 'package:get_it/get_it.dart';

// Domain Services
import 'package:ecommerce_b2b/modules/catalog/domain/services/order_pricing_domain_service.dart';
import 'package:ecommerce_b2b/modules/inventory/domain/services/inventory_allocator_domain_service.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/services/credit_policy_domain_service.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/services/order_state_machine_domain_service.dart';
import 'package:ecommerce_b2b/modules/sales_team/domain/services/commission_calculator_domain_service.dart';
import 'package:ecommerce_b2b/modules/sales_team/domain/services/sales_hierarchy_domain_service.dart';

// Repositories (Interfaces)
import 'package:ecommerce_b2b/modules/logistics/domain/aggregates/shipment/repositories/tracking_repository.dart';
import 'package:ecommerce_b2b/modules/logistics/domain/aggregates/shipment/repositories/freight_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/repositories/sales_order_repository.dart';
import 'package:ecommerce_b2b/modules/customer_portal/domain/repositories/boleto_repository.dart';

// Adapters (Implementations)
import 'package:ecommerce_b2b/modules/logistics/infrastructure/shipment/adapters/mock/mock_tracking_adapter.dart';
import 'package:ecommerce_b2b/modules/logistics/infrastructure/shipment/adapters/mock/mock_freight_adapter.dart';

// Use Cases
import 'package:ecommerce_b2b/modules/order_flow/application/process_finance_review/process_finance_review_use_case.dart';
import 'package:ecommerce_b2b/modules/order_flow/application/convert_quote/convert_quote_to_order_use_case.dart';
import 'package:ecommerce_b2b/modules/order_flow/application/create_quote/create_quote_use_case.dart';
import 'package:ecommerce_b2b/modules/logistics/application/procces_order/process_order_shipment_use_case.dart';
import 'package:ecommerce_b2b/modules/customer_portal/application/open_return_request/open_return_request_use_case.dart';
import 'package:ecommerce_b2b/modules/customer_portal/application/download_boleto/download_boleto_use_case.dart';
import 'package:ecommerce_b2b/modules/customer_portal/application/get_purchase_history/get_purchase_history_use_case.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // --- Domain Services ---
  getIt.registerLazySingleton(() => OrderPricingDomainService());
  getIt.registerLazySingleton(() => InventoryAllocatorDomainService());
  getIt.registerLazySingleton(() => CreditPolicyDomainService());
  getIt.registerLazySingleton(() => OrderStateMachineDomainService());
  getIt.registerLazySingleton(() => CommissionCalculatorDomainService());
  getIt.registerLazySingleton(() => SalesHierarchyDomainService());

  // --- Infrastructure / Adapters ---
  getIt.registerLazySingleton<TrackingRepository>(() => MockTrackingAdapter());
  getIt.registerLazySingleton<FreightRepository>(() => MockFreightAdapter());

  // --- Use Cases ---
  getIt.registerLazySingleton(() => CreateQuoteUseCase(
    getIt<OrderPricingDomainService>(),
  ));

  getIt.registerLazySingleton(() => ConvertQuoteToOrderUseCase(
    getIt<CreditPolicyDomainService>(),
    getIt<InventoryAllocatorDomainService>(),
  ));

  getIt.registerLazySingleton(() => ProcessFinanceReviewUseCase(
    getIt<OrderStateMachineDomainService>(),
    getIt<InventoryAllocatorDomainService>(),
  ));

  getIt.registerLazySingleton(() => ProcessOrderShipmentUseCase(
    getIt<OrderStateMachineDomainService>(),
  ));

  getIt.registerLazySingleton(() => OpenReturnRequestUseCase(
    getIt<OrderStateMachineDomainService>(),
  ));

  getIt.registerLazySingleton(() => DownloadBoletoUseCase(
    getIt<BoletoRepository>(),
  ));

  getIt.registerLazySingleton(() => GetPurchaseHistoryUseCase(
    getIt<SalesOrderRepository>(),
  ));
}
