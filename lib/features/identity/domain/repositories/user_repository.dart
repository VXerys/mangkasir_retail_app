import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_user.dart';

abstract interface class UserRepository {
  /// Daftar pengguna dalam bisnis. Membutuhkan USER_MANAGE.
  Future<Either<Failure, List<AppUser>>> getUsers(int businessId);
}
