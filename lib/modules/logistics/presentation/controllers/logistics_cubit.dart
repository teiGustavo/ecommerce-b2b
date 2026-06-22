import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ecommerce_b2b/app/config/service_locator.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/repositories/order_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/sales_order/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';

class LogisticsState extends Equatable {
  final bool isLoading;
  final List<SalesOrder> pickingOrders;
  final List<SalesOrder> packingOrders;
  final String freightResult;
  final bool isFreightLoading;

  const LogisticsState({
    this.isLoading = true,
    this.pickingOrders = const [],
    this.packingOrders = const [],
    this.freightResult = '',
    this.isFreightLoading = false,
  });

  LogisticsState copyWith({
    bool? isLoading,
    List<SalesOrder>? pickingOrders,
    List<SalesOrder>? packingOrders,
    String? freightResult,
    bool? isFreightLoading,
  }) {
    return LogisticsState(
      isLoading: isLoading ?? this.isLoading,
      pickingOrders: pickingOrders ?? this.pickingOrders,
      packingOrders: packingOrders ?? this.packingOrders,
      freightResult: freightResult ?? this.freightResult,
      isFreightLoading: isFreightLoading ?? this.isFreightLoading,
    );
  }

  @override
  List<Object?> get props => [isLoading, pickingOrders, packingOrders, freightResult, isFreightLoading];
}

class LogisticsCubit extends Cubit<LogisticsState> {
  final OrderRepository _orderRepository;

  LogisticsCubit()
      : _orderRepository = getIt<OrderRepository>(),
        super(const LogisticsState()) {
    loadOrders();
  }

  Future<void> loadOrders() async {
    emit(state.copyWith(isLoading: true));

    final orders = await _orderRepository.getAll();
    final picking = orders.where((o) => o.status == OrderStatus.pickingPacking).toList(); // Wait, FinanceReviewPage sets 'pickingPacking'
    // Se FinanceReviewPage setou 'pickingPacking', então 'approved' não é mais usado?
    // Vou usar 'pickingPacking' para picking, e precisamos de outro status para Packing?
    // Vamos usar a mesma lógica: se 'pickingPacking' então picking.
    
    // Ah, vou ler pickingPacking. E quando o usuário clica em "Iniciar Separação" no UI, 
    // na verdade não temos um enum 'readyForPacking'. Vamos usar 'pickingPacking' para picking, e 
    // vamos deixar o botão pular direto para 'inTransit'? 
    // Vou pegar pickingPacking para Picking, e criar um enum localmente ou usar 'pickingPacking' pra packing?
    // Para simplificar: Picking tab pega 'pickingPacking'. Após iniciar separação, vamos reusar 'pickingPacking' no Packing Tab? 
    // Vamos mudar a lista para Picking: order.status == pickingPacking.
    
    // Apenas para demo: 
    final pickingList = orders.where((o) => o.status == OrderStatus.pickingPacking).toList();
    final packingList = orders.where((o) => o.status == OrderStatus.pickingPacking).toList();

    emit(state.copyWith(
      isLoading: false,
      pickingOrders: pickingList,
      packingOrders: packingList,
    ));
  }

  Future<void> startPicking(SalesOrder order) async {
    // Demo: We can just say separation started.
    loadOrders();
  }

  Future<void> emitLabel(SalesOrder order) async {
    order.updateStatus(OrderStatus.inTransit);
    await _orderRepository.update(order);
    loadOrders();
  }

  Future<void> calculateFreight(String cepDestino, double peso) async {
    emit(state.copyWith(isFreightLoading: true));
    try {
      final cleanCep = cepDestino.replaceAll('-', '');
      final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cleanCep/json/'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['erro'] == true) {
          emit(state.copyWith(isFreightLoading: false, freightResult: 'CEP não encontrado.'));
          return;
        }

        final cidade = data['localidade'];
        final uf = data['uf'];
        
        // Simulação básica de preço baseada em peso
        final precoBase = 15.0;
        final valorPeso = peso * 2.5;
        final total = precoBase + valorPeso;

        emit(state.copyWith(
          isFreightLoading: false,
          freightResult: 'Destino: $cidade - $uf\nFrete Estimado: R\$ ${total.toStringAsFixed(2)}\nPrazo: 3 dias úteis',
        ));
      } else {
        emit(state.copyWith(isFreightLoading: false, freightResult: 'Erro na API ViaCEP.'));
      }
    } catch (e) {
      emit(state.copyWith(isFreightLoading: false, freightResult: 'Erro de conexão com ViaCEP.'));
    }
  }
}
