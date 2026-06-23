import 'package:ecommerce_b2b/app/core/di/service_locator.dart';
import 'package:ecommerce_b2b/modules/identity_access/presentation/cubit/auth_cubit.dart';
import 'package:ecommerce_b2b/app/presentation/widgets/user_profile_dropdown.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/presentation/cubit/representative_dashboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RepresentativeHomePage extends StatelessWidget {
  const RepresentativeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authState = context.watch<AuthCubit>().state;

    if (authState is! AuthAuthenticated) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final session = authState.session;

    return BlocProvider(
      create: (context) => getIt<RepresentativeDashboardCubit>()..loadDashboard(session),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Painel do Representante',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          centerTitle: false,
          actions: const [UserProfileDropdown()],
          elevation: 0,
          scrolledUnderElevation: 3,
          backgroundColor: colorScheme.surface,
          surfaceTintColor: colorScheme.surface,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              height: 1.0,
            ),
          ),
        ),
        body: BlocBuilder<RepresentativeDashboardCubit, RepresentativeDashboardState>(
          builder: (context, state) {
            if (state is RepresentativeDashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is RepresentativeDashboardFailure) {
              return Center(child: Text(state.message, style: TextStyle(color: colorScheme.error)));
            }

            if (state is RepresentativeDashboardLoaded) {
              return RefreshIndicator(
                onRefresh: () => context.read<RepresentativeDashboardCubit>().loadDashboard(session),
                child: CustomScrollView(
                  slivers: [
                    // Resumo Expressivo
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Seu Desempenho',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                _buildMetricCard(
                                  context,
                                  'Comissões',
                                  'R\$ ${_calculateTotalCommissions(state.commissions)}',
                                  Icons.payments_outlined,
                                  colorScheme.primaryContainer,
                                ),
                                const SizedBox(width: 12),
                                _buildMetricCard(
                                  context,
                                  'Carteira',
                                  '${state.assignments.length} Clientes',
                                  Icons.supervised_user_circle_outlined,
                                  colorScheme.secondaryContainer,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Ações de Venda
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Text(
                          'Vendas',
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            _buildActionCard(
                              context,
                              'Novo Orçamento',
                              Icons.add_shopping_cart_rounded,
                              colorScheme.tertiaryContainer,
                            ),
                            _buildActionCard(
                              context,
                              'Ver Catálogo',
                              Icons.auto_awesome_mosaic_rounded,
                              colorScheme.surfaceContainerHigh,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Lista de Comissões Recentes
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                        child: Text(
                          'Comissões Recentes',
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    if (state.commissions.isEmpty)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Center(child: Text('Nenhuma comissão registrada.')),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final commission = state.commissions[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: colorScheme.surfaceContainerHighest,
                                    child: const Icon(Icons.attach_money_rounded),
                                  ),
                                  title: Text('Comissão de ${commission.amount.toString()}'),
                                  subtitle: Text('Base: ${commission.baseAmount.toString()}'),
                                  trailing: const Icon(Icons.chevron_right_rounded),
                                ),
                              );
                            },
                            childCount: state.commissions.length,
                          ),
                        ),
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 32)),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  String _calculateTotalCommissions(List<dynamic> commissions) {
    // Simplificação para o mockup
    return '1.250,00';
  }

  Widget _buildMetricCard(BuildContext context, String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        color: color,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 28),
              const SizedBox(height: 12),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String label, IconData icon, Color color) {
    return Expanded(
      child: Card(
        color: color,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              children: [
                Icon(icon, size: 32),
                const SizedBox(height: 8),
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
