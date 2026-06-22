import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ecommerce_b2b/app/config/service_locator.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/repositories/company_repository.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/repositories/product_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/repositories/order_repository.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/company.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/aggregates/product/product.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/aggregates/product/product_variant.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/sales_order/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/sales_order/order_item.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/buyer_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/representative_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';

enum OrderEntryStatus { initial, loading, success, failure }

class OrderEntryState extends Equatable {
  final OrderEntryStatus status;
  final List<Company> availableCompanies;
  final List<Product> availableProducts;
  final Company? selectedCompany;
  final Product? selectedProduct;
  final ProductVariant? selectedVariant;
  final int quantity;
  final List<OrderItem> items; // Temporary list of items
  final String? errorMessage;

  const OrderEntryState({
    this.status = OrderEntryStatus.initial,
    this.availableCompanies = const [],
    this.availableProducts = const [],
    this.selectedCompany,
    this.selectedProduct,
    this.selectedVariant,
    this.quantity = 1,
    this.items = const [],
    this.errorMessage,
  });

  OrderEntryState copyWith({
    OrderEntryStatus? status,
    List<Company>? availableCompanies,
    List<Product>? availableProducts,
    Company? selectedCompany,
    Product? selectedProduct,
    ProductVariant? selectedVariant,
    int? quantity,
    List<OrderItem>? items,
    String? errorMessage,
    bool clearProduct = false,
    bool clearVariant = false,
  }) {
    return OrderEntryState(
      status: status ?? this.status,
      availableCompanies: availableCompanies ?? this.availableCompanies,
      availableProducts: availableProducts ?? this.availableProducts,
      selectedCompany: selectedCompany ?? this.selectedCompany,
      selectedProduct: clearProduct ? null : (selectedProduct ?? this.selectedProduct),
      selectedVariant: clearVariant ? null : (selectedVariant ?? this.selectedVariant),
      quantity: quantity ?? this.quantity,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        availableCompanies,
        availableProducts,
        selectedCompany,
        selectedProduct,
        selectedVariant,
        quantity,
        items,
        errorMessage
      ];
}

class OrderEntryCubit extends Cubit<OrderEntryState> {
  final CompanyRepository _companyRepository;
  final ProductRepository _productRepository;
  final OrderRepository _orderRepository;

  OrderEntryCubit()
      : _companyRepository = getIt<CompanyRepository>(),
        _productRepository = getIt<ProductRepository>(),
        _orderRepository = getIt<OrderRepository>(),
        super(const OrderEntryState()) {
    loadData();
  }

  Future<void> loadData() async {
    emit(state.copyWith(status: OrderEntryStatus.loading));
    try {
      final companies = await _companyRepository.getAll();
      final products = await _productRepository.getAll();
      emit(state.copyWith(
        status: OrderEntryStatus.initial,
        availableCompanies: companies,
        availableProducts: products,
      ));
    } catch (e) {
      emit(state.copyWith(status: OrderEntryStatus.failure, errorMessage: 'Erro ao carregar dados'));
    }
  }

  void selectCompany(Company company) {
    emit(state.copyWith(selectedCompany: company));
  }

  void selectProduct(Product product) {
    emit(state.copyWith(selectedProduct: product, clearVariant: true, quantity: 1));
  }

  void selectVariant(ProductVariant variant) {
    emit(state.copyWith(selectedVariant: variant));
  }

  void setQuantity(int quantity) {
    emit(state.copyWith(quantity: quantity));
  }

  void addItem() {
    if (state.selectedProduct == null || state.selectedVariant == null || state.quantity <= 0) return;

    final item = OrderItem(
      productId: state.selectedProduct!.id,
      quantity: Quantity.create(state.quantity).getOrThrow(),
      // Mocking price for now based on variant or generic
      unitPriceSnapshot: Money.create(100.0).getOrThrow(),
    );

    final updatedItems = List<OrderItem>.from(state.items)..add(item);
    
    emit(state.copyWith(
      items: updatedItems,
      clearProduct: true,
      clearVariant: true,
      quantity: 1,
    ));
  }

  void removeItem(OrderItem item) {
    final updatedItems = List<OrderItem>.from(state.items)..remove(item);
    emit(state.copyWith(items: updatedItems));
  }

  Future<void> saveDraft() async {
    if (state.selectedCompany == null || state.items.isEmpty) {
      emit(state.copyWith(errorMessage: 'Selecione uma empresa e adicione itens.'));
      return;
    }

    emit(state.copyWith(status: OrderEntryStatus.loading));
    try {
      final order = SalesOrder(
        id: OrderId('ORD_${DateTime.now().millisecondsSinceEpoch}'),
        companyId: state.selectedCompany!.id,
        buyerId: const BuyerId('auto_buyer'), // Padrão
        representativeId: state.selectedCompany!.representativeId ?? const RepresentativeId('rep_1'),
        createdAt: DateTime.now(),
        status: OrderStatus.draft, // Salva como rascunho
        creditStatus: CreditStatus.pending,
        items: state.items,
      );

      await _orderRepository.save(order);
      emit(state.copyWith(status: OrderEntryStatus.success));
    } catch (e) {
      emit(state.copyWith(status: OrderEntryStatus.failure, errorMessage: 'Erro ao salvar rascunho.'));
    }
  }
}
