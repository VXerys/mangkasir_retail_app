import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';

/// Pengguna yang terdaftar dalam sebuah bisnis.
///
/// Berbeda dari [SessionUser] yang hanya memuat data minimal untuk sesi aktif,
/// [AppUser] membawa data lengkap termasuk peran per outlet dan status akun —
/// dipakai halaman /settings/users.
@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required int id,
    required String uuid,
    required String email,
    required String username,
    required int businessId,
    @Default([]) List<AppUserRole> roles,
  }) = _AppUser;
}

/// Peran yang dipegang pengguna, opsional terbatas pada satu outlet.
@freezed
class AppUserRole with _$AppUserRole {
  const factory AppUserRole({
    required int userRoleId,
    required String roleName,
    int? outletId,
    String? outletName,
  }) = _AppUserRole;
}
