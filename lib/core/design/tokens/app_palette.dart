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
  ///
  /// Digelapkan pada UI-1. Nilai sebelumnya (`0xFF6B747E`) hanya mencapai
  /// 4,38:1 di atas [n50] — dan [n50] justru tempat teks tersier paling sering
  /// muncul: header tabel dan baris zebra. Nilai ini mencapai 4,71:1.
  static const n500 = Color(0xFF666F79);

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

  // ---------------------------------------------------------------------------
  // Ramp gelap.
  //
  // Bukan hasil membalik ramp terang. Tiga hal dikerjakan berbeda:
  //
  // 1. Selisih terang antar lapisan dibuat lebih rapat. Mata membedakan
  //    perbedaan kecerahan jauh lebih buruk di ujung gelap, jadi langkah
  //    sebesar ramp terang akan membuat lapisan atas terlihat abu-abu terang
  //    dan lapisan bawah hitam pekat.
  // 2. Saturasi warna semantik diturunkan. Merah dan hijau penuh di atas
  //    permukaan gelap tampak menyala dan melelahkan pada sesi delapan jam.
  // 3. Aksen dinaikkan kecerahannya, bukan diturunkan — biru gelap di atas
  //    permukaan gelap kehilangan seluruh perannya sebagai penanda aksi.
  //
  // Angka menaik selalu berarti lebih terang, sama seperti ramp `n` dibaca
  // dari n900 ke n0.
  // ---------------------------------------------------------------------------

  /// Kanvas workspace. Permukaan paling belakang dan paling gelap.
  static const d0 = Color(0xFF0F1318);

  /// Permukaan yang diredam: header tabel, sidebar, baris zebra.
  ///
  /// Lebih gelap dari [d100], bukan lebih terang. Peran "diredam" berarti
  /// mundur ke belakang di kedua tema.
  static const d50 = Color(0xFF141A21);

  /// Permukaan konten utama: panel, kartu, isi tabel.
  static const d100 = Color(0xFF1A2028);

  /// Baris dan kontrol saat disorot kursor.
  static const d150 = Color(0xFF212934);

  /// Permukaan yang melayang: dropdown, popover, dialog. Lebih terang dari
  /// [d100] — di tema gelap ketinggian dinyatakan dengan cahaya, bukan bayangan.
  static const d200 = Color(0xFF252E3A);

  /// Pemisah paling halus, di dalam satu panel.
  static const d300 = Color(0xFF2B3542);

  /// Garis default: batas panel, batas input, batas tabel.
  static const d400 = Color(0xFF38424F);

  /// Garis tegas: pembatas antar area besar, handle resize.
  static const d500 = Color(0xFF4B5665);

  /// Teks pada kontrol yang dinonaktifkan.
  static const d600 = Color(0xFF5F6A78);

  /// Teks tersier: metadata, timestamp, hint.
  static const d700 = Color(0xFF8B95A1);

  /// Teks sekunder: label, kolom pendukung.
  static const d800 = Color(0xFFB4BDC7);

  /// Teks utama pada permukaan gelap.
  ///
  /// Sengaja bukan putih murni: putih penuh di atas permukaan gelap
  /// menghasilkan halo yang membuat teks kecil terlihat bergetar.
  static const d900 = Color(0xFFE3E8EE);

  // Accent versi gelap. Perhatikan hover justru lebih *terang* dari nilai
  // dasarnya — di tema gelap, "lebih dekat ke pengguna" berarti lebih terang.

  static const accent50Dark = Color(0xFF1B2B45);
  static const accent500Dark = Color(0xFF3B82F6);
  static const accent600Dark = Color(0xFF5B99F8);
  static const accent700Dark = Color(0xFF2A6FD8);

  /// Teks di atas permukaan beraksen pada tema gelap.
  ///
  /// **Bukan putih.** Putih di atas [accent500Dark] hanya mencapai rasio 3,3:1
  /// dan gagal WCAG AA untuk teks berukuran normal; nilai gelap ini mencapai
  /// 5,2:1. Konsekuensinya label tombol primer di mode gelap berwarna gelap —
  /// itu memang keputusannya.
  static const onAccentDark = Color(0xFF0B0F14);

  // Semantik versi gelap: fg terang lembut, bg gelap ber-tint tipis, border
  // menengah supaya bentuk badge tetap terbaca tanpa mengandalkan rona saja.

  static const successFgDark = Color(0xFF6EDBA0);
  static const successBgDark = Color(0xFF10241A);
  static const successBorderDark = Color(0xFF275C40);

  static const dangerFgDark = Color(0xFFFF9B92);
  static const dangerBgDark = Color(0xFF2A1513);
  static const dangerBorderDark = Color(0xFF6B2E29);

  static const warningFgDark = Color(0xFFF0BE68);
  static const warningBgDark = Color(0xFF271B0B);
  static const warningBorderDark = Color(0xFF61451A);

  static const infoFgDark = Color(0xFF8FBEFF);
  static const infoBgDark = Color(0xFF12203A);
  static const infoBorderDark = Color(0xFF2E4B7A);

  // Aksen domain versi gelap — rona yang sama, kecerahan dinaikkan agar tetap
  // terbedakan sebagai seri chart di atas kanvas gelap.

  static const domainSalesDark = Color(0xFF5B99F8);
  static const domainInventoryDark = Color(0xFF9B7BE8);
  static const domainFinanceDark = Color(0xFF35B3BD);
  static const domainPurchaseDark = Color(0xFFD08A2E);
}
