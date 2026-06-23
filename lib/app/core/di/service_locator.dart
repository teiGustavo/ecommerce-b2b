import 'package:get_it/get_it.dart';

// Domain Services
import 'package:ecommerce_b2b/modules/catalog/price_table/domain/services/order_pricing_domain_service.dart';
import 'package:ecommerce_b2b/modules/inventory/warehouse/domain/services/inventory_allocator_domain_service.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/services/credit_policy_domain_service.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/services/order_state_machine_domain_service.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/services/commission_calculator_domain_service.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/services/sales_hierarchy_domain_service.dart';


// Repositories (Interfaces)
import 'package:ecommerce_b2b/modules/customer_management/company/domain/repositories/company_repository.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/repositories/tracking_repository.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/repositories/freight_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/repositories/sales_order_repository.dart';
import 'package:ecommerce_b2b/modules/customer_portal/boleto/domain/repositories/boleto_repository.dart';
import 'package:ecommerce_b2b/modules/identity_access/domain/repositories/auth_repository.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/repositories/sales_representative_repository.dart';

// Adapters (Implementations)
import 'package:ecommerce_b2b/modules/customer_management/company/infrastructure/repositories/adapters/mock/mock_company_adapter.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/infrastructure/repositories/adapters/mock/mock_tracking_adapter.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/infrastructure/repositories/adapters/mock/mock_freight_adapter.dart';
import 'package:ecommerce_b2b/modules/identity_access/infrastructure/repositories/adapters/mock/mock_auth_adapter.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/infrastructure/repositories/adapters/mock/mock_sales_order_adapter.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/infrastructure/repositories/adapters/mock/mock_representative_adapter.dart';

// Use Cases
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
import 'package:ecommerce_b2b/modules/order_flow/sales_order/presentation/finance_review/cubit/finance_review_cubit.dart';
import 'package:ecommerce_b2b/modules/identity_access/presentation/cubit/auth_cubit.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/presentation/cubit/representative_dashboard_cubit.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/application/get_companies/get_companies_use_case.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/application/register_company/register_company_use_case.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/application/add_authorized_buyer/add_authorized_buyer_use_case.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/presentation/cubit/company_management_cubit.dart';


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
  getIt.registerLazySingleton<CompanyRepository>(() => MockCompanyAdapter());
  getIt.registerLazySingleton<TrackingRepository>(() => MockTrackingAdapter());
  getIt.registerLazySingleton<FreightRepository>(() => MockFreightAdapter());
  getIt.registerLazySingleton<AuthRepository>(() => MockAuthAdapter());
  getIt.registerLazySingleton<SalesRepresentativeRepository>(() => MockRepresentativeAdapter());
  getIt.registerLazySingleton<SalesOrderRepository>(() => MockSalesOrderAdapter());

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
  getIt.registerLazySingleton(() => GetCompaniesUseCase(
    getIt<CompanyRepository>(),
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
  ));

  getIt.registerFactory(() => FinanceReviewCubit(
    getPendingReviews: getIt<GetPendingFinanceReviewsUseCase>(),
    processReview: getIt<ProcessFinanceReviewUseCase>(),
  ));

  getIt.registerFactory(() => CompanyManagementCubit(
    getCompaniesUseCase: getIt<GetCompaniesUseCase>(),
    registerCompanyUseCase: getIt<RegisterCompanyUseCase>(),
    addAuthorizedBuyerUseCase: getIt<AddAuthorizedBuyerUseCase>(),
  ));
}
