import 'package:get_it/get_it.dart';
import 'package:drift/drift.dart';

// Drift and Database
import 'package:ecommerce_b2b/modules/shared_kernel/infrastructure/database/app_database.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/infrastructure/database/database_seeder.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/infrastructure/repositories/drift_company_repository.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/infrastructure/repositories/drift_sales_representative_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/infrastructure/repositories/drift_sales_order_repository.dart';
import 'package:ecommerce_b2b/modules/identity_access/infrastructure/repositories/drift_auth_repository.dart';
import 'package:ecommerce_b2b/modules/inventory/warehouse/infrastructure/repositories/drift_inventory_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/infrastructure/repositories/drift_quote_repository.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/infrastructure/repositories/drift_shipment_repository.dart';
import 'package:ecommerce_b2b/modules/customer_portal/return_request/infrastructure/repositories/drift_return_request_repository.dart';

// Domain Services
import 'package:ecommerce_b2b/modules/catalog/price_table/domain/services/order_pricing_domain_service.dart';
import 'package:ecommerce_b2b/modules/inventory/warehouse/domain/services/inventory_allocator_domain_service.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/services/credit_policy_domain_service.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/services/order_state_machine_domain_service.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/services/commission_calculator_domain_service.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/services/sales_hierarchy_domain_service.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/services/credit_service.dart';
import 'package:ecommerce_b2b/modules/order_flow/application/order_workflow_service.dart';

// New Imports for Customer Portal
import 'package:ecommerce_b2b/modules/customer_portal/presentation/cubit/customer_portal_cubit.dart';
import 'package:ecommerce_b2b/modules/customer_portal/return_request/application/get_return_requests/get_return_requests_use_case.dart';
import 'package:ecommerce_b2b/modules/customer_portal/boleto/infrastructure/repositories/mock_boleto_repository.dart';

// Repositories (Interfaces)
import 'package:ecommerce_b2b/modules/catalog/price_table/domain/repositories/price_table_repository.dart';
import 'package:ecommerce_b2b/modules/catalog/product/domain/repositories/product_repository.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/repositories/company_repository.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/repositories/tracking_repository.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/repositories/freight_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/repositories/sales_order_repository.dart';
import 'package:ecommerce_b2b/modules/inventory/warehouse/domain/repositories/inventory_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/domain/repositories/quote_repository.dart';
import 'package:ecommerce_b2b/modules/customer_portal/boleto/domain/repositories/boleto_repository.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/repositories/shipment_repository.dart';
import 'package:ecommerce_b2b/modules/customer_portal/return_request/domain/repositories/return_request_repository.dart';
import 'package:ecommerce_b2b/modules/identity_access/domain/repositories/auth_repository.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/repositories/sales_representative_repository.dart';

// Adapters (Implementations)
import 'package:ecommerce_b2b/modules/catalog/price_table/infrastructure/repositories/drift_price_table_repository.dart';
import 'package:ecommerce_b2b/modules/catalog/product/infrastructure/repositories/drift_product_repository.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/infrastructure/repositories/adapters/mock/mock_tracking_adapter.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/infrastructure/repositories/adapters/mock/mock_freight_adapter.dart';

