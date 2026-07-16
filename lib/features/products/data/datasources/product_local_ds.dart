import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/product.dart';
import '../models/product_model.dart';

abstract class ProductLocalDs {
  Future<List<Product>> getAll({String? categoryId});
  Stream<List<Product>> watchActiveByCategory({String? categoryId});
  Future<void> save(Product product);
  Future<List<Product>> getPending();
  Future<void> markSynced(String id, String? serverId);
  Future<void> remapCategoryId({
    required String localCategoryId,
    required String serverCategoryId,
  });
}

@LazySingleton(as: ProductLocalDs)
class ProductLocalDsImpl implements ProductLocalDs {
  final AppDatabase _db;

  ProductLocalDsImpl(this._db);

  @override
  Future<List<Product>> getAll({String? categoryId}) async {
    try {
      final rows = await _db.productDao.getAll(categoryId: categoryId);
      return rows.map((r) => ProductModel.fromDrift(r).toEntity()).toList();
    } catch (e) {
      throw LocalException('getAll failed: $e');
    }
  }

  @override
  Stream<List<Product>> watchActiveByCategory({String? categoryId}) {
    return _db.productDao
        .watchActiveByCategory(categoryId: categoryId)
        .map((rows) => rows.map((r) => ProductModel.fromDrift(r).toEntity()).toList())
        .handleError((e) => throw LocalException('watch failed: $e'));
  }

  @override
  Future<void> save(Product product) async {
    try {
      await _db.productDao.upsert(
        ProductModel.fromEntity(product).toDriftCompanion(),
      );
    } catch (e) {
      throw LocalException('save failed: $e');
    }
  }

  @override
  Future<List<Product>> getPending() async {
    try {
      final rows = await _db.productDao.getPending();
      return rows.map((r) => ProductModel.fromDrift(r).toEntity()).toList();
    } catch (e) {
      throw LocalException('getPending failed: $e');
    }
  }

  @override
  Future<void> markSynced(String id, String? serverId) async {
    try {
      await _db.productDao.markSynced(id, serverId);
    } catch (e) {
      throw LocalException('markSynced failed: $e');
    }
  }

  @override
  Future<void> remapCategoryId({
    required String localCategoryId,
    required String serverCategoryId,
  }) async {
    try {
      await _db.productDao.remapCategoryId(
        localCategoryId: localCategoryId,
        serverCategoryId: serverCategoryId,
      );
    } catch (e) {
      throw LocalException('remapCategoryId failed: $e');
    }
  }
}
