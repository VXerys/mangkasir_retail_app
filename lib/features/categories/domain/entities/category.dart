import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    required String guid,
    required String name,
    required String storeId,
    @Default('pending') String syncStatus,
    String? serverId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Category;
}
