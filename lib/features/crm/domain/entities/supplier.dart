class Supplier {
  const Supplier({
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

  Supplier copyWith({
    int? id,
    String? uuid,
    int? businessId,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? taxId,
    String? paymentTerms,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Supplier(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      businessId: businessId ?? this.businessId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      taxId: taxId ?? this.taxId,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
