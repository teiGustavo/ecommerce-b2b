import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ecommerce_b2b/app/config/service_locator.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/repositories/order_repository.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/repositories/company_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/sales_order/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/services/credit_policy_domain_service.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/services/order_state_machine_domain_service.dart';

class BudgetListState extends Equatable {
  final bool isLoading;
  final List<SalesOrder> budgets;
  final String? errorMessage;
  final String? successMessage;

  const BudgetListState({
    this.isLoading = true,
    this.budgets = const [],
    this.errorMessage,
    this.successMessage,
  });

  BudgetListState copyWith({
    bool? isLoading,
    List<SalesOrder>? budgets,
    String? errorMessage,
    String? successMessage,
  }) {
    return BudgetListState(
      isLoading: isLoading ?? this.isLoading,
      budgets: budgets ?? this.budgets,
      errorMessage: errorMessage, // Notice: we clear messages if not provided
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, budgets, errorMessage, successMessage];
}

class BudgetListCubit extends Cubit<BudgetListState> {
  final OrderRepository _orderRepository;
  final CompanyRepository _companyRepository;
  final CreditPolicyDomainService _creditPolicy;
  final OrderStateMachineDomainService _stateMachine;

  BudgetListCubit()
      : _orderRepository = getIt<OrderRepository>(),
        _companyRepository = getIt<CompanyRepository>(),
        _creditPolicy = CreditPolicyDomainService(),
        _stateMachine = OrderStateMachineDomainService(),
        super(const BudgetListState()) {
    loadBudgets();
  }

  Future<void> loadBudgets() async {
    emit(state.copyWith(isLoading: true, errorMessage: null, successMessage: null));
    final orders = await _orderRepository.getAll();
    final budgets = orders.where((o) => o.status == OrderStatus.draft).toList();
    emit(state.copyWith(isLoading: false, budgets: budgets));
  }

  Future<void> convertToOrder(SalesOrder order) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, successMessage: null));
    
    try {
      final companies = await _companyRepository.getAll();
      final company = companies.firstWhere((c) => c.id == order.companyId);

      _stateMachine.transitionTo(order, OrderStatus.pendingFinanceApproval);

      // Avaliação de crédito
      _creditPolicy.evaluate(order, company);

      // Salva a alteração
      await _orderRepository.update(order);

      String msg = '';
      if (order.creditStatus == CreditStatus.blocked) {
        msg = 'Pedido bloqueado por falta de limite. Enviado ao financeiro.';
      } else {
        msg = 'Pedido aprovado com sucesso! Enviado para separação.';
      }

      final orders = await _orderRepository.getAll();
      final budgets = orders.where((o) => o.status == OrderStatus.draft).toList();

      emit(state.copyWith(isLoading: false, budgets: budgets, successMessage: msg));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: 'Erro ao converter: $e'));
      loadBudgets();
    }
  }
}
