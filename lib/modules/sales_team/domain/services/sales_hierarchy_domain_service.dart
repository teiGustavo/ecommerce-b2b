import 'package:ecommerce_b2b/modules/sales_team/domain/aggregates/sales_representative/sales_representative.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/representative_id.dart';

/// Serviço de Domínio responsável por gerenciar a hierarquia de vendas (RN9).
class SalesHierarchyDomainService {
  /// Verifica se um supervisor tem permissão para visualizar os dados de um subordinado.
  /// Isso inclui visão direta e recursiva (hierarquia de gestão).
  bool canSupervisorAccessSubordinate({
    required SalesRepresentative supervisor,
    required RepresentativeId subordinateId,
    required List<SalesRepresentative> allSubordinatesInContext,
  }) {
    // 1. Verificação direta: o ID procurado está na lista de subordinados diretos?
    final isDirectSubordinate = supervisor.subordinateLinks.any(
      (link) => link.subordinateId == subordinateId,
    );
    
    if (isDirectSubordinate) return true;

    // 2. Verificação recursiva: o subordinado pertence a algum dos subordinados diretos?
    for (final link in supervisor.subordinateLinks) {
      final directSubId = link.subordinateId;
      
      // Busca o objeto do subordinado direto para explorar a ramificação dele.
      final directSub = _findInContext(directSubId, allSubordinatesInContext);

      if (directSub != null && 
          canSupervisorAccessSubordinate(
            supervisor: directSub, 
            subordinateId: subordinateId, 
            allSubordinatesInContext: allSubordinatesInContext,
          )) {
        return true;
      }
    }

    return false;
  }

  SalesRepresentative? _findInContext(RepresentativeId id, List<SalesRepresentative> context) {
    try {
      return context.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
