import 'package:flutter/material.dart';
import 'package:ecommerce_b2b/modules/customer_management/presentation/pages/company_form_page.dart';
import 'package:ecommerce_b2b/modules/customer_management/presentation/pages/authorized_buyer_form_page.dart';
import 'package:ecommerce_b2b/modules/order_flow/presentation/pages/finance_review_page.dart';
import 'package:ecommerce_b2b/modules/sales_team/presentation/pages/sales_dashboard_page.dart';
import 'package:ecommerce_b2b/modules/catalog/presentation/pages/product_catalog_page.dart';
import 'package:ecommerce_b2b/modules/logistics/presentation/pages/logistics_dashboard_page.dart';
import 'package:ecommerce_b2b/modules/customer_portal/presentation/pages/customer_portal_page.dart';
import 'package:ecommerce_b2b/modules/order_flow/presentation/pages/order_entry_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('E-commerce B2B Menu')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildMenuButton(
            context,
            'Cadastro de Empresa',
            const CompanyFormPage(),
          ),
          _buildMenuButton(
            context,
            'Cadastro de Comprador',
            const AuthorizedBuyerFormPage(),
          ),
          _buildMenuButton(
            context,
            'Catálogo de Produtos',
            const ProductCatalogPage(),
          ),
          _buildMenuButton(context, 'Novo Pedido', const OrderEntryPage()),
          _buildMenuButton(
            context,
            'Revisão Financeira',
            const FinanceReviewPage(),
          ),
          _buildMenuButton(
            context,
            'Dashboard de Vendas',
            const SalesDashboardPage(),
          ),
          _buildMenuButton(
            context,
            'Logística e Expedição',
            const LogisticsDashboardPage(),
          ),
          _buildMenuButton(
            context,
            'Portal do Cliente',
            const CustomerPortalPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, Widget page) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Text(title, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
