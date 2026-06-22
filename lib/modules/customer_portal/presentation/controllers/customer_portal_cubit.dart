import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ecommerce_b2b/app/config/service_locator.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/repositories/order_repository.dart';
import 'package:ecommerce_b2b/modules/customer_portal/domain/repositories/rma_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/sales_order/sales_order.dart';
import 'package:ecommerce_b2b/modules/customer_portal/domain/aggregates/rma.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/rma_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:ecommerce_b2b/modules/customer_portal/domain/enums/rma_status.dart';

class CustomerPortalState extends Equatable {
  final bool isLoading;
  final List<SalesOrder> myOrders;
  final List<Rma> myRmas;

  const CustomerPortalState({
    this.isLoading = true,
    this.myOrders = const [],
    this.myRmas = const [],
  });

  CustomerPortalState copyWith({
    bool? isLoading,
    List<SalesOrder>? myOrders,
    List<Rma>? myRmas,
  }) {
    return CustomerPortalState(
      isLoading: isLoading ?? this.isLoading,
      myOrders: myOrders ?? this.myOrders,
      myRmas: myRmas ?? this.myRmas,
    );
  }

  @override
  List<Object?> get props => [isLoading, myOrders, myRmas];
}

class CustomerPortalCubit extends Cubit<CustomerPortalState> {
  final OrderRepository _orderRepository;
  final RmaRepository _rmaRepository;

  CustomerPortalCubit()
      : _orderRepository = getIt<OrderRepository>(),
        _rmaRepository = getIt<RmaRepository>(),
        super(const CustomerPortalState()) {
    loadData();
  }

  Future<void> loadData() async {
    emit(state.copyWith(isLoading: true));
    final orders = await _orderRepository.getAll();
    final rmas = await _rmaRepository.getAll();
    emit(state.copyWith(
      isLoading: false,
      myOrders: orders, // Simplified: assuming all orders are mine
      myRmas: rmas,
    ));
  }

  Future<void> requestRma(SalesOrder order, String reason) async {
    final rma = Rma(
      id: RmaId(DateTime.now().millisecondsSinceEpoch.toString()),
      orderId: order.id,
      reason: reason,
      status: RmaStatus.pending,
    );
    await _rmaRepository.save(rma);
    loadData();
  }
}
