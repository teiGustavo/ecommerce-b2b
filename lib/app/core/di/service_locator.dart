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
import 'package:ecommerce_b2b/modules/order_flow/sales_order/presentation/finance_review/cubit/finance_review_cubit.dart';
import 'package:ecommerce_b2b/modules/identity_access/presentation/cubit/auth_cubit.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/presentation/cubit/representative_dashboard_cubit.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/application/get_companies/get_companies_use_case.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/application/register_company/register_company_use_case.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/application/add_authorized_buyer/add_authorized_buyer_use_case.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/presentation/cubit/company_management_cubit.dart';
import 'package:ecommerce_b2b/modules/catalog/price_table/presentation/cubit/price_table_cubit.dart';
import 'package:ecommerce_b2b/modules/catalog/product/presentation/cubit/catalog_cubit.dart';
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

  getIt.registerFactory(() => CatalogCubit(
    getIt<GetProductsUseCase>(),
    getIt<SaveProductUseCase>(),
  ));

  getIt.registerFactory(() => PriceTableCubit(
    getIt<GetPriceTablesUseCase>(),
    getIt<SavePriceTableUseCase>(),
  ));
}

Future<void> _seedDatabase(AppDatabase db) async {
  final companiesList = await db.select(db.companies).get();
  final usersList = await db.customSelect('SELECT id FROM users LIMIT 1').get();

  final companyRepo = DriftCompanyRepository(db);
  final repRepo = DriftSalesRepresentativeRepository(db);
  final orderRepo = DriftSalesOrderRepository(db);

  if (companiesList.isEmpty) {
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

    await orderRepo.save(order1);
    await orderRepo.save(order2);
  }

  if (usersList.isEmpty) {
    final now = DateTime.now();
    Future<void> insertUser({
      required String fullName,
      required String email,
      required String role,
      String? companyId,
    }) {
      return db.customInsert(
        'INSERT OR REPLACE INTO users (id, full_name, email, password_hash, role, company_id, active, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
        variables: [
          Variable(generateId()),
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
    );
    await insertUser(
      fullName: 'Financeiro Mock',
      email: 'finance@test.com',
      role: UserRole.finance.name,
    );
  }

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
