import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_b2b/modules/order_flow/presentation/controllers/order_entry/order_entry_cubit.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/company.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/aggregates/product/product.dart';
import 'package:ecommerce_b2b/modules/catalog/domain/aggregates/product/product_variant.dart';

class OrderEntryPage extends StatelessWidget {
  const OrderEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderEntryCubit(),
      child: const _OrderEntryView(),
    );
  }
}

class _OrderEntryView extends StatelessWidget {
  const _OrderEntryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Orçamento')),
      body: BlocConsumer<OrderEntryCubit, OrderEntryState>(
        listener: (context, state) {
          if (state.status == OrderEntryStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Orçamento salvo com sucesso!'), backgroundColor: Colors.green));
            // You can navigate away or clear the form here
            Navigator.of(context).pop();
          } else if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red));
          }
        },
        builder: (context, state) {
          if (state.status == OrderEntryStatus.loading && state.availableCompanies.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Dados do Cliente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                DropdownButtonFormField<Company>(
                  decoration: const InputDecoration(labelText: 'Selecione a Empresa Cliente'),
                  value: state.selectedCompany,
                  items: state.availableCompanies.map((c) => DropdownMenuItem(value: c, child: Text(c.legalName))).toList(),
                  onChanged: (val) {
                    if (val != null) context.read<OrderEntryCubit>().selectCompany(val);
                  },
                ),
                const SizedBox(height: 32),
                const Text('Adicionar Item', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                DropdownButtonFormField<Product>(
                  decoration: const InputDecoration(labelText: 'Selecione o Produto'),
                  value: state.selectedProduct,
                  items: state.availableProducts.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
                  onChanged: (val) {
                    if (val != null) context.read<OrderEntryCubit>().selectProduct(val);
                  },
                ),
                const SizedBox(height: 16),
                if (state.selectedProduct != null && state.selectedProduct!.variants.isNotEmpty)
                  DropdownButtonFormField<ProductVariant>(
                    decoration: const InputDecoration(labelText: 'Selecione a Variação'),
                    value: state.selectedVariant,
                    items: state.selectedProduct!.variants.map((v) => DropdownMenuItem(value: v, child: Text('${v.color} - ${v.size} - ${v.voltage}'))).toList(),
                    onChanged: (val) {
                      if (val != null) context.read<OrderEntryCubit>().selectVariant(val);
                    },
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        initialValue: state.quantity.toString(),
                        decoration: const InputDecoration(labelText: 'Quantidade'),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          final q = int.tryParse(val) ?? 1;
                          context.read<OrderEntryCubit>().setQuantity(q);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: state.selectedProduct != null && state.selectedVariant != null
                            ? () => context.read<OrderEntryCubit>().addItem()
                            : null,
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Adicionar ao Orçamento'),
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 32),
                const Text('Itens do Orçamento', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                if (state.items.isEmpty)
                  const Text('Nenhum item adicionado.', style: TextStyle(color: Colors.grey))
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      // Display logic (we just display product id as we didn't fetch product name locally, but works for MVP)
                      return ListTile(
                        title: Text('Produto ID: ${item.productId.value}'),
                        subtitle: Text('Qtd: ${item.quantity.value}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => context.read<OrderEntryCubit>().removeItem(item),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: state.items.isNotEmpty && state.selectedCompany != null
                      ? () => context.read<OrderEntryCubit>().saveDraft()
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: state.status == OrderEntryStatus.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Salvar Orçamento', style: TextStyle(fontSize: 16)),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
