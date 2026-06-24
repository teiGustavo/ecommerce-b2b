import 'package:ecommerce_b2b/modules/customer_management/company/domain/company.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/sales_order.dart';

/// Serviço de Domínio responsável por validar as regras de crédito (RN4, RN10).
class CreditPolicyDomainService {
  /// Avalia se o pedido deve ser bloqueado automaticamente por estourar o limite de crédito.
  void evaluate(SalesOrder order, Company company) {
    final availableLimit = company.creditAccount.availableLimit;
    
    if (order.total.amountInCents > availableLimit.amountInCents) {
      order.updateCreditStatus(CreditStatus.blocked);
      order.updateStatus(OrderStatus.blockedByFinance);
    } else {
      order.updateCreditStatus(CreditStatus.approved);
      // Mantém em Aguardando Aprovação Financeira para revisão manual ou processamento posterior,
      // seguindo a máquina de estados linear (RN11).
      order.updateStatus(OrderStatus.pendingFinanceApproval);
    }
  }
}
