import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_local_ds.dart';
import '../datasources/payment_remote_ds.dart';

@LazySingleton(as: PaymentRepository)
class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentLocalDs _localDs;
  final PaymentRemoteDs _remoteDs;

  const PaymentRepositoryImpl(this._localDs, this._remoteDs);

  @override
  Future<Either<Failure, Unit>> save(Payment payment) async {
    try {
      await _localDs.save(payment);
      return const Right(unit);
    } on LocalException catch (e) {
      return Left(LocalFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> syncPending() async {
    try {
      final pending = await _localDs.getPending();
      for (final payment in pending) {
        try {
          final serverId = await _remoteDs.pushPayment(payment);
          await _localDs.markSynced(payment.id, serverId);
        } on RemoteException {
          continue;
        }
      }
      return const Right(unit);
    } on LocalException catch (e) {
      return Left(SyncFailure(e.message));
    }
  }
}
