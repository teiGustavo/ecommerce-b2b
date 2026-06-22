import 'package:ecommerce_b2b/modules/inventory/warehouse/domain/stock_reservation.dart';
import 'package:ecommerce_b2b/modules/inventory/warehouse/domain/warehouse.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';

/// Serviço de Domínio responsável por gerenciar a alocação e reserva de estoque entre depósitos (RF8, RN12).
class InventoryAllocatorDomainService {
  /// Consolida a disponibilidade física total de um produto somando todos os depósitos (RN12).
  Quantity getConsolidatedPhysicalStock(List<Warehouse> warehouses, ProductId productId) {
    int total = 0;
    for (var warehouse in warehouses) {
      final stockItem = warehouse.getStockItem(productId);
      if (stockItem != null) {
        total += stockItem.physicalQuantity.value;
      }
    }
    return Quantity.create(total).getOrThrow();
  }

  /// Consolida a disponibilidade real (livre para venda) total de um produto.
  Quantity getConsolidatedAvailableStock(List<Warehouse> warehouses, ProductId productId) {
    int total = 0;
    for (var warehouse in warehouses) {
      final stockItem = warehouse.getStockItem(productId);
      if (stockItem != null) {
        total += stockItem.availableQuantity.value;
      }
    }
    return Quantity.create(total).getOrThrow();
  }

  /// Tenta reservar estoque para um pedido em múltiplos depósitos.
  /// Retorna uma lista de depósitos onde a reserva foi feita com sucesso.
  void allocateStock(List<Warehouse> warehouses, OrderId orderId, ProductId productId, Quantity requestedQuantity) {
    final available = getConsolidatedAvailableStock(warehouses, productId);
    if (available.value < requestedQuantity.value) {
      throw StateError('Estoque insuficiente consolidado para o produto $productId.');
    }

    int remaining = requestedQuantity.value;

    for (var warehouse in warehouses) {
      if (remaining <= 0) break;

      final stockItem = warehouse.getStockItem(productId);
      if (stockItem == null || stockItem.availableQuantity.value <= 0) continue;

      final canAllocate = stockItem.availableQuantity.value >= remaining 
          ? remaining 
          : stockItem.availableQuantity.value;
      
      stockItem.addReservation(StockReservation(
        orderId: orderId,
        quantity: Quantity.create(canAllocate).getOrThrow(),
      ));

      remaining -= canAllocate;
    }

    if (remaining > 0) {
      // Teoricamente não deveria chegar aqui se a validação inicial passou, 
      // mas serve como garantia de consistência.
      throw StateError('Falha crítica na alocação de estoque: saldo remanescente de $remaining.');
    }
  }
}
