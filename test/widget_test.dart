import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mangkasir_retail_app/core/design/design.dart';
import 'package:mangkasir_retail_app/core/design/gallery/design_gallery_page.dart';

/// Uji asap galeri design system.
///
/// Galeri merender setiap token dan setiap primitive, jadi kalau halaman ini
/// terbangun tanpa galat, seluruh permukaan design system ikut terbukti bisa
/// dirender. Sengaja tidak menyentuh `main()`: aplikasi sesungguhnya
/// memerlukan `.env`, Supabase, dan DI, sedangkan design system harus bisa
/// diuji tanpa satu pun di antaranya.
void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID');
  });

  Widget wrap(Widget child, {ThemeData? theme}) => MaterialApp(
        theme: theme ?? AppTheme.light,
        home: child,
      );

  testWidgets('galeri terbangun pada lebar desktop', (tester) async {
    tester.view.physicalSize = const Size(1600, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(wrap(const DesignGalleryPage()));
    await tester.pump();

    expect(find.text('Design System — MangRitel'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('galeri terbangun pada lebar ponsel tanpa overflow',
      (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(wrap(const DesignGalleryPage()));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });

  testWidgets('galeri terbangun pada tema gelap', (tester) async {
    tester.view.physicalSize = const Size(1600, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      wrap(const DesignGalleryPage(), theme: AppTheme.dark),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
  });

  testWidgets('sakelar tema melaporkan pilihan ke pemanggilnya',
      (tester) async {
    tester.view.physicalSize = const Size(1600, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    ThemeMode? picked;

    await tester.pumpWidget(
      wrap(
        DesignGalleryPage(
          themeMode: ThemeMode.light,
          onThemeModeChanged: (mode) => picked = mode,
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byIcon(AppIcons.themeDark));
    await tester.pump();

    expect(picked, ThemeMode.dark);
  });

  testWidgets('sakelar tema disembunyikan bila tidak dirangkai', (tester) async {
    // Galeri harus tetap bisa dirender tanpa DI — itu yang membuat uji asap di
    // atas tidak memerlukan Hive maupun get_it.
    tester.view.physicalSize = const Size(1600, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(wrap(const DesignGalleryPage()));
    await tester.pump();

    expect(find.byIcon(AppIcons.themeDark), findsNothing);
  });

  testWidgets('tombol nonaktif tidak memanggil onPressed', (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      wrap(
        Scaffold(
          body: Center(
            child: AppButton(
              label: 'Bayar',
              isLoading: true,
              onPressed: () => taps++,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Bayar'));
    await tester.pump();

    // isLoading harus memblokir aksi. Kalau tidak, kasir yang menekan dua kali
    // saat jaringan lambat bisa membuat transaksi ganda.
    expect(taps, 0);
  });
}
