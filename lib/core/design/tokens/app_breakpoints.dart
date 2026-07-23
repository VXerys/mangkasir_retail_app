import 'package:flutter/widgets.dart';

/// Kelas ukuran jendela yang dipakai seluruh aplikasi.
///
/// Diberi nama berdasarkan *ruang yang tersedia*, bukan nama perangkat.
/// Sebuah tablet dalam mode terbagi dua bisa saja berada di [compact], dan
/// jendela desktop yang dikecilkan berada di [medium] — memakai nama perangkat
/// akan membuat kode berbohong.
enum WindowSize {
  /// < 600 — ponsel, atau jendela desktop yang sangat sempit.
  compact,

  /// 600–1023 — tablet potret.
  medium,

  /// 1024–1439 — tablet lanskap, laptop kecil.
  expanded,

  /// >= 1440 — desktop. Semua panel muat sekaligus.
  large;

  bool operator >=(WindowSize other) => index >= other.index;
  bool operator >(WindowSize other) => index > other.index;
  bool operator <=(WindowSize other) => index <= other.index;
  bool operator <(WindowSize other) => index < other.index;
}

/// Ambang batas lebar layar.
///
/// Angka mengikuti Material 3 window size class, dengan tambahan [large] di
/// 1440 karena layout POS baru muat penuh (sidebar berlabel + workspace +
/// inspector + bottom panel) di lebar tersebut.
abstract final class AppBreakpoints {
  static const double medium = 600;
  static const double expanded = 1024;
  static const double large = 1440;

  static WindowSize fromWidth(double width) {
    if (width >= large) return WindowSize.large;
    if (width >= expanded) return WindowSize.expanded;
    if (width >= medium) return WindowSize.medium;
    return WindowSize.compact;
  }
}

extension WindowSizeContext on BuildContext {
  /// Kelas ukuran jendela saat ini.
  ///
  /// Memakai `MediaQuery.sizeOf` sehingga widget hanya dibangun ulang saat
  /// ukuran benar-benar berubah, bukan setiap kali ada perubahan MediaQuery
  /// lain seperti munculnya papan ketik.
  WindowSize get windowSize =>
      AppBreakpoints.fromWidth(MediaQuery.sizeOf(this).width);

  /// `true` bila ruang yang tersedia minimal sebesar [size].
  bool isAtLeast(WindowSize size) => windowSize >= size;
}
