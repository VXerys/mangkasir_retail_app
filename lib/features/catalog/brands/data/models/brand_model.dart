import '../../domain/entities/brand.dart';

class BrandModel {
  const BrandModel({
    required this.id,
    required this.name,
    required this.businessId,
    required this.isActive,
  });

  final int id;
  final String name;
  final int businessId;
  final bool isActive;

  factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
        id: json['id'] as int,
        name: json['name'] as String,
        businessId: json['business_id'] as int,
        isActive: (json['is_active'] as bool?) ?? true,
      );

  static BrandModel fromEntity(Brand brand) => BrandModel(
        id: brand.id,
        name: brand.name,
        businessId: brand.businessId,
        isActive: brand.isActive,
      );

  Brand toEntity() => Brand(
        id: id,
        name: name,
        businessId: businessId,
        isActive: isActive,
      );

  Map<String, dynamic> toInsertJson() => {
        'name': name,
        'business_id': businessId,
        'is_active': isActive,
      };

  Map<String, dynamic> toUpdateJson() => {
        'name': name,
        'is_active': isActive,
      };
}
