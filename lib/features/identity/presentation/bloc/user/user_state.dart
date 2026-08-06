import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/app_user.dart';

part 'user_state.freezed.dart';

@freezed
sealed class UserState with _$UserState {
  const factory UserState.loading() = UserLoading;
  const factory UserState.loaded(List<AppUser> users) = UserLoaded;
  const factory UserState.error(String message) = UserError;
}