// Use Cases
import 'package:ecommerce_b2b/modules/catalog/price_table/application/get_price_tables/get_price_tables_use_case.dart';
import 'package:ecommerce_b2b/modules/catalog/price_table/application/save_price_table/save_price_table_use_case.dart';
import 'package:ecommerce_b2b/modules/catalog/product/application/get_products/get_products_use_case.dart';
import 'package:ecommerce_b2b/modules/catalog/product/application/save_product/save_product_use_case.dart';
import 'package:ecommerce_b2b/modules/catalog/product/application/delete_product/delete_product_use_case.dart';
import 'package:ecommerce_b2b/modules/catalog/product/application/delete_product_variant/delete_product_variant_use_case.dart';
import 'package:ecommerce_b2b/modules/logistics/application/procces_order/process_order_shipment_use_case.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/application/convert_quote/convert_quote_to_order_use_case.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/application/create_quote/create_quote_use_case.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/application/process_finance_review/process_finance_review_use_case.dart';
import 'package:ecommerce_b2b/modules/customer_portal/boleto/application/download_boleto/download_boleto_use_case.dart';
import 'package:ecommerce_b2b/modules/customer_portal/purchase_history/application/get_purchase_history/get_purchase_history_use_case.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/application/get_pending_finance_reviews/get_pending_finance_reviews_use_case.dart';
import 'package:ecommerce_b2b/modules/customer_portal/return_request/application/open_return_request/open_return_request_use_case.dart';
import 'package:ecommerce_b2b/modules/identity_access/application/login/login_use_case.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/application/get_commissions/get_representative_commissions_use_case.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/application/get_customers/get_customer_portfolio_use_case.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/application/get_quotes/get_recent_quotes_use_case.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/presentation/finance_review/cubit/finance_review_cubit.dart';
import 'package:ecommerce_b2b/modules/identity_access/presentation/cubit/auth_cubit.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/presentation/cubit/representative_dashboard_cubit.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/application/get_companies/get_companies_use_case.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/application/register_company/register_company_use_case.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/application/add_authorized_buyer/add_authorized_buyer_use_case.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/presentation/cubit/company_management_cubit.dart';
import 'package:ecommerce_b2b/modules/catalog/price_table/presentation/cubit/price_table_cubit.dart';
import 'package:ecommerce_b2b/modules/catalog/product/presentation/cubit/catalog_cubit.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/presentation/cubit/quote_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator({QueryExecutor? connection}) async {
  // --- Database ---
  final db = AppDatabase(connection ?? openConnection());
  getIt.registerSingleton<AppDatabase>(db);
  await DatabaseSeeder.seed(db);

  // --- Domain Services ---
  getIt.registerLazySingleton(() => OrderPricingDomainService());
  getIt.registerLazySingleton(() => InventoryAllocatorDomainService());
  getIt.registerLazySingleton(() => CreditPolicyDomainService());
  getIt.registerLazySingleton(() => OrderStateMachineDomainService());
  getIt.registerLazySingleton(() => CommissionCalculatorDomainService());
  getIt.registerLazySingleton(() => SalesHierarchyDomainService());
  getIt.registerLazySingleton(() => CreditService(getIt<CompanyRepository>(), getIt<SalesOrderRepository>()));
  getIt.registerLazySingleton(() => OrderWorkflowService(getIt<SalesOrderRepository>(), getIt<CreditService>()));

  // --- Infrastructure / Adapters ---
  getIt.registerLazySingleton<PriceTableRepository>(() => DriftPriceTableRepository(getIt<AppDatabase>()));
  getIt.registerLazySingleton<ProductRepository>(() => DriftProductRepository(getIt<AppDatabase>()));
  getIt.registerLazySingleton<CompanyRepository>(() => DriftCompanyRepository(getIt<AppDatabase>()));
  getIt.registerLazySingleton<TrackingRepository>(() => MockTrackingAdapter());
  getIt.registerLazySingleton<FreightRepository>(() => MockFreightAdapter());
  getIt.registerLazySingleton<AuthRepository>(() => DriftAuthRepository(getIt<AppDatabase>()));
  getIt.registerLazySingleton<SalesRepresentativeRepository>(() => DriftSalesRepresentativeRepository(getIt<AppDatabase>()));
  getIt.registerLazySingleton<SalesOrderRepository>(() => DriftSalesOrderRepository(getIt<AppDatabase>()));
  getIt.registerLazySingleton<InventoryRepository>(() => DriftInventoryRepository(getIt<AppDatabase>()));
  getIt.registerLazySingleton<QuoteRepository>(() => DriftQuoteRepository(getIt<AppDatabase>()));
  getIt.registerLazySingleton<ShipmentRepository>(() => DriftShipmentRepository(getIt<AppDatabase>()));
  getIt.registerLazySingleton<ReturnRequestRepository>(() => DriftReturnRequestRepository(getIt<AppDatabase>()));
  getIt.registerLazySingleton<BoletoRepository>(() => MockBoletoRepository());

  // --- Use Cases ---
  getIt.registerLazySingleton(() => LoginUseCase(
    getIt<AuthRepository>(),
  ));

  getIt.registerLazySingleton(() => GetRepresentativeCommissionsUseCase(
    getIt<SalesRepresentativeRepository>(),
    getIt<SalesHierarchyDomainService>(),
  ));

  getIt.registerLazySingleton(() => GetCustomerPortfolioUseCase(
    getIt<SalesRepresentativeRepository>(),
    getIt<SalesHierarchyDomainService>(),
  ));
  getIt.registerLazySingleton(() => GetRecentQuotesUseCase(
    getIt<QuoteRepository>(),
    getIt<SalesRepresentativeRepository>(),
    getIt<SalesHierarchyDomainService>(),
  ));
  getIt.registerLazySingleton(() => GetProductsUseCase(
    getIt<ProductRepository>(),
  ));
  getIt.registerLazySingleton(() => SaveProductUseCase(
    getIt<ProductRepository>(),
  ));
  getIt.registerLazySingleton(() => DeleteProductUseCase(
    getIt<ProductRepository>(),
  ));
  getIt.registerLazySingleton(() => DeleteProductVariantUseCase(
    getIt<ProductRepository>(),
  ));
  getIt.registerLazySingleton(() => GetPriceTablesUseCase(
    getIt<PriceTableRepository>(),
  ));
  getIt.registerLazySingleton(() => SavePriceTableUseCase(
    getIt<PriceTableRepository>(),
  ));
  getIt.registerLazySingleton(() => GetCompaniesUseCase(
    getIt<CompanyRepository>(),
    getIt<SalesRepresentativeRepository>(),
    getIt<SalesHierarchyDomainService>(),
  ));
  getIt.registerLazySingleton(() => RegisterCompanyUseCase(
    getIt<CompanyRepository>(),
  ));
  getIt.registerLazySingleton(() => AddAuthorizedBuyerUseCase(
    getIt<CompanyRepository>(),
  ));
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
    getIt<SalesOrderRepository>(),
  ));

  getIt.registerLazySingleton(() => ProcessOrderShipmentUseCase(
    getIt<OrderStateMachineDomainService>(),
    getIt<ShipmentRepository>(),
    getIt<SalesOrderRepository>(),
  ));

  getIt.registerLazySingleton(() => OpenReturnRequestUseCase(
    getIt<OrderStateMachineDomainService>(),
    getIt<ReturnRequestRepository>(),
    getIt<SalesOrderRepository>(),
  ));

  getIt.registerLazySingleton(() => DownloadBoletoUseCase(
    getIt<BoletoRepository>(),
  ));

  getIt.registerLazySingleton(() => GetPurchaseHistoryUseCase(
    getIt<SalesOrderRepository>(),
    getIt<SalesRepresentativeRepository>(),
    getIt<SalesHierarchyDomainService>(),
  ));

  getIt.registerLazySingleton(() => GetReturnRequestsUseCase(
    getIt<ReturnRequestRepository>(),
    getIt<SalesOrderRepository>(),
  ));

  getIt.registerLazySingleton(() => GetPendingFinanceReviewsUseCase(
    getIt<SalesOrderRepository>(),
  ));

  // --- Cubits ---
  getIt.registerLazySingleton(() => AuthCubit(
    loginUseCase: getIt<LoginUseCase>(),
    authRepository: getIt<AuthRepository>(),
  ));

  getIt.registerFactory(() => RepresentativeDashboardCubit(
    getCommissionsUseCase: getIt<GetRepresentativeCommissionsUseCase>(),
    getCustomerPortfolioUseCase: getIt<GetCustomerPortfolioUseCase>(),
    getRecentQuotesUseCase: getIt<GetRecentQuotesUseCase>(),
    representativeRepository: getIt<SalesRepresentativeRepository>(),
  ));

  getIt.registerFactory(() => FinanceReviewCubit(
    getPendingReviews: getIt<GetPendingFinanceReviewsUseCase>(),
    processReview: getIt<ProcessFinanceReviewUseCase>(),
    inventoryRepository: getIt<InventoryRepository>(),
  ));

  getIt.registerFactory(() => CompanyManagementCubit(
    getCompaniesUseCase: getIt<GetCompaniesUseCase>(),
    registerCompanyUseCase: getIt<RegisterCompanyUseCase>(),
    addAuthorizedBuyerUseCase: getIt<AddAuthorizedBuyerUseCase>(),
    representativeRepository: getIt<SalesRepresentativeRepository>(),
  ));

  getIt.registerFactory(() => CatalogCubit(
    getIt<GetProductsUseCase>(),
    getIt<SaveProductUseCase>(),
    getIt<DeleteProductUseCase>(),
    getIt<DeleteProductVariantUseCase>(),
  ));

  getIt.registerFactory(() => PriceTableCubit(
    getIt<GetPriceTablesUseCase>(),
    getIt<SavePriceTableUseCase>(),
  ));

  getIt.registerFactory(() => QuoteCubit(
    getIt<QuoteRepository>(),
  ));

  getIt.registerFactory(() => CustomerPortalCubit(
    getPurchaseHistoryUseCase: getIt<GetPurchaseHistoryUseCase>(),
    getReturnRequestsUseCase: getIt<GetReturnRequestsUseCase>(),
    downloadBoletoUseCase: getIt<DownloadBoletoUseCase>(),
    openReturnRequestUseCase: getIt<OpenReturnRequestUseCase>(),
  ));
}
