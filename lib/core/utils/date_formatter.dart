import 'package:intl/intl.dart';

/// Format tanggal dan waktu dalam bahasa Indonesia.
///
/// Memerlukan `initializeDateFormatting('id_ID')` yang dipanggil sekali di
/// `main.dart` sebelum `runApp`. Tanpa itu, intl melempar galat locale saat
/// nama hari atau bulan pertama kali dirender.
abstract final class DateFormatter {
  static const _locale = 'id_ID';

  static final _dayMonthYear = DateFormat('d MMM yyyy', _locale);
  static final _dayMonthYearLong = DateFormat('d MMMM yyyy', _locale);
  static final _time = DateFormat('HH:mm', _locale);
  static final _timeWithSeconds = DateFormat('HH:mm:ss', _locale);
  static final _dateTime = DateFormat('d MMM yyyy, HH:mm', _locale);
  static final _receipt = DateFormat('dd/MM/yyyy HH:mm', _locale);
  static final _weekday = DateFormat('EEEE, d MMMM yyyy', _locale);

  /// `23 Jul 2026` — kolom tabel dan label ringkas.
  static String date(DateTime value) => _dayMonthYear.format(value);

  /// `23 Juli 2026` — judul halaman dan header laporan.
  static String dateLong(DateTime value) => _dayMonthYearLong.format(value);

  /// `Kamis, 23 Juli 2026` — header dasbor.
  static String dateWithWeekday(DateTime value) => _weekday.format(value);

  /// `14:30`
  static String time(DateTime value) => _time.format(value);

  /// `14:30:07` — jejak audit, tempat urutan detik menentukan.
  static String timePrecise(DateTime value) => _timeWithSeconds.format(value);

  /// `23 Jul 2026, 14:30`
  static String dateTime(DateTime value) => _dateTime.format(value);

  /// `23/07/2026 14:30` — dicetak pada struk.
  ///
  /// Sengaja numerik seluruhnya: printer termal memakai lebar karakter tetap,
  /// dan nama bulan membuat panjang barisnya berubah-ubah.
  static String receipt(DateTime value) => _receipt.format(value);

  /// `baru saja`, `5 menit lalu`, `2 jam lalu`, lalu jatuh ke tanggal penuh.
  ///
  /// Dipakai untuk indikator "terakhir disinkronkan". Setelah lewat sehari,
  /// waktu relatif kehilangan gunanya — "3 hari lalu" tidak membantu kasir
  /// memutuskan apa pun, sedangkan tanggal pastinya membantu.
  static String relative(DateTime value, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final diff = reference.difference(value);

    if (diff.isNegative) return dateTime(value);
    if (diff.inSeconds < 60) return 'baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    return dateTime(value);
  }
}
