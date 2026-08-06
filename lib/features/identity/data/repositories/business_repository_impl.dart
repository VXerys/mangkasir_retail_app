import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/business.dart';
import '../../domain/repositories/business_repository.dart';
import '../datasources/business_remote_ds.dart';
import '../models/business_model.dart';

@LazySingleton(as: BusinessRepository)
class BusinessRepositoryImpl implements BusinessRepository {
  final BusinessRemoteDs _remote;

  BusinessRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, Business>> getBusiness(int businessId) async {
    try {
      final model = await _remote.getBusiness(businessId);
      return Right(model.toEntity());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure('Gagal memuat data bisnis: $e'));
    }
  }

  @override
  Future<Either<Failure, Business>> updateBusiness(Business business) async {
    try {
      final updated =
          await _remote.updateBusiness(BusinessModel.fromEntity(business));
      return Right(updated.toEntity());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure('Gagal memperbarui bisnis: $e'));
    }
  }
}
