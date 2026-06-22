import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:ecommerce_b2b/modules/logistics/presentation/controllers/logistics_cubit.dart';

class LogisticsDashboardPage extends StatelessWidget {
  const LogisticsDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogisticsCubit(),
      child: const _LogisticsDashboardView(),
    );
  }
}

class _LogisticsDashboardView extends StatefulWidget {
  const _LogisticsDashboardView();

  @override
  State<_LogisticsDashboardView> createState() => _LogisticsDashboardViewState();
}

class _LogisticsDashboardViewState extends State<_LogisticsDashboardView> {
  final zipFormatter = MaskTextInputFormatter(mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});
  final cepDestinoController = TextEditingController();
  final pesoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Logística e Expedição'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Picking'),
              Tab(text: 'Packing'),
              Tab(text: 'Simulador Frete'),
            ],
          ),
          actions: [
            IconButton(icon: const Icon(Icons.refresh), onPressed: () => context.read<LogisticsCubit>().loadOrders()),
          ],
        ),
        body: BlocBuilder<LogisticsCubit, LogisticsState>(
          builder: (context, state) {
            if (state.isLoading) return const Center(child: CircularProgressIndicator());

            return TabBarView(
              children: [
                _buildPickingTab(state),
                _buildPackingTab(state),
                _buildFreightSimulatorTab(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPickingTab(LogisticsState state) {
    if (state.pickingOrders.isEmpty) return const Center(child: Text('Nenhum pedido para separação.'));

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: state.pickingOrders.length,
      itemBuilder: (context, index) {
        final order = state.pickingOrders[index];
        return Card(
          child: ListTile(
            title: Text('Pedido: ${order.id.value.substring(0, 8)}'),
            subtitle: Text('Itens: ${order.items.length}'),
            trailing: ElevatedButton(
              onPressed: () {
                context.read<LogisticsCubit>().startPicking(order);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Separação Iniciada!')));
              },
              child: const Text('Iniciar Separação'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPackingTab(LogisticsState state) {
    if (state.packingOrders.isEmpty) return const Center(child: Text('Nenhum pedido para embalagem.'));

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: state.packingOrders.length,
      itemBuilder: (context, index) {
        final order = state.packingOrders[index];
        return Card(
          child: ListTile(
            title: Text('Pedido: ${order.id.value.substring(0, 8)}'),
            subtitle: const Text('Status: Separação Concluída'),
            trailing: ElevatedButton(
              onPressed: () {
                context.read<LogisticsCubit>().emitLabel(order);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Etiqueta Emitida! Pedido em Trânsito.')));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
              child: const Text('Emitir Etiqueta'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFreightSimulatorTab(BuildContext context, LogisticsState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Simulador de Frete (ViaCEP API)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: cepDestinoController,
            inputFormatters: [zipFormatter],
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'CEP Destino', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: pesoController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Peso Total (kg)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: state.isFreightLoading
                ? null
                : () {
                    final peso = double.tryParse(pesoController.text.replaceAll(',', '.')) ?? 1.0;
                    context.read<LogisticsCubit>().calculateFreight(cepDestinoController.text, peso);
                  },
            child: state.isFreightLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Calcular Frete'),
          ),
          const SizedBox(height: 24),
          if (state.freightResult.isNotEmpty)
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  state.freightResult,
                  style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
