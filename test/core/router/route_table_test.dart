import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangkasir_retail_app/core/constants/app_routes.dart';
import 'package:mangkasir_retail_app/core/router/app_nav_tree.dart';
import 'package:mangkasir_retail_app/core/session/app_permissions.dart';
import 'package:mangkasir_retail_app/core/session/app_role.dart';
import 'package:mangkasir_retail_app/core/session/dev_session_repository.dart';

/// Membaca seluruh konstanta jalur dari berkas sumbernya.
///
/// Dart tidak bisa merefleksikan anggota statis sebuah kelas, jadi tanpa ini
/// tes hanya bisa memeriksa rute yang sudah kita ingat untuk didaftarkan —
/// dan rute yang **lupa** didaftarkan, satu-satunya yang berbahaya, lolos.
Set<String> _routesInSource() {
  final source = File('lib/core/constants/app_routes.dart').readAsStringSync();
  final pattern = RegExp(r"static const \w+ = '(/[^']*)'");

  return pattern
      .allMatches(source)
      .map((match) => match.group(1)!)
      .toSet();
}

void main() {
  group('tabel rute', () {
    test('setiap jalur punya entri di pohon navigasi', () {
      final inTree = AppNavTree.allDestinations.map((d) => d.route).toSet();
      final expected = _routesInSource().difference(AppRoutes.outsideNavTree);

      final missing = expected.difference(inTree);

      expect(
        missing,
        isEmpty,
        reason: 'Rute berikut tidak punya entri di AppNavTree, sehingga tidak '
            'punya izin penjaga, tidak punya induk breadcrumb, dan tidak bisa '
            'dicapai dari menu mana pun:\n${missing.join("\n")}',
      );
    });

    test('pohon tidak menunjuk jalur yang tidak ada di AppRoutes', () {
      final declared = _routesInSource();
      final stray = AppNavTree.allDestinations
          .map((d) => d.route)
          .where((route) => !declared.contains(route))
          .toSet();

      expect(
        stray,
        isEmpty,
        reason: 'Jalur ditulis sebagai literal alih-alih konstanta: '
            '${stray.join(", ")}',
      );
    });

    test('tidak ada rute yang terdaftar dua kali', () {
      final routes = AppNavTree.allDestinations.map((d) => d.route).toList();
      expect(routes.length, routes.toSet().length);
    });

    test('setiap kode izin yang dirujuk ada di kamus server', () {
      final referenced = <String>{
        for (final area in AppNavTree.areas) ...area.permissions,
        for (final destination in AppNavTree.allDestinations)
          ...destination.permissions,
      };

      final unknown = referenced.difference(AppPermissions.all);

      expect(
        unknown,
        isEmpty,
        reason: 'Kode berikut tidak ada di tabel `permissions` Supabase, jadi '
            'tidak ada satu peran pun yang bisa memenuhinya — halamannya akan '
            'tersembunyi dari semua orang:\n${unknown.join("\n")}',
      );
    });

    test('halaman anak tidak pernah muncul sebagai butir menu', () {
      for (final area in AppNavTree.areas) {
        for (final destination in area.destinations) {
          for (final child in destination.children) {
            expect(
              child.showInMenu,
              isFalse,
              reason: '${child.route} adalah halaman detail; ia tidak berdiri '
                  'sendiri di sidebar',
            );
          }
        }
      }
    });

    test('jalur berparameter didaftarkan sesudah saudara statisnya', () {
      // `/inventory/products/new` juga cocok dengan pola
      // `/inventory/products/:id`. Kalau polanya lebih dulu, formulir produk
      // baru diperiksa memakai izin halaman detail.
      for (final area in AppNavTree.areas) {
        for (final destination in area.destinations) {
          final children = destination.children;
          final firstParam =
              children.indexWhere((child) => child.route.contains(':'));
          if (firstParam == -1) continue;

          final staticAfter = children
              .skip(firstParam)
              .where((child) => !child.route.contains(':'));

          expect(
            staticAfter,
            isEmpty,
            reason: 'Di bawah ${destination.route}, jalur statis harus '
                'didaftarkan sebelum jalur berparameter',
          );
        }
      }
    });
  });

  group('pencocokan alamat', () {
    test('jalur statis cocok dengan dirinya sendiri', () {
      final match = AppNavTree.match(AppRoutes.inventoryProducts);
      expect(match?.destination.route, AppRoutes.inventoryProducts);
      expect(match?.child, isNull);
    });

    test('jalur berparameter cocok dan menunjuk induknya', () {
      final match = AppNavTree.match('/inventory/products/42');

      expect(match?.child?.route, AppRoutes.inventoryProductDetail);
      expect(match?.destination.route, AppRoutes.inventoryProducts);
      expect(match?.area.label, 'Persediaan');
    });

    test('jalur statis menang atas pola yang juga cocok', () {
      // Inilah kesalahan yang paling mudah terjadi dan paling sulit dilihat.
      final match = AppNavTree.match(AppRoutes.inventoryProductNew);

      expect(match?.child?.route, AppRoutes.inventoryProductNew);
      expect(match?.child?.permissions, [AppPermissions.productCreate]);
    });

    test('query string dan garis miring di ujung diabaikan', () {
      expect(
        AppNavTree.match('/inventory/products?sort=name')?.destination.route,
        AppRoutes.inventoryProducts,
      );
      expect(
        AppNavTree.match('/inventory/products/')?.destination.route,
        AppRoutes.inventoryProducts,
      );
    });

    test('alamat asing tidak cocok dengan apa pun', () {
      expect(AppNavTree.match('/tidak/ada'), isNull);
      // Jumlah ruas yang berbeda tidak boleh diselamatkan pola berparameter.
      expect(AppNavTree.match('/inventory/products/42/harga'), isNull);
    });
  });

  group('area yang terlihat per peran', () {
    // Diturunkan dari `role_permissions` yang sebenarnya, dan sengaja ditulis
    // sebagai daftar penuh — bukan sekadar jumlah. Jumlah yang benar dengan
    // isi yang salah tetap salah.
    const expected = {
      AppRole.owner: [
        'Dasbor',
        'Penjualan',
        'Persediaan',
        'Pembelian',
        'CRM',
        'Keuangan',
        'Laporan',
        'Setelan',
      ],
      AppRole.administrator: [
        'Dasbor',
        'Penjualan',
        'Persediaan',
        'Pembelian',
        'CRM',
        'Keuangan',
        'Laporan',
        'Setelan',
      ],
      AppRole.manager: [
        'Dasbor',
        'Penjualan',
        'Persediaan',
        'Pembelian',
        'CRM',
        'Keuangan',
        'Laporan',
        'Setelan',
      ],
      AppRole.kasir: [
        'Dasbor',
        'Penjualan',
        'Persediaan',
        'CRM',
        'Keuangan',
      ],
      AppRole.purchasing: ['Dasbor', 'Persediaan', 'Pembelian', 'CRM'],
      AppRole.gudang: ['Dasbor', 'Persediaan', 'Pembelian'],
      AppRole.finance: [
        'Dasbor',
        'Penjualan',
        'Pembelian',
        'Keuangan',
        'Laporan',
      ],
    };

    for (final entry in expected.entries) {
      test('${entry.key} melihat ${entry.value.length} area', () {
        final session = DevSessionRepository.sampleSession(entry.key);
        final areas =
            AppNavTree.visibleAreas(session).map((a) => a.label).toList();

        expect(areas, entry.value);
      });
    }

    test('tanpa sesi tidak ada area sama sekali', () {
      // Layar yang sempat terlihat sebelum sesi siap adalah kebocoran.
      expect(
        AppNavTree.visibleAreas(null).map((a) => a.label),
        ['Dasbor'],
      );
    });

    test('Akun tidak pernah muncul sebagai area di navigasi utama', () {
      for (final role in AppRole.seeded) {
        final session = DevSessionRepository.sampleSession(role);
        expect(
          AppNavTree.visibleAreas(session).map((a) => a.label),
          isNot(contains('Akun')),
        );
      }
    });
  });

  group('tujuan yang terlihat di dalam area', () {
    test('Kasir melihat katalog tapi tidak melihat penyesuaian stok', () {
      final kasir = DevSessionRepository.sampleSession(AppRole.kasir);
      final persediaan =
          AppNavTree.areas.firstWhere((a) => a.label == 'Persediaan');
      final labels =
          persediaan.visibleDestinations(kasir).map((d) => d.label).toList();

      expect(labels, contains('Produk'));
      expect(labels, contains('Stok'));
      // PRODUCT_CREATE, STOCK_ADJUST, dan STOCK_TRANSFER tidak dipegangnya.
      expect(labels, isNot(contains('Penyesuaian')));
      expect(labels, isNot(contains('Transfer')));
    });

    test('Manager melihat Setelan tapi bukan Pengguna dan Peran', () {
      final manager = DevSessionRepository.sampleSession(AppRole.manager);
      final setelan = AppNavTree.areas.firstWhere((a) => a.label == 'Setelan');
      final labels =
          setelan.visibleDestinations(manager).map((d) => d.label).toList();

      expect(labels, contains('Bisnis'));
      expect(labels, isNot(contains('Pengguna')));
      expect(labels, isNot(contains('Peran')));
    });

    test('area membuka tujuan pertama yang boleh dibuka, bukan yang pertama',
        () {
      // Gudang tidak memegang SALE_CREATE, jadi menekan Persediaan tidak boleh
      // mendarat di halaman yang langsung menolaknya. Di sini yang diuji
      // Pembelian: tujuan pertamanya butuh PURCHASE_READ yang ia punya.
      final gudang = DevSessionRepository.sampleSession(AppRole.gudang);
      final pembelian =
          AppNavTree.areas.firstWhere((a) => a.label == 'Pembelian');

      expect(pembelian.defaultRouteFor(gudang), AppRoutes.purchaseOrders);

      // Finance tidak memegang SALE_CREATE, jadi Penjualan tidak boleh
      // mendarat di layar kasir.
      final finance = DevSessionRepository.sampleSession(AppRole.finance);
      final penjualan =
          AppNavTree.areas.firstWhere((a) => a.label == 'Penjualan');

      expect(penjualan.defaultRouteFor(finance), AppRoutes.salesTransactions);
    });
  });
}
