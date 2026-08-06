import 'package:dartz/dartz.dart';

import '../error/failures.dart';
import '../preferences/app_preferences.dart';
import 'app_permissions.dart';
import 'app_role.dart';
import 'app_session.dart';
import 'session_repository.dart';

/// Pembangun sesi palsu — **hanya untuk tes dan galeri**.
///
/// Kelas ini **tidak** terdaftar di GetIt produksi. `SupabaseSessionRepository`
/// menggantikannya sebagai implementasi `SessionRepository` di build sungguhan.
///
/// Yang masih boleh dipanggil dari luar:
/// - [sampleSession] — membangun sesi contoh dengan izin sesuai peran, dipakai
///   `FakeSessionRepository` di `test/support/app_harness.dart`.
/// - [sessionWith] — sesi dengan himpunan izin kustom, untuk tes izin tunggal.
/// - [sampleOutlets] — outlet contoh, dipakai galeri.
///
/// Method [signInAs] bersifat private bagi kelas ini; tidak ada jalur masuk
/// ke implementasi ini dari kode produksi.
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
  Future<Either<Failure, AppSession>> signIn(
    String email,
    String password,
  ) async {
    // Dalam mode dev, login dianggap selalu berhasil sebagai Owner.
    final role = AppRole.owner;
    await _preferences.setDevRole(role);
    return Right(_build(role, _preferences.activeOutletId ?? _outlets.first.id));
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async =>
      const Right(null);

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
