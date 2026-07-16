import 'package:drift/drift.dart';

import '../../../../core/database/tables/category_table.dart';
import '../../domain/entities/category.dart';

// Supabase mapping notes:
//   name    ↔  categories.category_name  (column name differs — mapped here)
//   storeId ↔  categories.outlet_id (bigint on server, stored as string locally)
//   guid    ↔  categories.uuid
class CategoryModel {
  final String id;
  final String guid;
  final String name;
  final String storeId;
  final String syncStatus;
  final String? serverId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CategoryModel({
    required this.id,
    required this.guid,
    required this.name,
    required this.storeId,
    required this.syncStatus,
    this.serverId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromDrift(CategoryTableData row) => CategoryModel(
        id: row.id,
        guid: row.guid,
        name: row.name,
        storeId: row.storeId,
        syncStatus: row.syncStatus,
        serverId: row.serverId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );

  // Supabase: category_name (not name), outlet_id (bigint)
  factory CategoryModel.fromSupabase(Map<String, dynamic> json) => CategoryModel(
        id: json['uuid'] as String,
        guid: json['uuid'] as String,
        name: json['category_name'] as String,
        storeId: json['outlet_id'].toString(),
        syncStatus: 'synced',
        serverId: json['id'].toString(),
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  static CategoryModel fromEntity(Category entity) => CategoryModel(
        id: entity.id,
        guid: entity.guid,
        name: entity.name,
        storeId: entity.storeId,
        syncStatus: entity.syncStatus,
        serverId: entity.serverId,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  Category toEntity() => Category(
        id: id,
        guid: guid,
        name: name,
        storeId: storeId,
        syncStatus: syncStatus,
        serverId: serverId,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  CategoryTableCompanion toDriftCompanion() => CategoryTableCompanion(
        id: Value(id),
        guid: Value(guid),
        name: Value(name),
        storeId: Value(storeId),
        syncStatus: Value(syncStatus),
        serverId: Value(serverId),
        createdAt: Value(createdAt),
        updatedAt: Value(updatedAt),
      );

  Map<String, dynamic> toSupabaseJson() => {
        'uuid': guid,
        'category_name': name,
        'outlet_id': int.tryParse(storeId),
      };
}
