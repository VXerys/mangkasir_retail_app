import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangkasir_retail_app/core/design/design.dart';

/// Merender sebuah tombol yang membuka overlay, di dalam tema aplikasi.
///
/// Overlay hidup di atas rute, bukan di dalam widget yang memanggilnya, jadi
/// setiap tes di berkas ini butuh `MaterialApp` sungguhan — bukan `pumpWidget`
/// dengan widget lepas.
Future<BuildContext> _pumpHost(WidgetTester tester, {Size? surface}) async {
  if (surface != null) {
    tester.view.physicalSize = surface;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  late BuildContext captured;

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Builder(
        builder: (context) {
          captured = context;
          return const Scaffold(body: SizedBox.expand());
        },
      ),
    ),
  );

  return captured;
}

/// Batas waktu pendek untuk tes yang menunggu `Future` dari sebuah rute.
///
/// Bila dialognya tidak pernah menutup, `await` di dalam tes tidak akan pernah
/// selesai dan bawaan 10 menit membuat satu kesalahan kecil memakan sepuluh
/// menit. Batas ini membuatnya gagal cepat.
const _shortTimeout = Timeout(Duration(seconds: 30));

void main() {
  group('showAppConfirm', () {
    testWidgets('mengembalikan true saat tombol penegas ditekan',
        (tester) async {
      final context = await _pumpHost(tester);

      final result = showAppConfirm(
        context: context,
        title: 'Kosongkan keranjang?',
        message: '3 item akan dihapus.',
        confirmLabel: 'Kosongkan',
        isDestructive: true,
      );
      await tester.pumpAndSettle();

      expect(find.text('Kosongkan keranjang?'), findsOneWidget);
      expect(find.text('3 item akan dihapus.'), findsOneWidget);

      await tester.tap(find.text('Kosongkan'));
      await tester.pumpAndSettle();

      expect(await result, isTrue);
    }, timeout: _shortTimeout);

    testWidgets('mengembalikan false saat dibatalkan', (tester) async {
      final context = await _pumpHost(tester);

      final result = showAppConfirm(
        context: context,
        title: 'Hapus produk?',
        message: 'Tindakan ini tidak bisa dibatalkan.',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();

      expect(await result, isFalse);
    }, timeout: _shortTimeout);

    testWidgets('ESC menutup dialog dan menghasilkan false', (tester) async {
      final context = await _pumpHost(tester);

      final result = showAppConfirm(
        context: context,
        title: 'Batalkan transaksi?',
        message: 'Keranjang akan dikosongkan.',
      );
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      // Menutup tanpa memilih tidak boleh dibaca sebagai persetujuan.
      expect(await result, isFalse);
      expect(find.text('Batalkan transaksi?'), findsNothing);
    }, timeout: _shortTimeout);

    testWidgets('Enter menjalankan aksi utama', (tester) async {
      final context = await _pumpHost(tester);

      final result = showAppConfirm(
        context: context,
        title: 'Simpan perubahan?',
        message: 'Perubahan akan disimpan ke perangkat.',
      );
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(await result, isTrue);
    }, timeout: _shortTimeout);
  });

  group('AppDialog', () {
    testWidgets('menampilkan judul, keterangan, isi, dan aksi', (tester) async {
      final context = await _pumpHost(tester);

      showAppDialog<void>(
        context: context,
        builder: (dialogContext) => AppDialog(
          title: 'Tambah produk',
          subtitle: 'Produk baru masuk ke outlet aktif',
          content: const Text('isi formulir'),
          actions: [
            AppButton(label: 'Simpan', onPressed: () {}),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tambah produk'), findsOneWidget);
      expect(find.text('Produk baru masuk ke outlet aktif'), findsOneWidget);
      expect(find.text('isi formulir'), findsOneWidget);
      expect(find.text('Simpan'), findsOneWidget);
    });

    testWidgets('tombol silang menutup dialog', (tester) async {
      final context = await _pumpHost(tester);

      showAppDialog<void>(
        context: context,
        builder: (_) => const AppDialog(
          title: 'Detail transaksi',
          content: Text('rincian'),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(AppIcons.close));
      await tester.pumpAndSettle();

      expect(find.text('Detail transaksi'), findsNothing);
    });

    testWidgets('kolom isian di dalam dialog bisa dirender dan diketik',
        (tester) async {
      // Sampai UI-5 dialog tidak punya leluhur Material, sehingga setiap
      // AppTextField di dalamnya ambruk dengan "No Material widget found".
      // Tidak pernah ketahuan karena seluruh dialog contoh hanya berisi teks —
      // padahal dialog yang paling sering dipakai justru yang berisi isian:
      // kategori baru, diskon, jumlah bayar.
      final context = await _pumpHost(tester);
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      showAppDialog<void>(
        context: context,
        builder: (_) => AppDialog(
          title: 'Kategori baru',
          content: AppTextField(
            label: 'Nama kategori',
            controller: controller,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(AppTextField), 'Makanan instan');
      await tester.pumpAndSettle();

      expect(controller.text, 'Makanan instan');
      expect(tester.takeException(), isNull);
    });
  });

  group('showAppDrawer', () {
    testWidgets('menampilkan isi dan menutup lewat tombol silang',
        (tester) async {
      final context = await _pumpHost(tester, surface: const Size(1600, 900));

      showAppDrawer<void>(
        context: context,
        builder: (_) => const AppDrawer(
          title: 'Filter lanjutan',
          content: Text('pilihan filter'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Filter lanjutan'), findsOneWidget);
      expect(find.text('pilihan filter'), findsOneWidget);

      await tester.tap(find.byIcon(AppIcons.close));
      await tester.pumpAndSettle();

      expect(find.text('Filter lanjutan'), findsNothing);
    });
  });

  group('AppToast', () {
    testWidgets('menampilkan pesan lalu hilang sendiri', (tester) async {
      final context = await _pumpHost(tester);

      AppToast.success(context, 'Transaksi tersimpan');
      await tester.pumpAndSettle();

      expect(find.text('Transaksi tersimpan'), findsOneWidget);

      // Bawaan 4 detik, ditambah animasi keluar.
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      expect(find.text('Transaksi tersimpan'), findsNothing);
    });

    testWidgets('menahan paling banyak tiga toast sekaligus', (tester) async {
      final context = await _pumpHost(tester);

      for (var i = 1; i <= 5; i++) {
        AppToast.info(context, 'Pesan $i');
      }
      await tester.pumpAndSettle();

      // Dua yang tertua digeser keluar tanpa menunggu waktunya habis.
      expect(find.text('Pesan 1'), findsNothing);
      expect(find.text('Pesan 2'), findsNothing);
      expect(find.text('Pesan 3'), findsOneWidget);
      expect(find.text('Pesan 4'), findsOneWidget);
      expect(find.text('Pesan 5'), findsOneWidget);

      AppToast.dismissAll(context);
      await tester.pumpAndSettle();
    });

    testWidgets('tombol silang menutup lebih cepat dari waktunya',
        (tester) async {
      final context = await _pumpHost(tester);

      AppToast.danger(context, 'Sinkronisasi gagal');
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(AppIcons.close));
      await tester.pump(); // proses ketukan, tandai data.leaving = true
      await tester.pump(const Duration(milliseconds: 300)); // animasi dismiss (≤220 ms)

      expect(find.text('Sinkronisasi gagal'), findsNothing);
    });
  });
}
