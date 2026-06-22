import 'package:ecommerce_b2b/modules/order_flow/domain/aggregates/sales_order/sales_order.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/company_id.dart';

/// Interface de repositório para persistência e consulta de pedidos.
abstract class SalesOrderRepository {
  /// Busca todos os pedidos vinculados a uma empresa específica (RF18).
  Future<List<SalesOrder>> findByCompanyId(CompanyId companyId);
}
