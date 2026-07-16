import 'package:drift/drift.dart';

// Supabase mapping:
//   transactionGuid ↔  transaction_details.transaction_guid
//   productGuid     ↔  transaction_details.product_guid (uuid FK)
//   productName     ↔  transaction_details.product_name  (snapshot)
//   productSku      ↔  transaction_details.product_sku   (snapshot)
//   price           ↔  transaction_details.price          (snapshot at sale time)
//   cost            ↔  transaction_details.cost           (snapshot)
//   discount        ↔  transaction_details.discount
//   tax             ↔  transaction_details.ppn
//   totalPrice      ↔  transaction_details.total_price
// Snapshot columns TIDAK boleh diubah setelah transaksi selesai —
// laporan historis harus konsisten walau produk di-edit.
class TransactionDetailTable extends Table {
  TextColumn get id => text()();
  TextColumn get guid => text()();
  TextColumn get transactionGuid => text()();
  TextColumn get productGuid => text().nullable()();

  // Snapshot at time of sale
  TextColumn get productName => text()();
  TextColumn get productSku => text().nullable()();
  RealColumn get price => real()();
  RealColumn get cost => real().withDefault(const Constant(0))();
  RealColumn get qty => real()();
  RealColumn get discount => real().withDefault(const Constant(0))();
  RealColumn get tax => real().withDefault(const Constant(0))();
  RealColumn get totalPrice => real()();

  // Sync columns
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  TextColumn get serverId => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {guid}
      ];
}
