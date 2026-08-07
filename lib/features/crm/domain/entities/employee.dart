class Employee {
  const Employee({
    required this.id,
    required this.businessId,
    required this.name,
    this.email,
    this.phone,
    this.roleName = 'Kasir',
    this.outletIds = const <int>[],
    this.isActive = true,
    this.userId,
    this.createdAt,
  });

  final String id;
  final int businessId;
  final String name;
  final String? email;
  final String? phone;
  final String roleName;
  final List<int> outletIds;
  final bool isActive;
  final String? userId;
  final DateTime? createdAt;

  Employee copyWith({
    String? id,
    int? businessId,
    String? name,
    String? email,
    String? phone,
    String? roleName,
    List<int>? outletIds,
    bool? isActive,
    String? userId,
    DateTime? createdAt,
  }) {
    return Employee(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      roleName: roleName ?? this.roleName,
      outletIds: outletIds ?? this.outletIds,
      isActive: isActive ?? this.isActive,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
