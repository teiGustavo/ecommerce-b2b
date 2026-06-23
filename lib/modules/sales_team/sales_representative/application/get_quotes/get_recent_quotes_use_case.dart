import 'package:ecommerce_b2b/modules/identity_access/domain/user_session.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/domain/quote.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/domain/repositories/quote_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/auth/errors/auth_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/representative_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';

class GetRecentQuotesUseCase {
  final QuoteRepository _quoteRepository;

  GetRecentQuotesUseCase(this._quoteRepository);

  Future<Result<List<Quote>, AuthError>> execute(
    RepresentativeId targetRepId,
    UserSession currentSession,
  ) async {
    // Para simplificar o MVP, permitimos que o representante veja seus próprios orçamentos
    if (currentSession.userId.value == targetRepId.value) {
      final quotes = await _quoteRepository.findByRepresentativeId(targetRepId.value);
      return Success(quotes);
    }

    // TODO: Adicionar lógica de hierarquia se necessário, similar às comissões
    return Success([]);
  }
}
