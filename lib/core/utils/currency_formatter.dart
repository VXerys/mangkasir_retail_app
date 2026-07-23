import 'package:intl/intl.dart';

/// Format nilai uang dalam Rupiah.
///
/// Rupiah tidak memakai pecahan desimal dalam praktik ritel — tidak ada
/// pecahan di bawah satu rupiah yang beredar. Karena itu seluruh format di sini
/// membulatkan ke bilangan bulat, bukan menampilkan `,00` yang hanya memakan
/// lebar kolom tanpa memberi informasi.
///
/// Entitas domain menyimpan uang sebagai `double` (lihat `Product.price`,
/// `CartTotals.grandTotal`), jadi seluruh fungsi menerima `double`.
abstract final class CurrencyFormatter {
  static const _locale = 'id_ID';

  static final _withSymbol = NumberFormat.currency(
    locale: _locale,
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static final _plain = NumberFormat.decimalPattern(_locale)
    ..maximumFractionDigits = 0;

  /// `Rp 1.250.000` — untuk label harga, total, dan tombol bayar.
  static String format(double value) => _withSymbol.format(value);

  /// `1.250.000` — untuk kolom tabel, di mana simbol mata uang sudah
  /// disebutkan sekali di header dan mengulangnya di tiap baris justru
  /// mengaburkan angkanya.
  static String plain(double value) => _plain.format(value);

  /// `Rp 1,3 jt` — untuk kartu KPI yang ruangnya sempit.
  ///
  /// Sengaja ditulis manual, bukan memakai `NumberFormat.compactCurrency`,
  /// karena bentuk ringkas bawaan intl untuk locale id menghasilkan "1,3 jt"
  /// pada sebagian versi dan "1,3M" pada versi lain. Angka yang tampil di
  /// dasbor pemilik tidak boleh berubah bentuk hanya karena pembaruan paket.
  static String compact(double value) {
    final abs = value.abs();
    final sign = value < 0 ? '-' : '';

    if (abs >= 1000000000) {
      return '${sign}Rp ${_short(abs / 1000000000)} M';
    }
    if (abs >= 1000000) {
      return '${sign}Rp ${_short(abs / 1000000)} jt';
    }
    if (abs >= 1000) {
      return '${sign}Rp ${_short(abs / 1000)} rb';
    }
    return format(value);
  }

  /// Satu angka di belakang koma, tanpa `,0` yang tidak perlu.
  static String _short(double value) {
    final rounded = (value * 10).round() / 10;
    if (rounded == rounded.roundToDouble()) {
      return rounded.toStringAsFixed(0);
    }
    return rounded.toStringAsFixed(1).replaceAll('.', ',');
  }
}
