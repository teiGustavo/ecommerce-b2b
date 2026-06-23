import 'package:ecommerce_b2b/modules/customer_management/company/application/add_authorized_buyer/add_authorized_buyer_use_case.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/application/get_companies/get_companies_use_case.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/application/register_company/register_company_use_case.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/domain/errors/cnpj_errors.dart';
import 'package:ecommerce_b2b/modules/customer_management/company/infrastructure/repositories/adapters/mock/mock_company_adapter.dart';
import 'package:ecommerce_b2b/modules/identity_access/domain/enums/user_role.dart';
import 'package:ecommerce_b2b/modules/identity_access/domain/user_session.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/user_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/auth/errors/auth_errors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MockCompanyAdapter companyRepository;
  late GetCompaniesUseCase getCompaniesUseCase;
  late RegisterCompanyUseCase registerCompanyUseCase;
  late AddAuthorizedBuyerUseCase addAuthorizedBuyerUseCase;

  setUp(() {
    companyRepository = MockCompanyAdapter();
    getCompaniesUseCase = GetCompaniesUseCase(companyRepository);
    registerCompanyUseCase = RegisterCompanyUseCase(companyRepository);
    addAuthorizedBuyerUseCase = AddAuthorizedBuyerUseCase(companyRepository);
  });

  group('GetCompaniesUseCase', () {
    test('should return all companies for a finance user', () async {
      final session = UserSession(
        userId: const UserId('finance-1'),
        role: UserRole.finance,
      );

      final result = await getCompaniesUseCase.execute(session);

      expect(result.isSuccess, isTrue);
      final list = result.getOrThrow();
      expect(list.length, 2);
    });

    test('should return representative companies for representative', () async {
      final session = UserSession(
        userId: const UserId('rep-456'),
        role: UserRole.representative,
      );

      final result = await getCompaniesUseCase.execute(session);

      expect(result.isSuccess, isTrue);
      final list = result.getOrThrow();
      expect(list.length, 2);
    });

    test('should return only own company for buyer', () async {
      final session = UserSession(
        userId: const UserId('buyer-1'),
        role: UserRole.buyer,
        companyId: const CompanyId('c1'),
      );

      final result = await getCompaniesUseCase.execute(session);

      expect(result.isSuccess, isTrue);
      final list = result.getOrThrow();
      expect(list.length, 1);
      expect(list.first.id, const CompanyId('c1'));
    });
  });

  group('RegisterCompanyUseCase', () {
    test('should successfully register a company for non-buyer roles', () async {
      final session = UserSession(
        userId: const UserId('rep-1'),
        role: UserRole.representative,
      );

      final result = await registerCompanyUseCase.execute(
        currentSession: session,
        legalName: 'Test Legal Name S.A.',
        tradeName: 'Test Trade Name',
        cnpj: '12345678000195', // valid CNPJ
        inscricaoEstadual: '123456789',
        email: 'test@company.com',
        phone: '11999999999',
        billingStreet: 'Test Street',
        billingNumber: '100',
        billingNeighborhood: 'Neighborhood',
        billingCity: 'São Paulo',
        billingState: 'SP',
        billingZipCode: '01000-000',
        shippingStreet: 'Test Street',
        shippingNumber: '100',
        shippingNeighborhood: 'Neighborhood',
        shippingCity: 'São Paulo',
        shippingState: 'SP',
        shippingZipCode: '01000-000',
        creditLimit: 25000,
      );

      expect(result.isSuccess, isTrue);
      final company = result.getOrThrow();
      expect(company.tradeName, 'Test Trade Name');
      expect(company.creditLimit.amount, 25000);
    });

    test('should return failure for buyer registering a company', () async {
      final session = UserSession(
        userId: const UserId('buyer-1'),
        role: UserRole.buyer,
        companyId: const CompanyId('c1'),
      );

      final result = await registerCompanyUseCase.execute(
        currentSession: session,
        legalName: 'Test Legal Name S.A.',
        tradeName: 'Test Trade Name',
        cnpj: '12345678000195',
        inscricaoEstadual: '123456789',
        email: 'test@company.com',
        phone: '11999999999',
        billingStreet: 'Test Street',
        billingNumber: '100',
        billingNeighborhood: 'Neighborhood',
        billingCity: 'São Paulo',
        billingState: 'SP',
        billingZipCode: '01000-000',
        shippingStreet: 'Test Street',
        shippingNumber: '100',
        shippingNeighborhood: 'Neighborhood',
        shippingCity: 'São Paulo',
        shippingState: 'SP',
        shippingZipCode: '01000-000',
        creditLimit: 25000,
      );

      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<UnauthorizedError>());
    });

    test('should return failure for invalid CNPJ', () async {
      final session = UserSession(
        userId: const UserId('rep-1'),
        role: UserRole.representative,
      );

      final result = await registerCompanyUseCase.execute(
        currentSession: session,
        legalName: 'Test Legal Name S.A.',
        tradeName: 'Test Trade Name',
        cnpj: '11111111111111', // invalid CNPJ
        inscricaoEstadual: '123456789',
        email: 'test@company.com',
        phone: '11999999999',
        billingStreet: 'Test Street',
        billingNumber: '100',
        billingNeighborhood: 'Neighborhood',
        billingCity: 'São Paulo',
        billingState: 'SP',
        billingZipCode: '01000-000',
        shippingStreet: 'Test Street',
        shippingNumber: '100',
        shippingNeighborhood: 'Neighborhood',
        shippingCity: 'São Paulo',
        shippingState: 'SP',
        shippingZipCode: '01000-000',
        creditLimit: 25000,
      );

      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<CnpjError>());
    });
  });

  group('AddAuthorizedBuyerUseCase', () {
    test('should successfully add a buyer to a company', () async {
      final session = UserSession(
        userId: const UserId('rep-1'),
        role: UserRole.representative,
      );

      final result = await addAuthorizedBuyerUseCase.execute(
        currentSession: session,
        companyId: const CompanyId('c1'),
        fullName: 'New Buyer Name',
        email: 'newbuyer@acme.com',
        phone: '11988888888',
        positionTitle: 'Coordinator',
      );

      expect(result.isSuccess, isTrue);
      final company = result.getOrThrow();
      expect(company.authorizedBuyers.any((b) => b.fullName == 'New Buyer Name'), isTrue);
    });

    test('should return failure when buyer tries to add a buyer', () async {
      final session = UserSession(
        userId: const UserId('buyer-1'),
        role: UserRole.buyer,
        companyId: const CompanyId('c1'),
      );

      final result = await addAuthorizedBuyerUseCase.execute(
        currentSession: session,
        companyId: const CompanyId('c1'),
        fullName: 'New Buyer Name',
        email: 'newbuyer@acme.com',
        phone: '11988888888',
        positionTitle: 'Coordinator',
      );

      expect(result.isFailure, isTrue);
      expect(result.getFailureOrThrow(), isA<UnauthorizedError>());
    });
  });
}
