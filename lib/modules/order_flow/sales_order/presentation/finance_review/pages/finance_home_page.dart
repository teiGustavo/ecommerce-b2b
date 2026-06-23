import 'package:ecommerce_b2b/app/core/routes/app_pages.dart';
import 'package:ecommerce_b2b/app/presentation/widgets/user_profile_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FinanceHomePage extends StatelessWidget {
  const FinanceHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Painel Financeiro',
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
      body: RefreshIndicator(
        onRefresh: () async {
          // Simulação de recarregamento
          await Future.delayed(const Duration(seconds: 1));
        },
        child: CustomScrollView(
          slivers: [
            // Cabeçalho de Boas-vindas
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gestão de Risco',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.5,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Monitore a saúde financeira e aprove créditos.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Cards de Métricas Críticas (Expressive Row)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    _buildMetricCard(
                      context,
                      'Inadimplência',
                      '2.4%',
                      Icons.trending_down_rounded,
                      colorScheme.errorContainer,
                      colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 12),
                    _buildMetricCard(
                      context,
                      'Exposure Total',
                      'R\$ 1.2M',
                      Icons.account_balance_rounded,
                      colorScheme.secondaryContainer,
                      colorScheme.onSecondaryContainer,
                    ),
                  ],
                ),
              ),
            ),

            // Ação Principal: Revisão de Crédito
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                child: _buildActionHeroCard(
                  context,
                  'Revisão de Crédito',
                  'Existem 2 pedidos aguardando sua análise manual.',
                  Icons.gpp_maybe_rounded,
                  colorScheme.primary,
                  colorScheme.onPrimary,
                  () => context.go(AppPage.finance.path),
                ),
              ),
            ),

            // Seção de Atividades
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Text(
                  'Liberados Hoje',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      color: colorScheme.surfaceContainerLow,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: colorScheme.primaryContainer,
                          child: Icon(Icons.check_circle_outline_rounded,
                              color: colorScheme.onPrimaryContainer),
                        ),
                        title: Text('Pedido #99${80 - index} Liberado',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Cliente: Tech Solutions Ltda'),
                        trailing: const Icon(Icons.chevron_right_rounded),
                      ),
                    );
                  },
                  childCount: 3,
                ),
              ),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color backgroundColor,
    Color foregroundColor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: foregroundColor, size: 28),
            const SizedBox(height: 16),
            Text(
              value,
              style: TextStyle(
                color: foregroundColor,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: foregroundColor.withValues(alpha: 0.8),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionHeroCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color backgroundColor,
    Color foregroundColor,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(32),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: foregroundColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 36, color: foregroundColor),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: foregroundColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: foregroundColor.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 18, color: foregroundColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
