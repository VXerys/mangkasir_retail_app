import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_ds.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDs _remote;

  UserRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<AppUser>>> getUsers(int businessId) async {
    try {
      final models = await _remote.getUsers(businessId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure('Gagal memuat daftar pengguna: $e'));
    }
  }
}
