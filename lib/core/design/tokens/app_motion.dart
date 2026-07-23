import 'package:flutter/widgets.dart';

/// Durasi dan kurva animasi.
///
/// [16_Design_System.md] menetapkan 100–150 ms dan secara eksplisit menolak
/// fade/scale/bounce 400 ms. Kasir mengulang gerakan yang sama ratusan kali
/// sehari; animasi yang terasa "halus" pada demo berubah menjadi penundaan yang
/// menjengkelkan pada pemakaian ke-tiga ratus.
abstract final class AppMotion {
  /// Tanpa animasi. Untuk perubahan yang harus terasa sebagai respons langsung,
  /// misalnya penambahan barang ke keranjang lewat pemindai barcode.
  static const Duration instant = Duration.zero;

  /// Perubahan warna: hover, tekan, centang.
  static const Duration fast = Duration(milliseconds: 100);

  /// Perubahan tata letak: buka panel, ganti tab, perluas baris.
  static const Duration normal = Duration(milliseconds: 150);

  /// Transisi antar halaman. **Plafon keras** — tidak ada animasi di aplikasi
  /// ini yang boleh lebih lama dari ini.
  static const Duration deliberate = Duration(milliseconds: 220);

  /// Kurva standar. Cepat di awal lalu melambat, sehingga gerakan terasa sudah
  /// selesai sebelum benar-benar berhenti.
  static const Curve standard = Curves.easeOutCubic;

  /// Untuk elemen yang masuk dari luar layar.
  static const Curve emphasized = Curves.easeOutQuart;

  /// Menyesuaikan durasi dengan preferensi aksesibilitas perangkat.
  ///
  /// Bila pengguna mematikan animasi di tingkat sistem, hasilnya
  /// [Duration.zero]. Selalu bungkus durasi dengan ini alih-alih memakai
  /// konstanta secara langsung — pengguna dengan sensitivitas gerak sering
  /// justru mereka yang menatap layar kerja sepanjang hari.
  static Duration resolve(BuildContext context, Duration duration) {
    return MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;
  }
}
