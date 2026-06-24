/// Classe base para todos os erros de domínio do sistema.
abstract class DomainError {
  final String message;

  const DomainError(this.message);

  @override
  String toString() => message;
}

abstract class EmptyError extends DomainError {
  final String fieldName;

  const EmptyError(this.fieldName) : super('$fieldName não pode ser vazio.');
}