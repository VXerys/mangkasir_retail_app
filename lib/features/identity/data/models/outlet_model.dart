import '../../domain/entities/outlet.dart';

class OutletModel {
  final int id;
  final String uuid;
  final int businessId;
  final String name;
  final String currency;
  final bool isActive;
  final String? address;
  final String? phone;

  const OutletModel({
    required this.id,
    required this.uuid,
    required this.businessId,
    required this.name,
    required this.currency,
    required this.isActive,
    this.address,
    this.phone,
  });

  factory OutletModel.fromJson(Map<String, dynamic> json) => OutletModel(
        id: json['id'] as int,
        uuid: json['uuid'] as String,
        businessId: json['business_id'] as int,
        name: json['name'] as String,
        currency: json['currency'] as String? ?? 'IDR',
        isActive: json['is_active'] as bool? ?? true,
        address: json['address'] as String?,
        phone: json['phone'] as String?,
      );

  factory OutletModel.fromEntity(Outlet o) => OutletModel(
        id: o.id,
        uuid: o.uuid,
        businessId: o.businessId,
        name: o.name,
        currency: o.currency,
        isActive: o.isActive,
        address: o.address,
        phone: o.phone,
      );

  Map<String, dynamic> toInsertJson() => {
        'business_id': businessId,
        'name': name,
        'currency': currency,
        'is_active': isActive,
        if (address != null) 'address': address,
        if (phone != null) 'phone': phone,
      };

  Map<String, dynamic> toUpdateJson() => {
        'name': name,
        'currency': currency,
        'is_active': isActive,
        if (address != null) 'address': address,
        if (phone != null) 'phone': phone,
      };

  Outlet toEntity() => Outlet(
        id: id,
        uuid: uuid,
        businessId: businessId,
        name: name,
        currency: currency,
        isActive: isActive,
        address: address,
        phone: phone,
      );
}
