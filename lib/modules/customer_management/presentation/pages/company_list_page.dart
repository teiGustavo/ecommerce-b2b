import 'package:flutter/material.dart';
import 'package:ecommerce_b2b/app/config/service_locator.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/repositories/company_repository.dart';
import 'package:ecommerce_b2b/modules/customer_management/domain/aggregates/company/company.dart';
import 'package:ecommerce_b2b/modules/customer_management/presentation/pages/company_form_page.dart';

class CompanyListPage extends StatefulWidget {
  const CompanyListPage({super.key});

  @override
  State<CompanyListPage> createState() => _CompanyListPageState();
}

class _CompanyListPageState extends State<CompanyListPage> {
  final _repository = getIt<CompanyRepository>();
  List<Company> _companies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    setState(() => _isLoading = true);
    final companies = await _repository.getAll();
    setState(() {
      _companies = companies;
      _isLoading = false;
    });
  }

  void _navigateToForm() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CompanyFormPage()),
    );
    _loadCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empresas Clientes'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: _navigateToForm,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Nova Empresa'),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _companies.isEmpty
              ? _buildEmptyState()
              : _buildList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.business_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Nenhuma empresa cadastrada.',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _navigateToForm,
            child: const Text('Cadastre o primeiro cliente'),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _companies.length,
      itemBuilder: (context, index) {
        final company = _companies[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(company.tradeName.substring(0, 1).toUpperCase()),
            ),
            title: Text(company.tradeName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('CNPJ: ${company.cnpj.toString()}'),
            trailing: Text(
              'R\$ ${company.creditLimit.amount.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
