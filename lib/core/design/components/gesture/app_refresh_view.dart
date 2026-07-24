import 'package:flutter/material.dart';

import '../../design.dart';

/// Tarik-untuk-muat-ulang, bertema token.
///
/// [RefreshIndicator] bawaan mewarnai dirinya dari `ColorScheme` dan memakai
/// lingkaran Material dengan bayangannya sendiri. Di sini warnanya diikat ke
/// `colors.accent` di atas `colors.surfaceRaised`, sehingga terlihat sama di
/// tema terang maupun gelap.
///
/// Catatan pemakaian pada aplikasi offline-first: gestur ini **bukan** cara
/// utama memuat data. Data datang dari Drift lewat stream dan selalu ada, juga
/// saat jaringan mati. Yang dilakukan tarik-untuk-muat-ulang di sini adalah
/// memicu sinkronisasi — jadi hubungkan ke `SyncBloc`, bukan ke kueri lokal.
class AppRefreshView extends StatelessWidget {
  final Widget child;

  /// Dipanggil saat pengguna menarik cukup jauh. Indikator berputar sampai
  /// future-nya selesai.
  final Future<void> Function() onRefresh;

  /// Menonaktifkan gestur, misalnya saat sinkronisasi sedang berjalan dari
  /// pemicu lain.
  final bool enabled;

  const AppRefreshView({
    super.key,
    required this.child,
    required this.onRefresh,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    final colors = context.colors;

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: colors.accent,
      backgroundColor: colors.surfaceRaised,
      // Setipis mungkin tanpa hilang. Lingkaran tebal ala Material menutupi
      // baris pertama tabel tepat saat pengguna ingin melihatnya.
      strokeWidth: 2.5,
      child: child,
    );
  }
}
