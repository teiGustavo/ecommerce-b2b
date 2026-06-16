abstract class DomainError {
  final String message;

  DomainError(this.message);

  @override
  String toString() => message;
}