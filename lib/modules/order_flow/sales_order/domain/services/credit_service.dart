import 'package:ecommerce_b2b/modules/customer_management/company/domain/repositories/company_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/repositories/sales_order_repository.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/sales_order.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';

class CreditService {
  final CompanyRepository _companyRepository;
  final SalesOrderRepository _orderRepository;

  CreditService(this._companyRepository, this._orderRepository);

  Future<CreditStatus> validateCredit(SalesOrder order) async {
    if (order.companyId == null) return CreditStatus.approved;

    final company = await _companyRepository.findById(CompanyId(order.companyId!));
    if (company == null) return CreditStatus.approved;

    final pendingOrders = await _orderRepository.findByCompanyId(company.id);
    
    double pendingBalance = 0;
    for (final pendingOrder in pendingOrders) {
      if (pendingOrder.status == OrderStatus.pendingFinanceApproval ||
          pendingOrder.status == OrderStatus.pickingPacking ||
          pendingOrder.status == OrderStatus.blockedByFinance) {
        pendingBalance += pendingOrder.total.amount;
      }
    }

    final totalExposure = pendingBalance + order.total.amount;
    
    if (totalExposure > company.creditLimit.amount) {
      return CreditStatus.blocked;
    }

    return CreditStatus.approved;
  }
}
