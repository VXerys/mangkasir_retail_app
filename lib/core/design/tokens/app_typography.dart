import 'package:flutter/material.dart';

/// Nama family font, harus sama persis dengan deklarasi di `pubspec.yaml`.
abstract final class AppFontFamily {
  /// Seluruh teks UI.
  static const ui = 'Inter';

  /// Angka, harga, KPI, dan struk. Lebar karakter tetap.
  static const numeric = 'JetBrainsMono';
}

/// Fitur OpenType yang membuat setiap digit punya lebar sama.
///
/// Tanpa ini, kolom harga di tabel POS bergeser setiap kali angka berubah —
/// `1.111` dan `9.999` merender dengan lebar berbeda. Di aplikasi yang isinya
/// kolom angka, itu langsung terasa salah. Semua style numerik di bawah wajib
/// memakainya.
const _tabular = <FontFeature>[FontFeature.tabularFigures()];

/// Gaya teks aplikasi, disusun berdasarkan **peran**, bukan tingkat judul.
///
/// [16_Design_System.md] menolak skala H1/H2/Body karena POS tidak punya
/// hierarki dokumen — yang ada adalah konteks pemakaian: toolbar, tabel,
/// formulir, KPI, dialog, dan struk. Satu peran bisa saja berukuran sama
/// dengan peran lain; yang penting nama di kode menjelaskan *di mana* dipakai,
/// sehingga penyesuaian nanti bisa dilakukan per konteks.
///
/// Diakses lewat `context.text` (lihat `design.dart`).
@immutable
class AppTypography extends ThemeExtension<AppTypography> {
  // --- Toolbar & navigasi ---------------------------------------------------

  /// Judul di bilah atas workspace.
  final TextStyle toolbarTitle;

  /// Label tombol dan item pada toolbar/sidebar.
  final TextStyle toolbarLabel;

  // --- Tabel (peran paling padat, dipakai di hampir semua layar) ------------

  /// Header kolom. Ukuran kecil dengan spasi huruf dilebarkan agar tetap
  /// terbaca sebagai label, bukan data.
  final TextStyle tableHeader;

  /// Sel teks biasa.
  final TextStyle tableCell;

  /// Sel angka — harga, qty, subtotal. Monospace + tabular.
  final TextStyle tableCellNumeric;

  /// Sel yang perlu ditonjolkan, misalnya nama produk pada baris.
  final TextStyle tableCellEmphasis;

  // --- Formulir -------------------------------------------------------------

  final TextStyle formLabel;
  final TextStyle formInput;

  /// Teks bantuan dan pesan galat di bawah input.
  final TextStyle formHelper;

  // --- Dashboard KPI --------------------------------------------------------

  /// Angka besar pada kartu ringkasan. Monospace supaya deretan kartu KPI
  /// punya tinggi optis yang sama.
  final TextStyle kpiValue;

  final TextStyle kpiLabel;

  /// Selisih terhadap periode sebelumnya (+12%, -3%).
  final TextStyle kpiDelta;

  // --- Dialog ---------------------------------------------------------------

  final TextStyle dialogTitle;
  final TextStyle dialogBody;

  // --- Struk ----------------------------------------------------------------
  //
  // Seluruhnya monospace karena pratinjau di layar harus setara dengan hasil
  // cetak printer termal yang memang berbasis karakter berlebar tetap.

  final TextStyle receiptHeader;
  final TextStyle receiptLine;
  final TextStyle receiptTotal;

  // --- Lain-lain ------------------------------------------------------------

  final TextStyle badge;
  final TextStyle buttonLabel;

  /// Harga pada kartu produk dan baris keranjang.
  final TextStyle priceRegular;

  /// Total yang harus dibayar — elemen terpenting di layar pembayaran.
  final TextStyle priceLarge;

  const AppTypography({
    required this.toolbarTitle,
    required this.toolbarLabel,
    required this.tableHeader,
    required this.tableCell,
    required this.tableCellNumeric,
    required this.tableCellEmphasis,
    required this.formLabel,
    required this.formInput,
    required this.formHelper,
    required this.kpiValue,
    required this.kpiLabel,
    required this.kpiDelta,
    required this.dialogTitle,
    required this.dialogBody,
    required this.receiptHeader,
    required this.receiptLine,
    required this.receiptTotal,
    required this.badge,
    required this.buttonLabel,
    required this.priceRegular,
    required this.priceLarge,
  });

