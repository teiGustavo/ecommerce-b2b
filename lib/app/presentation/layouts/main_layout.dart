import 'package:flutter/material.dart';
import 'package:ecommerce_b2b/modules/customer_management/presentation/pages/company_list_page.dart';
import 'package:ecommerce_b2b/modules/customer_management/presentation/pages/authorized_buyer_form_page.dart';
import 'package:ecommerce_b2b/modules/order_flow/presentation/pages/cart_page.dart';
import 'package:ecommerce_b2b/modules/order_flow/presentation/pages/budget_list_page.dart';
import 'package:ecommerce_b2b/modules/order_flow/presentation/pages/finance_review_page.dart';
import 'package:ecommerce_b2b/modules/sales_team/presentation/pages/sales_dashboard_page.dart';
import 'package:ecommerce_b2b/modules/catalog/presentation/pages/product_catalog_page.dart';
import 'package:ecommerce_b2b/modules/logistics/presentation/pages/logistics_dashboard_page.dart';
import 'package:ecommerce_b2b/modules/customer_portal/presentation/pages/customer_portal_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const SalesDashboardPage(),
    const ProductCatalogPage(),
    const CartPage(),
    const BudgetListPage(),
    const FinanceReviewPage(),
    const CompanyListPage(),
    const AuthorizedBuyerFormPage(),
    const LogisticsDashboardPage(),
    const CustomerPortalPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            leading: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Icon(Icons.business_center, size: 40, color: Colors.blue),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Vendas'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.inventory_2_outlined),
                selectedIcon: Icon(Icons.inventory_2),
                label: Text('Catálogo'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.shopping_cart_outlined),
                selectedIcon: Icon(Icons.shopping_cart),
                label: Text('Carrinho'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.request_quote_outlined),
                selectedIcon: Icon(Icons.request_quote),
                label: Text('Orçamentos'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.attach_money_outlined),
                selectedIcon: Icon(Icons.attach_money),
                label: Text('Financeiro'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.business_outlined),
                selectedIcon: Icon(Icons.business),
                label: Text('Empresas'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: Text('Compradores'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.local_shipping_outlined),
                selectedIcon: Icon(Icons.local_shipping),
                label: Text('Logística'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.headset_mic_outlined),
                selectedIcon: Icon(Icons.headset_mic),
                label: Text('Portal'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
