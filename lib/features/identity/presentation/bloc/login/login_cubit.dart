import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/session/session_cubit.dart';
import '../../../../../core/session/session_repository.dart';
import 'login_state.dart';

/// Mengelola keadaan form login dan pemulihan kata sandi.
///
/// Mengelola form login dan pemulihan kata sandi.
/// Instans baru tiap halaman dipasang; error state tidak bocor antar sesi.
@injectable
class LoginCubit extends Cubit<LoginState> {
  final SessionRepository _repository;

  LoginCubit(this._repository) : super(const LoginState.idle());

  Future<void> signIn(
    String email,
    String password,
    SessionCubit session,
  ) async {
    if (state is LoginLoading) return;
    emit(const LoginState.loading());

    final failure = await session.signIn(email.trim(), password);

    if (isClosed) return;
    if (failure != null) {
      emit(LoginState.error(failure.message));
    }
    // Berhasil: SessionCubit sudah emit active → GoRouter redirect ke home.
    // Cubit ini tidak perlu emit apa-apa karena halaman akan dilepas.
  }

  void showForgotPassword() => emit(const LoginState.forgotPasswordIdle());

  void backToLogin() => emit(const LoginState.idle());

  Future<void> sendPasswordReset(String email) async {
    if (state is LoginForgotLoading) return;
    emit(const LoginState.forgotPasswordLoading());

    final result = await _repository.forgotPassword(email.trim());
    if (isClosed) return;

    result.fold(
      (failure) => emit(LoginState.error(failure.message)),
      (_) => emit(const LoginState.forgotPasswordSent()),
    );
  }
}
