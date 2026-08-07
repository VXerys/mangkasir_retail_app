import '../../domain/entities/customer.dart';

class CustomerModel {
  const CustomerModel({
    required this.id,
    required this.uuid,
    required this.outletId,
    required this.name,
    this.phone,
    this.email,
    this.address,
    this.loyaltyPoints = 0.0,
    this.creditLimit = 0.0,
    this.createdAt,
  });

  final int id;
  final String uuid;
  final int outletId;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final double loyaltyPoints;
  final double creditLimit;
  final DateTime? createdAt;

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        id: (json['id'] as num).toInt(),
        uuid: (json['uuid'] as String?) ?? '',
        outletId: (json['outlet_id'] as num).toInt(),
        name: (json['name'] as String?) ?? '',
        phone: json['phone'] as String?,
        email: json['email'] as String?,
        address: json['address'] as String?,
        loyaltyPoints: (json['loyalty_points'] as num?)?.toDouble() ?? 0.0,
        creditLimit: (json['credit_limit'] as num?)?.toDouble() ?? 0.0,
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'] as String)
            : null,
      );

  static CustomerModel fromEntity(Customer c) => CustomerModel(
        id: c.id,
        uuid: c.uuid,
        outletId: c.outletId,
        name: c.name,
        phone: c.phone,
        email: c.email,
        address: c.address,
        loyaltyPoints: c.loyaltyPoints,
        creditLimit: c.creditLimit,
        createdAt: c.createdAt,
      );

  Customer toEntity() => Customer(
        id: id,
        uuid: uuid,
        outletId: outletId,
        name: name,
        phone: phone,
        email: email,
        address: address,
        loyaltyPoints: loyaltyPoints,
        creditLimit: creditLimit,
        createdAt: createdAt,
      );

  Map<String, dynamic> toInsertJson() => {
        'outlet_id': outletId,
        'name': name.trim(),
        if (phone != null && phone!.trim().isNotEmpty) 'phone': phone!.trim(),
        if (email != null && email!.trim().isNotEmpty) 'email': email!.trim(),
        if (address != null && address!.trim().isNotEmpty) 'address': address!.trim(),
        'loyalty_points': loyaltyPoints,
        'credit_limit': creditLimit,
      };

  Map<String, dynamic> toUpdateJson() => {
        'name': name.trim(),
        'phone': phone?.trim(),
        'email': email?.trim(),
        'address': address?.trim(),
        'loyalty_points': loyaltyPoints,
        'credit_limit': creditLimit,
      };
}
