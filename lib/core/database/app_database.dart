import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:injectable/injectable.dart';

import 'daos/category_dao.dart';
import 'daos/payment_dao.dart';
import 'daos/product_dao.dart';
import 'daos/transaction_dao.dart';
import 'daos/transaction_detail_dao.dart';
import 'tables/category_table.dart';
import 'tables/payment_table.dart';
import 'tables/product_table.dart';
import 'tables/transaction_detail_table.dart';
import 'tables/transaction_table.dart';

part 'app_database.g.dart';

@singleton
@DriftDatabase(
  tables: [
    ProductTable,
    CategoryTable,
    TransactionTable,
    TransactionDetailTable,
    PaymentTable,
  ],
  daos: [
    ProductDao,
    CategoryDao,
    TransactionDao,
    TransactionDetailDao,
    PaymentDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'mangkasir_db'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          // Schema version 2+: tambahkan kolom baru di sini
          // Contoh: if (from < 2) { await m.addColumn(productTable, productTable.someNewColumn); }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');

          if (details.wasCreated) {
            // Index untuk query laporan penjualan berdasarkan tanggal
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_trx_date '
              'ON transaction_table(created_at)',
            );
          }
        },
      );
}
