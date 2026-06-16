class ValidationFailure {
  final List<Object> errors;

  ValidationFailure(this.errors);

  bool get hasErrors => errors.isNotEmpty;

  @override
  String toString() {
    final buffer = StringBuffer('ValidationFailure (${errors.length} errors):\n');
    for (var i = 0; i < errors.length; i++) {
      buffer.writeln('  [${i + 1}] ${errors[i]}');
    }
    return buffer.toString();
  }
}