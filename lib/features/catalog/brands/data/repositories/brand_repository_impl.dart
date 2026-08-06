import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/brand.dart';
import '../../domain/repositories/brand_repository.dart';
import '../datasources/brand_remote_ds.dart';
import '../models/brand_model.dart';

@LazySingleton(as: BrandRepository)
class BrandRepositoryImpl implements BrandRepository {
  final BrandRemoteDs _remoteDs;

  const BrandRepositoryImpl(this._remoteDs);

  @override
  Future<Either<Failure, List<Brand>>> getAll(int businessId) async {
    try {
      final models = await _remoteDs.getAll(businessId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Brand>> create(Brand brand) async {
    try {
      final created = await _remoteDs.create(BrandModel.fromEntity(brand));
      return Right(created.toEntity());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Brand>> update(Brand brand) async {
    try {
      final updated = await _remoteDs.update(BrandModel.fromEntity(brand));
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
