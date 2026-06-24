import 'package:get_it/get_it.dart';
import 'package:drift/drift.dart';
import 'package:bcrypt/bcrypt.dart';

// Drift and Database
import 'package:ecommerce_b2b/modules/shared_kernel/infrastructure/database/app_database.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/infrastructure/repositories/drift_company_repository.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/infrastructure/repositories/drift_sales_representative_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/infrastructure/repositories/drift_sales_order_repository.dart';
import 'package:ecommerce_b2b/modules/identity_access/infrastructure/repositories/drift_auth_repository.dart';
import 'package:ecommerce_b2b/modules/inventory/warehouse/infrastructure/repositories/drift_inventory_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/infrastructure/repositories/drift_quote_repository.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/infrastructure/repositories/drift_shipment_repository.dart';
import 'package:ecommerce_b2b/modules/customer_portal/return_request/infrastructure/repositories/drift_return_request_repository.dart';

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
import 'package:ecommerce_b2b/modules/identity_access/domain/enums/user_role.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/id_generator.dart';

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
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/order_item.dart';


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
import 'package:ecommerce_b2b/modules/catalog/price_table/domain/price_table.dart';
import 'package:ecommerce_b2b/modules/catalog/price_table/domain/price_rule.dart';
import 'package:ecommerce_b2b/modules/catalog/price_table/domain/enums/price_scope_type.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/price_table_id.dart';
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
import 'package:ecommerce_b2b/modules/catalog/product/domain/product.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';


final getIt = GetIt.instance;

