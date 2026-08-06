import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/outlet.dart';
import '../../domain/repositories/outlet_repository.dart';
import '../datasources/outlet_remote_ds.dart';
import '../models/outlet_model.dart';

@LazySingleton(as: OutletRepository)
class OutletRepositoryImpl implements OutletRepository {
  final OutletRemoteDs _remote;

  OutletRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<Outlet>>> getOutlets(int businessId) async {
    try {
      final models = await _remote.getOutlets(businessId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure('Gagal memuat daftar outlet: $e'));
    }
  }

  @override
  Future<Either<Failure, Outlet>> createOutlet(Outlet outlet) async {
    try {
      final created = await _remote.createOutlet(OutletModel.fromEntity(outlet));
      return Right(created.toEntity());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure('Gagal membuat outlet: $e'));
    }
  }

  @override
  Future<Either<Failure, Outlet>> updateOutlet(Outlet outlet) async {
    try {
      final updated = await _remote.updateOutlet(OutletModel.fromEntity(outlet));
      return Right(updated.toEntity());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure('Gagal memperbarui outlet: $e'));
    }
  }
}
