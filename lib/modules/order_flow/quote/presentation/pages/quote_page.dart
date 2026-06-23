import 'package:ecommerce_b2b/app/presentation/widgets/b2b_app_bar.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/presentation/pages/create_quote_view.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/presentation/pages/quote_list_view.dart';
import 'package:flutter/material.dart';

class QuotePage extends StatelessWidget {
  const QuotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const B2BAppBar(
          title: 'Gestão de Orçamentos',
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.add_task_rounded), text: 'Novo Orçamento'),
              Tab(icon: Icon(Icons.list_alt_rounded), text: 'Meus Orçamentos'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CreateQuoteView(),
            QuoteListView(),
          ],
        ),
      ),
    );
  }
}
