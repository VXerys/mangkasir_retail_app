import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getAll({String? categoryId});
  Stream<Either<Failure, List<Product>>> watchActiveByCategory({
    String? categoryId,
  });
  Future<Either<Failure, Unit>> add(Product product);
  Future<Either<Failure, Unit>> update(Product product);
  Future<Either<Failure, Unit>> syncPending();
}
