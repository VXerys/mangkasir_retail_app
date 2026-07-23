import 'package:flutter/widgets.dart';

import 'app_breakpoints.dart';

/// Tingkat kerapatan tampilan.
///
/// [16_Design_System.md] menolak skala spasi 4/8/16/32 dan memintanya diganti
/// dengan Compact/Normal/Comfortable, karena POS memerlukan kerapatan berbeda
/// tergantung perangkat: kasir desktop ingin melihat 40 baris sekaligus,
/// sedangkan kasir yang memakai ponsel butuh area sentuh yang lega.
enum DensityLevel {
  /// Desktop. Sebanyak mungkin data terlihat sekaligus.
  compact,

  /// Tablet. Keseimbangan antara jumlah data dan kenyamanan sentuh.
  normal,

  /// Ponsel. Sentuhan didahulukan.
  comfortable,
}

/// Nilai spasi dan metrik kontrol untuk satu tingkat kerapatan.
///
/// Spasi dan tinggi kontrol disatukan dalam satu objek karena keduanya harus
/// berubah bersama-sama. Padding yang mengecil tanpa tinggi baris yang ikut
/// mengecil hanya menghasilkan tabel yang renggang di tempat yang salah.
@immutable
class AppDensity {
  final DensityLevel level;

  /// Spasi terkecil: jarak antara ikon dan labelnya.
  final double xs;

  /// Jarak antar elemen yang berkerabat dekat.
  final double sm;

  /// Padding standar di dalam kontrol dan sel.
  final double md;

  /// Jarak antar kelompok elemen di dalam satu panel.
  final double lg;

  /// Jarak antar panel, dan padding tepi halaman.
  final double xl;

  /// Tinggi satu baris tabel.
  final double rowHeight;

  /// Tinggi tombol, input, dan dropdown. Seluruh kontrol pada satu baris
  /// memakai nilai ini agar garis dasarnya sejajar.
  final double controlHeight;

  /// Area sentuh minimum.
  ///
  /// Sengaja **tidak** ikut mengecil bersama [controlHeight]. Prinsip
  /// "Large Touch Area" pada 16.1 menetapkan minimum 44px, dan kerapatan
  /// hanya boleh mengecilkan tampilan visual — bukan area yang bisa ditekan.
  /// Selisih antara keduanya diisi padding transparan, sehingga tombol setinggi
  /// 32px pada mode compact tetap dapat ditekan dengan andal.
  final double minTouchTarget;

  /// Lebar sidebar saat menampilkan label.
  final double sidebarExtendedWidth;

  /// Lebar sidebar saat hanya menampilkan ikon.
  final double sidebarRailWidth;

  /// Lebar panel inspector di sisi kanan.
  final double inspectorWidth;

  const AppDensity({
    required this.level,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.rowHeight,
    required this.controlHeight,
    required this.minTouchTarget,
    required this.sidebarExtendedWidth,
    required this.sidebarRailWidth,
    required this.inspectorWidth,
  });

  static const compact = AppDensity(
    level: DensityLevel.compact,
    xs: 2,
    sm: 4,
    md: 8,
    lg: 12,
    xl: 16,
    rowHeight: 32,
    controlHeight: 32,
    minTouchTarget: 44,
    sidebarExtendedWidth: 216,
    sidebarRailWidth: 56,
    inspectorWidth: 320,
  );

  static const normal = AppDensity(
    level: DensityLevel.normal,
    xs: 4,
    sm: 8,
    md: 12,
    lg: 16,
    xl: 24,
    rowHeight: 40,
    controlHeight: 40,
    minTouchTarget: 44,
    sidebarExtendedWidth: 232,
    sidebarRailWidth: 64,
    inspectorWidth: 340,
  );

  static const comfortable = AppDensity(
    level: DensityLevel.comfortable,
    xs: 4,
    sm: 12,
    md: 16,
    lg: 24,
    xl: 32,
    rowHeight: 48,
    controlHeight: 48,
    minTouchTarget: 48,
    sidebarExtendedWidth: 264,
    sidebarRailWidth: 72,
    inspectorWidth: 360,
  );

  /// Kerapatan yang sesuai untuk sebuah ukuran jendela.
  ///
  /// Semakin sempit layar, semakin lega tampilannya. Terlihat berlawanan dengan
  /// intuisi, tapi memang begitu: layar sempit hampir selalu berarti perangkat
  /// sentuh, dan menjejalkan baris setinggi 32px ke ponsel membuat aplikasi
  /// tidak bisa dipakai.
  static AppDensity forWindow(WindowSize size) => switch (size) {
        WindowSize.compact => comfortable,
        WindowSize.medium => normal,
        WindowSize.expanded => normal,
        WindowSize.large => compact,
      };

  /// Padding vertikal tambahan agar sebuah kontrol setinggi [controlHeight]
  /// tetap memenuhi [minTouchTarget].
  double get touchPadding =>
      ((minTouchTarget - controlHeight) / 2).clamp(0, double.infinity);
}

/// Menyediakan [AppDensity] untuk sebuah subtree.
///
/// Dipasang sekali oleh `AppShell` berdasarkan ukuran jendela, lalu boleh
/// dipasang ulang di area tertentu yang butuh kerapatan berbeda — misalnya
/// panel keranjang yang tetap [AppDensity.normal] walau daftar produk di
/// sebelahnya memakai [AppDensity.compact].
class DensityScope extends InheritedWidget {
  final AppDensity density;

  const DensityScope({
    super.key,
    required this.density,
    required super.child,
  });

  /// Kerapatan yang berlaku pada [context].
  ///
  /// Bila belum ada [DensityScope] di atasnya, nilainya dihitung dari lebar
  /// jendela. Artinya widget mana pun tetap mendapat kerapatan yang benar
  /// tanpa perlu pemasangan manual — termasuk widget di dalam dialog dan
  /// bottom sheet, yang berada di rute terpisah dan karenanya kerap luput dari
  /// scope milik halaman.
  static AppDensity of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<DensityScope>();
    return scope?.density ?? AppDensity.forWindow(context.windowSize);
  }

  @override
  bool updateShouldNotify(DensityScope oldWidget) =>
      density.level != oldWidget.density.level;
}
