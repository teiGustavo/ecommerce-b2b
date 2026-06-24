import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/domain/quote.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/order_item.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/repositories/sales_order_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/services/credit_service.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:uuid/uuid.dart';

class OrderWorkflowService {
  final SalesOrderRepository _orderRepository;
  final CreditService _creditService;

  OrderWorkflowService(
    this._orderRepository,
    this._creditService,
  );

  Future<SalesOrder> convertQuoteToOrder(Quote quote, {String? companyId}) async {
    final order = SalesOrder(
      id: OrderId(const Uuid().v4()),
      companyId: companyId,
      status: OrderStatus.pendingFinanceApproval,
      creditStatus: CreditStatus.pending,
      items: quote.items.map((i) => OrderItem(
        productId: i.productId,
        quantity: i.quantity,
        unitPriceSnapshot: i.unitPrice,
      )).toList(),
    );

    // Validate credit
    final creditStatus = await _creditService.validateCredit(order);
    order.updateCreditStatus(creditStatus);

    if (creditStatus == CreditStatus.blocked) {
      order.updateStatus(OrderStatus.blockedByFinance);
    }

    await _orderRepository.save(order);
    return order;
  }

  Future<void> approveOrder(OrderId orderId) async {
    final order = await _orderRepository.getById(orderId);
    if (order == null) throw Exception('Pedido não encontrado');

    order.updateStatus(OrderStatus.pickingPacking);
    await _orderRepository.save(order);
  }

  Future<void> rejectOrder(OrderId orderId) async {
    final order = await _orderRepository.getById(orderId);
    if (order == null) throw Exception('Pedido não encontrado');

    order.updateStatus(OrderStatus.cancelled);
    await _orderRepository.save(order);
  }
}
