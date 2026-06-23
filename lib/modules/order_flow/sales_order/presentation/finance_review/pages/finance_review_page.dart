import 'package:ecommerce_b2b/app/core/di/service_locator.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/presentation/finance_review/cubit/finance_review_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FinanceReviewPage extends StatelessWidget {
  const FinanceReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProvider(
      create: (context) => getIt<FinanceReviewCubit>()..loadPendingOrders(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Análise Financeira', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: BlocBuilder<FinanceReviewCubit, FinanceReviewState>(
          builder: (context, state) {
            if (state is FinanceReviewLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is FinanceReviewFailure) {
              return Center(child: Text(state.message, style: TextStyle(color: colorScheme.error)));
            }

            if (state is FinanceReviewLoaded) {
              if (state.pendingOrders.isEmpty) {
                return const Center(child: Text('Nenhum pedido aguardando revisão.'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.pendingOrders.length,
                itemBuilder: (context, index) {
                  final order = state.pendingOrders[index];
                  final isBlocked = order.status == OrderStatus.blockedByFinance;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pedido #${order.id.value.substring(0, 8)}',
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isBlocked ? colorScheme.errorContainer : colorScheme.tertiaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  isBlocked ? 'BLOQUEADO' : 'AGUARDANDO',
                                  style: TextStyle(
                                    color: isBlocked ? colorScheme.onErrorContainer : colorScheme.onTertiaryContainer,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text('Valor Total: ${order.total.toString()}', style: theme.textTheme.bodyLarge),
                          const Divider(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => _showReviewDialog(context, order, false),
                                style: TextButton.styleFrom(foregroundColor: colorScheme.error),
                                child: const Text('REPROVAR'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () => _showReviewDialog(context, order, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                ),
                                child: const Text('APROVAR'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showReviewDialog(BuildContext context, dynamic order, bool approve) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(approve ? 'Aprovar Pedido' : 'Reprovar Pedido'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Justificativa',
            hintText: 'Digite o motivo da decisão...',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('CANCELAR')),
          TextButton(
            onPressed: () {
              if (approve) {
                context.read<FinanceReviewCubit>().approveOrder(order, controller.text);
              } else {
                context.read<FinanceReviewCubit>().rejectOrder(order, controller.text);
              }
              Navigator.pop(dialogContext);
            },
            child: const Text('CONFIRMAR'),
          ),
        ],
      ),
    );
  }
}
