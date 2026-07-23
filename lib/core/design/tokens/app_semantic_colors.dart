import 'package:flutter/material.dart';

/// Trio warna untuk satu peran semantik.
///
/// Setiap sinyal (sukses, bahaya, peringatan, informasi) selalu butuh tiga
/// nilai yang serasi: warna teks/ikon, warna isian, dan warna garis. Menyatukan
/// ketiganya dalam satu objek mencegah kombinasi yang tidak pernah divalidasi
/// kontrasnya — misalnya teks `dangerFg` di atas isian `warningBg`.
@immutable
class SemanticColor {
  /// Warna teks dan ikon. Dijamin kontras terhadap [bg].
  final Color fg;

  /// Warna isian latar untuk badge, banner, dan baris tersorot.
  final Color bg;

  /// Warna garis tepi. Wajib dipakai bersama [bg] agar elemen tetap terbaca
  /// oleh pengguna dengan gangguan persepsi warna — bentuk ikut memberi sinyal,
  /// bukan hanya rona.
  final Color border;

  const SemanticColor({
    required this.fg,
    required this.bg,
    required this.border,
  });

  static SemanticColor lerp(SemanticColor a, SemanticColor b, double t) {
    return SemanticColor(
      fg: Color.lerp(a.fg, b.fg, t)!,
      bg: Color.lerp(a.bg, b.bg, t)!,
      border: Color.lerp(a.border, b.border, t)!,
    );
  }
}

