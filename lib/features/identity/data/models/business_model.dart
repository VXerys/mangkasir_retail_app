import '../../domain/entities/business.dart';

class BusinessModel {
  final int id;
  final String uuid;
  final String name;
  final String currency;
  final String? phone;
  final String? address;
  final String? email;
  final String? taxNumber;
  final String? logoUrl;

  const BusinessModel({
    required this.id,
    required this.uuid,
    required this.name,
    required this.currency,
    this.phone,
    this.address,
    this.email,
    this.taxNumber,
    this.logoUrl,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) => BusinessModel(
        id: json['id'] as int,
        uuid: json['uuid'] as String,
        name: json['name'] as String,
        currency: json['currency'] as String? ?? 'IDR',
        phone: json['phone'] as String?,
        address: json['address'] as String?,
        email: json['email'] as String?,
        taxNumber: json['tax_number'] as String?,
        logoUrl: json['logo_url'] as String?,
      );

  factory BusinessModel.fromEntity(Business b) => BusinessModel(
        id: b.id,
        uuid: b.uuid,
        name: b.name,
        currency: b.currency,
        phone: b.phone,
        address: b.address,
        email: b.email,
        taxNumber: b.taxNumber,
        logoUrl: b.logoUrl,
      );

  Map<String, dynamic> toUpdateJson() => {
        'name': name,
        'currency': currency,
        if (phone != null) 'phone': phone,
        if (address != null) 'address': address,
        if (email != null) 'email': email,
        if (taxNumber != null) 'tax_number': taxNumber,
      };

  Business toEntity() => Business(
        id: id,
        uuid: uuid,
        name: name,
        currency: currency,
        phone: phone,
        address: address,
        email: email,
        taxNumber: taxNumber,
        logoUrl: logoUrl,
      );
}
