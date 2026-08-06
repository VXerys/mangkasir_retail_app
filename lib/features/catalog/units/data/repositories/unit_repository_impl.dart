import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/unit.dart' as domain;
import '../../domain/repositories/unit_repository.dart';
import '../datasources/unit_remote_ds.dart';
import '../models/unit_model.dart';

@LazySingleton(as: UnitRepository)
class UnitRepositoryImpl implements UnitRepository {
  final UnitRemoteDs _remoteDs;

  const UnitRepositoryImpl(this._remoteDs);

  @override
  Future<Either<Failure, List<domain.Unit>>> getAll(int businessId) async {
    try {
      final models = await _remoteDs.getAll(businessId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, domain.Unit>> create(domain.Unit unit) async {
    try {
      final created = await _remoteDs.create(UnitModel.fromEntity(unit));
      return Right(created.toEntity());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, domain.Unit>> update(domain.Unit unit) async {
    try {
      final updated = await _remoteDs.update(UnitModel.fromEntity(unit));
      return Right(updated.toEntity());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete(int id) async {
    try {
      await _remoteDs.delete(id);
      return const Right(unit);
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    }
  }
}
