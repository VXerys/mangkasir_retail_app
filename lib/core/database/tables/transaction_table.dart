import 'package:drift/drift.dart';

// Supabase mapping:
//   guid         ↔  transactions.guid
//   storeId      ↔  transactions.outlet_id
//   subTotal     ↔  transactions.sub_total
//   discount     ↔  transactions.invoice_discount
//   tax          ↔  transactions.invoice_ppn
//   flag         ↔  transactions.flag  ('done' | 'void')
//   customerName ↔  transactions.customer_name
//   cashierId    ↔  transactions.cashier_id (stored as string)
//   date         ↔  transactions.date
//   invoice      ↔  transactions.invoice
// paymentMethod stored here as convenience snapshot; detail ada di PaymentTable
class TransactionTable extends Table {
  TextColumn get id => text()();
  TextColumn get guid => text()();
  TextColumn get storeId => text()();
  RealColumn get subTotal => real()();
  RealColumn get discount => real().withDefault(const Constant(0))();
  RealColumn get tax => real().withDefault(const Constant(0))();
  TextColumn get paymentMethod => text()();
  TextColumn get flag => text().withDefault(const Constant('done'))();
  TextColumn get invoice => text().nullable()();
  TextColumn get customerName => text().nullable()();
  TextColumn get cashierId => text().nullable()();
  DateTimeColumn get date => dateTime().nullable()();

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
