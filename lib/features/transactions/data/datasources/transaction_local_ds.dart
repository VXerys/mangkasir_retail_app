import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_detail.dart';
import '../models/transaction_detail_model.dart';
import '../models/transaction_model.dart';

abstract class TransactionLocalDs {
  Future<void> saveWithDetails({
    required Transaction transaction,
    required List<TransactionDetail> details,
  });
  Future<List<Transaction>> getPendingTransactions();
  Future<List<TransactionDetail>> getDetailsByGuid(String transactionGuid);
  Future<void> markTransactionSynced(String id, String? serverId);
  Future<void> markDetailsSynced(String transactionGuid);
}

@LazySingleton(as: TransactionLocalDs)
class TransactionLocalDsImpl implements TransactionLocalDs {
  final AppDatabase _db;

  TransactionLocalDsImpl(this._db);

  @override
  Future<void> saveWithDetails({
    required Transaction transaction,
    required List<TransactionDetail> details,
  }) async {
    try {
      await _db.transaction(() async {
        await _db.transactionDao.insert(
          TransactionModel.fromEntity(transaction).toDriftCompanion(),
        );
        await _db.transactionDetailDao.insertAll(
          details.map((d) => TransactionDetailModel.fromEntity(d).toDriftCompanion()).toList(),
        );
      });
    } catch (e) {
      throw LocalException('saveWithDetails failed: $e');
    }
  }

  @override
  Future<List<Transaction>> getPendingTransactions() async {
    try {
      final rows = await _db.transactionDao.getPending();
      return rows.map((r) => TransactionModel.fromDrift(r).toEntity()).toList();
    } catch (e) {
      throw LocalException('getPendingTransactions failed: $e');
    }
  }

  @override
  Future<List<TransactionDetail>> getDetailsByGuid(
    String transactionGuid,
  ) async {
    try {
      final rows = await _db.transactionDetailDao
          .getByTransactionGuid(transactionGuid);
      return rows
          .map((r) => TransactionDetailModel.fromDrift(r).toEntity())
          .toList();
    } catch (e) {
      throw LocalException('getDetailsByGuid failed: $e');
    }
  }

  @override
  Future<void> markTransactionSynced(String id, String? serverId) async {
    try {
      await _db.transactionDao.markSynced(id, serverId);
    } catch (e) {
      throw LocalException('markTransactionSynced failed: $e');
    }
  }

  @override
  Future<void> markDetailsSynced(String transactionGuid) async {
    try {
      await _db.transactionDetailDao
          .markSyncedByTransactionGuid(transactionGuid, 'synced');
    } catch (e) {
      throw LocalException('markDetailsSynced failed: $e');
    }
  }
}
