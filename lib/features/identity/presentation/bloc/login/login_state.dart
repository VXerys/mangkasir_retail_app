import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
sealed class LoginState with _$LoginState {
  const factory LoginState.idle() = LoginIdle;
  const factory LoginState.loading() = LoginLoading;
  const factory LoginState.error(String message) = LoginError;

  /// Pemulihan password: form kosong → minta email → terkirim.
  const factory LoginState.forgotPasswordIdle() = LoginForgotIdle;
  const factory LoginState.forgotPasswordLoading() = LoginForgotLoading;
  const factory LoginState.forgotPasswordSent() = LoginForgotSent;
}
