import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ecommerce_b2b/app/config/service_locator.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/repositories/company_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/repositories/order_repository.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/company.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/representative_id.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';

class SalesDashboardState extends Equatable {
  final bool isLoading;
  final List<Company> portfolio;
  final double totalCommission;

  const SalesDashboardState({
    this.isLoading = true,
    this.portfolio = const [],
    this.totalCommission = 0.0,
  });

  SalesDashboardState copyWith({
    bool? isLoading,
    List<Company>? portfolio,
    double? totalCommission,
  }) {
    return SalesDashboardState(
      isLoading: isLoading ?? this.isLoading,
      portfolio: portfolio ?? this.portfolio,
      totalCommission: totalCommission ?? this.totalCommission,
    );
  }

  @override
  List<Object?> get props => [isLoading, portfolio, totalCommission];
}

class SalesDashboardCubit extends Cubit<SalesDashboardState> {
  final CompanyRepository _companyRepository;
  final OrderRepository _orderRepository;
  final RepresentativeId _currentRep = const RepresentativeId('REP_ALPHA_001');

  SalesDashboardCubit()
      : _companyRepository = getIt<CompanyRepository>(),
        _orderRepository = getIt<OrderRepository>(),
        super(const SalesDashboardState()) {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    emit(state.copyWith(isLoading: true));

    final companies = await _companyRepository.getAll();
    final myCompanies = companies.where((c) => c.representativeId == _currentRep).toList();

    final orders = await _orderRepository.getAll();
    final myOrders = orders.where((o) => o.representativeId == _currentRep).toList();

    double commission = 0.0;
    for (final order in myOrders) {
      if (order.status == OrderStatus.delivered || order.status == OrderStatus.inTransit || order.status == OrderStatus.pickingPacking) {
        // Comissão fixa de 5% sobre pedidos aprovados/faturados
        commission += order.total.amount * 0.05;
      }
    }

    emit(state.copyWith(
      isLoading: false,
      portfolio: myCompanies,
      totalCommission: commission,
    ));
  }
}
