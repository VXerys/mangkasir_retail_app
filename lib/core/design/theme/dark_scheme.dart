import 'light_scheme.dart';

/// Kerangka tema gelap.
///
/// Sengaja belum diisi. Yang dibangun lebih dulu adalah *strukturnya*: karena
/// setiap widget membaca warna lewat `context.colors` dan tidak pernah menulis
/// `Colors.white`, mengaktifkan mode gelap nanti cukup mengganti isi berkas ini
/// — tanpa menyentuh satu pun widget.
///
/// Saat mengisi nanti, tiga hal yang paling sering salah pada tema gelap POS:
///
/// 1. **Jangan membalik ramp begitu saja.** Permukaan gelap butuh selisih
///    terang yang lebih rapat antar lapisan, kalau tidak semuanya terlihat
///    hitam pekat.
/// 2. **Turunkan saturasi warna semantik.** Merah dan hijau penuh di atas
///    permukaan gelap tampak menyala dan melelahkan mata.
/// 3. **Permukaan yang lebih tinggi harus lebih terang, bukan lebih gelap.**
///    Kebalikan dari tema terang.
///
/// Sampai diisi, `AppTheme.dark` memakai skema terang sehingga aplikasi tetap
/// bisa dijalankan dan tidak ada layar yang tiba-tiba tak terbaca.
abstract final class DarkScheme {
  // TODO(design): isi nilai tema gelap. Lihat catatan di atas.
  static const colors = LightScheme.colors;

  static final typography = LightScheme.typography;
}