  /// Merakit seluruh peran dari dua family font.
  ///
  /// [defaultColor] dipakai sebagai warna dasar semua gaya; pemanggil tinggal
  /// `copyWith(color: ...)` untuk teks sekunder atau bernuansa semantik.
  /// Skema terang dan gelap memanggil pabrik yang sama dengan warna berbeda,
  /// jadi metrik huruf dijamin identik di kedua tema.
  factory AppTypography.standard({required Color defaultColor}) {
    const ui = AppFontFamily.ui;
    const mono = AppFontFamily.numeric;

    TextStyle text(double size, double height, FontWeight weight,
            {double? spacing}) =>
        TextStyle(
          fontFamily: ui,
          fontSize: size,
          height: height / size,
          fontWeight: weight,
          letterSpacing: spacing,
          color: defaultColor,
        );

    TextStyle number(double size, double height, FontWeight weight) =>
        TextStyle(
          fontFamily: mono,
          fontSize: size,
          height: height / size,
          fontWeight: weight,
          fontFeatures: _tabular,
          color: defaultColor,
        );

    return AppTypography(
      toolbarTitle: text(15, 20, FontWeight.w600, spacing: -0.1),
      toolbarLabel: text(13, 16, FontWeight.w500),
      // Spasi huruf +0,3 menahan huruf kecil ukuran 12 agar tidak menggumpal.
      tableHeader: text(12, 16, FontWeight.w600, spacing: 0.3),
      tableCell: text(13, 18, FontWeight.w400),
      tableCellNumeric: number(13, 18, FontWeight.w400),
      tableCellEmphasis: text(13, 18, FontWeight.w600),
      formLabel: text(12, 16, FontWeight.w500),
      formInput: text(14, 20, FontWeight.w400),
      formHelper: text(11, 14, FontWeight.w400),
      kpiValue: number(28, 32, FontWeight.w700),
      kpiLabel: text(12, 16, FontWeight.w500),
      kpiDelta: text(12, 16, FontWeight.w600),
      dialogTitle: text(17, 24, FontWeight.w600),
      dialogBody: text(14, 20, FontWeight.w400),
      receiptHeader: number(13, 18, FontWeight.w700),
      receiptLine: number(11, 16, FontWeight.w400),
      receiptTotal: number(14, 20, FontWeight.w700),
      badge: text(11, 14, FontWeight.w600),
      buttonLabel: text(14, 18, FontWeight.w600),
      priceRegular: number(14, 20, FontWeight.w700),
      priceLarge: number(24, 30, FontWeight.w700),
    );
  }

  /// Menghasilkan salinan dengan warna dasar berbeda.
  ///
  /// Sengaja tidak menyediakan override per gaya: nilai ukuran dan bobot adalah
  /// keputusan design system, dan membiarkannya ditimpa satu per satu adalah
  /// jalan tercepat menuju tipografi yang tidak konsisten.
  @override
  AppTypography copyWith({Color? color}) {
    if (color == null) return this;
    return AppTypography.standard(defaultColor: color);
  }

  @override
  AppTypography lerp(ThemeExtension<AppTypography>? other, double t) {
    if (other is! AppTypography) return this;
    return AppTypography(
      toolbarTitle: TextStyle.lerp(toolbarTitle, other.toolbarTitle, t)!,
      toolbarLabel: TextStyle.lerp(toolbarLabel, other.toolbarLabel, t)!,
      tableHeader: TextStyle.lerp(tableHeader, other.tableHeader, t)!,
      tableCell: TextStyle.lerp(tableCell, other.tableCell, t)!,
      tableCellNumeric:
          TextStyle.lerp(tableCellNumeric, other.tableCellNumeric, t)!,
      tableCellEmphasis:
          TextStyle.lerp(tableCellEmphasis, other.tableCellEmphasis, t)!,
      formLabel: TextStyle.lerp(formLabel, other.formLabel, t)!,
      formInput: TextStyle.lerp(formInput, other.formInput, t)!,
      formHelper: TextStyle.lerp(formHelper, other.formHelper, t)!,
      kpiValue: TextStyle.lerp(kpiValue, other.kpiValue, t)!,
      kpiLabel: TextStyle.lerp(kpiLabel, other.kpiLabel, t)!,
      kpiDelta: TextStyle.lerp(kpiDelta, other.kpiDelta, t)!,
      dialogTitle: TextStyle.lerp(dialogTitle, other.dialogTitle, t)!,
      dialogBody: TextStyle.lerp(dialogBody, other.dialogBody, t)!,
      receiptHeader: TextStyle.lerp(receiptHeader, other.receiptHeader, t)!,
      receiptLine: TextStyle.lerp(receiptLine, other.receiptLine, t)!,
      receiptTotal: TextStyle.lerp(receiptTotal, other.receiptTotal, t)!,
      badge: TextStyle.lerp(badge, other.badge, t)!,
      buttonLabel: TextStyle.lerp(buttonLabel, other.buttonLabel, t)!,
      priceRegular: TextStyle.lerp(priceRegular, other.priceRegular, t)!,
      priceLarge: TextStyle.lerp(priceLarge, other.priceLarge, t)!,
    );
  }
}
