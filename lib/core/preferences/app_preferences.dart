import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

/// Preferensi perangkat: pilihan pengguna yang melekat pada satu mesin kasir,
/// bukan pada akun.
///
/// Berbeda dari `CartStorage` yang membuka kotaknya secara malas, kotak ini
/// dibuka sekali di `main()` lewat [open] sebelum `runApp`. Alasannya: tema
/// harus diketahui pada frame pertama. Membacanya secara asinkron berarti
/// aplikasi selalu berkedip terang dulu sebelum berpindah ke gelap — persis
/// hal yang paling mengganggu pada perangkat yang dipakai di ruangan gelap.
@lazySingleton
class AppPreferences {
  static const _boxName = 'settings_box';

  static const _themeModeKey = 'theme_mode';

  static const _activeOutletKey = 'active_outlet_id';

  static const _devRoleKey = 'dev_role';

  /// Membuka kotak preferensi. Wajib dipanggil (dan ditunggu) di `main()`
  /// sebelum `configureDependencies()`.
  static Future<void> open() => Hive.openBox(_boxName);

  Box get _box => Hive.box(_boxName);

  /// Mode tema pilihan pengguna.
  ///
  /// Bawaannya [ThemeMode.system]: perangkat yang dipakai bergantian pagi dan
  /// malam langsung ikut sistem tanpa ada yang perlu menyetelnya.
  ThemeMode get themeMode {
    final raw = _box.get(_themeModeKey) as String?;
    return switch (raw) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) {
    // Disimpan sebagai nama, bukan indeks enum. Indeks berubah diam-diam kalau
    // urutan enum Flutter bergeser, dan pengguna akan menemukan temanya
    // berpindah sendiri setelah pembaruan.
    return _box.put(_themeModeKey, mode.name);
  }

  /// Outlet yang terakhir dipilih di mesin ini.
  ///
  /// Melekat pada perangkat, bukan pada akun — dan memang seharusnya begitu:
  /// mesin kasir di cabang selalu melayani cabang itu, siapa pun yang sedang
  /// berjaga. Menyimpannya di sisi server justru membuat kasir pengganti
  /// membuka aplikasi di outlet yang salah.
  int? get activeOutletId => _box.get(_activeOutletKey) as int?;

  Future<void> setActiveOutletId(int? id) => id == null
      ? _box.delete(_activeOutletKey)
      : _box.put(_activeOutletKey, id);

  /// Peran yang sedang disamar selama autentikasi sungguhan belum ada.
  ///
  /// Hanya dibaca `DevSessionRepository`. Ikut hilang bersama berkas itu ketika
  /// login asli terpasang.
  String? get devRole => _box.get(_devRoleKey) as String?;

  Future<void> setDevRole(String role) => _box.put(_devRoleKey, role);
}
