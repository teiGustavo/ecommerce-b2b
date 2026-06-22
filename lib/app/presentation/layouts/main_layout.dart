import 'package:flutter/material.dart';
import 'package:ecommerce_b2b/main.dart';
import 'package:ecommerce_b2b/modules/customer_management/presentation/pages/company_list_page.dart';
import 'package:ecommerce_b2b/modules/customer_management/presentation/pages/authorized_buyer_form_page.dart';
import 'package:ecommerce_b2b/modules/order_flow/presentation/pages/budget_list_page.dart';
import 'package:ecommerce_b2b/modules/order_flow/presentation/pages/order_entry_page.dart';
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
    const BudgetListPage(),
    const OrderEntryPage(),
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
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
              child: Image.asset(
                'assets/icon/ecommerce-b2b.png',
                width: 56,
                height: 56,
              ),
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
                icon: Icon(Icons.request_quote_outlined),
                selectedIcon: Icon(Icons.request_quote),
                label: Text('Orçamentos'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.add_shopping_cart_outlined),
                selectedIcon: Icon(Icons.add_shopping_cart),
                label: Text('Novo Pedido'),
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
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: ValueListenableBuilder<ThemeMode>(
                    valueListenable: themeNotifier,
                    builder: (context, currentMode, _) {
                      final isDark = currentMode == ThemeMode.dark ||
                          (currentMode == ThemeMode.system &&
                              MediaQuery.of(context).platformBrightness ==
                                  Brightness.dark);
                      return IconButton(
                        icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                        onPressed: () {
                          themeNotifier.value =
                              isDark ? ThemeMode.light : ThemeMode.dark;
                        },
                        tooltip: isDark
                            ? 'Mudar para Tema Claro'
                            : 'Mudar para Tema Escuro',
                      );
                    },
                  ),
                ),
              ),
            ),
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
