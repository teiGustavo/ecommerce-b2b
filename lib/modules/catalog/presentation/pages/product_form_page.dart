import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ecommerce_b2b/modules/catalog/presentation/controllers/product_form/product_form_cubit.dart';

class ProductFormPage extends StatelessWidget {
  const ProductFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductFormCubit(),
      child: const _ProductFormView(),
    );
  }
}

class _ProductFormView extends StatefulWidget {
  const _ProductFormView();

  @override
  State<_ProductFormView> createState() => _ProductFormViewState();
}

class _ProductFormViewState extends State<_ProductFormView> {
  final _colorController = TextEditingController();
  final _sizeController = TextEditingController();
  final _voltageController = TextEditingController();

  @override
  void dispose() {
    _colorController.dispose();
    _sizeController.dispose();
    _voltageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Novo Produto'),
      ),
      body: BlocListener<ProductFormCubit, ProductFormState>(
        listener: (context, state) {
          if (state.status.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produto cadastrado com sucesso!'), backgroundColor: Colors.green));
            Navigator.of(context).pop(true); // Return true to signal refresh
          } else if (state.status.isFailure) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao salvar produto.'), backgroundColor: Colors.red));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Dados Básicos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              BlocBuilder<ProductFormCubit, ProductFormState>(
                buildWhen: (previous, current) => previous.name != current.name,
                builder: (context, state) {
                  return TextField(
                    onChanged: (val) => context.read<ProductFormCubit>().nameChanged(val),
                    decoration: InputDecoration(
                      labelText: 'Nome do Produto *',
                      errorText: state.name.isNotValid && state.name.error != null ? 'Nome não pode ser vazio' : null,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<ProductFormCubit, ProductFormState>(
                buildWhen: (previous, current) => previous.sku != current.sku,
                builder: (context, state) {
                  return TextField(
                    onChanged: (val) => context.read<ProductFormCubit>().skuChanged(val),
                    decoration: InputDecoration(
                      labelText: 'SKU Principal *',
                      errorText: state.sku.isNotValid && state.sku.error != null ? 'SKU inválido (min. 3 caracteres)' : null,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: (val) => context.read<ProductFormCubit>().descriptionChanged(val),
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              const Text('Variações (Obrigatório ao menos uma)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: TextField(controller: _colorController, decoration: const InputDecoration(labelText: 'Cor', isDense: true))),
                          const SizedBox(width: 8),
                          Expanded(child: TextField(controller: _sizeController, decoration: const InputDecoration(labelText: 'Tamanho', isDense: true))),
                          const SizedBox(width: 8),
                          Expanded(child: TextField(controller: _voltageController, decoration: const InputDecoration(labelText: 'Voltagem', isDense: true))),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            if (_colorController.text.isNotEmpty && _sizeController.text.isNotEmpty) {
                              context.read<ProductFormCubit>().addVariant(
                                color: _colorController.text,
                                size: _sizeController.text,
                                voltage: _voltageController.text,
                              );
                              _colorController.clear();
                              _sizeController.clear();
                              _voltageController.clear();
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Adicionar Variante'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<ProductFormCubit, ProductFormState>(
                buildWhen: (previous, current) => previous.variants != current.variants,
                builder: (context, state) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.variants.length,
                    itemBuilder: (context, index) {
                      final variant = state.variants[index];
                      return ListTile(
                        title: Text('${variant.color} - ${variant.size} - ${variant.voltage}'),
                        subtitle: Text('SKU: ${variant.variantSku}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => context.read<ProductFormCubit>().removeVariant(variant),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 32),
              BlocBuilder<ProductFormCubit, ProductFormState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state.isValid && !state.status.isInProgress
                        ? () => context.read<ProductFormCubit>().submit()
                        : null,
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: state.status.isInProgress
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Salvar Produto', style: TextStyle(fontSize: 16)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
