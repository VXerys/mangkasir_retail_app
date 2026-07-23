import 'package:flutter/painting.dart';

/// Nilai bayangan mentah — lapisan paling bawah, sejajar dengan `AppPalette`.
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
///
/// Berkas ini **hanya** boleh diimpor oleh `AppElevation`. Feature membaca
/// bayangan lewat `context.elevation`, sama seperti warna lewat `context.colors`.
abstract final class AppShadows {
  /// Ketinggian nol. Pakai garis tepi untuk memisahkan permukaan.
  static const List<BoxShadow> none = <BoxShadow>[];

  // --- Tema terang ----------------------------------------------------------
  //
  // Bertinta biru tua mengikuti netral yang dingin, dengan alpha rendah:
  // di atas permukaan terang, bayangan lembut sudah cukup memisahkan lapisan.

  static const List<BoxShadow> popoverLight = [
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

  static const List<BoxShadow> dialogLight = [
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

  static const List<BoxShadow> dragLight = [
    BoxShadow(
      color: Color(0x29101828),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  // --- Tema gelap -----------------------------------------------------------
  //
  // Hitam murni dengan alpha jauh lebih tinggi. Bayangan bertinta biru yang
  // dipakai tema terang praktis lenyap di atas kanvas `d0` — permukaan
  // melayang jadi kehilangan pemisahnya. Sebarannya juga dilebarkan sedikit,
  // karena di tema gelap sebagian besar pekerjaan memisahkan lapisan justru
  // dilakukan oleh permukaan yang lebih terang, bukan oleh bayangannya.

  static const List<BoxShadow> popoverDark = [
    BoxShadow(
      color: Color(0x66000000),
      blurRadius: 12,
      offset: Offset(0, 3),
    ),
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> dialogDark = [
    BoxShadow(
      color: Color(0x80000000),
      blurRadius: 32,
      offset: Offset(0, 10),
    ),
    BoxShadow(
      color: Color(0x4D000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> dragDark = [
    BoxShadow(
      color: Color(0x8C000000),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];
}
