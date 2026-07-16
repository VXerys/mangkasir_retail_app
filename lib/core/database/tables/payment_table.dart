import 'package:drift/drift.dart';

// Supabase mapping:
//   transactionGuid ↔  payments.transaction_guid
//   amount          ↔  payments.paid
//   changeAmount    ↔  payments.change_amount
//   subTotal        ↔  payments.sub_total
//   method          ↔  payments.payment_methode  (typo di Supabase — kita pakai 'method')
//   notes           ↔  payments.notes
//   date            ↔  payments.date
class PaymentTable extends Table {
  TextColumn get id => text()();
  TextColumn get guid => text()();
  TextColumn get transactionGuid => text()();
  RealColumn get amount => real()();
  RealColumn get changeAmount => real().withDefault(const Constant(0))();
  RealColumn get subTotal => real()();
  TextColumn get method => text()();
  TextColumn get notes => text().nullable()();
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
