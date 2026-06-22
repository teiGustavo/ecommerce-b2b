import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/sales_order/sales_order.dart';
import 'package:ecommerce_b2b/modules/sales_team/domain/aggregates/sales_representative/commission.dart';
import 'package:ecommerce_b2b/modules/sales_team/domain/aggregates/sales_representative/sales_representative.dart';
import 'package:ecommerce_b2b/modules/sales_team/domain/enums/commission_status.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';

/// Serviço de Domínio responsável por calcular as comissões dos representantes (RN8).
class CommissionCalculatorDomainService {
  /// Calcula a comissão baseada no valor total do pedido e no percentual fixo do representante.
  Commission calculate(SalesOrder order, SalesRepresentative representative) {
    final baseAmount = order.total;
    final rate = representative.commissionRate;
    
    // valor da comissão = base * (taxa / 100)
    final amountCents = (baseAmount.amountInCents * rate.decimal).round();
    final commissionAmount = Money.create(amountCents / 100, currency: baseAmount.currency).getOrThrow();

    return Commission(
      baseAmount: baseAmount,
      rate: rate,
      amount: commissionAmount,
      status: CommissionStatus.pending, // Inicialmente pendente até o faturamento ser confirmado.
    );
  }
}
