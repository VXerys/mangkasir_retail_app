import '../../domain/entities/app_user.dart';

class AppUserModel {
  final int id;
  final String uuid;
  final String email;
  final String username;
  final int businessId;
  final List<AppUserRoleModel> roles;

  const AppUserModel({
    required this.id,
    required this.uuid,
    required this.email,
    required this.username,
    required this.businessId,
    this.roles = const [],
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    final userRoles = (json['user_roles'] as List? ?? [])
        .map((r) => AppUserRoleModel.fromJson(r as Map<String, dynamic>))
        .toList();

    return AppUserModel(
      id: json['id'] as int,
      uuid: json['uuid'] as String,
      email: json['email'] as String? ?? '',
      username: json['username'] as String? ?? '',
      businessId: json['business_id'] as int,
      roles: userRoles,
    );
  }

  AppUser toEntity() => AppUser(
        id: id,
        uuid: uuid,
        email: email,
        username: username,
        businessId: businessId,
        roles: roles.map((r) => r.toEntity()).toList(),
      );
}

class AppUserRoleModel {
  final int userRoleId;
  final String roleName;
  final int? outletId;
  final String? outletName;

  const AppUserRoleModel({
    required this.userRoleId,
    required this.roleName,
    this.outletId,
    this.outletName,
  });

  factory AppUserRoleModel.fromJson(Map<String, dynamic> json) {
    final role = json['roles'] as Map<String, dynamic>? ?? {};
    final outlet = json['outlets'] as Map<String, dynamic>?;
    return AppUserRoleModel(
      userRoleId: json['id'] as int,
      roleName: role['name'] as String? ?? '',
      outletId: json['outlet_id'] as int?,
      outletName: outlet?['name'] as String?,
    );
  }

  AppUserRole toEntity() => AppUserRole(
        userRoleId: userRoleId,
        roleName: roleName,
        outletId: outletId,
        outletName: outletName,
      );
}
