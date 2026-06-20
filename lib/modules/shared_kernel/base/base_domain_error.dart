/// Classe base para todos os erros de domínio do sistema.
abstract class DomainError {
  final String message;

  DomainError(this.message);

  @override
  String toString() => message;
}
