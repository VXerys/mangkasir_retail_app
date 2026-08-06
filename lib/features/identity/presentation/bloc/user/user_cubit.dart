import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/repositories/user_repository.dart';
import 'user_state.dart';

@injectable
class UserCubit extends Cubit<UserState> {
  final UserRepository _repository;

  UserCubit(this._repository) : super(const UserState.loading());

  Future<void> load(int businessId) async {
    emit(const UserState.loading());
    final result = await _repository.getUsers(businessId);
    if (isClosed) return;
    result.fold(
      (f) => emit(UserState.error(f.message)),
      (users) => emit(UserState.loaded(users)),
    );
  }
}
