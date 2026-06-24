import 'package:ecommerce_b2b/modules/customer_portal/boleto/domain/repositories/boleto_repository.dart';
import 'package:ecommerce_b2b/modules/customer_portal/boleto/domain/value_objects/boleto_copy.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';

/// Implementação simulada (Mock) do BoletoRepository para o MVP.
class MockBoletoRepository implements BoletoRepository {
  @override
  Future<BoletoCopy> getBoletoByOrder(OrderId orderId) async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Gera uma linha digitável realista (formato de boleto bancário brasileiro)
    final orderHash = orderId.value.hashCode.abs().toString().padRight(5, '0').substring(0, 5);
    final barcode = '34191.79001 01043.513184 $orderHash.150008 7 90000000035000';
    
    return BoletoCopy(
      barcode: barcode,
      url: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', // PDF padrão para simulação
    );
  }
}
