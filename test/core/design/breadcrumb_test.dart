import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangkasir_retail_app/core/design/design.dart';

const _phone = Size(390, 844);
const _tablet = Size(1280, 800);

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  Size surface = _tablet,
}) async {
  tester.view.physicalSize = surface;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: Align(child: child)),
    ),
  );
}

void main() {
  group('AppBreadcrumb', () {
    testWidgets('satu ruas tidak menghasilkan jejak apa pun', (tester) async {
      // Halaman level 1 tidak mendapat breadcrumb, sesuai dokumen IA. Satu ruas
      // bukan jejak, ia cuma judul — dan judul sudah ada di tempat lain.
      await _pump(
        tester,
        const AppBreadcrumb(items: [AppBreadcrumbItem(label: 'Dasbor')]),
      );

      expect(find.text('Dasbor'), findsNothing);
    });

    testWidgets('dua ruas ditampilkan seluruhnya', (tester) async {
      await _pump(
        tester,
        AppBreadcrumb(
          items: [
            AppBreadcrumbItem(label: 'Persediaan', onTap: () {}),
            const AppBreadcrumbItem(label: 'Produk'),
          ],
        ),
      );

      expect(find.text('Persediaan'), findsOneWidget);
      expect(find.text('Produk'), findsOneWidget);
      expect(find.text('…'), findsNothing);
    });

    testWidgets('ruas terakhir tidak bisa ditekan meski diberi aksi',
        (tester) async {
      var ditekan = false;

      await _pump(
        tester,
        AppBreadcrumb(
          items: [
            AppBreadcrumbItem(label: 'Persediaan', onTap: () {}),
            AppBreadcrumbItem(label: 'Produk', onTap: () => ditekan = true),
          ],
        ),
      );

      await tester.tap(find.text('Produk'), warnIfMissed: false);
      await tester.pump();

      // Menavigasi ke halaman yang sedang dibuka adalah penekanan yang tidak
      // melakukan apa-apa, dan pengguna membacanya sebagai aplikasi yang macet.
      expect(ditekan, isFalse);
    });

    testWidgets('ruas selain terakhir melaporkan penekanan', (tester) async {
      var ditekan = false;

      await _pump(
        tester,
        AppBreadcrumb(
          items: [
            AppBreadcrumbItem(label: 'Persediaan', onTap: () => ditekan = true),
            const AppBreadcrumbItem(label: 'Produk'),
          ],
        ),
      );

      await tester.tap(find.text('Persediaan'));
      expect(ditekan, isTrue);
    });

    testWidgets('di layar lebar empat ruas tidak diciutkan', (tester) async {
      await _pump(
        tester,
        AppBreadcrumb(
          items: [
            AppBreadcrumbItem(label: 'Persediaan', onTap: () {}),
            AppBreadcrumbItem(label: 'Produk', onTap: () {}),
            AppBreadcrumbItem(label: 'Detail produk', onTap: () {}),
            const AppBreadcrumbItem(label: 'Riwayat harga'),
          ],
        ),
      );

      expect(find.text('…'), findsNothing);
      expect(find.text('Produk'), findsOneWidget);
      expect(find.text('Detail produk'), findsOneWidget);
    });

    testWidgets('di ponsel ruas tengah diciutkan, ujungnya tetap utuh',
        (tester) async {
      await _pump(
        tester,
        AppBreadcrumb(
          items: [
            AppBreadcrumbItem(label: 'Persediaan', onTap: () {}),
            AppBreadcrumbItem(label: 'Produk', onTap: () {}),
            AppBreadcrumbItem(label: 'Detail produk', onTap: () {}),
            const AppBreadcrumbItem(label: 'Riwayat harga'),
          ],
        ),
        surface: _phone,
      );

      expect(find.text('…'), findsOneWidget);
      // Asal dan posisi sekarang justru dua hal yang membuat breadcrumb ada;
      // membuangnya demi ruang berarti membuang alasannya.
      expect(find.text('Persediaan'), findsOneWidget);
      expect(find.text('Riwayat harga'), findsOneWidget);
      expect(find.text('Produk'), findsNothing);
      expect(find.text('Detail produk'), findsNothing);
    });

    testWidgets('ruas yang diciutkan bisa dibuka dan tetap bisa dinavigasi',
        (tester) async {
      var dituju = '';

      await _pump(
        tester,
        AppBreadcrumb(
          items: [
            AppBreadcrumbItem(label: 'Persediaan', onTap: () {}),
            AppBreadcrumbItem(label: 'Produk', onTap: () => dituju = 'Produk'),
            AppBreadcrumbItem(label: 'Detail produk', onTap: () {}),
            const AppBreadcrumbItem(label: 'Riwayat harga'),
          ],
        ),
        surface: _phone,
      );

      await tester.tap(find.text('…'));
      await tester.pumpAndSettle();

      expect(find.text('Jejak navigasi'), findsOneWidget);

      await tester.tap(find.text('Produk'));
      await tester.pumpAndSettle();

      // Menciutkan ruas boleh menyembunyikannya, tidak boleh memutus jalannya.
      expect(dituju, 'Produk');
    });

    testWidgets('di ponsel tiga ruas masih muat tanpa diciutkan',
        (tester) async {
      await _pump(
        tester,
        AppBreadcrumb(
          items: [
            AppBreadcrumbItem(label: 'CRM', onTap: () {}),
            AppBreadcrumbItem(label: 'Pelanggan', onTap: () {}),
            const AppBreadcrumbItem(label: 'Detail'),
          ],
        ),
        surface: _phone,
      );

      expect(find.text('…'), findsNothing);
      expect(find.text('Pelanggan'), findsOneWidget);
    });
  });
}
