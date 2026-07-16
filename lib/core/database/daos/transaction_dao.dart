import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/transaction_table.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [TransactionTable])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(super.db);

  Future<void> insert(TransactionTableCompanion companion) {
    return into(transactionTable).insert(companion);
  }

  Future<List<TransactionTableData>> getPending() {
    return (select(transactionTable)
          ..where((t) => t.syncStatus.equals('pending')))
        .get();
  }

  Future<void> markSynced(String id, String? serverId) {
    return (update(transactionTable)..where((t) => t.id.equals(id))).write(
      TransactionTableCompanion(
        syncStatus: const Value('synced'),
        serverId: Value(serverId),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Used for invoice sequence number: INV-{store}-{date}-{seq}
  Future<int> countByDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    final query = select(transactionTable)
      ..where((t) => t.createdAt.isBetweenValues(start, end));
    return (await query.get()).length;
  }
}
