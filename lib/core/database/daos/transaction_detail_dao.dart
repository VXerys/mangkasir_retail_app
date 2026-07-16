import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/transaction_detail_table.dart';

part 'transaction_detail_dao.g.dart';

@DriftAccessor(tables: [TransactionDetailTable])
class TransactionDetailDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDetailDaoMixin {
  TransactionDetailDao(super.db);

  Future<void> insertAll(List<TransactionDetailTableCompanion> companions) {
    return batch((b) => b.insertAll(transactionDetailTable, companions));
  }

  Future<List<TransactionDetailTableData>> getByTransactionGuid(String guid) {
    return (select(transactionDetailTable)
          ..where((t) => t.transactionGuid.equals(guid)))
        .get();
  }

  Future<List<TransactionDetailTableData>> getPending() {
    return (select(transactionDetailTable)
          ..where((t) => t.syncStatus.equals('pending')))
        .get();
  }

  Future<void> markSyncedByTransactionGuid(
    String transactionGuid,
    String syncStatus,
  ) {
    return (update(transactionDetailTable)
          ..where((t) => t.transactionGuid.equals(transactionGuid)))
        .write(
      TransactionDetailTableCompanion(
        syncStatus: Value(syncStatus),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
