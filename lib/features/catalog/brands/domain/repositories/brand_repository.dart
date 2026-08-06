import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/brand.dart';

abstract interface class BrandRepository {
  Future<Either<Failure, List<Brand>>> getAll(int businessId);
  Future<Either<Failure, Brand>> create(Brand brand);
  Future<Either<Failure, Brand>> update(Brand brand);
  Future<Either<Failure, Unit>> deactivate(int id);
}
