import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_b2b/modules/customer_portal/presentation/controllers/customer_portal_cubit.dart';
import 'package:ecommerce_b2b/modules/customer_portal/domain/enums/rma_status.dart';

class CustomerPortalPage extends StatelessWidget {
  const CustomerPortalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomerPortalCubit(),
      child: const _CustomerPortalView(),
    );
  }
}

class _CustomerPortalView extends StatelessWidget {
  const _CustomerPortalView();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Portal do Cliente'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Histórico de Compras'),
              Tab(text: 'Devoluções (RMA)'),
            ],
          ),
          actions: [
            IconButton(icon: const Icon(Icons.refresh), onPressed: () => context.read<CustomerPortalCubit>().loadData()),
          ],
        ),
        body: BlocBuilder<CustomerPortalCubit, CustomerPortalState>(
          builder: (context, state) {
            if (state.isLoading) return const Center(child: CircularProgressIndicator());

            return TabBarView(
              children: [
                _buildOrderHistoryTab(context, state),
                _buildRmaTab(state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderHistoryTab(BuildContext context, CustomerPortalState state) {
    if (state.myOrders.isEmpty) return const Center(child: Text('Nenhum pedido encontrado.'));

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: state.myOrders.length,
      itemBuilder: (context, index) {
        final order = state.myOrders[index];
        return Card(
          child: ExpansionTile(
            title: Text('Pedido: ${order.id.value.substring(0, 8)} - Data: ${order.createdAt.toString().substring(0, 10)}'),
            subtitle: Text('Status: ${order.status.name} | R\$ ${order.total.amount.toStringAsFixed(2)}'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.download),
                      label: const Text('2ª Via Boleto'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Boleto baixado com sucesso.')));
                      },
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.autorenew),
                      label: const Text('Solicitar RMA'),
                      onPressed: () {
                        context.read<CustomerPortalCubit>().requestRma(order, 'Produto com defeito (Simulação)');
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('RMA Solicitado!')));
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildRmaTab(CustomerPortalState state) {
    if (state.myRmas.isEmpty) return const Center(child: Text('Nenhum RMA solicitado.'));

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: state.myRmas.length,
      itemBuilder: (context, index) {
        final rma = state.myRmas[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.assignment_return, color: Colors.orange),
            title: Text('RMA ID: ${rma.id.value.substring(0, 8)}'),
            subtitle: Text('Pedido Original: ${rma.orderId.value.substring(0, 8)}\nMotivo: ${rma.reason}'),
            trailing: Chip(
              label: Text(rma.status == RmaStatus.pending ? 'Em Análise' : rma.status.name),
              backgroundColor: Colors.orange.shade100,
            ),
          ),
        );
      },
    );
  }
}
