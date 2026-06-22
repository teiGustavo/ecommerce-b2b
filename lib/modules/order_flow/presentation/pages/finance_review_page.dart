import 'package:flutter/material.dart';
import 'package:ecommerce_b2b/app/config/service_locator.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/repositories/order_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/sales_order/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';

class FinanceReviewPage extends StatefulWidget {
  const FinanceReviewPage({super.key});

  @override
  State<FinanceReviewPage> createState() => _FinanceReviewPageState();
}

class _FinanceReviewPageState extends State<FinanceReviewPage> {
  final _repository = getIt<OrderRepository>();
  List<SalesOrder> _blockedOrders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    final orders = await _repository.getAll();
    setState(() {
      _blockedOrders = orders.where((o) => o.status == OrderStatus.pendingFinanceApproval).toList();
      _isLoading = false;
    });
  }

  Future<void> _approveOrder(SalesOrder order) async {
    order.updateStatus(OrderStatus.pickingPacking);
    await _repository.update(order);
    _loadOrders();
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pedido Aprovado!')));
  }

  Future<void> _rejectOrder(SalesOrder order) async {
    order.updateStatus(OrderStatus.cancelled);
    await _repository.update(order);
    _loadOrders();
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pedido Reprovado.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Revisão Financeira (Mesa de Crédito)'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadOrders),
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _blockedOrders.isEmpty
              ? const Center(child: Text('Nenhum pedido bloqueado no momento.', style: TextStyle(fontSize: 16)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _blockedOrders.length,
                  itemBuilder: (context, index) {
                    final order = _blockedOrders[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Pedido: ${order.id.value.substring(0, 8)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const Chip(label: Text('Bloqueado'), backgroundColor: Colors.orange),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const SizedBox(height: 8),
                            Text(
                              'Valor Total: R\$ ${order.total.amount.toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => _rejectOrder(order),
                                  child: const Text('Reprovar', style: TextStyle(color: Colors.red)),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () => _approveOrder(order),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                                  child: const Text('Aprovar Crédito'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
