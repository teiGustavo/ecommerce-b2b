import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ecommerce_b2b/app/config/service_locator.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/repositories/company_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/repositories/order_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/sales_order/sales_order.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/buyer_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/representative_id.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/sales_order/order_item.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';

enum CartStatus { initial, loading, success, budgetSaved, creditBlocked, failure, noCompany }

class CartState extends Equatable {
  final CartStatus status;
  final double totalAmount;

  const CartState({
    this.status = CartStatus.initial,
    this.totalAmount = 5000.0, // Mock valor total do carrinho
  });

  CartState copyWith({
    CartStatus? status,
    double? totalAmount,
  }) {
    return CartState(
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  @override
  List<Object?> get props => [status, totalAmount];
}

class CartCubit extends Cubit<CartState> {
  final CompanyRepository _companyRepository;
  final OrderRepository _orderRepository;

  CartCubit() 
      : _companyRepository = getIt<CompanyRepository>(),
        _orderRepository = getIt<OrderRepository>(),
        super(const CartState());

  Future<void> saveBudget() async {
    await _processOrder(isBudget: true);
  }

  Future<void> checkout() async {
    await _processOrder(isBudget: false);
  }

  Future<void> _processOrder({required bool isBudget}) async {
    emit(state.copyWith(status: CartStatus.loading));
    await Future.delayed(const Duration(seconds: 1));

    final companies = await _companyRepository.getAll();
    if (companies.isEmpty) {
      emit(state.copyWith(status: CartStatus.noCompany));
      return;
    }

    final company = companies.first; // Seleciona a primeira empresa simulando login
    final availableCredit = company.creditLimit.amount;
    
    final orderId = OrderId(DateTime.now().millisecondsSinceEpoch.toString());
    var orderStatus = isBudget ? OrderStatus.draft : OrderStatus.pendingFinanceApproval;
    var finalStatus = isBudget ? CartStatus.budgetSaved : CartStatus.creditBlocked;

    if (!isBudget && state.totalAmount <= availableCredit) {
      orderStatus = OrderStatus.pickingPacking;
      finalStatus = CartStatus.success;
    }

    final order = SalesOrder(
      id: orderId,
      companyId: company.id,
      buyerId: BuyerId('mock_buyer'),
      representativeId: company.representativeId ?? RepresentativeId('mock_rep'),
      createdAt: DateTime.now(),
      status: orderStatus,
      creditStatus: finalStatus == CartStatus.creditBlocked ? CreditStatus.pending : CreditStatus.approved,
      items: [
        OrderItem(
          productId: const ProductId('mock_product'),
          quantity: Quantity.create(1).getOrThrow(),
          unitPriceSnapshot: Money.create(state.totalAmount).getOrThrow(),
        )
      ],
    );

    await _orderRepository.save(order);
    emit(state.copyWith(status: finalStatus));
  }
}

