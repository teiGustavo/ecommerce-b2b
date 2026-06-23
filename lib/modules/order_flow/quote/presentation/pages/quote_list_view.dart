import 'package:ecommerce_b2b/app/core/di/service_locator.dart';
import 'package:ecommerce_b2b/modules/identity_access/presentation/cubit/auth_cubit.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/domain/quote.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/domain/repositories/quote_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuoteListView extends StatefulWidget {
  const QuoteListView({super.key});

  @override
  State<QuoteListView> createState() => _QuoteListViewState();
}

class _QuoteListViewState extends State<QuoteListView> {
  List<Quote> _quotes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuotes();
  }

  Future<void> _loadQuotes() async {
    setState(() => _isLoading = true);
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      final repository = getIt<QuoteRepository>();
      final quotes = await repository.findByRepresentativeId(authState.session.userId.value);
      if (!mounted) return;
      setState(() {
        _quotes = quotes;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_quotes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_rounded, size: 64, color: colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              'Nenhum orçamento encontrado.',
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadQuotes,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _quotes.length,
        itemBuilder: (context, index) {
          final quote = _quotes[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 0,
            color: colorScheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                'Orçamento #${quote.id.value.substring(0, 8)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Status: ${quote.status.name} • Itens: ${quote.items.length}',
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                // TODO: Navegar para detalhes do orçamento
              },
            ),
          );
        },
      ),
    );
  }
}
