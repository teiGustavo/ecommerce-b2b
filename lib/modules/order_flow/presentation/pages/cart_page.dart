import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_b2b/modules/order_flow/presentation/controllers/cart/cart_cubit.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartCubit(),
      child: const CartView(),
    );
  }
}

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrinho (Orçamento)')),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state.status == CartStatus.success) {
            _showDialog(context, 'Sucesso', 'Pedido aprovado e enviado para logística.', Colors.green);
          } else if (state.status == CartStatus.creditBlocked) {
            _showDialog(context, 'Bloqueado no Financeiro', 'O valor excedeu o limite de crédito. Enviado para análise.', Colors.orange);
          } else if (state.status == CartStatus.noCompany) {
            _showDialog(context, 'Erro', 'Nenhuma empresa cadastrada. Cadastre uma empresa primeiro.', Colors.red);
          } else if (state.status == CartStatus.budgetSaved) {
            _showDialog(context, 'Orçamento Salvo', 'Orçamento guardado com sucesso. Pode ser convertido em pedido depois.', Colors.blue);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text('Resumo do Pedido', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const Divider(),
                        ListTile(
                          title: const Text('Total do Pedido'),
                          trailing: Text('R\$ ${state.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                onPressed: state.status == CartStatus.loading
                                    ? null
                                    : () => context.read<CartCubit>().saveBudget(),
                                child: const Text('Salvar Orçamento', style: TextStyle(fontSize: 16)),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                onPressed: state.status == CartStatus.loading
                                    ? null
                                    : () => context.read<CartCubit>().checkout(),
                                child: state.status == CartStatus.loading
                                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                    : const Text('Finalizar Compra', style: TextStyle(fontSize: 16)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDialog(BuildContext context, String title, String message, Color color) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: TextStyle(color: color)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
