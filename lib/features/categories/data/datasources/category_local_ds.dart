import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/category.dart';
import '../models/category_model.dart';

abstract class CategoryLocalDs {
  Future<List<Category>> getAll();
  Stream<List<Category>> watchAll();
  Future<void> save(Category category);
  Future<List<Category>> getPending();
  Future<void> markSynced(String id, String? serverId);
}

@LazySingleton(as: CategoryLocalDs)
class CategoryLocalDsImpl implements CategoryLocalDs {
  final AppDatabase _db;

  CategoryLocalDsImpl(this._db);

  @override
  Future<List<Category>> getAll() async {
    try {
      final rows = await _db.categoryDao.getAll();
      return rows.map((r) => CategoryModel.fromDrift(r).toEntity()).toList();
    } catch (e) {
      throw LocalException('getAll failed: $e');
    }
  }

  @override
  Stream<List<Category>> watchAll() {
    return _db.categoryDao
        .watchAll()
        .map((rows) => rows.map((r) => CategoryModel.fromDrift(r).toEntity()).toList())
        .handleError((e) => throw LocalException('watch failed: $e'));
  }

  @override
  Future<void> save(Category category) async {
    try {
      await _db.categoryDao.upsert(
        CategoryModel.fromEntity(category).toDriftCompanion(),
      );
    } catch (e) {
      throw LocalException('save failed: $e');
    }
  }

  @override
  Future<List<Category>> getPending() async {
    try {
      final rows = await _db.categoryDao.getPending();
      return rows.map((r) => CategoryModel.fromDrift(r).toEntity()).toList();
    } catch (e) {
      throw LocalException('getPending failed: $e');
    }
  }

  @override
  Future<void> markSynced(String id, String? serverId) async {
    try {
      await _db.categoryDao.markSynced(id, serverId);
    } catch (e) {
      throw LocalException('markSynced failed: $e');
    }
  }
}
