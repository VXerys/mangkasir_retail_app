import 'package:drift/drift.dart';

// Supabase mapping:
//   id (local uuid PK)  ↔  —
//   guid                ↔  products.uuid
//   serverId            ↔  products.id (bigint, stored as string)
//   storeId             ↔  products.outlet_id
//   categoryId          ↔  products.category_id (local FK to CategoryTable.id)
class ProductTable extends Table {
  TextColumn get id => text()();
  TextColumn get guid => text()();
  TextColumn get barcode => text().nullable()();
  TextColumn get name => text()();
  RealColumn get price => real()();
  RealColumn get cost => real().withDefault(const Constant(0))();
  TextColumn get sku => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get storeId => text()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get parentId => text().nullable()();

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
