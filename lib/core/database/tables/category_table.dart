import 'package:drift/drift.dart';

// Supabase mapping:
//   guid    ↔  categories.uuid
//   name    ↔  categories.category_name  (different column name — map during sync)
//   storeId ↔  categories.outlet_id
class CategoryTable extends Table {
  TextColumn get id => text()();
  TextColumn get guid => text()();
  TextColumn get name => text()();
  TextColumn get storeId => text()();

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
