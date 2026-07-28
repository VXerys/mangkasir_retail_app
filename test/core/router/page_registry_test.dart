import 'package:flutter_test/flutter_test.dart';
import 'package:mangkasir_retail_app/core/constants/app_routes.dart';
import 'package:mangkasir_retail_app/core/router/app_nav_tree.dart';
import 'package:mangkasir_retail_app/core/router/app_page_registry.dart';

/// Registry halaman tidak boleh menyimpang dari pohon navigasi.
///
/// Satu-satunya cara desain ini bisa gagal adalah kunci yang basi: sebuah rute
/// diganti namanya di [AppRoutes], pohon ikut berubah, tetapi registry masih
/// memegang alamat lama. Akibatnya halaman diam-diam tidak pernah terpasang dan
/// penggunanya melihat penanda tempat tanpa satu pun galat. Tes ini menutup
/// celah itu.
void main() {
  /// Seluruh alamat yang benar-benar terdaftar di pohon.
  Set<String> allRoutes() {
    final routes = <String>{};
    for (final area in AppNavTree.areas) {
      for (final destination in area.destinations) {
        routes.add(destination.route);
        for (final child in destination.children) {
          routes.add(child.route);
        }
      }
    }
    return routes;
  }

  test('setiap alamat di registry punya entri di pohon navigasi', () {
    final tree = allRoutes();

    for (final route in AppPageRegistry.routes) {
      expect(
        tree.contains(route),
        isTrue,
        reason: 'Registry memegang "$route" yang tidak ada di AppNavTree. '
            'Halaman itu tidak akan pernah terpasang.',
      );
    }
  });

  test('rute tanpa halaman tetap dijawab null, bukan melempar', () {
    expect(AppPageRegistry.lookup(AppRoutes.reportsProfit), isNull);
  });

  test('halaman produk sudah terpasang', () {
    expect(AppPageRegistry.lookup(AppRoutes.inventoryProducts), isNotNull);
  });
}
