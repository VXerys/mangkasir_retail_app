import '../../domain/entities/warehouse.dart';

class WarehouseModel {
  const WarehouseModel({
    required this.id,
    required this.name,
    required this.outletId,
    required this.isDefault,
    required this.isActive,
  });

  final int id;
  final String name;
  final int outletId;
  final bool isDefault;
  final bool isActive;

  factory WarehouseModel.fromJson(Map<String, dynamic> json) => WarehouseModel(
        id: json['id'] as int,
        name: json['name'] as String,
        outletId: json['outlet_id'] as int,
        isDefault: (json['is_default'] as bool?) ?? false,
        isActive: (json['is_active'] as bool?) ?? true,
      );

  static WarehouseModel fromEntity(Warehouse w) => WarehouseModel(
        id: w.id,
        name: w.name,
        outletId: w.outletId,
        isDefault: w.isDefault,
        isActive: w.isActive,
      );

  Warehouse toEntity() => Warehouse(
        id: id,
        name: name,
        outletId: outletId,
        isDefault: isDefault,
        isActive: isActive,
      );

  Map<String, dynamic> toInsertJson() => {
        'name': name,
        'outlet_id': outletId,
        'is_default': isDefault,
        'is_active': isActive,
      };

  Map<String, dynamic> toUpdateJson() => {
        'name': name,
        'is_active': isActive,
      };
}
