class Customer {
  const Customer({
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

  Customer copyWith({
    int? id,
    String? uuid,
    int? outletId,
    String? name,
    String? phone,
    String? email,
    String? address,
    double? loyaltyPoints,
    double? creditLimit,
    DateTime? createdAt,
  }) {
    return Customer(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      outletId: outletId ?? this.outletId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      creditLimit: creditLimit ?? this.creditLimit,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
