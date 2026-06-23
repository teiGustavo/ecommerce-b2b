import 'package:get_it/get_it.dart';

// Drift and Database
import 'package:ecommerce_b2b/modules/shared_kernel/infrastructure/database/app_database.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/infrastructure/repositories/drift_company_repository.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/infrastructure/repositories/drift_sales_representative_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/infrastructure/repositories/drift_sales_order_repository.dart';

// Domain entities for seeding
import 'package:ecommerce_b2b/modules/customer_management/company/domain/company.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/value_objects/cnpj.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/value_objects/inscricao_estadual.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/address/enums/state.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/address/value_objects/address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/buyer_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/email_address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/phone_number.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/authorized_buyer.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/customer_credit_account.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/sales_representative.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/representative_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/percentage.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/sales_order.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';

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

Future<void> setupServiceLocator() async {
  // --- Database ---
  final db = AppDatabase(openConnection());
  getIt.registerSingleton<AppDatabase>(db);
  await _seedDatabase(db);

  // --- Domain Services ---
  getIt.registerLazySingleton(() => OrderPricingDomainService());
  getIt.registerLazySingleton(() => InventoryAllocatorDomainService());
  getIt.registerLazySingleton(() => CreditPolicyDomainService());
  getIt.registerLazySingleton(() => OrderStateMachineDomainService());
  getIt.registerLazySingleton(() => CommissionCalculatorDomainService());
  getIt.registerLazySingleton(() => SalesHierarchyDomainService());

  // --- Infrastructure / Adapters ---
  getIt.registerLazySingleton<CompanyRepository>(() => DriftCompanyRepository(getIt<AppDatabase>()));
  getIt.registerLazySingleton<TrackingRepository>(() => MockTrackingAdapter());
  getIt.registerLazySingleton<FreightRepository>(() => MockFreightAdapter());
  getIt.registerLazySingleton<AuthRepository>(() => MockAuthAdapter());
  getIt.registerLazySingleton<SalesRepresentativeRepository>(() => DriftSalesRepresentativeRepository(getIt<AppDatabase>()));
  getIt.registerLazySingleton<SalesOrderRepository>(() => DriftSalesOrderRepository(getIt<AppDatabase>()));

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

Future<void> _seedDatabase(AppDatabase db) async {
  final companiesList = await db.select(db.companies).get();
  if (companiesList.isNotEmpty) return;

  final companyRepo = DriftCompanyRepository(db);
  final repRepo = DriftSalesRepresentativeRepository(db);
  final orderRepo = DriftSalesOrderRepository(db);

  // Seed Sales Representative
  final rep = SalesRepresentative(
    id: const RepresentativeId('rep-456'),
    fullName: 'Representante Mock',
    email: EmailAddress.create('rep@test.com').getOrThrow(),
    commissionRate: Percentage.create(5).getOrThrow(),
  );
  await repRepo.save(rep);

  // Seed Companies
  final company1 = Company(
    id: const CompanyId('c1'),
    legalName: 'Acme Corporation Ltda',
    tradeName: 'Acme Corp',
    cnpj: Cnpj.create('12345678000195').getOrThrow(),
    inscricaoEstadual: InscricaoEstadual.create('123456789').getOrThrow(),
    email: EmailAddress.create('contato@acme.com').getOrThrow(),
    phone: PhoneNumber.create('11999999999').getOrThrow(),
    billingAddress: Address.create(
      street: 'Avenida Paulista',
      number: '1000',
      neighborhood: 'Bela Vista',
      city: 'São Paulo',
      state: 'SP',
      zipCode: '01310100',
    ).getOrThrow(),
    shippingAddress: Address.create(
      street: 'Avenida Paulista',
      number: '1000',
      neighborhood: 'Bela Vista',
      city: 'São Paulo',
      state: 'SP',
      zipCode: '01310100',
    ).getOrThrow(),
    state: State.saoPaulo,
    creditLimit: Money.create(100000).getOrThrow(),
    authorizedBuyers: [
      AuthorizedBuyer(
        id: const BuyerId('buyer-1'),
        fullName: 'Carlos Comprador',
        email: EmailAddress.create('carlos@acme.com').getOrThrow(),
        phone: PhoneNumber.create('11988888888').getOrThrow(),
        positionTitle: 'Diretor de Compras',
        active: true,
      ),
    ],
    creditAccount: CustomerCreditAccount(
      preApprovedLimit: Money.create(100000).getOrThrow(),
      openBalance: Money.create(15000).getOrThrow(),
      pendingOrdersBalance: Money.create(5000).getOrThrow(),
    ),
  );

  final company2 = Company(
    id: const CompanyId('c2'),
    legalName: 'Indústrias Stark S.A.',
    tradeName: 'Stark Industries',
    cnpj: Cnpj.create('60746948000112').getOrThrow(),
    inscricaoEstadual: InscricaoEstadual.create('987654321').getOrThrow(),
    email: EmailAddress.create('contact@stark.com').getOrThrow(),
    phone: PhoneNumber.create('21999999999').getOrThrow(),
    billingAddress: Address.create(
      street: 'Avenida Atlântica',
      number: '400',
      neighborhood: 'Copacabana',
      city: 'Rio de Janeiro',
      state: 'RJ',
      zipCode: '22010000',
    ).getOrThrow(),
    shippingAddress: Address.create(
      street: 'Avenida Atlântica',
      number: '400',
      neighborhood: 'Copacabana',
      city: 'Rio de Janeiro',
      state: 'RJ',
      zipCode: '22010000',
    ).getOrThrow(),
    state: State.rioDeJaneiro,
    creditLimit: Money.create(500000).getOrThrow(),
    authorizedBuyers: [
      AuthorizedBuyer(
        id: const BuyerId('buyer-2'),
        fullName: 'Pepper Potts',
        email: EmailAddress.create('pepper@stark.com').getOrThrow(),
        phone: PhoneNumber.create('21988888888').getOrThrow(),
        positionTitle: 'CEO',
        active: true,
      ),
    ],
    creditAccount: CustomerCreditAccount(
      preApprovedLimit: Money.create(500000).getOrThrow(),
      openBalance: Money.create(0).getOrThrow(),
      pendingOrdersBalance: Money.create(45000).getOrThrow(),
    ),
  );

  await companyRepo.save(company1);
  await companyRepo.save(company2);

  // Seed Sales Orders
  final order1 = SalesOrder(
    id: const OrderId('order-101'),
    status: OrderStatus.blockedByFinance,
    creditStatus: CreditStatus.blocked,
    items: [],
  );
  final order2 = SalesOrder(
    id: const OrderId('order-102'),
    status: OrderStatus.pendingFinanceApproval,
    creditStatus: CreditStatus.approved,
    items: [],
  );

  await orderRepo.save(order1, companyId: const CompanyId('c1'));
  await orderRepo.save(order2, companyId: const CompanyId('c2'));
}