/// Peran warna aplikasi.
///
/// Disusun mengikuti [16_Design_System.md] yang menetapkan semantik lebih dulu
/// dan warna belakangan. Karena itu tidak ada field bernama `blue` atau
/// `primaryColor` di sini — yang ada adalah peran.
///
/// Diakses lewat `context.colors` (lihat `design.dart`).
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  // --- Permukaan ------------------------------------------------------------

  /// Latar paling belakang: area workspace tempat panel diletakkan.
  final Color canvas;

  /// Permukaan konten utama: panel, kartu, isi tabel.
  final Color surface;

  /// Permukaan yang diredam: header tabel, sidebar, baris zebra.
  final Color surfaceSubtle;

  /// Permukaan interaktif saat disorot kursor.
  final Color surfaceHover;

  /// Permukaan yang melayang di atas konten: dropdown, popover, dialog.
  final Color surfaceRaised;

  /// Tirai gelap di belakang modal.
  final Color overlay;

  // --- Garis ----------------------------------------------------------------

  /// Pemisah paling halus, di dalam satu panel.
  final Color borderSubtle;

  /// Garis tepi standar untuk panel, input, dan sel tabel.
  final Color borderDefault;

  /// Garis tepi bertekanan: pembatas antar area besar, handle resize.
  final Color borderStrong;

  /// Cincin fokus keyboard. Wajib terlihat jelas — POS ini dirancang untuk
  /// dioperasikan tanpa mouse.
  final Color borderFocus;

  // --- Teks -----------------------------------------------------------------

  /// Isi utama dan judul.
  final Color textPrimary;

  /// Label, kolom pendukung, keterangan.
  final Color textSecondary;

  /// Metadata: timestamp, jumlah baris, hint.
  final Color textTertiary;

  /// Teks pada kontrol yang dinonaktifkan.
  final Color textDisabled;

  /// Teks di atas permukaan [accent].
  final Color textOnAccent;

  // --- Interaktif -----------------------------------------------------------

  /// Warna aksi utama: tombol primer, tab aktif, baris terpilih.
  final Color accent;

  /// State kursor di atas elemen ber-[accent].
  final Color accentHover;

  /// State tertekan.
  final Color accentPressed;

  /// Isian lembut ber-[accent]: latar baris terpilih, chip filter aktif.
  final Color accentSubtle;

  // --- Sinyal semantik ------------------------------------------------------

  final SemanticColor success;
  final SemanticColor danger;
  final SemanticColor warning;
  final SemanticColor info;

  // --- Aksen domain ---------------------------------------------------------
  //
  // Hanya untuk identitas modul, seri chart, dan tint badge kategori.
  // Jangan dipakai sebagai warna aksi — itu selalu [accent].

  final Color domainSales;
  final Color domainInventory;
  final Color domainFinance;
  final Color domainPurchase;

  // --- Status khas POS ------------------------------------------------------
  //
  // Diangkat menjadi token tersendiri karena muncul di banyak layar (daftar
  // produk, panel keranjang, kartu stok, header sync). Kalau setiap layar
  // memilih warnanya sendiri, arti "merah" jadi tidak konsisten.

  /// Stok habis. Menghalangi penjualan.
  final SemanticColor stockOut;

  /// Stok menipis, di bawah titik pesan ulang.
  final SemanticColor stockLow;

  /// Stok aman.
  final SemanticColor stockOk;

  /// Ada data lokal yang belum terkirim ke server.
  final SemanticColor syncPending;

  /// Sync berhenti karena kegagalan. Butuh perhatian pengguna.
  final SemanticColor syncFailed;

  /// Perangkat sedang tanpa koneksi. Bersifat informatif, bukan kesalahan —
  /// aplikasi ini memang dirancang untuk tetap bekerja offline.
  final SemanticColor offline;

  const AppSemanticColors({
    required this.canvas,
    required this.surface,
    required this.surfaceSubtle,
    required this.surfaceHover,
    required this.surfaceRaised,
    required this.overlay,
    required this.borderSubtle,
    required this.borderDefault,
    required this.borderStrong,
    required this.borderFocus,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textDisabled,
    required this.textOnAccent,
    required this.accent,
    required this.accentHover,
    required this.accentPressed,
    required this.accentSubtle,
    required this.success,
    required this.danger,
    required this.warning,
    required this.info,
    required this.domainSales,
    required this.domainInventory,
    required this.domainFinance,
    required this.domainPurchase,
    required this.stockOut,
    required this.stockLow,
    required this.stockOk,
    required this.syncPending,
    required this.syncFailed,
    required this.offline,
  });

  @override
  AppSemanticColors copyWith({
    Color? canvas,
    Color? surface,
    Color? surfaceSubtle,
    Color? surfaceHover,
    Color? surfaceRaised,
    Color? overlay,
    Color? borderSubtle,
    Color? borderDefault,
    Color? borderStrong,
    Color? borderFocus,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textDisabled,
    Color? textOnAccent,
    Color? accent,
    Color? accentHover,
    Color? accentPressed,
    Color? accentSubtle,
    SemanticColor? success,
    SemanticColor? danger,
    SemanticColor? warning,
    SemanticColor? info,
    Color? domainSales,
    Color? domainInventory,
    Color? domainFinance,
    Color? domainPurchase,
    SemanticColor? stockOut,
    SemanticColor? stockLow,
    SemanticColor? stockOk,
    SemanticColor? syncPending,
    SemanticColor? syncFailed,
    SemanticColor? offline,
  }) {
    return AppSemanticColors(
      canvas: canvas ?? this.canvas,
      surface: surface ?? this.surface,
      surfaceSubtle: surfaceSubtle ?? this.surfaceSubtle,
      surfaceHover: surfaceHover ?? this.surfaceHover,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      overlay: overlay ?? this.overlay,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      borderDefault: borderDefault ?? this.borderDefault,
      borderStrong: borderStrong ?? this.borderStrong,
      borderFocus: borderFocus ?? this.borderFocus,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textDisabled: textDisabled ?? this.textDisabled,
      textOnAccent: textOnAccent ?? this.textOnAccent,
      accent: accent ?? this.accent,
      accentHover: accentHover ?? this.accentHover,
      accentPressed: accentPressed ?? this.accentPressed,
      accentSubtle: accentSubtle ?? this.accentSubtle,
      success: success ?? this.success,
      danger: danger ?? this.danger,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      domainSales: domainSales ?? this.domainSales,
      domainInventory: domainInventory ?? this.domainInventory,
      domainFinance: domainFinance ?? this.domainFinance,
      domainPurchase: domainPurchase ?? this.domainPurchase,
      stockOut: stockOut ?? this.stockOut,
      stockLow: stockLow ?? this.stockLow,
      stockOk: stockOk ?? this.stockOk,
      syncPending: syncPending ?? this.syncPending,
      syncFailed: syncFailed ?? this.syncFailed,
      offline: offline ?? this.offline,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceSubtle: Color.lerp(surfaceSubtle, other.surfaceSubtle, t)!,
      surfaceHover: Color.lerp(surfaceHover, other.surfaceHover, t)!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      borderDefault: Color.lerp(borderDefault, other.borderDefault, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      borderFocus: Color.lerp(borderFocus, other.borderFocus, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      textOnAccent: Color.lerp(textOnAccent, other.textOnAccent, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentHover: Color.lerp(accentHover, other.accentHover, t)!,
      accentPressed: Color.lerp(accentPressed, other.accentPressed, t)!,
      accentSubtle: Color.lerp(accentSubtle, other.accentSubtle, t)!,
      success: SemanticColor.lerp(success, other.success, t),
      danger: SemanticColor.lerp(danger, other.danger, t),
      warning: SemanticColor.lerp(warning, other.warning, t),
      info: SemanticColor.lerp(info, other.info, t),
      domainSales: Color.lerp(domainSales, other.domainSales, t)!,
      domainInventory: Color.lerp(domainInventory, other.domainInventory, t)!,
      domainFinance: Color.lerp(domainFinance, other.domainFinance, t)!,
      domainPurchase: Color.lerp(domainPurchase, other.domainPurchase, t)!,
      stockOut: SemanticColor.lerp(stockOut, other.stockOut, t),
      stockLow: SemanticColor.lerp(stockLow, other.stockLow, t),
      stockOk: SemanticColor.lerp(stockOk, other.stockOk, t),
      syncPending: SemanticColor.lerp(syncPending, other.syncPending, t),
      syncFailed: SemanticColor.lerp(syncFailed, other.syncFailed, t),
      offline: SemanticColor.lerp(offline, other.offline, t),
    );
  }
}
