import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/category_table.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [CategoryTable])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  Stream<List<CategoryTableData>> watchAll() {
    return select(categoryTable).watch();
  }

  Future<List<CategoryTableData>> getAll() {
    return select(categoryTable).get();
  }

  Future<void> upsert(CategoryTableCompanion companion) {
    return into(categoryTable).insert(
      companion,
      onConflict: DoUpdate((old) => companion, target: [categoryTable.guid]),
    );
  }

  Future<List<CategoryTableData>> getPending() {
    return (select(categoryTable)
          ..where((t) => t.syncStatus.equals('pending')))
        .get();
  }

  Future<void> markSynced(String id, String? serverId) {
    return (update(categoryTable)..where((t) => t.id.equals(id))).write(
      CategoryTableCompanion(
        syncStatus: const Value('synced'),
        serverId: Value(serverId),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
