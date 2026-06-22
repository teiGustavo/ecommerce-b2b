import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/presentation/formz/not_empty_input.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/presentation/formz/email_input.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/presentation/formz/phone_input.dart';

class AuthorizedBuyerFormState extends Equatable {
  final NotEmptyInput fullName;
  final EmailInput email;
  final PhoneInput phone;
  final NotEmptyInput positionTitle;
  final bool active;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  const AuthorizedBuyerFormState({
    this.fullName = const NotEmptyInput.pure(),
    this.email = const EmailInput.pure(),
    this.phone = const PhoneInput.pure(),
    this.positionTitle = const NotEmptyInput.pure(),
    this.active = true,
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  AuthorizedBuyerFormState copyWith({
    NotEmptyInput? fullName,
    EmailInput? email,
    PhoneInput? phone,
    NotEmptyInput? positionTitle,
    bool? active,
    FormzSubmissionStatus? status,
    String? errorMessage,
  }) {
    return AuthorizedBuyerFormState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      positionTitle: positionTitle ?? this.positionTitle,
      active: active ?? this.active,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  bool get isValid => Formz.validate([
        fullName,
        email,
        phone,
        positionTitle,
      ]);

  @override
  List<Object?> get props => [
        fullName,
        email,
        phone,
        positionTitle,
        active,
        status,
        errorMessage,
      ];
}
