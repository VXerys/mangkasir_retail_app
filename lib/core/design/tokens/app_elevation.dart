import 'package:flutter/material.dart';

import 'app_shadows.dart';

/// Peran ketinggian permukaan.
///
/// Dibuat sebagai [ThemeExtension] dengan alasan yang sama seperti
/// `AppSemanticColors`: bayangan tidak bisa sama di kedua tema. Nilai yang
/// pas di atas kanvas terang praktis tidak terlihat di atas kanvas gelap, dan
/// selama nilainya berupa `const` statis, tidak ada cara memperbaikinya tanpa
/// menyentuh setiap pemanggil.
///
/// Diakses lewat `context.elevation` (lihat `design.dart`).
@immutable
class AppElevation extends ThemeExtension<AppElevation> {
  /// Ketinggian nol. Ini yang dipakai panel, kartu, dan tabel — pemisahnya
  /// garis, bukan bayangan.
  final List<BoxShadow> flat;

  /// Dropdown, tooltip, menu konteks, autocomplete.
  final List<BoxShadow> popover;

  /// Dialog dan sheet modal.
  final List<BoxShadow> dialog;

  /// Elemen yang sedang diseret — misalnya baris yang diurutkan ulang.
  final List<BoxShadow> drag;

  const AppElevation({
    required this.flat,
    required this.popover,
    required this.dialog,
    required this.drag,
  });

  const AppElevation.light()
      : flat = AppShadows.none,
        popover = AppShadows.popoverLight,
        dialog = AppShadows.dialogLight,
        drag = AppShadows.dragLight;

  const AppElevation.dark()
      : flat = AppShadows.none,
        popover = AppShadows.popoverDark,
        dialog = AppShadows.dialogDark,
        drag = AppShadows.dragDark;

  @override
  AppElevation copyWith({
    List<BoxShadow>? flat,
    List<BoxShadow>? popover,
    List<BoxShadow>? dialog,
    List<BoxShadow>? drag,
  }) {
    return AppElevation(
      flat: flat ?? this.flat,
      popover: popover ?? this.popover,
      dialog: dialog ?? this.dialog,
      drag: drag ?? this.drag,
    );
  }

  /// Bertukar di tengah jalan, bukan menginterpolasi.
  ///
  /// Set terang dan gelap punya jumlah lapisan yang sama tetapi warna dan
  /// sebaran yang berbeda jauh; menginterpolasinya menghasilkan bayangan
  /// kelabu keruh di tengah transisi. Transisi tema sendiri berlangsung di
  /// bawah plafon gerak 220 ms, jadi pertukaran mendadak ini tidak terlihat.
  @override
  AppElevation lerp(ThemeExtension<AppElevation>? other, double t) {
    if (other is! AppElevation) return this;
    return t < 0.5 ? this : other;
  }
}
