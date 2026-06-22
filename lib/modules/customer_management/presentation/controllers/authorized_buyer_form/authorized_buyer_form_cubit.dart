import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'authorized_buyer_form_state.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/presentation/formz/not_empty_input.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/presentation/formz/email_input.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/presentation/formz/phone_input.dart';

class AuthorizedBuyerFormCubit extends Cubit<AuthorizedBuyerFormState> {
  AuthorizedBuyerFormCubit() : super(const AuthorizedBuyerFormState());

  void fullNameChanged(String value) {
    final fullName = NotEmptyInput.dirty(value);
    emit(state.copyWith(fullName: fullName));
  }

  void emailChanged(String value) {
    final email = EmailInput.dirty(value);
    emit(state.copyWith(email: email));
  }

  void phoneChanged(String value) {
    final phone = PhoneInput.dirty(value);
    emit(state.copyWith(phone: phone));
  }

  void positionTitleChanged(String value) {
    final positionTitle = NotEmptyInput.dirty(value);
    emit(state.copyWith(positionTitle: positionTitle));
  }

  void activeChanged(bool value) {
    emit(state.copyWith(active: value));
  }

  Future<void> submit() async {
    if (!state.isValid) {
      emit(state.copyWith(
        fullName: NotEmptyInput.dirty(state.fullName.value),
        email: EmailInput.dirty(state.email.value),
        phone: PhoneInput.dirty(state.phone.value),
        positionTitle: NotEmptyInput.dirty(state.positionTitle.value),
      ));
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await Future.delayed(const Duration(seconds: 1)); // Mock save
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
