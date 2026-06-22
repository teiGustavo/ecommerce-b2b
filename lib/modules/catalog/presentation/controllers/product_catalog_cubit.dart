import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ecommerce_b2b/app/config/service_locator.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/repositories/product_repository.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/aggregates/product/product.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/services/order_pricing_domain_service.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/aggregates/price_table/price_table.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/aggregates/price_table/price_rule.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/enums/price_scope_type.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/address/enums/state.dart' as addr_state;
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';
import 'package:ecommerce_b2b/modules/inventory/domain/repositories/warehouse_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/price_table_id.dart';

class ProductCatalogState extends Equatable {
  final bool isLoading;
  final List<Product> products;
  final Map<String, Money> productPrices; // SKU -> Price
  final Map<String, int> productStocks; // SKU -> Total Stock

  const ProductCatalogState({
    this.isLoading = true,
    this.products = const [],
    this.productPrices = const {},
    this.productStocks = const {},
  });

  ProductCatalogState copyWith({
    bool? isLoading,
    List<Product>? products,
    Map<String, Money>? productPrices,
    Map<String, int>? productStocks,
  }) {
    return ProductCatalogState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      productPrices: productPrices ?? this.productPrices,
      productStocks: productStocks ?? this.productStocks,
    );
  }

  @override
  List<Object?> get props => [isLoading, products, productPrices, productStocks];
}

class ProductCatalogCubit extends Cubit<ProductCatalogState> {
  final ProductRepository _productRepository;
  final OrderPricingDomainService _pricingService;
  final WarehouseRepository _warehouseRepository;

  ProductCatalogCubit()
      : _productRepository = getIt<ProductRepository>(),
        _warehouseRepository = getIt<WarehouseRepository>(),
        _pricingService = OrderPricingDomainService(),
        super(const ProductCatalogState()) {
    loadCatalog();
  }

  Future<void> loadCatalog() async {
    emit(state.copyWith(isLoading: true));

    final products = await _productRepository.getAll();

    // Mocking two price tables: Nacional and SP Regional
    final nationalTable = PriceTable(
      id: const PriceTableId('PT_NACIONAL'),
      name: 'Tabela Nacional Base',
      scopeType: PriceScopeType.national,
      rules: [
        PriceRule(
          minQuantity: Quantity.create(1).getOrThrow(),
          maxQuantity: Quantity.create(9999).getOrThrow(),
          state: addr_state.State.rioDeJaneiro, // Default to simulate fallback later
          unitPrice: Money.create(3500.0).getOrThrow(),
        ),
      ],
    );

    final spRegionalTable = PriceTable(
      id: const PriceTableId('PT_SP_REGIONAL'),
      name: 'Tabela SP Regional com Desconto',
      scopeType: PriceScopeType.regional,
      rules: [
        PriceRule(
          minQuantity: Quantity.create(1).getOrThrow(),
          maxQuantity: Quantity.create(9999).getOrThrow(),
          state: addr_state.State.saoPaulo,
          unitPrice: Money.create(3200.0).getOrThrow(), // Preço com desconto para SP
        ),
      ],
    );

    final Map<String, Money> prices = {};
    final Map<String, int> stocks = {};

    // Vamos simular que a empresa selecionada é de SP (baseado no form anterior que chumbamos SP)
    final currentState = addr_state.State.saoPaulo; 
    
    final warehouses = await _warehouseRepository.getAll(); 

    for (final product in products) {
      if (product.sku == 'SKU-TV-001') {
        prices[product.sku] = _pricingService.getUnitPrice(
          priceTable: spRegionalTable, // Usando a regional para TV
          quantity: Quantity.create(1).getOrThrow(),
          state: currentState,
        );
      } else {
        prices[product.sku] = _pricingService.getUnitPrice(
          priceTable: nationalTable, 
          quantity: Quantity.create(1).getOrThrow(),
          state: currentState,
        ); // Fallback vai pegar a primeira regra
      }

      int totalStock = 0;
      for (final w in warehouses) {
        final item = w.getStockItem(product.id);
        if (item != null) {
          totalStock += item.availableQuantity.value;
        }
      }
      stocks[product.sku] = totalStock;
    }

    emit(state.copyWith(
      isLoading: false,
      products: products,
      productPrices: prices,
      productStocks: stocks,
    ));
  }
}
