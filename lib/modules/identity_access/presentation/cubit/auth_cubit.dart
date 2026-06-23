import 'package:ecommerce_b2b/modules/identity_access/application/login/login_use_case.dart';
import 'package:ecommerce_b2b/modules/identity_access/domain/repositories/auth_repository.dart';
import 'package:ecommerce_b2b/modules/identity_access/domain/user_session.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final AuthRepository _authRepository;

  AuthCubit({
    required this._loginUseCase,
    required this._authRepository,
  })  : super(AuthInitial()) {
    _checkInitialSession();
  }

  Future<void> _checkInitialSession() async {
    final session = await _authRepository.getCurrentSession();
    if (session != null) {
      emit(AuthAuthenticated(session));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await _loginUseCase.execute(email, password);

    result.fold(
      (error) => emit(AuthFailure(error.message)),
      (session) => emit(AuthAuthenticated(session)),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await _authRepository.logout();
    emit(AuthUnauthenticated());
  }
}
