import 'package:drift/drift.dart';

import '../../../../core/database/tables/product_table.dart';
import '../../domain/entities/product.dart';

// Maps between: Drift row ↔ Product entity ↔ Supabase JSON
class ProductModel {
  final String id;
  final String guid;
  final String? barcode;
  final String name;
  final double price;
  final double cost;
  final String? sku;
  final String status;
  final String storeId;
  final String? categoryId;
  final String? parentId;
  final String syncStatus;
  final String? serverId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductModel({
    required this.id,
    required this.guid,
    this.barcode,
    required this.name,
    required this.price,
    required this.cost,
    this.sku,
    required this.status,
    required this.storeId,
    this.categoryId,
    this.parentId,
    required this.syncStatus,
    this.serverId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromDrift(ProductTableData row) => ProductModel(
        id: row.id,
        guid: row.guid,
        barcode: row.barcode,
        name: row.name,
        price: row.price,
        cost: row.cost,
        sku: row.sku,
        status: row.status,
        storeId: row.storeId,
        categoryId: row.categoryId,
        parentId: row.parentId,
        syncStatus: row.syncStatus,
        serverId: row.serverId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );

  // Supabase mapping:
  //   outlet_id expects bigint — storeId stores the server outlet bigint as string.
  //   category_id expects bigint — categoryId stores the server category bigint as string.
  factory ProductModel.fromSupabase(Map<String, dynamic> json) => ProductModel(
        id: json['uuid'] as String,
        guid: json['uuid'] as String,
        barcode: json['barcode'] as String?,
        name: json['name'] as String,
        price: (json['price'] as num).toDouble(),
        cost: (json['cost'] as num).toDouble(),
        sku: json['sku'] as String?,
        status: json['status'] as String? ?? 'active',
        storeId: json['outlet_id'].toString(),
        categoryId: json['category_id']?.toString(),
        parentId: json['parent_id']?.toString(),
        syncStatus: 'synced',
        serverId: json['id'].toString(),
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Product toEntity() => Product(
        id: id,
        guid: guid,
        barcode: barcode,
        name: name,
        price: price,
        cost: cost,
        sku: sku,
        status: status,
        storeId: storeId,
        categoryId: categoryId,
        parentId: parentId,
        syncStatus: syncStatus,
        serverId: serverId,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  ProductTableCompanion toDriftCompanion() => ProductTableCompanion(
        id: Value(id),
        guid: Value(guid),
        barcode: Value(barcode),
        name: Value(name),
        price: Value(price),
        cost: Value(cost),
        sku: Value(sku),
        status: Value(status),
        storeId: Value(storeId),
        categoryId: Value(categoryId),
        parentId: Value(parentId),
        syncStatus: Value(syncStatus),
        serverId: Value(serverId),
        createdAt: Value(createdAt),
        updatedAt: Value(updatedAt),
      );

  Map<String, dynamic> toSupabaseJson() => {
        'uuid': guid,
        'name': name,
        'price': price,
        'cost': cost,
        if (barcode != null) 'barcode': barcode,
        if (sku != null) 'sku': sku,
        'status': status,
        // outlet_id and category_id are bigints on server; we stored them as strings
        'outlet_id': int.tryParse(storeId),
        if (categoryId != null) 'category_id': int.tryParse(categoryId!),
        if (parentId != null) 'parent_id': int.tryParse(parentId!),
      };

  static ProductModel fromEntity(Product entity) => ProductModel(
        id: entity.id,
        guid: entity.guid,
        barcode: entity.barcode,
        name: entity.name,
        price: entity.price,
        cost: entity.cost,
        sku: entity.sku,
        status: entity.status,
        storeId: entity.storeId,
        categoryId: entity.categoryId,
        parentId: entity.parentId,
        syncStatus: entity.syncStatus,
        serverId: entity.serverId,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );
}
