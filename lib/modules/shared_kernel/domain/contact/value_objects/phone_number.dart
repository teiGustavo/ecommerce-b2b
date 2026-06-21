import 'package:ecommerce_b2b/modules/shared_kernel/base/base_value_object.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/contact/errors/phone_number_errors.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';
import 'package:flutter/foundation.dart';

/// Objeto de Valor que representa um número de telefone no padrão internacional E.164.
/// O formato E.164 garante que o número inclua o código do país, DDD e número, 
/// começando com o caractere '+' seguido apenas por dígitos (máximo 15 dígitos).
@immutable
class PhoneNumber extends ValueObject {
  /// O número de telefone no formato E.164 (ex: +5511999998888).
  final String value;

  const PhoneNumber._(this.value);

  /// Cria uma instância de [PhoneNumber] validando o padrão E.164.
  /// Aceita inputs com formatação variada, mas normaliza para +DDI...
  static Result<PhoneNumber, PhoneNumberError> create(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return Failure(PhoneNumberEmptyError());
    }

    // Remove tudo que não for dígito (incluindo '+')
    final digits = trimmed.replaceAll(RegExp(r'\D'), '');
    
    // O padrão E.164 recomenda: [+][código do país][assinante]
    // Mínimo costuma ser 7 (ex: países pequenos) e máximo 15.
    if (digits.length < 7 || digits.length > 15) {
      return Failure(PhoneNumberInvalidError());
    }

    // Se não tinha '+', assume que deve ser adicionado (DDI deve estar incluso nos dígitos)
    final formatted = '+$digits';

    return Success(PhoneNumber._(formatted));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhoneNumber &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
