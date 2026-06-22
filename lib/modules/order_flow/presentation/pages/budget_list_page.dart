import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_b2b/modules/order_flow/presentation/controllers/budget/budget_list_cubit.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';

class BudgetListPage extends StatelessWidget {
  const BudgetListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BudgetListCubit(),
      child: const _BudgetListView(),
    );
  }
}

class _BudgetListView extends StatelessWidget {
  const _BudgetListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Orçamentos'),
      ),
      body: BlocConsumer<BudgetListCubit, BudgetListState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red));
          }
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.successMessage!), backgroundColor: Colors.green));
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.budgets.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.budgets.isEmpty) {
            return const Center(child: Text('Nenhum orçamento salvo.', style: TextStyle(fontSize: 16, color: Colors.grey)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.budgets.length,
            itemBuilder: (context, index) {
              final budget = state.budgets[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ID: ${budget.id.value.substring(0, 8)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const Chip(
                            label: Text('Rascunho'),
                            backgroundColor: Colors.amberAccent,
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Data: ${budget.createdAt.toLocal().toString().split('.')[0]}'),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('Converter em Pedido'),
                          onPressed: () {
                            context.read<BudgetListCubit>().convertToOrder(budget);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
