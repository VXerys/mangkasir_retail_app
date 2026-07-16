import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_detail.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_local_ds.dart';
import '../datasources/transaction_remote_ds.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDs _localDs;
  final TransactionRemoteDs _remoteDs;

  const TransactionRepositoryImpl(this._localDs, this._remoteDs);

  @override
  Future<Either<Failure, Unit>> save({
    required Transaction transaction,
    required List<TransactionDetail> details,
  }) async {
    try {
      await _localDs.saveWithDetails(
        transaction: transaction,
        details: details,
      );
      return const Right(unit);
    } on LocalException catch (e) {
      return Left(LocalFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> syncPending() async {
    try {
      final pending = await _localDs.getPendingTransactions();
      for (final transaction in pending) {
        try {
          final details =
              await _localDs.getDetailsByGuid(transaction.guid);
          final serverId =
              await _remoteDs.pushTransaction(transaction, details);
          await _localDs.markTransactionSynced(transaction.id, serverId);
          await _localDs.markDetailsSynced(transaction.guid);
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
