import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_permissions.dart';
import 'app_role.dart';

part 'app_session.freezed.dart';

/// Pengguna yang sedang masuk.
///
/// Membawa **dua** pengenal, dan keduanya wajib. `users.id` (bigint) adalah
/// yang dirujuk seluruh foreign key — `user_roles.user_id`,
/// `user_has_outlet.user_id`, kolom `created_by`. `users.uuid` adalah yang
/// dicocokkan dengan `auth.uid()` oleh kebijakan RLS. Menyimpan salah satunya
/// saja berarti setengah dari kueri tidak bisa dibuat.
@freezed
class SessionUser with _$SessionUser {
  const factory SessionUser({
    required int id,
    required String uuid,
    required String username,
    required String email,
  }) = _SessionUser;
}

/// Tenant tempat pengguna bernaung.
@freezed
class SessionBusiness with _$SessionBusiness {
  const factory SessionBusiness({
    required int id,
    required String name,
  }) = _SessionBusiness;
}

/// Satu outlet yang boleh diakses pengguna.
@freezed
class SessionOutlet with _$SessionOutlet {
  const factory SessionOutlet({
    required int id,
    required String name,
  }) = _SessionOutlet;
}

/// Keadaan sesi yang aktif: siapa, di outlet mana, dan boleh apa.
///
/// [permissions] adalah himpunan izin **untuk [activeOutlet]**, bukan untuk
/// pengguna secara keseluruhan. `user_roles.outlet_id` boleh NULL (peran
/// se-bisnis) atau berisi satu outlet (peran terbatas), jadi orang yang sama
/// bisa menjadi Manager di outlet pusat dan Kasir di cabang. Berpindah outlet
/// karena itu **wajib** menghitung ulang himpunan ini — bukan sekadar menukar
/// label di pojok layar.
@freezed
class AppSession with _$AppSession {
  const AppSession._();

  const factory AppSession({
    required SessionUser user,
    required SessionBusiness business,
    required List<SessionOutlet> outlets,
    required SessionOutlet? activeOutlet,
    required Set<String> roleNames,
    required Set<String> permissions,
  }) = _AppSession;

  /// Pemilik bisnis melewati seluruh pemeriksaan izin.
  ///
  /// Bukan kelonggaran yang kita pilih: `public.has_permission` di database
  /// sudah mem-bypass Owner lebih dulu. Klien yang tidak ikut akan
  /// menyembunyikan menu yang server justru izinkan.
  bool get isOwner => roleNames.contains(AppRole.owner);

  /// Apakah pengguna boleh melakukan sesuatu yang menuntut [code].
  ///
  /// Sinonim kamus diperlakukan setara di kedua arah, sehingga rute yang minta
  /// `STOCK_READ` tetap terbuka bagi pemegang `INVENTORY_VIEW`.
  bool can(String code) {
    if (isOwner) return true;

    final wanted = AppPermissions.canonical(code);
    return permissions.any((held) => AppPermissions.canonical(held) == wanted);
  }

  /// Apakah **salah satu** dari [codes] dipegang.
  ///
  /// Inilah bentuk yang dipakai pohon navigasi: sebuah area terlihat kalau
  /// setidaknya satu tujuan di dalamnya bisa dibuka.
  bool canAny(Iterable<String> codes) =>
      codes.isEmpty || codes.any(can);

  /// Apakah **seluruh** [codes] dipegang. Untuk aksi yang menyentuh dua domain
  /// sekaligus, misalnya menerima barang yang juga menaikkan stok.
  bool canAll(Iterable<String> codes) => codes.every(can);
}
