import 'package:flutter_test/flutter_test.dart';
import 'package:mangkasir_retail_app/core/constants/app_routes.dart';
import 'package:mangkasir_retail_app/core/router/app_route_guard.dart';
import 'package:mangkasir_retail_app/core/session/app_permissions.dart';
import 'package:mangkasir_retail_app/core/session/app_role.dart';
import 'package:mangkasir_retail_app/core/session/dev_session_repository.dart';
import 'package:mangkasir_retail_app/core/session/session_state.dart';

SessionState _as(String role) =>
    SessionState.active(DevSessionRepository.sampleSession(role));

void main() {
  group('sesi belum diketahui', () {
    test('menahan pengguna di tempatnya, tidak melemparnya ke layar masuk', () {
      // Kalau `unknown` disamakan dengan `signedOut`, setiap start dingin
      // berkedip lewat /login sebelum menarik pengguna kembali. Pada aplikasi
      // yang dibuka puluhan kali sehari, kedipan itu terbaca sebagai kerusakan.
      const state = SessionState.unknown();

      expect(AppRouteGuard.redirect(state, AppRoutes.root), isNull);
      expect(AppRouteGuard.redirect(state, AppRoutes.salesPos), isNull);
      expect(AppRouteGuard.redirect(state, AppRoutes.settingsUsers), isNull);
    });
  });

  group('belum masuk', () {
    const state = SessionState.signedOut();

    test('seluruh alamat dialihkan ke layar masuk', () {
      expect(AppRouteGuard.redirect(state, AppRoutes.root), AppRoutes.login);
      expect(
        AppRouteGuard.redirect(state, AppRoutes.dashboard),
        AppRoutes.login,
      );
      expect(
        AppRouteGuard.redirect(state, '/inventory/products/42'),
        AppRoutes.login,
      );
    });

    test('layar masuk sendiri tidak dialihkan ke mana-mana', () {
      expect(AppRouteGuard.redirect(state, AppRoutes.login), isNull);
    });

    test('galeri tetap terbuka tanpa sesi', () {
      // Galeri hanya ada pada build debug, tidak menyentuh data, dan justru
      // harus bisa dibuka tanpa sesi apa pun.
      expect(AppRouteGuard.redirect(state, AppRoutes.designGallery), isNull);
    });
  });

  group('sudah masuk', () {
    test('layar masuk dialihkan ke tujuan awal', () {
      expect(
        AppRouteGuard.redirect(_as(AppRole.owner), AppRoutes.login),
        AppRoutes.dashboard,
      );
      expect(
        AppRouteGuard.redirect(_as(AppRole.kasir), AppRoutes.login),
        AppRoutes.salesPos,
      );
    });

    test('alamat akar memilih tujuan menurut izin, bukan nama peran', () {
      // Yang membedakan: membuat penjualan tetapi tidak membaca laporan =
      // orang yang berdiri di depan mesin kasir sepanjang hari.
      expect(
        AppRouteGuard.redirect(_as(AppRole.kasir), AppRoutes.root),
        AppRoutes.salesPos,
      );

      for (final role in [
        AppRole.owner,
        AppRole.administrator,
        AppRole.manager,
        AppRole.purchasing,
        AppRole.gudang,
        AppRole.finance,
      ]) {
        expect(
          AppRouteGuard.redirect(_as(role), AppRoutes.root),
          AppRoutes.dashboard,
          reason: '$role bukan kasir depan',
        );
      }
    });

    test('aturan tujuan awal tidak menyebut nama peran sama sekali', () {
      // Peran buatan tenant belum ada hari ini tetapi akan ada. Sesi tanpa nama
      // peran apa pun, hanya memegang SALE_CREATE, harus tetap mendarat di POS.
      final tanpaNama = DevSessionRepository.sessionWith({
        AppPermissions.saleCreate,
        AppPermissions.saleView,
      });

      expect(AppRouteGuard.homeFor(tanpaNama), AppRoutes.salesPos);
    });

    test('rute yang berhak diteruskan apa adanya', () {
      expect(
        AppRouteGuard.redirect(_as(AppRole.kasir), AppRoutes.salesPos),
        isNull,
      );
      expect(
        AppRouteGuard.redirect(_as(AppRole.gudang), AppRoutes.inventoryStocks),
        isNull,
      );
    });

    test('rute tanpa izin dialihkan ke 403', () {
      expect(
        AppRouteGuard.redirect(_as(AppRole.kasir), AppRoutes.settingsUsers),
        AppRoutes.forbidden,
      );
      expect(
        AppRouteGuard.redirect(_as(AppRole.gudang), AppRoutes.salesPos),
        AppRoutes.forbidden,
      );
      expect(
        AppRouteGuard.redirect(_as(AppRole.finance), AppRoutes.inventoryStocks),
        AppRoutes.forbidden,
      );
    });

    test('tautan dalam ke halaman detail ikut dijaga', () {
      // Tautan dalam adalah cara paling mudah melewati menu. Kalau penjaga
      // hanya memeriksa halaman daftar, notifikasi dan tautan struk membuka
      // pintu yang menu-nya sudah tutup.
      expect(
        AppRouteGuard.redirect(_as(AppRole.gudang), '/sales/transactions/9'),
        AppRoutes.forbidden,
      );
      expect(
        AppRouteGuard.redirect(_as(AppRole.kasir), '/inventory/products/42'),
        isNull,
      );
    });

    test('formulir produk baru dijaga izin membuat, bukan izin membaca', () {
      // Kasir memegang PRODUCT_READ tetapi tidak PRODUCT_CREATE. Kalau
      // `/inventory/products/new` tertelan pola `/inventory/products/:id`,
      // pemeriksaan ini lolos dan kasir bisa membuka formulir produk baru.
      expect(
        AppRouteGuard.redirect(
          _as(AppRole.kasir),
          AppRoutes.inventoryProductNew,
        ),
        AppRoutes.forbidden,
      );
      expect(
        AppRouteGuard.redirect(
          _as(AppRole.manager),
          AppRoutes.inventoryProductNew,
        ),
        isNull,
      );
    });

    test('Owner boleh ke mana saja', () {
      final owner = _as(AppRole.owner);
      for (final route in [
        AppRoutes.settingsUsers,
        AppRoutes.settingsRoles,
        AppRoutes.salesPos,
        AppRoutes.inventoryOpname,
        AppRoutes.reportsProfit,
      ]) {
        expect(AppRouteGuard.redirect(owner, route), isNull, reason: route);
      }
    });

    test('halaman 403 sendiri tidak dialihkan — kalau tidak ia berputar', () {
      expect(
        AppRouteGuard.redirect(_as(AppRole.kasir), AppRoutes.forbidden),
        isNull,
      );
    });

    test('alamat asing diteruskan agar GoRouter yang melaporkannya', () {
      // Menelannya di sini akan menyamarkan salah ketik jalur sebagai
      // persoalan hak akses — dan menyembunyikan bug selama berbulan-bulan.
      expect(AppRouteGuard.redirect(_as(AppRole.owner), '/tidak/ada'), isNull);
    });

    test('query string tidak mengelabui penjaga', () {
      expect(
        AppRouteGuard.redirect(
          _as(AppRole.kasir),
          '${AppRoutes.settingsUsers}?tab=aktif',
        ),
        AppRoutes.forbidden,
      );
    });
  });
}
