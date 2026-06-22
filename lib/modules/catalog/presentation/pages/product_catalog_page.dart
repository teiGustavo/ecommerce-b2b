import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_b2b/modules/catalog/presentation/controllers/product_catalog_cubit.dart';
import 'package:ecommerce_b2b/modules/catalog/presentation/pages/product_form_page.dart';

class ProductCatalogPage extends StatelessWidget {
  const ProductCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCatalogCubit(),
      child: const _ProductCatalogView(),
    );
  }
}

class _ProductCatalogView extends StatelessWidget {
  const _ProductCatalogView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Produtos'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProductFormPage()));
          if (result == true && context.mounted) {
            context.read<ProductCatalogCubit>().loadCatalog();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Novo Produto'),
      ),
      body: BlocBuilder<ProductCatalogCubit, ProductCatalogState>(
        builder: (context, state) {
          if (state.isLoading) return const Center(child: CircularProgressIndicator());

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              final price = state.productPrices[product.sku];
              final stock = state.productStocks[product.sku] ?? 0;

              return Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image, size: 64, color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Text('SKU: ${product.sku}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text('${product.variants.length} variações', style: const TextStyle(fontSize: 12, color: Colors.blue)),
                          const SizedBox(height: 4),
                          Text('Estoque: $stock un', style: TextStyle(fontSize: 12, color: stock > 0 ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(
                            price != null ? 'R\$ ${price.amount.toStringAsFixed(2)}' : 'Sob consulta',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