Future<void> setupServiceLocator({QueryExecutor? connection}) async {
  // --- Database ---
  final db = AppDatabase(connection ?? openConnection());
  getIt.registerSingleton<AppDatabase>(db);
  await _seedDatabase(db);

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

Future<void> _seedDatabase(AppDatabase db) async {
  final companiesList = await db.select(db.companies).get();
  await db.customSelect('SELECT id FROM users LIMIT 1').get();
  final repsList = await db.select(db.salesRepresentativesTable).get();
  final ordersList = await db.select(db.salesOrdersTable).get();
  final commissionsList = await db.select(db.commissionsTable).get();
  final quotesList = await db.select(db.quotesTable).get();

  final companyRepo = DriftCompanyRepository(db);
  final repRepo = DriftSalesRepresentativeRepository(db);
  final orderRepo = DriftSalesOrderRepository(db);

  // Seed Sales Representatives & Supervisor Hierarchy
  final hasRep456 = repsList.any((r) => r.id == 'rep-456');
  final hasSupervisor = repsList.any((r) => r.id == 'rep-supervisor');

  if (!hasSupervisor) {
    final supervisor = SalesRepresentative(
      id: const RepresentativeId('rep-supervisor'),
      fullName: 'Supervisor Mock',
      email: EmailAddress.create('supervisor@test.com').getOrThrow(),
      commissionRate: Percentage.create(3).getOrThrow(),
    );
    await repRepo.save(supervisor);
  }

  if (!hasRep456) {
    final rep = SalesRepresentative(
      id: const RepresentativeId('rep-456'),
      fullName: 'Representante Mock',
      email: EmailAddress.create('rep@test.com').getOrThrow(),
      commissionRate: Percentage.create(5).getOrThrow(),
    );
    rep.setSupervisor(const RepresentativeId('rep-supervisor'));
    await repRepo.save(rep);
  } else {
    final repRow = repsList.firstWhere((r) => r.id == 'rep-456');
    if (repRow.supervisorId == null) {
      final rep = SalesRepresentative(
        id: const RepresentativeId('rep-456'),
        fullName: repRow.fullName,
        email: EmailAddress.create(repRow.email).getOrThrow(),
        commissionRate: Percentage.create(repRow.commissionRate).getOrThrow(),
      );
      rep.setSupervisor(const RepresentativeId('rep-supervisor'));
      await repRepo.save(rep);
    }
  }

  if (companiesList.isEmpty) {
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
      representativeId: 'rep-456',
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
      representativeId: 'rep-456',
    );

    await companyRepo.save(company1);
    await companyRepo.save(company2);
  }

  if (ordersList.isEmpty) {
    // Seed Sales Orders
    final order1 = SalesOrder(
      id: const OrderId('order-101'),
      companyId: 'c1',
      status: OrderStatus.blockedByFinance,
      creditStatus: CreditStatus.blocked,
      items: [],
    );
    final order2 = SalesOrder(
      id: const OrderId('order-102'),
      companyId: 'c2',
      status: OrderStatus.pendingFinanceApproval,
      creditStatus: CreditStatus.approved,
      items: [],
    );
    final order3 = SalesOrder(
      id: const OrderId('order-103'),
      companyId: 'c1',
      status: OrderStatus.delivered,
      creditStatus: CreditStatus.approved,
      items: [
        OrderItem(
          productId: const ProductId('p1'),
          quantity: Quantity.create(2).getOrThrow(),
          unitPriceSnapshot: Money.create(5000).getOrThrow(),
        ),
      ],
    );

    await orderRepo.save(order1);
    await orderRepo.save(order2);
    await orderRepo.save(order3);
  }

  if (commissionsList.isEmpty) {
    // Seed Commissions
    await db.into(db.commissionsTable).insert(CommissionsTableCompanion.insert(
      representativeId: 'rep-456',
      baseAmount: 5000.0,
      rate: 5.0,
      amount: 250.0,
      status: 'paid',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ));
    await db.into(db.commissionsTable).insert(CommissionsTableCompanion.insert(
      representativeId: 'rep-456',
      baseAmount: 10000.0,
      rate: 5.0,
      amount: 500.0,
      status: 'pending',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ));
  }

  if (quotesList.isEmpty) {
    // Seed Quotes
    await db.into(db.quotesTable).insert(QuotesTableCompanion.insert(
      id: 'quote-001',
      companyId: const Value('c1'),
      representativeId: const Value('rep-456'),
      status: 'draft',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ));
    await db.into(db.quotesTable).insert(QuotesTableCompanion.insert(
      id: 'quote-002',
      companyId: const Value('c2'),
      representativeId: const Value('rep-456'),
      status: 'sent',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ));
  }

  final now = DateTime.now();
  Future<void> insertUser({
    required String fullName,
    required String email,
    required String role,
    String? companyId,
    String? userId,
  }) async {
    final existing = await db.customSelect('SELECT id FROM users WHERE email = ?', variables: [Variable(email)]).get();
    if (existing.isEmpty) {
      await db.customInsert(
        'INSERT OR REPLACE INTO users (id, full_name, email, password_hash, role, company_id, active, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
        variables: [
          Variable(userId ?? generateId()),
          Variable(fullName),
          Variable(email),
          Variable(BCrypt.hashpw('password123', BCrypt.gensalt())),
          Variable(role),
          Variable(companyId),
          const Variable(true),
          Variable(now),
          Variable(now),
        ],
      );
    }
  }

  await insertUser(
    fullName: 'Carlos Comprador',
    email: 'buyer@test.com',
    role: UserRole.buyer.name,
    companyId: 'c1',
  );
  await insertUser(
    fullName: 'Representante Mock',
    email: 'rep@test.com',
    role: UserRole.representative.name,
    userId: 'rep-456',
  );
  await insertUser(
    fullName: 'Supervisor Mock',
    email: 'supervisor@test.com',
    role: UserRole.supervisor.name,
    userId: 'rep-supervisor',
  );
  await insertUser(
    fullName: 'Financeiro Mock',
    email: 'finance@test.com',
    role: UserRole.finance.name,
  );

  // Seed Products
  final productRepo = DriftProductRepository(db);
  final productsList = await productRepo.getAll();
  if (productsList.isEmpty) {
    await productRepo.save(Product(
      id: const ProductId('p1'),
      sku: 'SKU-001',
      name: 'Notebook Pro 15',
      description: 'Notebook de alta performance para empresas.',
      basePrice: Money.create(5500).getOrThrow(),
      active: true,
    ));
    await productRepo.save(Product(
      id: const ProductId('p2'),
      sku: 'SKU-002',
      name: 'Monitor UltraWide 34',
      description: 'Monitor curvo para máxima produtividade.',
      basePrice: Money.create(2800).getOrThrow(),
      active: true,
    ));
    await productRepo.save(Product(
      id: const ProductId('p3'),
      sku: 'SKU-003',
      name: 'Teclado Mecânico RGB',
      description: 'Teclado ergonômico e durável.',
      basePrice: Money.create(450).getOrThrow(),
      active: false,
    ));
  }

  // Seed Price Tables
  final priceTableRepo = DriftPriceTableRepository(db);
  final tables = await priceTableRepo.findAll();
  if (tables.isEmpty) {
    final table1 = PriceTable(
      id: const PriceTableId('pt-1'),
      name: 'Tabela Atacado SP',
      scopeType: PriceScopeType.regional,
      rules: [
        PriceRule(
          productId: const ProductId('p1'),
          minQuantity: Quantity.create(10).getOrThrow(),
          maxQuantity: Quantity.create(999).getOrThrow(),
          state: State.saoPaulo,
          unitPrice: Money.create(5000).getOrThrow(),
        ),
      ],
    );
    await priceTableRepo.save(table1);
  }
}
