import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/warehouse.dart';
import '../../domain/repositories/warehouse_repository.dart';
import '../datasources/warehouse_remote_ds.dart';
import '../models/warehouse_model.dart';

@LazySingleton(as: WarehouseRepository)
class WarehouseRepositoryImpl implements WarehouseRepository {
  final WarehouseRemoteDs _remoteDs;

  const WarehouseRepositoryImpl(this._remoteDs);

  @override
  Future<Either<Failure, List<Warehouse>>> getAll(int outletId) async {
    try {
      final models = await _remoteDs.getAll(outletId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Warehouse>> create(Warehouse warehouse) async {
    try {
      final created = await _remoteDs.create(WarehouseModel.fromEntity(warehouse));
      return Right(created.toEntity());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Warehouse>> update(Warehouse warehouse) async {
    try {
      final updated = await _remoteDs.update(WarehouseModel.fromEntity(warehouse));
      return Right(updated.toEntity());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deactivate(int id) async {
    try {
      await _remoteDs.deactivate(id);
      return const Right(unit);
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    }
  }
}
