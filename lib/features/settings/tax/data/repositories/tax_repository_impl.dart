import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/tax_settings.dart';
import '../../domain/repositories/tax_repository.dart';
import '../datasources/tax_remote_ds.dart';

@LazySingleton(as: TaxRepository)
class TaxRepositoryImpl implements TaxRepository {
  final TaxRemoteDs _remoteDs;

  const TaxRepositoryImpl(this._remoteDs);

  @override
  Future<Either<Failure, TaxSettings>> get(int outletId) async {
    try {
      return Right(await _remoteDs.get(outletId));
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, TaxSettings>> save(TaxSettings settings) async {
    try {
      return Right(await _remoteDs.save(settings));
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    }
  }
}
