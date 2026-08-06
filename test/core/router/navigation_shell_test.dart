import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangkasir_retail_app/core/design/design.dart';
import 'package:mangkasir_retail_app/core/error/failures.dart';
import 'package:mangkasir_retail_app/core/router/app_root.dart';
import 'package:mangkasir_retail_app/core/session/app_role.dart';
import 'package:mangkasir_retail_app/core/session/app_session.dart';
import 'package:mangkasir_retail_app/core/session/dev_session_repository.dart';
import 'package:mangkasir_retail_app/core/session/session_cubit.dart';
import 'package:mangkasir_retail_app/core/session/session_repository.dart';
import 'package:mangkasir_retail_app/core/session/session_state.dart';
import 'package:mangkasir_retail_app/core/di/injection.dart';
import 'package:mangkasir_retail_app/features/products/domain/usecases/add_product_usecase.dart';
import 'package:mangkasir_retail_app/features/products/domain/usecases/update_product_usecase.dart';
import 'package:mangkasir_retail_app/features/products/domain/usecases/watch_products_usecase.dart';
import 'package:mangkasir_retail_app/features/products/presentation/bloc/product/product_bloc.dart';

import '../../support/app_harness.dart';
import '../../support/fake_product_repository.dart';

const _phone = Size(390, 844);
const _tabletPortrait = Size(834, 1194);
const _tabletLandscape = Size(1280, 800);

/// Sumber sesi yang seluruhnya ditentukan tes.
///
/// Tidak memakai [DevSessionRepository] karena ia menulis ke Hive; yang diuji
/// di sini adalah shell, bukan penyimpanan.
class _FakeSessionRepository implements SessionRepository {
  AppSession? session;

  _FakeSessionRepository(this.session);

  @override
  Future<Either<Failure, AppSession>> restore() async => session == null
      ? const Left(AuthFailure('kosong'))
      : Right(session!);

  @override
  Future<Either<Failure, AppSession>> selectOutlet(int outletId) async {
    final current = session;
    if (current == null) return const Left(AuthFailure('kosong'));

    session = current.copyWith(
      activeOutlet:
          current.outlets.firstWhere((outlet) => outlet.id == outletId),
    );
    return Right(session!);
  }

  @override
  Future<Either<Failure, AppSession>> signIn(
    String email,
    String password,
  ) async =>
      session == null
          ? const Left(AuthFailure('kosong'))
          : Right(session!);

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async =>
      const Right(null);

  @override
  Future<void> signOut() async => session = null;
}

Future<SessionCubit> _pumpAs(
  WidgetTester tester,
  String? role, {
  Size surface = _tabletLandscape,
}) async {
  tester.view.physicalSize = surface;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  addTearDown(getIt.reset);

  // Shell ini menavigasi lewat menu sungguhan, jadi begitu sebuah tujuan
  // berhenti menjadi penanda tempat, halaman aslinya ikut dibangun — dan
  // halaman meminta bloc-nya ke `getIt`. Ganda ini yang membuat tes navigasi
  // tetap menguji navigasi, bukan ketersediaan DI.
  final products = FakeProductRepository();
  addTearDown(products.dispose);
  registerFake<ProductBloc>(
    () => ProductBloc(
      WatchProductsUseCase(products),
      AddProductUseCase(products),
      UpdateProductUseCase(products),
    ),
  );

  final cubit = SessionCubit(
    _FakeSessionRepository(
      role == null ? null : DevSessionRepository.sampleSession(role),
    ),
  );
  addTearDown(cubit.close);

  await tester.pumpWidget(AppRoot(session: cubit, themeMode: ThemeMode.light));
  await cubit.restore();
  await tester.pumpAndSettle();

  return cubit;
}

