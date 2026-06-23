import 'package:ecommerce_b2b/app/presentation/widgets/b2b_app_bar.dart';
import 'package:ecommerce_b2b/modules/catalog/product/presentation/pages/product_list_view.dart';
import 'package:ecommerce_b2b/modules/catalog/price_table/presentation/pages/price_table_list_view.dart';
import 'package:flutter/material.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const B2BAppBar(
          title: 'Catálogo de Produtos',
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.inventory_2_rounded), text: 'Produtos'),
              Tab(icon: Icon(Icons.sell_rounded), text: 'Tabelas de Preços'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ProductListView(),
            PriceTableListView(),
          ],
        ),
      ),
    );
  }
}
