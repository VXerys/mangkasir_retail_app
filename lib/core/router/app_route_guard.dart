import '../constants/app_routes.dart';
import '../session/app_permissions.dart';
import '../session/app_session.dart';
import '../session/session_state.dart';
import 'app_nav_tree.dart';

/// Penjaga rute: memutuskan ke mana sebuah alamat harus dialihkan.
///
/// Ditulis sebagai fungsi murni atas `(SessionState, alamat)` alih-alih
/// langsung sebagai `redirect` GoRouter, supaya seluruh tabel keputusannya bisa
/// diuji tanpa membangun aplikasi. Penjaga adalah tempat kesalahan paling mahal
/// — yang salah di sini mengunci pengguna di luar aplikasinya sendiri.
abstract final class AppRouteGuard {
  /// Alamat tujuan, atau null bila permintaan boleh diteruskan apa adanya.
  static String? redirect(SessionState state, String location) {
    final path = location.split('?').first;

    // Sesi belum diketahui. Menahan pengguna di tempatnya, bukan melemparnya
    // ke layar masuk — kalau tidak, setiap start dingin berkedip lewat /login
    // sebelum menariknya kembali.
    if (state.isUnknown) return null;

    final session = state.sessionOrNull;

    if (session == null) {
      return path == AppRoutes.login ? null : AppRoutes.login;
    }

    // Sudah masuk: layar masuk dan alamat akar sama-sama bukan tujuan akhir.
    if (path == AppRoutes.login || path == AppRoutes.root) {
      return homeFor(session);
    }

    if (path == AppRoutes.forbidden) return null;

    final match = AppNavTree.match(path);

    // Alamat yang tidak dikenal diteruskan agar GoRouter menampilkan galat
    // rutenya sendiri. Menelannya di sini akan menyamarkan salah ketik jalur
    // sebagai persoalan hak akses.
    if (match == null) return null;

    return match.leaf.isVisibleTo(session) ? null : AppRoutes.forbidden;
  }

  /// Tujuan awal setelah masuk.
  ///
  /// Aturannya berdasarkan izin, bukan nama peran — peran buatan tenant belum
  /// ada hari ini tetapi akan ada, dan `if (role == 'Kasir')` akan buta
  /// terhadapnya.
  ///
  /// Yang membedakan: orang yang **membuat penjualan tetapi tidak membaca
  /// laporan** adalah orang yang berdiri di depan mesin kasir sepanjang hari.
  /// Memaksanya lewat dasbor menambah satu ketukan pada pekerjaan yang paling
  /// sering dilakukan di aplikasi ini.
  static String homeFor(AppSession session) {
    final isFrontOfHouse = session.can(AppPermissions.saleCreate) &&
        !session.can(AppPermissions.reportsRead);

    return isFrontOfHouse ? AppRoutes.salesPos : AppRoutes.dashboard;
  }
}
