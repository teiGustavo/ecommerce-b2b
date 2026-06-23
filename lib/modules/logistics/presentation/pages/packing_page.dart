import 'package:ecommerce_b2b/app/core/di/service_locator.dart';
import 'package:ecommerce_b2b/app/presentation/widgets/b2b_app_bar.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/repositories/sales_order_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/sales_order.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/enums/shipment_status.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/shipment.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/shipping_label.dart';
import 'package:ecommerce_b2b/modules/logistics/shipment/domain/repositories/shipment_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/shipment_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/logistics/value_objects/tracking_code.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class PackingPage extends StatefulWidget {
  const PackingPage({super.key});

  @override
  State<PackingPage> createState() => _PackingPageState();
}

class _PackingPageState extends State<PackingPage> {
  List<SalesOrder> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final allOrders = await getIt<SalesOrderRepository>().getAll();
    setState(() {
      _orders = allOrders.where((o) => o.status == OrderStatus.pickingPacking).toList();
      _isLoading = false;
    });
  }

  Future<void> _shipOrder(SalesOrder order) async {
    final shipmentId = ShipmentId(const Uuid().v4());
    final shipment = Shipment(
      id: shipmentId,
      orderId: order.id.value,
      trackingCode: TrackingCode.create('TRK-${const Uuid().v4().substring(0, 8)}').getOrThrow(),
      status: ShipmentStatus.shipped,
      shippingLabel: ShippingLabel('LABEL-${order.id.value.substring(0, 8)}'),
    );

    await getIt<ShipmentRepository>().save(shipment);
    
    order.updateStatus(OrderStatus.inTransit);
    await getIt<SalesOrderRepository>().save(order);

    _loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const B2BAppBar(title: 'Expedição (Picking & Packing)'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? const Center(child: Text('Nenhum pedido para expedir.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    final order = _orders[index];
                    return Card(
                      child: ListTile(
                        title: Text('Pedido #${order.id.value.substring(0, 8)}'),
                        subtitle: Text('Itens: ${order.items.length}'),
                        trailing: ElevatedButton(
                          onPressed: () => _shipOrder(order),
                          child: const Text('Despachar'),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
