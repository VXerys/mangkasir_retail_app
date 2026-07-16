import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/category.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<Category>>> getAll();
  Stream<Either<Failure, List<Category>>> watchAll();
  Future<Either<Failure, Unit>> add(Category category);
  Future<Either<Failure, Unit>> update(Category category);
  Future<Either<Failure, Unit>> syncPending();
}
