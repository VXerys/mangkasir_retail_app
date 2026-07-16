import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String guid,
    String? barcode,
    required String name,
    required double price,
    required double cost,
    String? sku,
    @Default('active') String status,
    required String storeId,
    String? categoryId,
    String? parentId,
    @Default('pending') String syncStatus,
    String? serverId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Product;
}
