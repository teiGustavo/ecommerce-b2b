import 'package:ecommerce_b2b/modules/customer_management/company/domain/company.dart';
import 'package:ecommerce_b2b/modules/inventory/warehouse/domain/warehouse.dart';
import 'package:ecommerce_b2b/modules/inventory/warehouse/domain/services/inventory_allocator_domain_service.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/domain/quote.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/domain/enums/quote_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/order_item.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/services/credit_policy_domain_service.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';

/// Caso de Uso responsável por converter um orçamento em pedido (RF10, RN3).
class ConvertQuoteToOrderUseCase {
  final CreditPolicyDomainService _creditPolicy;
  final InventoryAllocatorDomainService _inventoryAllocator;

  ConvertQuoteToOrderUseCase(this._creditPolicy, this._inventoryAllocator);

  /// Executa a conversão, validando crédito e reservando estoque.
  SalesOrder execute({
    required OrderId orderId,
    required Quote quote,
    required Company company,
    required List<Warehouse> warehouses,
  }) {
    if (quote.status != QuoteStatus.sent) {
      throw StateError('Apenas orçamentos enviados podem ser convertidos em pedidos.');
    }

    final orderItems = quote.items.map((item) => OrderItem(
      productId: item.productId,
      quantity: item.quantity,
      unitPriceSnapshot: item.unitPrice,
    )).toList();

    final order = SalesOrder(
      id: orderId,
      status: OrderStatus.pendingFinanceApproval,
      creditStatus: CreditStatus.pending,
      items: orderItems,
    );

    // 1. Validar crédito automaticamente (RN4, RN11).
    _creditPolicy.evaluate(order, company);

    // 2. Se o pedido não foi bloqueado pelo crédito, tenta alocar estoque (RF13).
    // Nota: De acordo com RN11, o pedido segue para Embalagem (Picking/Packing) se aprovado.
    if (order.status == OrderStatus.pickingPacking) {
      for (final item in order.items) {
        _inventoryAllocator.allocateStock(warehouses, order.id, item.productId, item.quantity);
      }
    }

    quote.updateStatus(QuoteStatus.convertedToOrder);
    
    return order;
  }
}
