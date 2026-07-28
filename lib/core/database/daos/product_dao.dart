import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/product_table.dart';

part 'product_dao.g.dart';

@DriftAccessor(tables: [ProductTable])
class ProductDao extends DatabaseAccessor<AppDatabase> with _$ProductDaoMixin {
  ProductDao(super.db);

  /// Katalog satu outlet.
  ///
  /// [storeId] wajib, bukan opsional. Satu perangkat bisa berpindah outlet
  /// tanpa keluar dari aplikasi, dan penyaring yang boleh dilewatkan akan
  /// menampilkan katalog kedua outlet tercampur — persis perilaku yang berlaku
  /// sebelum UI-5, saat pengalih outlet hanya mengganti label di pojok layar.
  Stream<List<ProductTableData>> watchActiveByCategory({
    required String storeId,
    String? categoryId,
  }) {
    final query = select(productTable)
      ..where((t) => t.status.equals('active'))
      ..where((t) => t.storeId.equals(storeId));
    if (categoryId != null) {
      query.where((t) => t.categoryId.equals(categoryId));
    }
    return query.watch();
  }

  Future<List<ProductTableData>> getAll({
    required String storeId,
    String? categoryId,
  }) {
    final query = select(productTable)
      ..where((t) => t.storeId.equals(storeId));
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
