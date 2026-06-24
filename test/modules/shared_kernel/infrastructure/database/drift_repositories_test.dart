import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/authorized_buyer.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/company.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/customer_credit_account.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/value_objects/cnpj.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/value_objects/inscricao_estadual.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/infrastructure/repositories/drift_company_repository.dart';
import 'package:ecommerce_b2b/modules/identity_access/infrastructure/repositories/drift_auth_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/auth/errors/auth_errors.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/enums/finance_decision.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/finance_review.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/order_item.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/infrastructure/repositories/drift_sales_order_repository.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/sales_representative.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/infrastructure/repositories/drift_sales_representative_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/address/enums/state.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/address/value_objects/address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/buyer_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/id_generator.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/representative_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/email_address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/value_objects/phone_number.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/percentage.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/infrastructure/database/app_database.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/domain/enums/quote_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/domain/quote.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/domain/quote_item.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/infrastructure/repositories/drift_quote_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/quote_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late DriftCompanyRepository companyRepository;
  late DriftSalesRepresentativeRepository representativeRepository;
  late DriftSalesOrderRepository salesOrderRepository;
  late DriftAuthRepository authRepository;
  late DriftQuoteRepository quoteRepository;

  setUp(() async {
    // Start with an in-memory SQLite database connection for testing
    database = AppDatabase(NativeDatabase.memory());
    companyRepository = DriftCompanyRepository(database);
    representativeRepository = DriftSalesRepresentativeRepository(database);
    salesOrderRepository = DriftSalesOrderRepository(database);
    authRepository = DriftAuthRepository(database);
    quoteRepository = DriftQuoteRepository(database);

    final now = DateTime(2026, 6, 23);
    await database.customInsert(
      'INSERT OR REPLACE INTO users (id, full_name, email, password_hash, role, company_id, active, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
      variables: [
        Variable(generateId()),
        const Variable('Buyer Test'),
        const Variable('buyer@test.com'),
        Variable(BCrypt.hashpw('password123', BCrypt.gensalt())),
        const Variable('buyer'),
        Variable(generateId()),
        const Variable(true),
        Variable(now),
        Variable(now),
      ],
    );
  });

  tearDown(() async {
    await database.close();
  });

  group('DriftCompanyRepository Integration Tests', () {
    test('should save and find a company by id with authorized buyers', () async {
      final companyId = const CompanyId('comp-test-123');
      final company = Company(
        id: companyId,
        legalName: 'Super B2B Trade S.A.',
        tradeName: 'B2B Trade',
        cnpj: Cnpj.create('12345678000195').getOrThrow(),
        inscricaoEstadual: InscricaoEstadual.create('123456789').getOrThrow(),
        email: EmailAddress.create('contato@b2btrade.com').getOrThrow(),
        phone: PhoneNumber.create('11999999999').getOrThrow(),
        billingAddress: Address.create(
          street: 'Avenida Brasil',
          number: '123',
          neighborhood: 'Centro',
          city: 'Rio de Janeiro',
          state: 'RJ',
          zipCode: '20040000',
        ).getOrThrow(),
        shippingAddress: Address.create(
          street: 'Avenida Brasil',
          number: '123',
          neighborhood: 'Centro',
          city: 'Rio de Janeiro',
          state: 'RJ',
          zipCode: '20040000',
        ).getOrThrow(),
        state: State.rioDeJaneiro,
        creditLimit: Money.create(150000).getOrThrow(),
        authorizedBuyers: [
              AuthorizedBuyer(
                     id: BuyerId(generateId()),
            fullName: 'John Buyer',
            email: EmailAddress.create('john@b2btrade.com').getOrThrow(),
            phone: PhoneNumber.create('21988887777').getOrThrow(),
            positionTitle: 'Purchaser',
            active: true,
          ),
        ],
        creditAccount: CustomerCreditAccount(
          preApprovedLimit: Money.create(150000).getOrThrow(),
          openBalance: Money.create(20000).getOrThrow(),
          pendingOrdersBalance: Money.create(10000).getOrThrow(),
        ),
      );

      // Save company
      await companyRepository.save(company);

      // Find company
      final fetched = await companyRepository.findById(companyId);

      expect(fetched != null, isTrue);
      expect(fetched!.tradeName, 'B2B Trade');
      expect(fetched.cnpj.value, '12345678000195');
      expect(fetched.creditLimit.amount, 150000);
      expect(fetched.creditAccount.openBalance.amount, 20000);
      expect(fetched.creditAccount.pendingOrdersBalance.amount, 10000);
      expect(fetched.creditAccount.availableLimit.amount, 120000);

      expect(fetched.authorizedBuyers.length, 1);
      expect(fetched.authorizedBuyers.first.fullName, 'John Buyer');
      // IDs should be UUIDs (v7) after migration — just assert format and non-empty
      final buyerIdValue = fetched.authorizedBuyers.first.id.value;
      final uuidV7Regex = RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$' , caseSensitive: false);
      expect(buyerIdValue, isNotEmpty);
      expect(uuidV7Regex.hasMatch(buyerIdValue), isTrue);
    });

    test('should find all companies and by representative id', () async {
      final company1 = Company(
        id: const CompanyId('c1'),
        legalName: 'First S.A.',
        tradeName: 'First',
        cnpj: Cnpj.create('12345678000195').getOrThrow(),
        inscricaoEstadual: InscricaoEstadual.create('123456789').getOrThrow(),
        email: EmailAddress.create('c1@test.com').getOrThrow(),
        phone: PhoneNumber.create('11999999999').getOrThrow(),
        billingAddress: Address.create(street: 'Rua 1', number: '1', neighborhood: 'B', city: 'C', state: 'SP', zipCode: '01000000').getOrThrow(),
        shippingAddress: Address.create(street: 'Rua 1', number: '1', neighborhood: 'B', city: 'C', state: 'SP', zipCode: '01000000').getOrThrow(),
        state: State.saoPaulo,
        creditLimit: Money.create(5000).getOrThrow(),
        authorizedBuyers: [],
        creditAccount: CustomerCreditAccount(
          preApprovedLimit: Money.create(5000).getOrThrow(),
          openBalance: Money.create(0).getOrThrow(),
          pendingOrdersBalance: Money.create(0).getOrThrow(),
        ),
        representativeId: 'rep-456',
      );

      await companyRepository.save(company1);

      final list = await companyRepository.findAll();
      expect(list.length, 1);
      expect(list.first.tradeName, 'First');

      final repList = await companyRepository.findByRepresentativeId('rep-456');
      expect(repList.length, 1);
    });
  });

  group('DriftSalesRepresentativeRepository Integration Tests', () {
    test('should save and find sales representative by id', () async {
      final repId = const RepresentativeId('rep-test-01');
      final rep = SalesRepresentative(
        id: repId,
        fullName: 'Jane Representative',
        email: EmailAddress.create('jane@company.com').getOrThrow(),
        commissionRate: Percentage.create(8.5).getOrThrow(),
      );

      await representativeRepository.save(rep);

      final fetched = await representativeRepository.findById(repId);
      expect(fetched != null, isTrue);
      expect(fetched!.fullName, 'Jane Representative');
      expect(fetched.email.value, 'jane@company.com');
      expect(fetched.commissionRate.value, 8.5);

      final list = await representativeRepository.findAll();
      expect(list.length, 1);
    });
  });

  group('DriftSalesOrderRepository Integration Tests', () {
    test('should save and find sales orders by company id and status', () async {
      final orderId = const OrderId('order-test-555');
      final companyId = const CompanyId('comp-test-2');

      // Create a non-null date for testing persistence
      final fixedDate = DateTime(2026, 6, 23, 10, 0, 0);
      final orderWithFixedDate = SalesOrder(
        id: orderId,
        companyId: companyId.value,
        status: OrderStatus.pendingFinanceApproval,
        creditStatus: CreditStatus.approved,
        items: [
          OrderItem(
            productId: const ProductId('prod-1'),
            quantity: Quantity.create(5).getOrThrow(),
            unitPriceSnapshot: Money.create(120.0).getOrThrow(),
          ),
        ],
        financeReview: FinanceReview(
          decision: FinanceDecision.approved,
          reviewerId: 'finance-user-1',
          reviewedAt: fixedDate,
          justification: 'Approved automatically',
        ),
      );

      await salesOrderRepository.save(orderWithFixedDate);

      // Retrieve by company id
      final companyOrders = await salesOrderRepository.findByCompanyId(companyId);
      expect(companyOrders.length, 1);
      expect(companyOrders.first.id, orderId);
      expect(companyOrders.first.status, OrderStatus.pendingFinanceApproval);
      expect(companyOrders.first.creditStatus, CreditStatus.approved);
      expect(companyOrders.first.items.length, 1);
      expect(companyOrders.first.items.first.productId, const ProductId('prod-1'));
      expect(companyOrders.first.items.first.quantity.value, 5);
      expect(companyOrders.first.items.first.unitPriceSnapshot.amount, 120.0);
      expect(companyOrders.first.financeReview != null, isTrue);
      expect(companyOrders.first.financeReview!.reviewerId, 'finance-user-1');
      expect(companyOrders.first.financeReview!.reviewedAt, fixedDate);

      // Retrieve by status
      final statusOrders = await salesOrderRepository.findByStatus(OrderStatus.pendingFinanceApproval.name);
      expect(statusOrders.length, 1);
      expect(statusOrders.first.id, orderId);
    });
  });

  group('DriftAuthRepository Integration Tests', () {
    test('should persist active user session on login and clear on logout', () async {
      final email = EmailAddress.create('buyer@test.com').getOrThrow();
      
      final result = await authRepository.login(email, 'password123');
      expect(result.isSuccess, isTrue);
      
      final session = await authRepository.getCurrentSession();
      expect(session != null, isTrue);
      // After migration, session ids should be UUID v7 values
      final sessionUserId = session!.userId.value;
      final sessionCompanyId = session.companyId?.value;
      final uuidV7Regex = RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$' , caseSensitive: false);
      expect(uuidV7Regex.hasMatch(sessionUserId), isTrue);
      expect(session.isBuyer, isTrue);
      expect(sessionCompanyId != null, isTrue);
      expect(uuidV7Regex.hasMatch(sessionCompanyId!), isTrue);

      await authRepository.logout();
      
      final loggedOutSession = await authRepository.getCurrentSession();
      expect(loggedOutSession == null, isTrue);
    });

    test('should reject invalid password for stored user hash', () async {
      final email = EmailAddress.create('buyer@test.com').getOrThrow();

      final result = await authRepository.login(email, 'wrongpassword');

      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<InvalidCredentialsError>());
      expect(await authRepository.getCurrentSession() == null, isTrue);
    });
  });

  group('DriftQuoteRepository Integration Tests', () {
    test('should save and retrieve quote with items', () async {
      final quoteId = const QuoteId('q1');
      final quote = Quote(
        id: quoteId,
        status: QuoteStatus.draft,
        items: [
          QuoteItem(
            productId: const ProductId('p1'),
            quantity: Quantity.create(10).getOrThrow(),
            unitPrice: Money.create(50).getOrThrow(),
          ),
          QuoteItem(
            productId: const ProductId('p2'),
            quantity: Quantity.create(5).getOrThrow(),
            unitPrice: Money.create(100).getOrThrow(),
          ),
        ],
      );

      await quoteRepository.save(quote);

      final fetched = await quoteRepository.getById(quoteId);
      expect(fetched != null, isTrue);
      expect(fetched!.id, quoteId);
      expect(fetched.status, QuoteStatus.draft);
      expect(fetched.items.length, 2);
      expect(fetched.items.first.productId, const ProductId('p1'));
      expect(fetched.items.first.quantity.value, 10);
      expect(fetched.items.first.unitPrice.amount, 50);

      final allQuotes = await quoteRepository.getAll();
      expect(allQuotes.length, 1);
    });
  });
}
