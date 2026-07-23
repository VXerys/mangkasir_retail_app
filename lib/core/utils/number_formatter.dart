import 'package:intl/intl.dart';

/// Format angka non-uang: kuantitas, persentase, dan cacah.
abstract final class NumberFormatter {
  static const _locale = 'id_ID';

  static final _integer = NumberFormat.decimalPattern(_locale)
    ..maximumFractionDigits = 0;

  static final _decimal = NumberFormat.decimalPattern(_locale)
    ..maximumFractionDigits = 3;

  /// `1.250` — cacah, stok, dan kuantitas bilangan bulat.
  static String count(num value) => _integer.format(value);

  /// Kuantitas yang boleh pecahan, misalnya 1,5 kg.
  ///
  /// Pecahan nol dihilangkan: `2` bukan `2,000`. Kolom stok yang penuh nol di
  /// belakang koma menyulitkan mata memindai angka yang sesungguhnya berbeda.
  static String quantity(double value) {
    if (value == value.roundToDouble()) return _integer.format(value);
    return _decimal.format(value);
  }

  /// `12,5%` — untuk diskon, margin, dan pajak.
  static String percent(double value, {int decimals = 1}) {
    final formatted = value.toStringAsFixed(decimals).replaceAll('.', ',');
    // Buang pecahan yang hanya berisi nol: 10,0% -> 10%.
    final cleaned = formatted.endsWith(',${'0' * decimals}')
        ? formatted.substring(0, formatted.length - decimals - 1)
        : formatted;
    return '$cleaned%';
  }
}
