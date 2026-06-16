import 'package:ecommerce_b2b/app/core/validation_failure.dart';

/// Result/Either Pattern
sealed class Result<S, F> {
  /// Transforma os dois caminhos (Success e Failure) em um único resultado final
  T fold<T>(T Function(F error) onFailure, T Function(S value) onSuccess) {
    return switch (this) {
      Success(value: var v) => onSuccess(v),
      Failure(error: var e) => onFailure(e),
    };
  }

  /// Transforma o valor de sucesso se ele existir
  Result<NewS, F> map<NewS>(NewS Function(S value) transform) {
    return switch (this) {
      Success(value: var v) => Success(transform(v)),
      Failure(error: var e) => Failure(e),
    };
  }
}

class Success<S, F> extends Result<S, F> {
  final S value;
  Success(this.value);
}

class Failure<S, F> extends Result<S, F> {
  final F error;
  Failure(this.error);
}

typedef ValidationResult<S, F> = Result<S, List<F>>;

/// Extensão para combinar resultados de validação, que é uma lista de resultados
extension ResultCombine<S> on Result<S, ValidationFailure> {
  /// Combina este resultado com outro. Se ambos tiverem erros, junta as listas.
  static Result<List<dynamic>, ValidationFailure> combine(List<Result<dynamic, ValidationFailure>> results) {
    final List<Object> accumulatedErrors = [];
    final List<dynamic> successes = [];

    for (final result in results) {
      if (result is Failure<dynamic, ValidationFailure>) {
        accumulatedErrors.addAll(result.error.errors);
      } else if (result is Success<dynamic, ValidationFailure>) {
        successes.add(result.value);
      }
    }

    if (accumulatedErrors.isNotEmpty) {
      return Failure(ValidationFailure(accumulatedErrors));
    }

    return Success(successes);
  }
}