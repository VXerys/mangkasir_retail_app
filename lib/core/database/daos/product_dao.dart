import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/product_table.dart';

part 'product_dao.g.dart';

@DriftAccessor(tables: [ProductTable])
class ProductDao extends DatabaseAccessor<AppDatabase> with _$ProductDaoMixin {
  ProductDao(super.db);

  Stream<List<ProductTableData>> watchActiveByCategory({String? categoryId}) {
    final query = select(productTable)
      ..where((t) => t.status.equals('active'));
    if (categoryId != null) {
      query.where((t) => t.categoryId.equals(categoryId));
    }
    return query.watch();
  }

  Future<List<ProductTableData>> getAll({String? categoryId}) {
    final query = select(productTable);
    if (categoryId != null) {
      query.where((t) => t.categoryId.equals(categoryId));
    }
    return query.get();
  }

  Future<void> upsert(ProductTableCompanion companion) {
    return into(productTable).insert(
      companion,
      onConflict: DoUpdate((old) => companion, target: [productTable.guid]),
    );
  }

  Future<List<ProductTableData>> getPending() {
    return (select(productTable)
          ..where((t) => t.syncStatus.equals('pending')))
        .get();
  }

  Future<void> markSynced(String id, String? serverId) {
    return (update(productTable)..where((t) => t.id.equals(id))).write(
      ProductTableCompanion(
        syncStatus: const Value('synced'),
        serverId: Value(serverId),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// After a category is synced, update products FK from local category uuid
  /// to the server category bigint (stored as string) so Supabase push succeeds.
  Future<void> remapCategoryId({
    required String localCategoryId,
    required String serverCategoryId,
  }) {
    return (update(productTable)
          ..where((t) => t.categoryId.equals(localCategoryId)))
        .write(ProductTableCompanion(categoryId: Value(serverCategoryId)));
  }
}
