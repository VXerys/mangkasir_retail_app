import 'package:flutter/painting.dart';

/// Skala sudut membulat.
///
/// Karakter industrial berarti sudut tegas. Radius besar (16–24) membuat
/// elemen terasa seperti kartu aplikasi konsumen dan, lebih praktis lagi,
/// memboroskan ruang di pojok — masalah nyata ketika panel-panel POS
/// diletakkan berdampingan rapat.
abstract final class AppRadius {
  /// Badge dan indikator kecil.
  static const double xs = 2;

  /// Tombol, input, dropdown, chip.
  static const double sm = 4;

  /// Panel, kartu, dan kontainer tabel.
  static const double md = 6;

  /// Dialog dan popover.
  static const double lg = 8;

  /// Elemen berbentuk pil: avatar, penghitung notifikasi.
  static const double pill = 999;

  static const rXs = BorderRadius.all(Radius.circular(xs));
  static const rSm = BorderRadius.all(Radius.circular(sm));
  static const rMd = BorderRadius.all(Radius.circular(md));
  static const rLg = BorderRadius.all(Radius.circular(lg));
  static const rPill = BorderRadius.all(Radius.circular(pill));
}
