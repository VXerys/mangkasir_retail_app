import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/payment_table.dart';

part 'payment_dao.g.dart';

@DriftAccessor(tables: [PaymentTable])
class PaymentDao extends DatabaseAccessor<AppDatabase> with _$PaymentDaoMixin {
  PaymentDao(super.db);

  Future<void> insert(PaymentTableCompanion companion) {
    return into(paymentTable).insert(companion);
  }

  Future<List<PaymentTableData>> getByTransactionGuid(String guid) {
    return (select(paymentTable)
          ..where((t) => t.transactionGuid.equals(guid)))
        .get();
  }

  Future<List<PaymentTableData>> getPending() {
    return (select(paymentTable)
          ..where((t) => t.syncStatus.equals('pending')))
        .get();
  }

  Future<void> markSynced(String id, String? serverId) {
    return (update(paymentTable)..where((t) => t.id.equals(id))).write(
      PaymentTableCompanion(
        syncStatus: const Value('synced'),
        serverId: Value(serverId),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
