import 'package:flutter/painting.dart';

/// Ramp warna mentah — lapisan paling bawah design system.
///
/// File ini **hanya** boleh diimpor oleh `theme/light_scheme.dart` dan
/// `theme/dark_scheme.dart`. Feature tidak pernah menyentuh `AppPalette`
/// secara langsung; feature memakai peran semantik lewat `context.colors`.
///
/// Alasannya: nama seperti `n700` tidak memberi tahu apa pun tentang maksud
/// pemakaian, dan begitu dipakai di feature, mengganti tema berarti mengubah
/// puluhan file. Peran semantik (`textPrimary`, `danger.fg`) tetap stabil
/// walau nilainya berubah.
///
/// Karakter yang dipilih: **industrial / professional / dense**.
/// Neutral condong dingin (sedikit biru) supaya permukaan terasa seperti
/// perkakas kerja, bukan aplikasi konsumen. Aksen dan warna semantik ditahan
/// saturasinya agar tidak melelahkan mata pada sesi kerja delapan jam.
abstract final class AppPalette {
  // ---------------------------------------------------------------------------
  // Neutral — tulang punggung. Dipakai untuk permukaan, garis, dan teks.
  // ---------------------------------------------------------------------------

  /// Putih murni. Permukaan kartu/panel yang benar-benar di depan.
  static const n0 = Color(0xFFFFFFFF);

  /// Kanvas workspace. Sedikit lebih gelap dari putih agar panel di atasnya
  /// terbaca sebagai lapisan terpisah tanpa perlu bayangan.
  static const n25 = Color(0xFFFAFBFC);

  /// Isian halus: header tabel, baris zebra, latar sidebar.
  static const n50 = Color(0xFFF4F6F8);

  /// Isian yang sedikit lebih tegas: baris hover, chip nonaktif.
  static const n75 = Color(0xFFEDF0F3);

  /// Garis pemisah paling halus (divider di dalam panel).
  static const n100 = Color(0xFFE8ECF0);

  /// Garis default: batas panel, batas input, batas tabel.
  static const n200 = Color(0xFFD5DBE1);

  /// Garis tegas: batas elemen fokus sekunder, handle resize.
  static const n300 = Color(0xFFB4BDC6);

  /// Ikon dan placeholder yang diredam.
  static const n400 = Color(0xFF8A939D);

  /// Teks tersier: metadata, timestamp, hint.
  static const n500 = Color(0xFF6B747E);

  /// Teks sekunder: label, kolom pendukung.
  static const n600 = Color(0xFF4E565F);

  /// Teks utama pada permukaan terang.
  static const n700 = Color(0xFF343B43);

  /// Judul dan angka penting. Juga latar sidebar versi gelap.
  static const n800 = Color(0xFF22282E);

  /// Nyaris hitam. Latar overlay dan permukaan tergelap.
  static const n900 = Color(0xFF14181C);

  // ---------------------------------------------------------------------------
  // Accent — satu-satunya warna untuk state interaktif (fokus, seleksi, aksi
  // utama). Sengaja biru tenang, bukan biru cerah, agar tidak bersaing dengan
  // sinyal danger/warning yang harus lebih menonjol.
  // ---------------------------------------------------------------------------

  static const accent50 = Color(0xFFEAF2FD);
  static const accent100 = Color(0xFFCFE0FA);
  static const accent200 = Color(0xFFA6C6F5);
  static const accent500 = Color(0xFF1F6FEB);
  static const accent600 = Color(0xFF1A5DC7);
  static const accent700 = Color(0xFF144A9E);

  // ---------------------------------------------------------------------------
  // Semantik — masing-masing tiga langkah: fg (teks/ikon), bg (isian),
  // border (garis). Tiga langkah ini membuat badge dan banner bisa dirakit
  // tanpa `withOpacity` ad-hoc, yang selalu berakhir tidak konsisten.
  // ---------------------------------------------------------------------------

  static const successFg = Color(0xFF12693D);
  static const successBg = Color(0xFFE7F5EE);
  static const successBorder = Color(0xFFA9DCC1);

  static const dangerFg = Color(0xFFB02A24);
  static const dangerBg = Color(0xFFFDECEA);
  static const dangerBorder = Color(0xFFF3B6B1);

  static const warningFg = Color(0xFF8A5200);
  static const warningBg = Color(0xFFFFF4E0);
  static const warningBorder = Color(0xFFF0CE94);

  static const infoFg = Color(0xFF144A9E);
  static const infoBg = Color(0xFFEAF2FD);
  static const infoBorder = Color(0xFFA6C6F5);

  // ---------------------------------------------------------------------------
  // Domain — aksen per modul bisnis (lihat 16_Design_System.md bagian Color).
  //
  // Dipakai untuk: strip aksen sidebar, seri chart, tint badge kategori.
  // TIDAK dipakai untuk: tombol, fokus, atau state interaktif apa pun —
  // itu selalu milik `accent`. Kalau warna domain ikut jadi warna aksi,
  // kasir kehilangan satu-satunya isyarat "ini bisa diklik".
  // ---------------------------------------------------------------------------

  /// Penjualan / POS / transaksi.
  static const domainSales = Color(0xFF1F6FEB);

  /// Persediaan / gudang / stok.
  static const domainInventory = Color(0xFF6D45C4);

  /// Keuangan / kas / pembayaran.
  static const domainFinance = Color(0xFF0E7C86);

  /// Pembelian / purchase order / penerimaan.
  static const domainPurchase = Color(0xFFA85D00);
}