void main() {
  group('mendarat di tempat yang benar', () {
    testWidgets('Kasir mendarat di layar kasir, bukan dasbor', (tester) async {
      await _pumpAs(tester, AppRole.kasir);
      expect(find.text('Kasir'), findsWidgets);
      expect(find.text('Belum dibangun'), findsOneWidget);
    });

    testWidgets('Owner mendarat di dasbor', (tester) async {
      await _pumpAs(tester, AppRole.owner);
      expect(find.text('Ringkasan'), findsWidgets);
    });

    testWidgets('tanpa sesi mendarat di layar masuk', (tester) async {
      await _pumpAs(tester, null);
      expect(find.text('Masuk ke MangRitel'), findsOneWidget);
      expect(find.byType(AppShell), findsNothing);
    });
  });

  group('sidebar dikelompokkan per area dan disaring izin', () {
    testWidgets('Owner melihat delapan judul area', (tester) async {
      await _pumpAs(tester, AppRole.owner);

      final sidebar = tester.widget<AppSidebar>(find.byType(AppSidebar));

      expect(
        sidebar.sections.map((section) => section.label),
        [
          'Dasbor',
          'Penjualan',
          'Persediaan',
          'Pembelian',
          'CRM',
          'Keuangan',
          'Laporan',
          'Setelan',
        ],
      );

      // Yang di atas lipatan benar-benar tergambar; sisanya butuh gulir, dan
      // itu memang perilaku yang benar untuk daftar sepanjang ini.
      expect(find.text('DASBOR'), findsOneWidget);
      expect(find.text('PENJUALAN'), findsOneWidget);
    });

    testWidgets('Gudang kehilangan area yang tidak berhak', (tester) async {
      await _pumpAs(tester, AppRole.gudang);

      final sidebar = tester.widget<AppSidebar>(find.byType(AppSidebar));
      final labels = sidebar.sections.map((section) => section.label);

      expect(labels, ['Dasbor', 'Persediaan', 'Pembelian']);
      // Tidak memegang SALE_*, CASH_VIEW, REPORTS_READ, SETTING_MANAGE.
      expect(find.text('PENJUALAN'), findsNothing);
      expect(find.text('KEUANGAN'), findsNothing);
    });

    testWidgets('butir di dalam area ikut disaring, bukan hanya areanya',
        (tester) async {
      await _pumpAs(tester, AppRole.kasir);

      // Kasir memegang PRODUCT_READ dan INVENTORY_VIEW.
      expect(find.text('Produk'), findsWidgets);
      expect(find.text('Stok'), findsWidgets);
      // Tapi bukan STOCK_ADJUST maupun STOCK_TRANSFER.
      expect(find.text('Penyesuaian'), findsNothing);
      expect(find.text('Transfer'), findsNothing);
    });
  });

  group('bilah bawah di ponsel', () {
    testWidgets('menampilkan empat area ditambah pintu ke laci',
        (tester) async {
      await _pumpAs(tester, AppRole.owner, surface: _phone);

      expect(find.byType(AppBottomNav), findsOneWidget);
      expect(find.byType(AppSidebar), findsNothing);

      final nav = tester.widget<AppBottomNav>(find.byType(AppBottomNav));
      // Empat, bukan lima: slot kelima selalu milik "Lainnya".
      expect(nav.items, hasLength(4));
      expect(nav.overflowItem?.label, 'Lainnya');
    });

    testWidgets('peran dengan sedikit area tetap punya pintu ke laci',
        (tester) async {
      // Laci bukan hanya tempat area yang meluap: ganti outlet, akun, dan
      // keluar hanya ada di sana.
      await _pumpAs(tester, AppRole.gudang, surface: _phone);

      final nav = tester.widget<AppBottomNav>(find.byType(AppBottomNav));
      expect(nav.items, hasLength(3));
      expect(nav.overflowItem?.label, 'Menu');
    });

    testWidgets('laci memuat seluruh area, termasuk yang tidak muat',
        (tester) async {
      await _pumpAs(tester, AppRole.owner, surface: _phone);

      await tester.tap(find.text('Lainnya'));
      await tester.pumpAndSettle();

      // Empat area terakhir yang tidak muat di bilah bawah.
      expect(find.text('Keuangan'), findsWidgets);
      expect(find.text('Laporan'), findsWidgets);
      expect(find.text('Setelan'), findsWidgets);
      expect(find.text('Keluar'), findsOneWidget);
    });
  });

  group('tablet potret tidak kehilangan tujuan di balik rail', () {
    testWidgets('rail hanya memuat ikon area, tapi laci memuat semuanya',
        (tester) async {
      await _pumpAs(tester, AppRole.owner, surface: _tabletPortrait);

      // Rail: satu ikon per area, tanpa label dan tanpa sub-tujuan.
      expect(find.text('PERSEDIAAN'), findsNothing);
      expect(find.text('Kategori'), findsNothing);

      await tester.tap(find.byIcon(AppIcons.menu));
      await tester.pumpAndSettle();

      // Laci: pohon penuh. Tanpa ini, tablet potret benar-benar terputus dari
      // sebagian besar halaman aplikasi — bukan sekadar menyembunyikannya.
      expect(find.text('PERSEDIAAN'), findsOneWidget);
      expect(find.text('Kategori'), findsOneWidget);
    });
  });

  group('jalan keluar tersedia di setiap ukuran layar', () {
    for (final (nama, ukuran) in [
      ('ponsel', _phone),
      ('tablet potret', _tabletPortrait),
      ('tablet lanskap', _tabletLandscape),
    ]) {
      testWidgets('$nama punya tombol keluar', (tester) async {
        await _pumpAs(tester, AppRole.owner, surface: ukuran);

        if (ukuran != _tabletLandscape) {
          // Di ponsel ada dua pemicu laci: tombol menu di bilah atas dan
          // "Lainnya" di bilah bawah. Yang pertama milik bilah atas.
          await tester.tap(find.byIcon(AppIcons.menu).first);
          await tester.pumpAndSettle();
        }

        expect(find.byIcon(AppIcons.logout), findsWidgets);
      });
    }

    testWidgets('keluar meminta penegasan lebih dulu', (tester) async {
      final cubit = await _pumpAs(tester, AppRole.owner);

      await tester.tap(find.byIcon(AppIcons.logout).first);
      await tester.pumpAndSettle();

      expect(find.text('Keluar dari MangRitel?'), findsOneWidget);

      // Membatalkan tidak boleh mengakhiri sesi.
      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();

      expect(cubit.state.isActive, isTrue);
    });
  });

  group('bilah global', () {
    testWidgets('menampilkan outlet aktif dan nama bisnis', (tester) async {
      await _pumpAs(tester, AppRole.owner);

      expect(find.text('Outlet Pusat'), findsWidgets);
      expect(find.text('Toko MangRitel'), findsOneWidget);
    });

    testWidgets('ganti outlet memperbarui seluruh shell', (tester) async {
      await _pumpAs(tester, AppRole.owner);

      // Ikon outlet hanya muncul di penanda outlet pada bilah global; judul
      // sidebar menampilkan namanya sebagai teks tanpa ikon dan tidak bisa
      // ditekan.
      await tester.tap(find.byIcon(AppIcons.outlet));
      await tester.pumpAndSettle();

      expect(find.text('Ganti outlet'), findsOneWidget);

      await tester.tap(find.text('Cabang Antang').last);
      await tester.pumpAndSettle();

      expect(find.text('Cabang Antang'), findsWidgets);
      expect(find.text('Outlet Pusat'), findsNothing);
    });
  });

  group('breadcrumb mengikuti tabel rute', () {
    testWidgets('halaman level 2 memperlihatkan area dan tujuannya',
        (tester) async {
      await _pumpAs(tester, AppRole.owner);

      await tester.tap(find.text('Produk').first);
      await tester.pumpAndSettle();

      final breadcrumb = tester.widget<AppBreadcrumb>(
        find.byType(AppBreadcrumb),
      );

      expect(
        breadcrumb.items.map((item) => item.label),
        ['Persediaan', 'Produk'],
      );
    });
  });

  group('penjaga bekerja lewat navigasi sungguhan', () {
    testWidgets('keluar mengembalikan pengguna ke layar masuk',
        (tester) async {
      final cubit = await _pumpAs(tester, AppRole.owner);

      await cubit.signOut();
      await tester.pumpAndSettle();

      expect(find.text('Masuk ke MangRitel'), findsOneWidget);
    });
  });
}
