import 'package:flutter/painting.dart';

/// Ketinggian permukaan.
///
/// Aturan design system ini: **pemisahan dilakukan dengan garis, bukan
/// bayangan**. Panel, kartu, dan tabel semuanya berada di ketinggian nol dan
/// dibatasi `borderDefault`. Bayangan disediakan hanya untuk lapisan yang
/// memang melayang di atas konten dan bisa ditutup — dropdown, dialog, dan
/// pratinjau seret.
///
/// Alasannya bukan sekadar selera: layar POS penuh dengan permukaan
/// berdampingan. Kalau semuanya berbayang, tidak ada lagi yang menonjol, dan
/// bayangan bertumpuk membuat teks kecil sulit dibaca.
abstract final class AppShadows {
  /// Ketinggian nol. Pakai garis tepi untuk memisahkan permukaan.
  static const List<BoxShadow> none = <BoxShadow>[];

  /// Dropdown, tooltip, menu konteks, autocomplete.
  static const List<BoxShadow> popover = [
    BoxShadow(
      color: Color(0x14101828),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x0F101828),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  /// Dialog dan sheet modal.
  static const List<BoxShadow> dialog = [
    BoxShadow(
      color: Color(0x1F101828),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x0F101828),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];

  /// Elemen yang sedang diseret — misalnya baris yang diurutkan ulang.
  static const List<BoxShadow> drag = [
    BoxShadow(
      color: Color(0x29101828),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];
}
