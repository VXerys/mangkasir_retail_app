import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../error/failures.dart';
import '../preferences/app_preferences.dart';
import 'app_permissions.dart';
import 'app_role.dart';
import 'app_session.dart';
import 'session_repository.dart';

/// Sumber sesi sementara, dipakai selama layar masuk belum dibangun.
///
/// Alasan berkas ini ada: navigasi berbasis izin tidak bisa dibuktikan benar
/// tanpa sesi. Menunda seluruh RBAC sampai autentikasi selesai berarti menulis
/// pohon navigasi, guard, dan menu tanpa pernah menjalankannya — dan
/// menemukannya salah setelah empat puluh halaman berdiri di atasnya.
///
/// Yang **dipalsukan** hanya asal datanya. Bentuk sesi, aturan izin, bypass
/// Owner, dan penghitungan ulang saat ganti outlet semuanya nyata dan diuji.
/// Himpunan izin per peran disalin apa adanya dari `role_permissions`
/// (lihat [AppRole.seededPermissions]), sehingga menu yang muncul di sini sama
/// dengan menu yang nanti muncul setelah login sungguhan.
///
/// Berkas ini **dihapus**, bukan dikembangkan, saat fase auth tiba.
@LazySingleton(as: SessionRepository)
class DevSessionRepository implements SessionRepository {
  final AppPreferences _preferences;

  DevSessionRepository(this._preferences);

  static const _business = SessionBusiness(id: 1, name: 'Toko MangRitel');

  static const _outlets = [
    SessionOutlet(id: 1, name: 'Outlet Pusat'),
    SessionOutlet(id: 2, name: 'Cabang Antang'),
  ];

  static const _user = SessionUser(
    id: 1,
    uuid: '00000000-0000-4000-8000-000000000001',
    username: 'demo',
    email: 'demo@mangritel.test',
  );

  @override
  Future<Either<Failure, AppSession>> restore() async {
    final role = _preferences.devRole;
    if (role == null) {
      return const Left(AuthFailure('Belum ada sesi tersimpan'));
    }

    return Right(_build(role, _preferences.activeOutletId ?? _outlets.first.id));
  }

  @override
  Future<Either<Failure, AppSession>> selectOutlet(int outletId) async {
    if (!_outlets.any((outlet) => outlet.id == outletId)) {
      return const Left(ForbiddenFailure('Outlet tidak dapat diakses'));
    }

    final role = _preferences.devRole;
    if (role == null) {
      return const Left(AuthFailure('Belum ada sesi tersimpan'));
    }

    await _preferences.setActiveOutletId(outletId);
    return Right(_build(role, outletId));
  }

  @override
  Future<void> signOut() => _preferences.setActiveOutletId(null);

  /// Masuk sebagai peran tertentu. Hanya ada di implementasi dev.
  Future<AppSession> signInAs(String role) async {
    await _preferences.setDevRole(role);
    return _build(role, _preferences.activeOutletId ?? _outlets.first.id);
  }

  AppSession _build(String role, int outletId) {
    return AppSession(
      user: _user,
      business: _business,
      outlets: _outlets,
      activeOutlet: _outlets.firstWhere(
        (outlet) => outlet.id == outletId,
        orElse: () => _outlets.first,
      ),
      roleNames: {role},
      // Peran tak dikenal tidak melempar, ia hanya tidak memegang apa pun —
      // perilaku yang sama seperti peran buatan tenant yang belum dipetakan.
      permissions: AppRole.seededPermissions[role] ?? const <String>{},
    );
  }

  /// Peran yang bisa dipilih di galeri.
  static List<String> get selectableRoles => AppRole.seeded;

  /// Outlet contoh, dipakai galeri untuk mencoba pengalih outlet.
  static List<SessionOutlet> get sampleOutlets => _outlets;

  /// Sesi contoh tanpa menyentuh penyimpanan — untuk galeri dan tes.
  static AppSession sampleSession(String role, {int outletId = 1}) {
    return AppSession(
      user: _user,
      business: _business,
      outlets: _outlets,
      activeOutlet: _outlets.firstWhere(
        (outlet) => outlet.id == outletId,
        orElse: () => _outlets.first,
      ),
      roleNames: {role},
      permissions: AppRole.seededPermissions[role] ?? const <String>{},
    );
  }

  /// Sesi contoh dengan izin yang disusun sendiri, untuk tes yang ingin
  /// menguji satu kode saja tanpa membawa seluruh peran.
  static AppSession sessionWith(Set<String> permissions) {
    assert(
      permissions.every(AppPermissions.all.contains),
      'Kode izin di luar kamus server',
    );

    return AppSession(
      user: _user,
      business: _business,
      outlets: _outlets,
      activeOutlet: _outlets.first,
      roleNames: const {},
      permissions: permissions,
    );
  }
}
