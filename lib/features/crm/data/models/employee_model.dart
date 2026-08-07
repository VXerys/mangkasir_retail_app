import '../../domain/entities/employee.dart';

class EmployeeModel {
  const EmployeeModel({
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

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    final outletsList = (json['outlet_ids'] as List?)
            ?.map((e) => (e as num).toInt())
            .toList() ??
        <int>[];

    return EmployeeModel(
      id: (json['id'] as Object).toString(),
      businessId: (json['business_id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?) ?? (json['full_name'] as String?) ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      roleName: (json['role_name'] as String?) ?? (json['role'] as String?) ?? 'Staf',
      outletIds: outletsList,
      isActive: (json['is_active'] as bool?) ?? true,
      userId: json['user_id'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  static EmployeeModel fromEntity(Employee e) => EmployeeModel(
        id: e.id,
        businessId: e.businessId,
        name: e.name,
        email: e.email,
        phone: e.phone,
        roleName: e.roleName,
        outletIds: e.outletIds,
        isActive: e.isActive,
        userId: e.userId,
        createdAt: e.createdAt,
      );

  Employee toEntity() => Employee(
        id: id,
        businessId: businessId,
        name: name,
        email: email,
        phone: phone,
        roleName: roleName,
        outletIds: outletIds,
        isActive: isActive,
        userId: userId,
        createdAt: createdAt,
      );

  Map<String, dynamic> toInsertJson() => {
        'business_id': businessId,
        'name': name.trim(),
        if (email != null && email!.trim().isNotEmpty) 'email': email!.trim(),
        if (phone != null && phone!.trim().isNotEmpty) 'phone': phone!.trim(),
        'role_name': roleName,
        'is_active': isActive,
        if (userId != null) 'user_id': userId,
      };

  Map<String, dynamic> toUpdateJson() => {
        'name': name.trim(),
        'email': email?.trim(),
        'phone': phone?.trim(),
        'role_name': roleName,
        'is_active': isActive,
        'user_id': userId,
      };
}
