/// Alamat rute aplikasi.
///
/// Disimpan sebagai konstanta, bukan ditulis sebagai literal di tempat
/// pemanggilan, supaya salah ketik ketahuan saat kompilasi dan bukan saat
/// kasir menekan tombol.
///
/// Jalur mengikuti [15_Screen_Spesification.md].
abstract final class AppRoutes {
  /// Kasir. Menjadi halaman awal karena inilah layar yang paling sering
  /// dibuka — pemilik toko boleh mampir ke dasbor, kasir tidak.
  static const pos = '/pos';

  static const dashboard = '/dashboard';
  static const products = '/products';
  static const transactions = '/transactions';

  /// Galeri design system. Hanya terdaftar pada build debug.
  static const designGallery = '/dev/design';
}
