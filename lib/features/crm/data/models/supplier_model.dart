import '../../domain/entities/supplier.dart';

class SupplierModel {
  const SupplierModel({
    required this.id,
    required this.uuid,
    required this.businessId,
    required this.name,
    this.phone,
    this.email,
    this.address,
    this.taxId,
    this.paymentTerms,
    this.isActive = true,
    this.createdAt,
  });

  final int id;
  final String uuid;
  final int businessId;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String? taxId;
  final String? paymentTerms;
  final bool isActive;
  final DateTime? createdAt;

  factory SupplierModel.fromJson(Map<String, dynamic> json) => SupplierModel(
        id: (json['id'] as num).toInt(),
        uuid: (json['uuid'] as String?) ?? '',
        businessId: (json['business_id'] as num).toInt(),
        name: (json['name'] as String?) ?? '',
        phone: json['phone'] as String?,
        email: json['email'] as String?,
        address: json['address'] as String?,
        taxId: json['tax_id'] as String?,
        paymentTerms: json['payment_terms'] as String?,
        isActive: (json['is_active'] as bool?) ?? true,
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'] as String)
            : null,
      );

  static SupplierModel fromEntity(Supplier s) => SupplierModel(
        id: s.id,
        uuid: s.uuid,
        businessId: s.businessId,
        name: s.name,
        phone: s.phone,
        email: s.email,
        address: s.address,
        taxId: s.taxId,
        paymentTerms: s.paymentTerms,
        isActive: s.isActive,
        createdAt: s.createdAt,
      );

  Supplier toEntity() => Supplier(
        id: id,
        uuid: uuid,
        businessId: businessId,
        name: name,
        phone: phone,
        email: email,
        address: address,
        taxId: taxId,
        paymentTerms: paymentTerms,
        isActive: isActive,
        createdAt: createdAt,
      );

  Map<String, dynamic> toInsertJson() => {
        'business_id': businessId,
        'name': name.trim(),
        if (phone != null && phone!.trim().isNotEmpty) 'phone': phone!.trim(),
        if (email != null && email!.trim().isNotEmpty) 'email': email!.trim(),
        if (address != null && address!.trim().isNotEmpty) 'address': address!.trim(),
        if (taxId != null && taxId!.trim().isNotEmpty) 'tax_id': taxId!.trim(),
        if (paymentTerms != null && paymentTerms!.trim().isNotEmpty)
          'payment_terms': paymentTerms!.trim(),
      };

  Map<String, dynamic> toUpdateJson() => {
        'name': name.trim(),
        'phone': phone?.trim(),
        'email': email?.trim(),
        'address': address?.trim(),
        'tax_id': taxId?.trim(),
        'payment_terms': paymentTerms?.trim(),
        'is_active': isActive,
      };
}
