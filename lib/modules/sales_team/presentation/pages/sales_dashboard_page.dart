import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_b2b/modules/sales_team/presentation/controllers/sales_dashboard_cubit.dart';

class SalesDashboardPage extends StatelessWidget {
  const SalesDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SalesDashboardCubit(),
      child: const _SalesDashboardView(),
    );
  }
}

class _SalesDashboardView extends StatelessWidget {
  const _SalesDashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard do Representante'), actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => context.read<SalesDashboardCubit>().loadDashboard(),
        )
      ]),
      body: BlocBuilder<SalesDashboardCubit, SalesDashboardState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const Text('Comissões (Pedidos Faturados/Aprovados)', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        Text(
                          'R\$ ${state.totalCommission.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 32, 
                            fontWeight: FontWeight.bold, 
                            color: Theme.of(context).colorScheme.onPrimaryContainer
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Carteira de Clientes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (state.portfolio.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Nenhum cliente na sua carteira.'),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.portfolio.length,
                    itemBuilder: (context, index) {
                      final company = state.portfolio[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(child: Text(company.tradeName.substring(0, 1).toUpperCase())),
                          title: Text(company.tradeName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('CNPJ: ${company.cnpj.toString()}'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {},
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
