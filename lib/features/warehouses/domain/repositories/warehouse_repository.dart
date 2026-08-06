import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/warehouse.dart';

abstract interface class WarehouseRepository {
  Future<Either<Failure, List<Warehouse>>> getAll(int outletId);
  Future<Either<Failure, Warehouse>> create(Warehouse warehouse);
  Future<Either<Failure, Warehouse>> update(Warehouse warehouse);
  Future<Either<Failure, Unit>> deactivate(int id);
}
